---
doc_id: DOC-023
title: Incident Management Process
doc_type: process
owner: Tuomas Virta
version: "4.2"
status: current
classification: internal
created: 2017-05-11
updated: 2026-03-16
review_due: 2027-03-16
source_location: Confluence /Service Delivery/Incident Management
related: [DOC-006, DOC-020]
supersedes: [v4.0]
synthetic: true
---

# Incident Management Process

## 1. Purpose

This process governs incident management at Norvane Managed IT Services Oy,
covering roles, timelines, and communication requirements for every severity
level. Severity definitions follow DOC-006.

## 2. Ticket lifecycle

Every incident progresses through these stages:

1. **New**
2. **Triaged**
3. **Assigned**
4. **In progress**
5. **Resolved**
6. **Closed**

Re-opening is permitted within five business days of closure without manual
approval. A resolved ticket not re-opened is auto-closed after 10 business days.

## 3. Triage

Triage must be completed within 15 minutes of ticket creation during business
hours (07:00–18:00 EET/EEST, Monday to Friday, excluding Finnish public
holidays). During out-of-hours periods the target is the next page interval of
the on-call rota.

The triaging engineer must confirm or assign a severity (P1–P4) per DOC-006,
assign a responsible engineer from the appropriate rota or team, record the
customer tier and the applicable response window, and add a triage note
describing observed symptoms and initial diagnostic steps.

## 4. Escalation

The escalation rules are:

- A P1 is escalated to the duty manager within 30 minutes of ticket creation,
  regardless of current status.
- A P2 that is unassigned after 30 minutes is escalated to the duty manager.
- A P1 that reaches 50% of its resolution window without a confirmed fix is
  escalated to the Head of Infrastructure.

The Service Delivery Manager must be informed of any P1 that breaches the SLA
response or resolution window.

## 5. Major incident management

A major incident is declared when a P1 affects more than one customer or has
lasted for more than two hours without resolution. Upon declaration:

- An incident commander is named within 10 minutes. The incident commander is
  separate from the duty engineer and coordinates the response.
- A dedicated major-incident bridge call or chat channel is opened immediately.
- Status updates are issued every 30 minutes to all affected customers and to
  the Service Delivery Manager. Updates must include the current status, the
  estimated time to the next update, and any customer-facing actions required.
- All subsequent changes during the major incident are logged under a single
  change ticket referencing the incident ID.

## 6. Customer communication

Platinum and Gold customers receive telephone notification from the duty engineer
within the response window defined in DOC-006, followed by a formal email
summary within one hour.

Silver and Bronze customers receive an email notification within the response
window. Telephone notification is not automatic but may be initiated by the
incident commander for P1 events.

## 7. Postmortems

A written postmortem is required for every P1 incident within 10 business days
of resolution. Postmortems for P2 incidents are optional and at the duty
manager's discretion.

Postmortems are conducted under a blameless framework. Every postmortem must
include a summary and timeline, impact assessment, root cause, detection and
response assessment, contributing factors, a description of what went well,
action items with named owners and due dates, and lessons learned. Open action
items must be published in the team backlog; closed items must include their
completion dates.

Postmortems are stored in the Service Desk repository. A customer-facing
summary is extracted per section 6.

## 8. Closure and records

An incident is closed when the service is restored or a workaround is in place,
all required communications have been sent, and the postmortem (if required) has
been completed and filed.

Closed incidents are retained in the ITSM system for a minimum of three years.