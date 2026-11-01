---
doc_id: DOC-020
title: On-Call and Escalation Policy
doc_type: policy
owner: Tuomas Virta
version: "2.5"
status: current
classification: internal
created: 2019-01-28
updated: 2026-03-16
review_due: 2027-03-16
source_location: Confluence /Service Delivery/On-Call
related: [DOC-006, DOC-023]
supersedes: [v2.0]
synthetic: true
---

# On-Call and Escalation Policy

## 1. Purpose

This policy governs the on-call rota, acknowledgement obligations, and escalation
ladder for Norvane Managed IT Services Oy. It applies to all members of the
Service Desk and Infrastructure teams who participate in the support operation.
Severity classifications follow DOC-006.

## 2. Coverage and rota

Norvane provides 24 × 7 coverage for Platinum and Gold customers for P1 and P2
incidents. Silver and Bronze customers receive support during business hours only
(07:00–18:00 EET/EEST, Monday to Friday, excluding Finnish public holidays); a
P1 raised out of hours pages the on-call rota as a fallback.

The rota is published every Monday by the duty manager and covers 24-hour
calendar shifts. Each shift carries one primary engineer and one secondary
engineer. The primary holds the console; the secondary monitors the queue and
stands ready to assume the primary role if the primary is unavailable.

Shift handover is conducted at 08:00 EET each morning. A written handover record
is posted to the shared Service Desk folder and attached to the corresponding
incident management ticket; see section 6.

## 3. Acknowledgement obligations

Every page or assignment in the Service Desk system must be acknowledged within
15 minutes of receipt. The acknowledgement may be a status change in the ITSM
tool or a voice call to the originating channel.

If the primary engineer fails to acknowledge a page within 15 minutes, the
system automatically pages the secondary engineer on the same shift. A P1 must be
escalated to the duty manager within 15 minutes of ticket creation. The duty
manager records the escalation reason on the ticket and notifies the affected
customer if the response window has been exceeded.

All acknowledgement times are logged in the Service Desk audit trail and form the
basis of the monthly SLA compliance report.

## 4. Escalation ladder

The escalation ladder for incidents is:

1. Duty engineer (primary on-call)
2. Duty manager
3. Head of Infrastructure
4. Service Delivery Manager

The duty manager holds the rota contact sheet. Individual mobile numbers are never
published in this document or in any customer-facing material. If escalation is
required, the duty engineer or secondary contacts the duty manager through the
process described in DOC-023.

The Head of Infrastructure is escalated when the incident affects more than one
data centre or requires a change outside normal maintenance windows. The Service
Delivery Manager is the final escalation point and owns customer communication
throughout the incident.

## 5. Out-of-hours authority

During out-of-hours periods (defined as outside 07:00–18:00 EET/EEST Monday to
Friday, excluding Finnish public holidays), the authority to approve an emergency
infrastructure change rests with the duty manager acting jointly with the
Security Lead. This follows the change management process documented in DOC-013
and supersedes the normal CAB approval requirement for emergency items only.

The duty manager logs the joint approval on the change ticket and obtains formal
CAB sign-off within two business days of the implementation.

## 6. Handover

The handover at 08:00 must include:

- A list of all open P1 and P2 incidents, with current status and any SLA
  countdowns.
- Pending customer callbacks, including the requested callback window and the
  customer tier.
- Any active change freeze, with its scope and the name of the person who
  imposed it.
- Outstanding action items from the previous shift that were not closed.

The outgoing primary and incoming primary both sign the handover record. Any
discrepancy must be resolved before the 08:00 handover concludes.

## 7. Records

All on-call shifts, handover records, escalation events, and acknowledgement times
are retained for a minimum of two years in the Service Desk repository. Quarterly
reviews of the rota coverage are performed by the Service Delivery Manager to
ensure adequate staffing across all tiers.