---
doc_id: DOC-031
title: Postmortem PM-2026-03 — DNS Misconfiguration at Brambleby
doc_type: postmortem
owner: Tuomas Virta
version: "1.0"
status: current
classification: internal
created: 2026-02-20
updated: 2026-02-20
review_due: ""
source_location: Confluence /Service Delivery/Postmortems/PM-2026-03
related: [DOC-006, DOC-016, DOC-024]
supersedes: []
synthetic: true
---

# Postmortem PM-2026-03 — DNS Misconfiguration at Brambleby

**Incident:** INC-2026-0052 · **Customer:** Brambleby Logistics Ltd (Silver, CUST-02) · **Date:** 2026-02-08 · **Severity:** P2 · **Status:** closed

## Summary

On 2026-02-08 between 07:40 and 09:45 EET, Brambleby Logistics Ltd (Silver, CUST-02) lost name resolution at both sites in Turku. IP connectivity was unaffected. Applications dependent on DNS — the ERP system, internal web portal, and file shares — were inaccessible. The incident was classified as a P2 (125 minutes). No downtime was recorded because only name resolution was affected. The P2 response SLA was breached. No service credit was issued because the duration did not reach Brambleby's credit floor. The root cause was a DHCP scope option 006 change the previous evening that replaced the configured pair of DNS server addresses with a single address. When that resolver was patched at 07:30, clients had no name resolution.

## Timeline

- **2026-02-07 21:10** — A network engineer applied a DHCP scope option 006 change to the Brambleby scope. The configuration tool accepted only a single address; the engineer entered the primary resolver, replacing the ordered pair. No notification was sent to the Service Desk or customers.
- **07:40** — First user report: ERP system would not open. Service Desk created ticket INC-2026-0052.
- **08:05** — Ticket triaged as P2. IP connectivity tests successful; issue isolated to DNS resolution.
- **08:20** — On-call engineer compared the active DHCP scope against the documented standard and identified that option 006 contained a single address instead of the expected pair.
- **08:55** — The correct ordered pair was restored. Change applied live.
- **09:45** — Post-change verification confirmed clients had renewed with correct DNS entries. Incident resolved.

## Impact

The ERP system, internal web portal, and file shares were inaccessible because these services rely on DNS name resolution. IP connectivity was unaffected throughout. The outage was classified as degraded service because the underlying network infrastructure remained fully functional — name resolution was the sole affected component. No data loss occurred.

## Root cause

A DHCP scope option 006 change on the evening of 2026-02-07 replaced the configured ordered pair of DNS server addresses with a single address. The configuration tool accepted only a single value; the engineer entered the primary resolver, and the secondary was not included. When clients renewed their DHCP leases on 2026-02-08 morning, they received a scope with only one DNS server.

At approximately 07:30, that single DNS resolver was patched as part of a separate maintenance activity — a routine firmware update that took the resolver offline. With no secondary DNS server on the scope, Brambleby clients had no name resolution available.

The change was categorised as a standard change, which permits implementation without a post-change verification test. Had a name resolution test been performed after the change, the misconfiguration would have been detected before users were affected.

## Detection

No automated monitoring detected the outage. Zabbix monitors reachability through HTTP and ICMP probes, but these use cached DNS entries or direct IP targets and did not fail. No synthetic DNS query probe was configured for the Brambleby site. The incident was first detected through user reports at 07:40.

## Response

The Service Desk created and triaged the incident as P2 at 08:05. The on-call engineer identified the misconfiguration at 08:20 by comparing the live scope against the documented standard — a manual process that relied on checking scope options against the DNS and DHCP standards document. The remediation was applied at 08:55, and a post-change verification queried live clients for their DNS assignment. The incident was communicated to the Brambleby account manager via email at 08:15 and 09:45.

## Contributing factors

- The change was made under the standard change category, which does not require a CAB review or a mandatory post-change test. Changes altering client-facing network settings, including DHCP scope options defining core network parameters, should have been elevated to a normal change requiring CAB review per DOC-024.
- No post-change verification covered name resolution. The change checklist includes connectivity testing but does not specify a DNS resolution test for DHCP changes.

## What went well

- The Service Desk correctly classified the incident as P2 and did not investigate a P1.
- The on-call engineer identified the root cause within 40 minutes by comparing the live scope against the documented standard.

## Action items

| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | Reclassify DHCP scope option changes as normal changes requiring CAB review per DOC-024. | Marko Heinänen | 2026-03-31 | **Completed** — updated 2026-03-16. |
| 2 | Add a name-resolution check to the post-change verification steps in the change implementation checklist. | Tuomas Virta | 2026-04-30 | **STILL OPEN** |
| 3 | Assign an owner and review date to the DNS and DHCP standards document. | Marko Heinänen | 2026-03-31 | **STILL OPEN** |

## Lessons learned

A DHCP scope is not a configuration setting; it is a runtime contract for every client that leases from it. Changes affecting name resolution have the same impact as changing DNS servers and should be treated with equal rigour. The DNS and DHCP standards document is the authoritative source, but when a document has no named owner and no review cycle, it cannot function as a living standard. An unowned document is a single point of failure. Action Item 3 addresses this structural weakness.