-- ============================================================
-- Norvane demo — query walkthrough
-- Run in the BigQuery console, or:  bq query --use_legacy_sql=false < queries.sql
--
-- Each block is independent. They are ordered to build up from
-- "SELECT three columns" to joins, windows and a text search that
-- sets up next week's RAG demo.
-- ============================================================


-- ------------------------------------------------------------
-- 00. What is in the dataset?
-- ------------------------------------------------------------
SELECT table_id AS table_name, row_count
FROM `norvane_demo.__TABLES__`
ORDER BY table_name;


-- ------------------------------------------------------------
-- 01. The simplest possible query
-- ------------------------------------------------------------
SELECT customer_id, name, tier, licensed_seats
FROM `norvane_demo.customers`
ORDER BY licensed_seats DESC;


-- ------------------------------------------------------------
-- 02. WHERE + ORDER BY
-- ------------------------------------------------------------
SELECT name, tier, contract_end
FROM `norvane_demo.customers`
WHERE tier IN ('Platinum', 'Gold')
ORDER BY contract_end;


-- ------------------------------------------------------------
-- 03. Aggregation: who are we actually serving?
-- ------------------------------------------------------------
SELECT tier,
       COUNT(*)                 AS customers,
       SUM(licensed_seats)      AS total_seats,
       ROUND(AVG(licensed_seats)) AS avg_seats
FROM `norvane_demo.customers`
GROUP BY tier
ORDER BY total_seats DESC;


-- ------------------------------------------------------------
-- 04. JOIN: incidents with the customer name attached
-- ------------------------------------------------------------
SELECT i.incident_id, c.short_name, i.severity, i.service,
       i.downtime_minutes, i.sla_breached, i.credit_issued_eur
FROM `norvane_demo.incidents` AS i
JOIN `norvane_demo.customers` AS c USING (customer_id)
ORDER BY i.opened_at DESC;


-- ------------------------------------------------------------
-- 05. Date arithmetic: how long did each incident actually take?
-- ------------------------------------------------------------
SELECT incident_id, customer_id, severity,
       TIMESTAMP_DIFF(resolved_at, opened_at, MINUTE) AS duration_minutes,
       downtime_minutes,
       ROUND(TIMESTAMP_DIFF(resolved_at, opened_at, MINUTE) / 60.0, 1) AS duration_hours
FROM `norvane_demo.incidents`
WHERE severity = 'P1'
ORDER BY duration_minutes DESC;


-- ------------------------------------------------------------
-- 06. The real question: did we breach the contract?
--     incidents x sla_targets  (the join that makes this dataset worth having)
-- ------------------------------------------------------------
SELECT i.incident_id,
       c.short_name,
       c.tier,
       i.severity,
       TIMESTAMP_DIFF(i.resolved_at, i.opened_at, MINUTE) AS duration_minutes,
       -- P1 resolution target for this customer's tier, in minutes
       CAST(t.p1_resolution_hours AS INT64) * 60 AS p1_resolution_target_minutes,
       TIMESTAMP_DIFF(i.resolved_at, i.opened_at, MINUTE)
         > CAST(t.p1_resolution_hours AS INT64) * 60 AS exceeded_resolution_target
FROM `norvane_demo.incidents` AS i
JOIN `norvane_demo.customers` AS c USING (customer_id)
JOIN (
  SELECT customer_id,
         MAX(IF(metric = 'p1_resolution_hours', target_value, NULL)) AS p1_resolution_hours
  FROM `norvane_demo.sla_targets`
  GROUP BY customer_id
) AS t USING (customer_id)
WHERE i.severity = 'P1'
ORDER BY exceeded_resolution_target DESC, duration_minutes DESC;


-- ------------------------------------------------------------
-- 07. Breach rate and credits per customer
-- ------------------------------------------------------------
SELECT c.short_name,
       c.tier,
       COUNT(i.incident_id)                        AS incidents,
       COUNTIF(i.sla_breached)                     AS breaches,
       ROUND(SAFE_DIVIDE(COUNTIF(i.sla_breached), COUNT(i.incident_id)) * 100, 1) AS breach_pct,
       SUM(i.credit_issued_eur)                    AS credits_eur
FROM `norvane_demo.customers` AS c
LEFT JOIN `norvane_demo.incidents` AS i USING (customer_id)
GROUP BY c.short_name, c.tier
ORDER BY credits_eur DESC;


-- ------------------------------------------------------------
-- 08. Window function: rank customers by downtime, and keep a running total
-- ------------------------------------------------------------
SELECT short_name,
       total_downtime_minutes,
       RANK() OVER (ORDER BY total_downtime_minutes DESC) AS downtime_rank,
       SUM(total_downtime_minutes) OVER (
         ORDER BY total_downtime_minutes DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM (
  SELECT c.short_name, SUM(i.downtime_minutes) AS total_downtime_minutes
  FROM `norvane_demo.customers` AS c
  JOIN `norvane_demo.incidents` AS i USING (customer_id)
  GROUP BY c.short_name
)
ORDER BY downtime_rank;


-- ------------------------------------------------------------
-- 09. Availability achieved vs committed (whole-year approximation)
--     365 days = 525,600 minutes; targets are monthly, so this is
--     illustrative only — say so if you show it.
-- ------------------------------------------------------------
WITH downtime AS (
  SELECT customer_id, SUM(downtime_minutes) AS downtime_minutes
  FROM `norvane_demo.incidents`
  GROUP BY customer_id
),
committed AS (
  SELECT customer_id, MAX(IF(metric = 'uptime_pct', target_value, NULL)) AS target_uptime_pct
  FROM `norvane_demo.sla_targets`
  GROUP BY customer_id
)
SELECT c.short_name,
       c.tier,
       cm.target_uptime_pct,
       ROUND(100 * (1 - COALESCE(d.downtime_minutes, 0) / 525600.0), 3) AS achieved_uptime_pct,
       ROUND(cm.target_uptime_pct - 100 * (1 - COALESCE(d.downtime_minutes, 0) / 525600.0), 3) AS delta_pp
FROM `norvane_demo.customers` AS c
JOIN committed AS cm USING (customer_id)
LEFT JOIN downtime AS d USING (customer_id)
ORDER BY delta_pp;


-- ------------------------------------------------------------
-- 10. Documents: slice the corpus
-- ------------------------------------------------------------
SELECT doc_type, status, COUNT(*) AS docs, SUM(body_word_count) AS words
FROM `norvane_demo.documents`
GROUP BY doc_type, status
ORDER BY docs DESC;


-- ------------------------------------------------------------
-- 11. Document hygiene — the "our intranet is a mess" query.
--     These three results are the motivation for the RAG demo.
-- ------------------------------------------------------------
-- (a) nobody owns it
SELECT doc_id, title, doc_type, updated
FROM `norvane_demo.documents`
WHERE owner IS NULL OR owner = ''
ORDER BY doc_id;

-- (b) overdue for review
SELECT doc_id, title, updated, review_due,
       DATE_DIFF(CURRENT_DATE(), review_due, DAY) AS days_overdue
FROM `norvane_demo.documents`
WHERE review_due IS NOT NULL
  AND review_due < CURRENT_DATE()
ORDER BY days_overdue DESC;

-- (c) same title, two live copies
SELECT title, COUNT(*) AS copies,
       STRING_AGG(doc_id || ' v' || version || ' (' || status || ')', ', ') AS versions
FROM `norvane_demo.documents`
GROUP BY title
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- 12. Repeated field: which documents are the most cross-referenced?
--     UNNEST() is the BigQuery-native way to look inside an array.
-- ------------------------------------------------------------
SELECT rel AS referenced_doc_id, COUNT(*) AS times_referenced
FROM `norvane_demo.documents`, UNNEST(related) AS rel
GROUP BY rel
ORDER BY times_referenced DESC
LIMIT 10;

-- ...and what those documents are called
SELECT d.doc_id, d.title, r.times_referenced
FROM `norvane_demo.documents` AS d
JOIN (
  SELECT rel, COUNT(*) AS times_referenced
  FROM `norvane_demo.documents`, UNNEST(related) AS rel
  GROUP BY rel
) AS r ON r.rel = d.doc_id
ORDER BY r.times_referenced DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 13. Text search in SQL — a keyword search is the poor man's retrieval
-- ------------------------------------------------------------
SELECT doc_id, title, classification
FROM `norvane_demo.documents`
WHERE REGEXP_CONTAINS(LOWER(body), r'\brpo\b')
ORDER BY doc_id;

-- BigQuery's SEARCH() is token-based and easier to read:
SELECT doc_id, title
FROM `norvane_demo.documents`
WHERE SEARCH(body, 'restore RPO')
ORDER BY doc_id;

-- Show the matching sentences so the audience sees *why* a chunk-based
-- retriever is the next step.
SELECT doc_id, title
FROM `norvane_demo.documents`
WHERE REGEXP_CONTAINS(LOWER(body), r'restor(a|e)')
LIMIT 5;


-- ------------------------------------------------------------
-- 14. Bridge query: which customers have no document mentioning them?
--     Full-text match against the corpus, joined back to reference data.
-- ------------------------------------------------------------
WITH mentions AS (
  SELECT c.customer_id, c.short_name,
         (SELECT COUNT(*)
          FROM `norvane_demo.documents` AS d
          WHERE REGEXP_CONTAINS(LOWER(d.body), LOWER(c.short_name))) AS docs_mentioning
  FROM `norvane_demo.customers` AS c
)
SELECT * FROM mentions ORDER BY docs_mentioning;


-- ------------------------------------------------------------
-- 15. Full-text search over documents, ranked by word count, with a
--     snippet — the closest SQL gets to retrieval, and the handover
--     point to next week's RAG demo.
-- ------------------------------------------------------------
SELECT doc_id,
       title,
       doc_type,
       body_word_count,
       SUBSTR(body, GREATEST(1, STRPOS(LOWER(body), 'rto') - 120), 260) AS snippet
FROM `norvane_demo.documents`
WHERE REGEXP_CONTAINS(LOWER(body), r'\brto\b')
ORDER BY body_word_count DESC;