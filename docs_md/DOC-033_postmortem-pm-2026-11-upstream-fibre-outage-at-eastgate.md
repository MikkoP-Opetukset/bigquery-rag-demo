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

On 2026-06-29 the upstream connectivity for Eastgate Housing Association (CUST-06, Bronze tier) was disrupted when a third-party contractor cutting a duct during street works damaged the Vantage Fibre primary circuit VF-HEL-4471. The backup circuit VF-HEL-4472 did not fail over because both circuits share the last 400 metres of duct into the building, and the same duct was cut. Eastgate's two sites (eastgate-offices and eastgate-sheltered-housing) were offline for 6 hours 40 minutes (05:05 → 11:45 EEST). No telecare calls were lost; the sheltered-housing telecare system runs on a separate GSM path that was unaffected by the street works.

The incident was classified as P1. The Bronze availability target of 99.00% was missed. A service credit of EUR 3,100 was issued to the customer, capped at the 5% Bronze limit per DOC-002. A vendor credit of EUR 1,850 was claimed from Vantage Fibre within the 30-day contractual window.

## Timeline

| Time (EEST) | Event |
|---|---|
| 05:05 | Zabbix monitoring detects upstream circuit down; alert fired |
| 05:12 | On-call engineer acknowledges the alert |
| 05:30 | Ticket raised with Vantage Fibre NOC as Critical |
| 06:10 | Vantage Fibre confirms street-works cable strike as the cause |
| 07:00 | Norvane establishes that the backup circuit VF-HEL-4472 is also down; shared-duct issue raised internally |
| 09:20 | Vantage Fibre splice team arrives on site |
| 11:20 | Primary circuit restored by Vantage Fibre |
| 11:45 | Eastgate services verified as operational; incident resolved |

## Impact

- Both Eastgate sites (eastgate-offices and eastgate-sheltered-housing) offline for 6 hours 40 minutes.
- Bronze availability target of 99.00% breached.
- Service credit of EUR 3,100 issued to the customer (capped at 5% of monthly fee, the Bronze limit per DOC-002).
- No sheltered-housing telecare calls lost (telecare runs on a separate GSM path).
- Vendor credit of EUR 1,850 claimed from Vantage Fib Oy within the 30-day window.

## Root cause

The root cause category is upstream_provider. A third-party contractor, executing approved street works, cut through a fibre duct containing the Vantage Fibre primary circuit VF-HEL-4471. The circuit went down immediately.

Norvane's upstream architecture provides two circuits: VF-HEL-4471 (1 Gbit/s symmetric primary) and VF-HEL-4472 (300/100 Mbit/s backup). The edge firewalls control failover between them. The backup circuit VF-HEL-4472 did not take over because both circuits share the last 400 metres of duct into the building. The street works cut through that shared duct section, taking both circuits down simultaneously.

The procurement record for the backup circuit, held in DOC-007, notes the shared duct in 2023. This note was never acted upon. Norvane's network architecture documentation (DOC-010) describes the two paths as "geographically diverse fibre paths with no shared physical infrastructure" (DOC-010 section 5). This description does not match the actual physical reality.

## Detection

Zabbix detected the circuit failure at 05:05 via its 60-second polling and BGP-peer-down alert rule, which fires immediately (DOC-021 section 3, "BGP or upstream peer down — P1 — Immediate"). The alert was acknowledged within 7 minutes. The detection of the primary circuit failure was timely; the detection that the backup circuit was also down took longer because the initial assumption was that the backup path would have already taken over.

## Response

1. The on-call engineer acknowledged the alert at 05:12 and opened the incident ticket.
2. At 05:30, the Vantage Fibre NOC was contacted and the issue was raised as Critical.
3. At 06:10, the vendor confirmed the cause as a street-works cable strike.
4. At 07:00, the engineer verified that the backup circuit VF-HEL-4472 was also down and raised the shared-duct issue internally with the Head of Infrastructure.
5. The Service Delivery Manager notified the customer of the outage and the upstream nature of the cause.
6. The vendor splice team was on site at 09:20 and restored the circuit at 11:20.
7. Services were verified at 11:45 and the incident was closed.

## Contributing factors

1. **Shared duct between primary and backup circuits.** VF-HEL-4471 and VF-HEL-4472 share the last 400 metres of duct into the DC1 building. A cut in that duct takes both circuits down, eliminating the diversity that the backup circuit is intended to provide. This was recorded in the procurement documentation for the backup circuit in 2023 (DOC-007) but was never remediated.

2. **Architecture documentation does not match physical reality.** DOC-010 section 5 states that "DC1 and DC2 sit on geographically diverse fibre paths with no shared physical infrastructure" and that the two sites are connected "over separate right-of-way routes, eliminating any single-point-of-failure risk in the transport layer between them." For the upstream circuits at DC1, the two paths are not independent in the final segment. The procurement record in DOC-007 captures the shared-duct detail that the architecture document omits.

3. **Procurement note not acted upon.** The procurement record for VF-HEL-4472 noted the shared duct in 2023. No action was taken to remedy the issue, commission a separate path, or at minimum flag the risk in the customer's site plan. This is a process gap: identified risk was recorded but never escalated to resolution.

4. **No pre-armed failover test.** The backup circuit failover was not tested prior to the outage. A quarterly failover test would have revealed the shared-duct dependency before a real incident exposed it. The quarterly service review for Eastgate does not include a failover test.

## What went well

- Zabbix detected the outage within seconds; the alert fired immediately per the monitoring thresholds in DOC-021.
- The on-call engineer acknowledged the alert within 7 minutes and raised the vendor NOC ticket promptly.
- The vendor met its 30-minute response SLA; the splice team was dispatched and arrived on site within 4 hours 15 minutes of the initial report.
- The vendor credit of EUR 1,850 was claimed within the 30-day contractual window.
- Telecare services were unaffected; the GSM path for sheltered-housing telecare is independent of the fibre circuits and functioned throughout the incident.

## Action items

| # | Action | Owner | Due date | Status |
|---|---|---|---|---|
| 1 | Commission a genuinely diverse second path for DC1 (separate duct, separate right-of-way) | Marko Heinänen | 2027-03-31 | Still open |
| 2 | Correct the resilience section of DOC-010 to reflect the shared-duct reality | Marko Heinänen | 2026-08-31 | Still open |
| 3 | Review all customer sites for single-homed or shared-duct upstream circuits | Marko Heinänen | 2026-09-30 | Still open |
| 4 | Add a pre-armed failover test of the upstream circuits to the quarterly service review | Tuomas Virta | 2026-10-31 | Still open |

## Lessons learned

1. **Documented diversity is not the same as physical diversity.** Architecture diagrams and descriptive documents can present a view of the network that does not match the ground reality. Procurement records that capture operational constraints must be reconciled with architecture documentation, and the higher-fidelity record (procurement) should take precedence when they disagree.

2. **Failover testing validates design assumptions.** A pre-armed test of the upstream circuit failover would have identified the shared-duct dependency before a contractor's digger exposed it. Failover tests should be a standard part of the quarterly service review for all customers with redundant circuits.

3. **Procurement notes must be acted on.** Identifying a risk and recording it in a procurement file is not sufficient. Identified risks must be escalated to a remediation owner with a due date and tracked to closure.