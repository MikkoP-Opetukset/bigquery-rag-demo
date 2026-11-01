---
doc_id: DOC-001
title: Master Service Level Agreement
doc_type: contract
owner: Legal & Compliance (Petra Lindqvist)
version: "4.2"
status: current
classification: confidential
created: 2019-08-01
updated: 2024-10-15
review_due: 2026-10-15
source_location: //fs01.norvane.internal/policies/legal/master-sla-v4.2.pdf
related: [DOC-002, DOC-003, DOC-004, DOC-005, DOC-006]
supersedes: []
---

# Master Service Level Agreement

**Norvane Managed IT Services Oy** ("Norvane") and the Customer named in the
applicable Service Schedule ("Customer").

Version 4.2, effective 1 January 2025. Replaces version 3.6 (2021-11-02).

## 1. Purpose and structure

This Master Service Level Agreement ("Master SLA") sets out the framework terms
under which Norvane delivers managed IT services. It does not by itself commit
Norvane to any specific performance level. The committed performance levels for
each Customer are set out in that Customer's **Service Schedule**, which
incorporates this Master SLA by reference.

The following documents form part of the agreement, in descending order of
precedence:

1. The Customer's Service Schedule
2. This Master SLA
3. The Service Credit and Penalty Policy (DOC-005)
4. The Support Tier Definitions (DOC-006)
5. Norvane's published operational policies, as amended from time to time

Where a Customer's Service Schedule and this Master SLA conflict, the Service
Schedule prevails for that Customer only.

## 2. Definitions

**Service Availability** — the percentage of minutes in a calendar month during
which a covered service is operational and able to perform its documented
function, excluding Excused Downtime.

**Excused Downtime** — downtime arising from: (a) a Customer-approved
Maintenance Window notified at least five (5) business days in advance;
(b) Customer-side faults including but not limited to Customer-owned equipment,
Customer network changes made without Norvane involvement, or Customer staff
actions; (c) Force Majeure; (d) suspension for non-payment.

**Severity** — P1 to P4 as defined in DOC-006.

**Recovery Time Objective (RTO)** — the maximum acceptable elapsed time from
declaration of a disaster to restoration of the service at the agreed
functional level.

**Recovery Point Objective (RPO)** — the maximum acceptable age, measured
backwards from the time of failure, of the most recent recoverable copy of data.

**Business Hours** — 07:00 to 18:00 EET/EEST, Monday to Friday, excluding
Finnish public holidays.

## 3. Service tiers

Norvane offers four service tiers: **Platinum**, **Gold**, **Silver** and
**Bronze**. The tier assigned to each Customer is stated in its Service
Schedule. Tier determines the committed availability target, the P1 response
and resolution obligations, the recovery objectives and the maximum service
credit percentage. Support tier definitions (P1–P4) are common to all tiers;
the tier determines the clock against which response and resolution are
measured.

## 4. Measurement and reporting

Availability is measured by Norvane's monitoring platform (DOC-021) using
synthetic probes at one-minute intervals, supplemented by device up/down traps.
Measurement methodology is not negotiable per Customer except where a Service
Schedule explicitly specifies an alternative probe set.

Where monitoring data is unavailable or disputed, the parties shall use the
ticketing system's recorded timestamps as the system of record.

Monthly service reports are issued within five (5) business days of month end
and state, per covered service: availability achieved, incident counts by
severity, P1 response and resolution performance, and any credit due.

## 5. Service credits

Service credits are the Customer's sole and exclusive remedy for failure to
meet a committed service level. The credit schedule, calculation method, caps
and claim procedure are set out in DOC-005. Credits are applied against the
following month's invoice and are not payable in cash.

## 6. Exclusions

Norvane is not responsible for performance of services, applications or
connectivity not supplied by Norvane, including Customer-owned WAN links,
third-party SaaS applications and Customer-managed on-premises systems, except
where a Service Schedule explicitly extends coverage.

## 7. Term, termination and review

Initial term and renewal terms are stated in each Service Schedule. Either
party may terminate for material breach with thirty (30) days' written notice
and a fifteen (15) day cure period. This Master SLA is reviewed annually by
Legal & Compliance; the current review date is shown in the document metadata.

## 8. Change control

Amendments require written agreement of both parties. Norvane may amend
operational policies referenced in clause 1 without Customer consent provided
the amendment does not reduce a committed service level.
