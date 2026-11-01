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

On 2026-04-21 the file-services volume for aurora-hq was corrupted at 01:15 EET by a failed storage controller firmware update. Aurora Health District (CUST-01, Platinum tier) experienced a P1 outage lasting 665 minutes until 12:20 when services were verified. Norvane invoked the documented restore procedure defined in DOC-018. Two systemic failures emerged during recovery.

First, the most recent recoverable copy on bkparr-01 was 9 hours old. The nightly backup job had been failing silently since 2026-04-20 16:00, and replication to bkparr-02 carried the same stale point because both appliances follow the same schedule (DOC-018 section 3). The 1-hour RPO was missed by 8 hours, and the last 9 hours of clinical correspondence files were unrecoverable from backup.

Second, the whole-volume restore took 11 hours 05 minutes against a 4-hour RTO target. The restore ran at SAN disk speed rather than the expected file-level or application-level restore, resulting in a prolonged data-unavailability window for the Aurora Health District staff.

The customer credit of EUR 24,000 was applied per DOC-002.

## Timeline

| Time (EET) | Event |
|---|---|
| 01:15 | Storage controller firmware update fails; aurora-hq file-services volume is corrupted |
| 01:40 | Restore decision made; Backup & Storage Engineer begins recovery |
| 02:30 | Restore initiated from the most recent image on bkparr-01 |
| 04:00 | First indication that the restore point is 9 hours old (the nightly job failure from 2026-04-20 16:00) |
| 06:00 | Duty manager escalates to Service Delivery Manager |
| 09:15 | Customer informed of the data-loss window (01:15 → 10:15 on 2026-04-20) |
| 11:30 | Volume comes online after 11 hours 05 minutes of restore |
| 12:20 | Services verified as operational; incident resolved |

## Impact

- aurora-hq file-services volume offline for 665 minutes (01:15 → 12:20 EET).
- Platinum availability target of 99.95% breached.
- 1-hour RPO target missed by 8 hours; 9 hours of clinical correspondence data unrecoverable.
- 4-hour RTO target exceeded; actual restore time was 11 hours 05 minutes.
- Service credit of EUR 24,000 issued to the customer.

## Root cause

The primary root cause is a process failure. A failed storage controller firmware update corrupted the aurora-hq file-services volume at 01:15. Norvane executed the correct documented procedure from DOC-018. However, two downstream conditions degraded the outcome:

1. **Silent backup job failure.** The nightly backup job on bkparr-01 had been failing since 2026-04-20 16:00. Replication to bkparr-02 carried the same stale data because it mirrors the source schedule and only begins after the source job completes successfully (DOC-018 section 3). The failure was not surfaced to the on-call rota because the alert trigger watched the appliance job status rather than the protected-object status.

2. **Restored volume took 11 hours 05 minutes.** The whole-volume restore at SAN disk speed far exceeded the documented estimate of approximately 2 hours (DOC-018 section 5). The restore was running from the correct procedure; the discrepancy was between the documented performance expectations and the actual I/O throughput of the bkparr-01 → aurora-hq path.

## Detection

The corruption was detected at 01:15 through the Zabbix monitoring platform, which polls at 60-second intervals and processes SNMP traps immediately (DOC-021 section 3). A P1 ticket was opened. The backup job failure itself was not surfaced at the time because the Platinum immediate alert is configured to watch the appliance job status, not the protected-object status.

## Response

1. The Backup & Storage Engineer assessed the corruption and confirmed a restore was necessary.
2. The restore was initiated from the most recent image on bkparr-01 per DOC-018 section 5.
3. At 04:00, the engineer identified that the restore point was 9 hours stale and flagged the issue.
4. The duty manager was escalated to at 06:00. The Service Delivery Manager was notified at 09:15 with the data-loss window.
5. The restore completed at 11:30; services were verified operational by 12:20.

## Contributing factors

1. **Alert on job status, not protected objects.** The alert configuration monitors the appliance job status rather than the state of the protected objects themselves. If the alert watched the protected-object status, the backup failure would have been surfaced to the on-call rota within minutes of the first failure at 2026-04-20 16:00, not the following morning. This applies across all tiers; Silver and Bronze failures are aggregated into the morning review per DOC-021 section 3, but the Platinum alert did not fire at all.

2. **Backup replication carries stale data.** The replication schedule on bkparr-02 mirrors bkparr-01 and does not start until the source job succeeds. When the source fails silently, both appliances hold the same outdated data. This was noted as a gap in DOC-018 section 7.

3. **Restore performance discrepancy.** The runbook estimates approximately 2 hours for a whole-volume restore (DOC-018 section 5). The actual restore took 11 hours 05 minutes. No performance benchmarking against the aurora-hq → bkparr-01 restore path has been conducted to validate the documented estimate.

4. **Disaster recovery plan validation is not supported by operational evidence.** DOC-019 section 8 records that a full disaster recovery test was carried out on 2024-11-16 in which all tiers were exercised and all objectives were met. The operational record shows that this test covered only the file-services tier and did not perform a restore of the clinical database tier. The clinical database tier had never been restored end to end in the Norvane environment; restore tests were conducted at vendor level only. The claim in DOC-019 section 8 that restore testing is "performed twice yearly across all backup tiers" is therefore not supported by operational evidence. DOC-018 section 6 states that restore tests "cover the file-services tier only" and that "database restores are tested at vendor level, not end to end in the Norvane environment." The validation section of DOC-019 has not been revised to reflect what is actually tested.

5. **Replication lag is not alerted on.** Replication lag between bkparr-01 and bkparr-02 is collected and displayed on the dashboard but generates no alert (DOC-021 section 6). A significant lag would have been visible on the dashboard but was not surfaced to on-call staff.

## What went well

- The P1 was activated immediately when the storage controller failure was detected, triggering the on-call rota without delay.
- The correct runbook (DOC-018) was followed throughout the restore operation.
- The Service Desk team maintained regular communication with the customer, including notification of the data-loss window at 09:15.
- The restore was completed within a reasonable timeframe given the constraints of working with a stale backup point.

## Action items

| # | Action | Owner | Due date | Status |
|---|---|---|---|---|
| 1 | Configure alerts on protected-object failures rather than appliance job status | Marko Heinänen | 2026-06-30 | Completed 2026-06-11 |
| 2 | Configure alerts on replication lag between bkparr-01 and bkparr-02 | Emil Nyberg | 2026-06-30 | Still open |
| 3 | Schedule an end-to-end restore test of the clinical database tier | Emil Nyberg | 2026-09-30 | Still open |
| 4 | Revise the validation section of DOC-019 to reflect what is actually tested | Marko Heinänen | 2026-06-30 | Still open |

## Lessons learned

1. **Alert on protected-object status, not job status.** Monitoring the appliance's job status alone is insufficient to detect backup failures. When the protected object is the thing that matters, the alert must watch the protected object.

2. **Replication lag must be alerted on.** The dashboard display is not sufficient; active alerting is required. As documented in DOC-021 section 6, replication lag is not alerted on. This is a gap that must be closed.

3. **Disaster recovery plan validation must reflect reality.** A DR test report claiming all tiers were exercised must be supported by evidence. When the operational record shows that only the file-services tier has been restored end to end, the plan must be updated to reflect that. Testing must cover every tier that the plan claims to cover.