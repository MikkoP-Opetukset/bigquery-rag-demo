---
doc_id: DOC-032
title: Postmortem PM-2026-07 — Failed Backup Restore at Aurora
doc_type: postmortem
owner: Emil Nyberg
version: "1.0"
status: current
classification: confidential
created: 2026-05-06
updated: 2026-05-06
review_due: ""
source_location: Confluence /Service Delivery/Postmortems/PM-2026-07
related: [DOC-018, DOC-019, DOC-021, DOC-002]
supersedes: []
synthetic: true
---

# Postmortem PM-2026-07 — Failed Backup Restore at Aurora

**Incident:** INC-2026-0095 · **Customer:** Aurora Health District (Platinum, CUST-01) · **Date:** 2026-04-21 · **Severity:** P1 · **Status:** closed

## Summary

A failed storage controller firmware update corrupted the aurora-hq file-services volume on 2026-04-21; Aurora Health District (Platinum, CUST-01) suffered a 665-minute P1 outage, SLA breached, closed at 12:20. Two systemic failures emerged: the most recent recoverable copy on bkparr-01 was 9 hours old, and the restore ran past the 4-hour RTO.

## Timeline

| Time (EET) | Event |
|---|---|
| 01:15 | Firmware update fails; volume corrupted |
| 01:40 | Restore decision |
| 02:30 | Restore started from most recent bkparr-01 image |
| 04:00 | 9-hour-old restore point discovered |
| 06:00 | Duty manager escalation |
| 09:15 | Customer informed of data-loss window |
| 11:30 | Volume online after 11 hours 05 minutes |
| 12:20 | Services verified |

## Impact

- 665 minutes offline (01:15 → 12:20 EET).
- Platinum availability target 99.95% breached.
- 1-hour RPO missed by 8 hours; 9 hours of clinical correspondence data unrecoverable from backup.
- 4-hour RTO exceeded: 11 hours 05 minutes actual.
- Service credit EUR 24,000 issued per DOC-002.

## Root cause

Process failure. A failed storage controller firmware update corrupted the volume at 01:15; the correct documented procedure (DOC-018) was executed. Two downstream conditions degraded the outcome:

1. Silent backup job failure: the bkparr-01 nightly job had been failing silently since 2026-04-20 16:00, and replication to bkparr-02 carried the same stale point because it starts only after a successful source job (DOC-018 section 3).
2. Restore duration: 11 hours 05 minutes at SAN disk speed against the roughly 2-hour DOC-018 section 5 estimate.

## Detection

Corruption was detected at 01:15 via Zabbix, which polls every 60 seconds and processes SNMP traps immediately (DOC-021 section 3); a P1 ticket was opened. The backup failure itself was never surfaced: the Platinum immediate alert existed but did not fire, because it watches the appliance job status, not the protected-object status.

## Response

The Backup & Storage Engineer assessed the corruption and confirmed a restore from the most recent bkparr-01 image per DOC-018 section 5. Stale point flagged at 04:00, duty manager escalated at 06:00, customer informed at 09:15; completed 11:30, services verified 12:20.

## Contributing factors

1. Job-status alerting: the Platinum immediate alert watches appliance job status, not protected-object status, so the silent failure of 2026-04-20 16:00 never reached the on-call rota within minutes. Silver/Bronze failures roll into the morning review (DOC-021 section 3); the Platinum alert never fired.
2. Replication carries stale data: bkparr-02 mirrors bkparr-01's schedule and starts only after the source job succeeds, so a silent failure leaves both at the same point (DOC-018 section 7).
3. The ~2-hour runbook estimate (DOC-018 section 5) was never benchmarked against the actual restore path.
4. Disaster recovery plan validation is not supported by operational evidence. DOC-019 section 8 records a full DR test on 2024-11-16 said to have exercised all tiers, but that test covered only the file-services tier and did not restore the clinical database tier; that tier had never been restored end to end outside a vendor lab. DOC-019's claim that restore testing is "performed twice yearly across all backup tiers" is not supported by operational evidence; DOC-018 section 6 states that restore tests cover the file-services tier only.
5. Replication lag between bkparr-01 and bkparr-02 is displayed on the dashboard but generates no alert (DOC-021 section 6).

## What went well

- The P1 was activated immediately at detection, triggering the on-call rota without delay.
- The correct runbook (DOC-018) was followed throughout.
- The Service Desk maintained regular customer communication, including the 09:15 data-loss notification.

## Action items

| # | Action | Owner | Status |
|---|---|---|---|
| 1 | Alert on protected-object failures, not job status | Marko Heinänen | Completed 2026-06-11 |
| 2 | Alert on replication lag | Emil Nyberg | Still open |
| 3 | End-to-end restore test of clinical database tier | Emil Nyberg | Still open |
| 4 | Revise the validation section of DOC-019 | Marko Heinänen | Still open |

## Lessons learned

1. Job-status monitoring alone cannot detect backup failures; alerts must watch protected objects.
2. Replication lag must be actively alerted on, not just displayed.
3. DR plan validation claims must be backed by operational evidence.
