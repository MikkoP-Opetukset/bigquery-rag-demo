---
doc_id: DOC-006
title: Support Tier Definitions (P1-P4)
doc_type: reference
owner: Service Desk (Marko Heinänen)
version: "5.1"
status: current
classification: internal
created: 2018-05-20
updated: 2025-09-15
review_due: 2026-09-15
source_location: Confluence / Service Desk / Severity Matrix
related: [DOC-001, DOC-020, DOC-023]
supersedes: [v4.0]
---

# Support Tier Definitions (P1–P4)

## 1. Severity matrix

| Severity | Definition | Typical examples |
|---|---|---|
| **P1** | Complete loss of a covered service, or loss affecting patient safety, statutory reporting or all trading locations. No workaround. | Core switch down; site offline; backup restore fails during a declared disaster |
| **P2** | Major degradation of a covered service, or loss affecting a significant subset of users with no acceptable workaround. | One store offline; firewall blocking a business-critical SaaS application; 30–70% of users unable to work |
| **P3** | Degradation with an acceptable workaround, or a single user or small group affected. | Port flapping; one user's VPN broken; print queue stuck |
| **P4** | Cosmetic, informational, or a request for change rather than a fault. | Documentation correction; capacity question; cosmetic UI issue |

Severity is set by Norvane at triage and may be re-graded with the Customer's
agreement. A Customer may request an upgrade to P1; the duty manager decides
within 30 minutes and records the decision on the ticket.

## 2. Response and resolution clocks

The clock starts when the ticket is created in the ITSM system, not when the
Customer notices the fault. For telephone-reported incidents, the clock starts
at call answer.

Committed values are per Customer tier and are held in the `sla_targets` table.
The generic framework is:

| Tier | P1 response | P1 resolution | P2 response | P3 response |
|---|---|---|---|---|
| Platinum | 15 min | 4 h | 30 min | 4 h |
| Gold | 30 min | 8 h | 1 h | 8 h |
| Silver | 60 min | 12 h | 2 h | 1 business day |
| Bronze | 4 business hours | 24 business hours | 4 business hours | 2 business days |

**Response** means a qualified engineer has engaged, acknowledged the
incident to the Customer and begun diagnosis. An automated acknowledgment does
not stop the clock.

**Resolution** means the service is restored to its documented function. A
workaround agreed with the Customer stops the resolution clock but opens a
linked P3 problem ticket.

## 3. Escalation triggers

Automatic escalation to the duty manager occurs when:

- a P1 is unacknowledged at 50% of the response window
- a P1 remains unresolved at 75% of the resolution window
- a P1 has more than three Customer chase contacts
- three or more P1s are open simultaneously

Further escalation paths are in DOC-020.

## 4. Downgrade rules

A P1 is downgraded to P2 only when the service is restored or when the
Customer and the duty manager agree that the fault is narrower than first
reported. Downgrade does not retroactively remove the response-clock
commitment.

## 5. Out-of-hours behaviour

Platinum and Gold Customers are supported 24x7 for P1 and P2. Silver and
Bronze are supported in business hours; a P1 raised out of hours pages the
on-call rota, but P2 and below are queued until the next business day.

## 6. Common errors at triage

- Classifying a single-user VPN fault as P2 instead of P3 inflates the
  reporting and creates false breaches.
- Classifying a store outage as P3 during peak trading is a recurring
  disagreement with Cobalt; the peak-period terms in DOC-004 section 3 govern.
- Recording the Customer's "first noticed" time as the open time distorts the
  response metric.
