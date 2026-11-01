---
doc_id: DOC-024
title: Change Management Policy
doc_type: policy
owner: Marko Heinänen
version: "3.3"
status: current
classification: internal
created: 2017-05-11
updated: 2026-04-30
review_due: 2027-04-30
source_location: Confluence /Service Delivery/Change Management
related: [DOC-013, DOC-022, DOC-023]
supersedes: [v3.2]
synthetic: true
---

# Change Management Policy

## 1 Purpose

This policy establishes the framework under which all changes to Norvane's
production infrastructure, managed services, and supporting systems are planned
and recorded. The objective is to reduce unplanned service disruption while
maintaining sufficient agility.

## 2 Scope

This policy applies to every person employed by Norvane or engaged as a
subcontractor who creates, modifies, or removes configuration items in a
production environment. It covers all infrastructure documented in the network
architecture overview (DOC-010), including DC1 (Helsinki Pasila), DC2 (Tampere
Kaleva), and all managed customer sites.

Specific processes under this policy include the firewall rule-change process
in DOC-013 and the patching windows in DOC-022. Incidents arising from changes
are handled according to DOC-023.

## 3 Change categories

Changes fall into three categories:

**Standard changes** are pre-approved, low-risk, and repeatable. They follow a
documented procedure and carry no risk of service disruption. Examples include
routine firewall rule additions within an approved range, password resets for
managed accounts, and adding a single access-port assignment to an existing
VLAN. Standard changes do not require CAB review.

**Normal changes** are any change that does not qualify as standard. Each must
be raised as a Change Request (CR) with a change ID in the format CHG-YYYY-NNNN.
It is assessed by the CAB before implementation. Typical lead time is five
business days.

**Emergency changes** are changes that must be implemented immediately to
restore service, address a security vulnerability, or comply with a statutory
requirement. The emergency process is governed by DOC-013 when the change
involves a firewall rule. Emergency changes are approved by the Head of
Infrastructure (or the Security Lead for security-specific changes) and receive
retrospective CAB review within five business days.

## 4 The CAB

The Change Advisory Board meets weekly, normally on Tuesdays at 10:00 EET.
Quorum is three members. The CAB is chaired by the Head of Infrastructure and
its membership is fixed:

- The Head of Infrastructure (chair)
- The Security Lead
- The Service Delivery Manager
- A Service Desk representative

Decisions are recorded on the change ticket. The CAB may convene ad hoc when
an urgent matter requires assessment outside the scheduled meeting.

## 5 Risk assessment and backout

Every normal change and every emergency change requires a written risk
assessment and a backout plan. The risk assessment covers the expected impact,
the affected services, and the execution window.

The backout plan names the trigger condition under which the change is reversed
and identifies the person authorised to invoke it. That person must not be the
sole implementer; at least one second person must confirm that backout conditions
have been met. The backout plan is reviewed and acknowledged by the CAB before
a normal change is approved.

## 6 Change freeze

Change freeze periods during which only emergency changes are permitted are:

- 23 December to 2 January inclusive (annual holiday freeze)
- Any period a Customer has defined in their contract as a peak trading period

During a freeze, normal and standard changes are suspended. Emergency changes
require written approval of the Head of Infrastructure and are recorded with
the reason code `FREEZE_OVERRIDE`.

## 7 Failed changes

A failed change is one that produces an unintended outcome requiring backout,
service degradation, or a corrective change after CAB approval. Every failed
change is reviewed at the next CAB meeting with a written post-implementation
review (PIR).

Three failed changes of the same type in a single quarter trigger an automatic
design review by the Security Lead and the Head of Infrastructure. The design
review examines the underlying architecture or procedure that repeatedly fails
and recommends corrective action before further changes of that type are
approved.

## 8 Records

All changes are recorded in the ITSM system with their assigned CHG-YYYY-NNNN
identifier. CAB meeting minutes, the approved change schedule, PIR reports, and design-review output are documented for at least two years.