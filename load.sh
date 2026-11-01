#!/usr/bin/env bash
# Load the Norvane demo dataset into BigQuery.
#
# Prerequisites: gcloud CLI with `bq`, authenticated, with a project selected:
#   gcloud auth login
#   gcloud config set project YOUR_PROJECT_ID
#
# NOTE: this script has NOT been executed against a live BigQuery project.
# It is written against the documented `bq` CLI. Run it once end to end and
# check the row counts before demoing.
#
# Why truncate instead of `bq load --replace`: --replace REPLACES the whole
# table, which silently discards the partitioning and clustering defined in
# schema.sql. Truncate-then-append keeps the table definition and refills it,
# so the script is safe to re-run.

set -euo pipefail
cd "$(dirname "$0")"

DATASET="${DATASET:-norvane_demo}"
PROJECT="${PROJECT:-$(gcloud config get-value project 2>/dev/null)}"

if [[ -z "${PROJECT}" || "${PROJECT}" == "(unset)" ]]; then
  echo "No project set. Run: gcloud config set project YOUR_PROJECT_ID" >&2
  exit 1
fi

echo "==> Project: ${PROJECT}   Dataset: ${DATASET}"

echo "==> 1/4  Creating dataset and tables (schema.sql)"
bq query --use_legacy_sql=false < schema.sql

echo "==> 2/4  Emptying tables (makes re-runs safe)"
bq query --use_legacy_sql=false --format=none "
TRUNCATE TABLE \`${PROJECT}.${DATASET}.customers\`;
TRUNCATE TABLE \`${PROJECT}.${DATASET}.sla_targets\`;
TRUNCATE TABLE \`${PROJECT}.${DATASET}.incidents\`;
TRUNCATE TABLE \`${PROJECT}.${DATASET}.assets\`;
TRUNCATE TABLE \`${PROJECT}.${DATASET}.documents\`;"

echo "==> 3/4  Loading CSV tables"
for t in customers sla_targets incidents assets; do
  echo "    - ${t}"
  bq load \
    --source_format=CSV \
    --skip_leading_rows=1 \
    --allow_quoted_newlines \
    "${PROJECT}:${DATASET}.${t}" \
    "data/${t}.csv"
done

echo "==> 4/4  Loading documents (newline-delimited JSON)"
bq load \
  --source_format=NEWLINE_DELIMITED_JSON \
  "${PROJECT}:${DATASET}.documents" \
  data/documents.ndjson

echo "==> Row counts"
bq query --use_legacy_sql=false --format=pretty \
  "SELECT 'customers' AS table_name, COUNT(*) AS rows FROM \`${PROJECT}.${DATASET}.customers\`
   UNION ALL SELECT 'sla_targets', COUNT(*) FROM \`${PROJECT}.${DATASET}.sla_targets\`
   UNION ALL SELECT 'incidents',   COUNT(*) FROM \`${PROJECT}.${DATASET}.incidents\`
   UNION ALL SELECT 'assets',      COUNT(*) FROM \`${PROJECT}.${DATASET}.assets\`
   UNION ALL SELECT 'documents',   COUNT(*) FROM \`${PROJECT}.${DATASET}.documents\`
   ORDER BY table_name"

echo "Expected: customers 6, sla_targets 42, incidents 16, assets 25, documents 30"
echo "Done."