---
doc_id: DOC-033
title: Postmortem PM-2026-11 — Upstream Fibre Outage at Eastgate
doc_type: postmortem
owner: Tuomas Virta
version: "1.0"
status: current
classification: internal
created: 2026-07-14
updated: 2026-07-14
review_due: ""
source_location: Confluence /Service Delivery/Postmortems/PM-2026-11
related: [DOC-005, DOC-007, DOC-010]
supersedes: []
synthetic: true
---

# Postmortem PM-2026-11 — Upstream Fibre Outage at Eastgate

**Incident:** INC-2026-0128 · **Customer:** Eastgate Housing Association (Bronze, CUST-06) · **Date:** 2026-06-29 · **Severity:** P1 · **Status:** closed

## Summary

On 2026-06-29, a third-party contractor during street works cut the duct carrying the Vantage Fibre primary circuit VF-HEL-4471 for Eastgate Housing Association (CUST-06, Bronze tier). The backup circuit VF-HEL-4472 did not fail over because both circuits share the last 400 metres of duct into the building — the duct that was cut. Eastgate's two sites (eastgate-offices, eastgate-sheltered-housing) were offline for 6 hours 40 minutes (400 minutes), 05:05 → 11:45 EEST.

## Timeline

| Time (EEST) | Event |
|---|---|
| 05:05 | Zabbix detects circuit down; alert fired |
| 05:12 | On-call engineer acknowledges alert |
| 05:30 | Ticket raised with Vantage Fibre NOC as Critical |
| 06:10 | Vendor confirms street-works cable strike |
| 07:00 | Backup VF-HEL-4472 also down; shared duct raised internally |
| 09:20 | Splice team arrives on site |
| 11:20 | Primary circuit restored |
| 11:45 | Services verified; incident closed |

## Impact

- Both sites offline for 6 hours 40 minutes.
- No sheltered-housing telecare calls lost: telecare runs on a separate GSM path.
- Bronze availability target of 99.00% breached; service credit EUR 3,100, capped at the 5% Bronze limit per the credit schedule in DOC-005, applied under DOC-002.
- Vendor credit of EUR 1,850 claimed from Vantage Fibre within the 30-day contractual window.

## Root cause

The root cause category is upstream_provider. A third-party contractor executing approved street works cut the duct containing primary circuit VF-HEL-4471, which went down immediately. The upstream architecture comprises VF-HEL-4471 (1 Gbit/s symmetric primary) and VF-HEL-4472 (300/100 Mbit/s backup), with failover controlled by the edge firewalls; both circuits ride the same last 400 metres of duct into the DC1 building, so the cut took both down and the backup could not take over.

The discrepancy between documents is material: the network architecture documentation (DOC-010, section 5) describes the two paths as "geographically diverse fibre paths with no shared physical infrastructure", while the 2023 procurement record for the backup circuit (DOC-007) noted the shared duct — a note that was never acted on.

## Detection

Zabbix detected the failure at 05:05 via 60-second polling and immediate BGP-peer-down rule (DOC-021 section 3); the alert was acknowledged within 7 minutes. Confirming the backup was also down took longer, because failover was assumed to have occurred.

## Response

1. Alert acknowledged; incident ticket opened.
2. Vantage Fibre NOC engaged as Critical.
3. Backup confirmed down; shared duct raised with the Head of Infrastructure.
4. Customer notified by Service Delivery Manager.
5. Splice team restored the circuit; services verified and incident closed.

## Contributing factors

1. **Shared duct.** The last 400 metres of duct carries both circuits, eliminating the diversity the backup is meant to provide.
2. **Documentation vs physical reality.** DOC-010 claims no shared physical infrastructure; the 2023 procurement note (DOC-007) recorded the shared duct, but the risk was recorded and never escalated to resolution.
3. **No pre-armed failover test.** A quarterly failover test would have exposed the dependency before a real incident; Eastgate's quarterly service review includes none.

## What went well

- Zabbix detected the outage within seconds.
- The vendor met its 30-minute response commitment but missed its 4-hour target repair: 6 hours 15 minutes to restoration.

## Action items

| # | Action | Owner | Due date | Status |
|---|---|---|---|---|
| 1 | Commission a genuinely diverse second path for DC1 (separate duct, separate right-of-way) | Marko Heinänen | 2027-03-31 | Still open |
| 2 | Correct the resilience section of DOC-010 to reflect the shared-duct reality | Marko Heinänen | 2026-08-31 | Still open |
| 3 | Review all customer sites for single-homed or shared-duct upstream circuits | Marko Heinänen | 2026-09-30 | Still open |
| 4 | Add a pre-armed failover test of the upstream circuits to the quarterly service review | Tuomas Virta | 2026-10-31 | Still open |

## Lessons learned

1. **Documented diversity is not physical diversity.** When architecture documents (DOC-010) and procurement records (DOC-007) disagree, the higher-fidelity operational record prevails.
2. **Failover testing validates design assumptions.** Pre-armed tests should be standard in quarterly service reviews for all customers with redundant circuits.
3. **Procurement notes must be acted on.** An identified risk must be escalated to a remediation owner with a due date and tracked to closure.
