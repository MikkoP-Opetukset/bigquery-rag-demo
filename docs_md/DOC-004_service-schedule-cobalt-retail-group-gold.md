---
doc_id: DOC-004
title: Service Schedule — Cobalt Retail Group (Gold)
doc_type: contract
owner: Legal & Compliance (Petra Lindqvist)
version: "3.0"
status: current
classification: confidential
created: 2022-09-01
updated: 2025-06-30
review_due: 2026-06-30
source_location: //fs01.norvane.internal/policies/legal/customers/cobalt/cobalt-service-schedule-v3.0.pdf
related: [DOC-001, DOC-005, DOC-006, DOC-012, DOC-030]
supersedes: [v2.2 (2023)]
---

# Service Schedule — Cobalt Retail Group

Customer: **Cobalt Retail Group** (CUST-03)
Tier: **Gold**
Effective: 2025-06-30. Supersedes v2.2.
Contract term: 2022-09-01 to 2026-08-31.

## 1. Covered services

| Service | Committed level |
|---|---|
| Network & Connectivity | 99.9% monthly availability |
| Backup & Recovery | RTO 8 hours, RPO 4 hours |
| Managed Firewall | P1 response 30 minutes, P1 resolution 8 hours |
| Service Desk | P1 response 30 minutes, 24x7 |

## 2. Site coverage

Six sites: cobalt-hq (Helsinki) and five retail stores (cobalt-store-01 to
cobalt-store-05). Stores connect to HQ over site-to-site VPN on consumer-grade
fibre; store-level availability is measured but the **committed** availability
target applies to the aggregate across all six sites.

Because retail trading hours dominate the risk profile, availability is
measured over **trading hours only** (08:00–21:00 local, seven days) rather
than the full calendar month. This is an explicit amendment to the Master SLA
definition of Service Availability and applies to Cobalt only.

Store openings and closures during the contract term are handled by a site
variation notice rather than a Schedule amendment, provided the total site
count does not exceed eight.

## 3. Peak trading periods

Cobalt designates four peak trading periods per year (roughly November,
December, January sale and a summer promotion). During these periods:

- No planned maintenance on core or distribution switching without written
  approval from Cobalt's IT manager.
- P1 response target is reduced to 15 minutes by mutual agreement.
- A Norvane duty engineer is on site at cobalt-hq during the first trading day
  of the period.

The current peak period calendar is maintained by the Service Delivery Manager
and is not part of this Schedule.

## 4. Core switching

Cobalt operates a two-switch stack at HQ (see DOC-012 for the configuration
standard). Redundancy is expected to survive the loss of one member. The
Schedule does not commit to a specific failover time; the availability target
is the only committed measure.

## 5. Backup scope

File services, POS transaction logs, HQ directory services. POS databases are
backed up by the POS vendor; Norvane retains the vault copy and is responsible
for restoring the vault copy only.

## 6. Reporting

Monthly report plus a quarterly review with head of IT and store operations.

## 7. Service credits

Maximum credit 20% of the monthly fee for the affected service. Because
availability is measured over trading hours, credit calculations use
trading-hour minutes as the denominator.

## 8. Special terms

Cobalt may request up to two emergency change windows per quarter at no charge.
Additional emergency windows are chargeable at the rates in the rate card.
