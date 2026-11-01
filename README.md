# Norvane demo corpus — BigQuery (week 1) and RAG (week 2)

A synthetic dataset for teaching **how to create and query a database in Google
BigQuery**, built so the *same* corpus can be reused as the document store for a
**RAG demo** next week.

> **All of this is fabricated.** *Norvane Managed IT Services Oy*, its
> customers, staff, vendors, hosts, addresses and phone numbers are invented —
> none of the organisations or people described here are real. (Company names may
> coincidentally resemble real businesses; an unrelated apparel brand shares the
> "Norvane" name.) IP addressing deliberately uses the RFC 5737 documentation
> ranges (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`) and customer
> domains use `example.com`, so nothing here can be mistaken for a real
> organisation's material. `synthetic: true` is set on every document record.

## What is in here

| Path | What it is |
|---|---|
| `docs_md/` | 30 markdown documents with YAML frontmatter — the source corpus |
| `data/documents.ndjson` | the same 30 documents, one JSON object per line, ready for `bq load` |
| `data/customers.csv` | 6 customers |
| `data/sla_targets.csv` | 42 committed service levels (6 customers × 7 metrics) |
| `data/incidents.csv` | 16 incidents |
| `data/assets.csv` | 25 managed devices with firmware, EOL dates and patch groups |
| `schema.sql` | BigQuery DDL for 5 tables |
| `load.sh` | creates the dataset and loads all five tables |
| `queries.sql` | 16 numbered query blocks, simplest first |
| `scripts/build_ndjson.py` | rebuilds `documents.ndjson` from `docs_md/` (no dependencies) |
| `CANON.md` | the shared fact sheet the corpus was written against |

**Corpus shape:** 30 documents, ~21,500 words, mean 715 words each.
Types: 9 policy, 4 contract, 4 reference, 4 postmortem, 3 standard, 1 each of
guide, runbook, plan, process, checklist, vendor contract.
Classification: 21 internal, 8 confidential, 1 restricted.

## Week 1 — the BigQuery demo

Prerequisites: `gcloud` CLI, authenticated, project selected. **`bq` is not
installed on the machine this corpus was built on, so `load.sh` has not been
executed** — run it once beforehand and confirm the row counts.

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
./load.sh
```

Then walk through `queries.sql`. The intended arc:

1. **Create** — `schema.sql`. Show the DDL: typed columns, `PARTITION BY updated`,
   `CLUSTER BY doc_type, classification`, and `related ARRAY<STRING>`.
2. **Load** — `bq load` with CSV and with newline-delimited JSON.
3. **Query basics** — blocks 00–03: `SELECT`, `WHERE`, `GROUP BY`.
4. **Joins** — blocks 04–07: incidents to customers, and the one that earns its
   keep, incidents to `sla_targets` to answer *"did we breach the contract?"*
5. **Window functions** — block 08: `RANK()` and a running total.
6. **The documents table** — blocks 10–12, including `UNNEST(related)` on the
   repeated field.
7. **Text search in SQL** — blocks 13–15. This is the handover to next week:
   a keyword search is the poor man's retriever, and the last query shows why
   you want chunking instead.

### Suggested talking points

- The `documents` table is *both* a normal relational table and the RAG corpus.
  Same data, two uses — that is the point of building it this way.
- Partitioning and clustering are visible in the DDL and measurably reduce bytes
  scanned once the table grows; on 30 rows it is illustrative only. Say so.
- `UNNEST(related)` demonstrates BigQuery's nested/repeated model, which is where
  it differs most from a plain relational database.

## Deliberate defects — read this before you present

The corpus is *moderately messy on purpose*. These are features, not bugs. They
give the query demo something to find and next week's RAG demo a real problem to
solve.

| Where | The defect |
|---|---|
| **DOC-013 vs DOC-014** | Two firewall change policies with the same title on the same share. DOC-013 v3.0 (2025) is current; DOC-014 v1.0 (2019, owner who left in 2022) is marked `superseded` but describes a different, obsolete approval route. Query 11c finds the pair. |
| **DOC-016** | DNS and DHCP Standards has an **empty `owner`** — orphaned knowledge. Query 11a finds it. |
| **DOC-017** | Wireless Standards last updated 2021 and overdue review since 2022. It promises WPA3 "during 2022" and a Wi-Fi 6 rollout "planned for Q3 2021". Nothing in it has been updated since. Query 11b finds it, along with eight other overdue documents. |
| **DOC-019 vs DOC-032** | **The one real contradiction.** The DR plan states a full test on 2024-11-16 exercised all tiers and met all objectives. The Aurora restore postmortem says that test covered the file-services tier only and that the clinical database tier had never been restored end to end outside a vendor lab. |
| **DOC-020 vs DOC-023** | Escalation timing drifts: 15 minutes in the on-call policy, 30 minutes in the incident process. Both are current. |
| **DOC-010 vs DOC-007** | The architecture overview claims DC1 and DC2 sit on "geographically diverse fibre paths with no shared physical infrastructure". The vendor contract record notes the backup circuit shares a 400 m duct with the primary. |

Nine documents are overdue for review as of the demo date (2026-11-01):
`DOC-001, 003, 004, 006, 014, 016, 017, 019, 022`.

## Week 2 — using the same data for RAG

`documents.ndjson` is the retrieval source. Suggested starting point:

- **Chunk by `##` section.** The bodies are written with numbered sections, so
  section-level chunks are natural and self-contained. Expect roughly 250–300
  chunks across the corpus.
- **Carry the metadata onto every chunk** — `doc_id`, `doc_type`, `classification`,
  `status`, `updated`. `status = superseded` and a missing `owner` are useful
  filters, and `classification` lets you demo filtered retrieval.
- **The defect list above is your evaluation set.** "What is our committed RTO
  for Aurora and did we meet it?" should surface DOC-002 *and* DOC-019 *and*
  DOC-032 — and a good answer has to notice they disagree. "How do I get a
  firewall rule approved?" should return DOC-013, not DOC-014. Those are the
  questions that separate retrieval from a keyword search, and they are why the
  corpus was built with the mess left in.

BigQuery can also be the vector store (`VECTOR_SEARCH` / `ML.GENERATE_EMBEDDING`)
if you want to keep both weeks on one platform.

## Known limitations

- `load.sh` and `queries.sql` were written against the documented `bq` interface
  but **never executed** — no `bq`/`gcloud` on the build machine. Verify before
  presenting.
- `incidents.opened_at` / `resolved_at` are naive timestamp strings. BigQuery
  will read them as UTC, while the source documents express times in EET/EEST
  (UTC+2/+3). Harmless for the demo; mention it if anyone joins text to timestamps.
- Query block 09 annualises downtime against a 365-day denominator to produce a
  single availability figure. Real contracts are monthly, and Cobalt's target is
  measured over trading hours only. It is an illustration, not a compliance
  calculation.
- Four documents run long: DOC-015 (1,246 words), DOC-016 (1,016), DOC-032
  (1,356) and DOC-033 (1,269). Fine for chunking, but they will dominate a naive
  word-count sort.
- The corpus has 30 documents, not 20–30 in the sense of "at most 30 with room to
  spare" — it is exactly 30, so adding more means re-running the canon check.