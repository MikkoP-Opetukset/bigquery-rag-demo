---
doc_id: DOC-030
title: Postmortem PM-2025-17 — Core Switch Failure at Cobalt
doc_type: postmortem
owner: Tuomas Virta
version: "1.0"
status: current
classification: internal
created: 2025-09-26
updated: 2025-09-26
review_due: ""
source_location: Confluence /Service Delivery/Postmortems/PM-2025-17
related: [DOC-004, DOC-012, DOC-006]
supersedes: []
synthetic: true
---

# Postmortem PM-2025-17 — Core Switch Failure at Cobalt

**Incident:** INC-2025-0311 · **Customer:** Cobalt Retail Group (Gold, CUST-03) · **Date:** 2025-09-12 · **Severity:** P1 · **Status:** closed

## Summary

At 03:20 EET on 2025-09-12 the Cobalt Retail Group (Gold, CUST-03) headquarters site lost all IP connectivity, taking down POS traffic for all five retail stores. The outage lasted 252 minutes (03:20 → 07:32) and was classified as a P1. The root cause was a failed power supply unit on switch `sw-core-c1` (Catalyst 9500-24Y4C) combined with a configuration error: the stack's power redundancy mode was `combined` rather than `redundant`, so a single PSU failure triggered a full stack reboot. A service credit of EUR 18,400 was issued.

## Timeline

- **03:20** — Zabbix P1 alert: all stack members and connected sites down.
- **03:27** — On-call engineer acknowledged. P1 ticket created.
- **03:41** — First customer contacts; store POS terminals reported dark.
- **04:15** — Investigation redirected to suspected fibre failure. A 40-minute dead end: patch panels and optical power tested, fibre confirmed healthy. The core switch was not inspected.
- **05:05** — On-site engineer dispatched to Cobalt HQ. Observed Catalyst 9500 cycling through `reload` messages at least four times.
- **05:50** — Suspect PSU replaced in `sw-core-c1`. The switch entered another reload cycle within three minutes.
- **06:30** — Shared console session identified the `combined` power redundancy mode. Changed to `redundant`, issued a clean reload.
- **07:32** — Services verified. Incident resolved.

## Impact

All five Cobalt Retail stores lost POS and intranet connectivity for 252 minutes. No data loss was reported. The Gold-tier SLA breach required a EUR 18,400 service credit against the 20 % maximum.

## Root cause

Two co-factors caused the outage:

1. **Hardware failure.** PSU-2 on `sw-core-c1` failed during a planned building electrical maintenance window at Cobalt HQ. The facilities team advised of a load transfer but raised no specific alert about the switch PSU.

2. **Configuration error.** The Catalyst 9500 stack power redundancy mode was `combined` instead of `redundant`. In `combined` mode a single-unit failure triggers a full stack reboot; in `redundant` mode the spare PSU absorbs the failure. The correct mode was documented in DOC-012, but an earlier stack expansion had overwritten the setting and the deviation was never caught by a configuration audit.

## Detection

Zabbix detected the outage within its 60-second polling interval, picking up loss of reachability on all `cobalt-hq` interfaces and store VPN endpoints. The alert was automatically elevated to P1.

## Response

The on-call engineer followed the P1 escalation path in DOC-023. The initial diagnosis misidentified the cause as a fibre failure — a 40-minute detour that extended the outage but is documented transparently. Once the on-site engineer identified the repeated reload pattern, the investigation pivoted to the switch hardware. The root cause was remediated at 06:30.

## Contributing factors

- The `combined` power redundancy mode on `sw-core-c1` deviated from DOC-012 and was not caught by configuration audits.
- Cobalt's entire store network depended on a single stack at headquarters; a second stack would have contained the blast radius.
- The building's electrical maintenance was communicated only by email (DOC-022) but not flagged for monitoring.
- The NOC runbook lacks a "repeated stack reload" diagnostic branch, delaying the correct diagnosis after the fibre dead-end was cleared.

## What went well

- Zabbix detected the outage within the polling interval and the alert was correctly elevated to P1.
- The on-call engineer acknowledged within seven minutes — well within the 30-minute P1 target for Gold.
- An on-site engineer was dispatched within one hour.

## Action items

| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | Audit power redundancy mode on all Catalyst 9500 and 9300 stacks. Correct any running in `combined`. | Marko Heinänen | 2025-10-10 | **Completed** — three stacks corrected at CUST-03 and CUST-01. |
| 2 | Add a mandatory section on power redundancy configuration to DOC-012, prohibiting `combined` mode. | Marko Heinänen | 2025-12-08 | **Completed** — landed in DOC-012 v2.4. |
| 3 | Add a Zabbix alert for repeated stack reloads (three or more reboots per hour) on core and distribution switches. | Marko Heinänen | 2026-01-31 | **STILL OPEN** |
| 4 | Update the NOC runbook to include the "repeated stack reload" diagnostic path. | Tuomas Virta | 2025-11-30 | **STILL OPEN** |

## Lessons learned

Hardware redundancy configured in the hardware but not in the configuration is not redundancy. The Cobalt Catalyst 9500 had two PSU units physically present, but the `combined` mode meant a single failure took the entire stack offline. Configuration audits that check interfaces and routing protocols but not operational modes like power redundancy will miss this gap. The audit in Action Item 1 should be repeated every six months as a runbook procedure, not left to a one-off exercise.