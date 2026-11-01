---
doc_id: DOC-013
title: Firewall Change Management Policy
doc_type: policy
owner: Aino Salo
version: "3.0"
status: current
classification: internal
created: 2022-05-30
updated: 2025-03-02
review_due: 2027-03-02
source_location: SharePoint /Security/Policies/Firewall Change Management Policy v3.0.docx
related: [DOC-006, DOC-024, DOC-021]
supersedes: [v2.0]
synthetic: true
---

# Firewall Change Management Policy

## 1 Purpose

This policy governs all changes to firewall rules on Norvane's FortiGate 400F edge pair (fw-edge-01, fw-edge-02), Catalyst core zone-firewalls, and VPN concentrator policies. Firewall changes carry high risk — a single mis-ordered rule can expose internal services or break customer traffic. Every change must be authorised, tested, peer-reviewed, and documented before touching production.

## 2 Scope

This policy applies to every modification of a firewall rule — additions, deletions, source/destination/port changes, and rule reordering — on edge firewalls, core switch zone policies, and VPN concentrator rules. Firmware upgrades and interface changes are excluded (DOC-012, DOC-024). All Norvane personnel with firewall write access, external contractors managing firewall objects, and the security engineering team are subject to this policy.

## 3 Change classes

**Standard changes** are pre-approved, recurring modifications affecting no more than five ports. They are logged as tickets with no CAB approval required, but must be peer-reviewed by a second security engineer before implementation.

**Normal changes** cover all other modifications: new destination networks, changes affecting more than five ports, any internet-facing rule, and any change altering a customer-facing service scope. Normal changes require CAB approval, a written rollback plan, and five business days' lead time.

**Emergency changes** must be implemented immediately to resolve an active security incident, critical outage, or compliance breach. They follow a fast-tracked approval path (see §9) and are subject to retrospective CAB review.

## 4 Approval and the CAB

Normal and emergency changes require CAB approval. The CAB meets weekly on Tuesdays at 10:00 EET. Standing members are the Security Lead, the Head of Infrastructure, the Service Delivery Manager, and a rotating Service Desk representative.

The CAB reviews each ticket for impact analysis, rollback feasibility, timing, and peer-review confirmation. Peer review by a second security engineer is mandatory before the ticket reaches the CAB; the reviewer's initials and date must appear on the ticket. Changes affecting more than five ports or any internet-facing rule require CAB sign-off and cannot be handled as standard changes.

## 5 Lead time and scheduling

Normal changes require five business days' lead time between CAB approval and implementation. A business day is 07:00–18:00 EET/EEST, Monday–Friday, excluding Finnish public holidays. Insufficient lead time means deferral to the next CAB meeting unless the change qualifies as an emergency.

Implementation windows for normal changes are scheduled on Tuesdays or Thursdays during 18:00–22:00 EET unless the CAB authorises an alternative window.

## 6 Testing and rollback

A written rollback plan is mandatory before CAB approval. The plan must identify every rule to be added, modified, or reordered, specify the exact reversal action, and state the expected post-rollback state.

Changes must be tested in the staging environment (or in a non-production rule ordering on fw-edge-02) before implementation. Test results must be recorded on the ticket. Changes that break connectivity during testing require a revised rollback plan and renewed CAB approval.

## 7 Post-change verification

After implementation, the engineer runs a verification test: connectivity checks from source to destination on every affected port. A 30-minute observation window follows. The ticket stays open during this window; any issue triggers immediate rollback. The ticket closes only after the window passes cleanly.

## 8 Rule lifecycle and review

Every edge firewall rule is reviewed every six months for business need, scope accuracy, and compliance. Rules with zero hits over a 12-month period are marked for removal — a notice is added to the rule description and removal occurs at the next change window. A final review of recent traffic confirms no burst or seasonal traffic is being overlooked.

Monitoring and alert thresholds supporting firewall reviews are defined in DOC-021.

## 9 Emergency changes

Emergency changes may be approved by the Security Lead together with the on-duty manager. Approval must be verbal or via synchronous communication; email alone is insufficient. The emergency ticket must be raised within 24 hours and must include a retrospective description, justification, and full rollback plan. Retrospective review occurs at the next CAB meeting. Emergency changes follow the same post-change verification and observation window as normal changes.

## 10 Records

All firewall change tickets are retained in the ITSM system for a minimum of three years. Records include the ticket number, change class, approval status, CAB minutes, peer review confirmation, rollback plan, verification results, and observation log. Emergency records also include the emergency justification and the retrospective CAB assessment. Service tier definitions for incident response are in DOC-006.