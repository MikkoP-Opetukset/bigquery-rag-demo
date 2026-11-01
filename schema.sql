-- ============================================================
-- Norvane demo dataset — BigQuery DDL
-- Fictional data. See README.md.
--
--   bq query --use_legacy_sql=false < schema.sql
--
-- Types are deliberately simple: STRING, INT64, FLOAT64, BOOL,
-- DATE and one ARRAY<STRING> to show a repeated field.
-- ============================================================

CREATE SCHEMA IF NOT EXISTS `norvane_demo`
OPTIONS (
  location = 'europe-north1',
  description = 'Fictional managed-IT-services corpus for BigQuery and RAG demos'
);

-- ------------------------------------------------------------
-- Structured reference data
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `norvane_demo.customers` (
  customer_id           STRING NOT NULL,
  name                  STRING,
  short_name            STRING,
  tier                  STRING,
  industry              STRING,
  contract_start        DATE,
  contract_end          DATE,
  licensed_seats        INT64,
  sites                 INT64,
  service_desk_hours    STRING,
  primary_contact_name  STRING,
  primary_contact_email STRING
);

CREATE OR REPLACE TABLE `norvane_demo.sla_targets` (
  target_id        STRING NOT NULL,
  customer_id      STRING,
  tier             STRING,
  service          STRING,
  metric           STRING,
  target_value     FLOAT64,
  unit             STRING,
  measured_window  STRING,
  notes            STRING
);

CREATE OR REPLACE TABLE `norvane_demo.incidents` (
  incident_id         STRING NOT NULL,
  customer_id         STRING,
  service             STRING,
  severity            STRING,
  opened_at           TIMESTAMP,
  resolved_at         TIMESTAMP,
  downtime_minutes    INT64,
  root_cause_category STRING,
  sla_breached        BOOL,
  credit_issued_eur   INT64,
  short_summary       STRING
);

CREATE OR REPLACE TABLE `norvane_demo.assets` (
  asset_id          STRING NOT NULL,
  customer_id       STRING,   -- 'NORVANE' for demo-site infrastructure
  site              STRING,
  hostname          STRING,
  device_type       STRING,
  vendor_model      STRING,
  mgmt_ip           STRING,
  firmware_version  STRING,
  end_of_life_date  DATE,
  criticality       STRING,
  patch_group       STRING
);

-- ------------------------------------------------------------
-- The corpus itself. This is the table the RAG demo will read.
-- `related` is a repeated field -> demonstrates ARRAY<STRING>
-- and lets you show UNNEST() in the query demo.
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `norvane_demo.documents` (
  doc_id            STRING NOT NULL,
  title             STRING,
  doc_type          STRING,
  owner             STRING,       -- NULL means nobody owns it
  version           STRING,
  status            STRING,       -- current | superseded
  classification    STRING,       -- internal | confidential | restricted
  created           DATE,
  updated           DATE,
  review_due        DATE,
  source_location   STRING,
  related           ARRAY<STRING>,
  supersedes        ARRAY<STRING>,
  synthetic         BOOL,
  body              STRING,
  body_word_count   INT64,
  body_char_count   INT64,
  source_file       STRING
)
PARTITION BY updated
CLUSTER BY doc_type, classification
OPTIONS (
  description = 'Synthetic internal documents (SLA, infrastructure, policy, postmortems)'
);