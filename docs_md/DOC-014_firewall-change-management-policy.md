---
doc_id: DOC-014
title: Firewall Change Management Policy
doc_type: policy
owner: Ilkka Rantala
version: "1.0"
status: superseded
classification: internal
created: 2019-04-17
updated: 2019-04-17
review_due: 2020-04-17
source_location: //fs01.norvane.internal/policies/archive/firewall-change-policy-v1.0.doc
related: []
supersedes: [v0.5]
synthetic: true
---

**Version 1.0 — superseded by version 3.0. Retained for audit purposes.**

# Firewall Change Management Policy

## 1 Purpose

This document sets out the procedure for making changes to firewall rules on Norvane's perimeter and internal firewalls. All firewall modifications must be documented and approved before they are applied to any production device. The purpose of this policy is to maintain a controlled, auditable change process while keeping the team's ability to respond to business needs flexible and fast.

This policy was created as part of the migration to the new FortiGate estate, which is currently being rolled out across both data centres. It replaces the previous rule-change procedure documented in the earlier version of this file.

## 2 Scope

This policy applies to all changes on the firewall devices managed by the network team of four. Changes include additions, deletions, and modifications of any rule, whether on the edge firewalls or on internal zone-firewall policies. Changes to firewall firmware, interface configuration, or general device settings are not covered by this document — those fall under the infrastructure change procedure.

All members of the network team, the service desk, and any external contractors with firewall access are subject to this policy.

## 3 Change categories

Changes are divided into two categories:

**Standard changes.** These are routine, low-risk modifications that follow a documented and pre-approved procedure. Examples include adding a single destination IP to an existing allow rule, updating a port range within an already-approved service group, and removing a source address that was previously authorised by the Network Manager. Standard changes are logged as tickets but do not require further approval beyond the ticket record.

**Non-standard changes.** Any change that does not qualify as standard is non-standard. This includes the creation of entirely new rules, changes to internet-facing rules, and modifications that affect multiple customer services. Non-standard changes must be approved by the Network Manager before implementation.

## 4 Approval procedure

All non-standard changes require written approval from the Network Manager (Ilkka Rantala). Approval is obtained by email. The change request must be sent to the Network Manager at least 48 hours before the intended implementation date. The email must describe the change, the business reason, the scope of affected rules, and the engineer responsible for implementation.

The Network Manager will respond with approval, a request for more information, or a rejection. If more information is needed, the 48-hour clock restarts from the date of the Network Manager's reply. If the Network Manager is unavailable, the duty network engineer may provisionally approve a non-standard change and notify the Network Manager as soon as possible thereafter.

Standard changes do not require email approval but must be recorded on a change ticket with the implementing engineer's name and a description of the work performed.

## 5 Lead time

A minimum of 48 hours' notice is required for all non-standard changes. This means that the change request email must be sent to the Network Manager at least two business days before the intended implementation date. Changes requested on shorter notice will be deferred to the next available window unless the situation qualifies as an emergency.

Implementation of firewall changes is scheduled on a best-effort basis and is carried out during the evening maintenance window or, where urgent, during business hours with the approval of the Network Manager. The network team aims to have all non-standard changes implemented within ten business days of the Network Manager's approval, subject to operational priorities.

## 6 Testing

Changes should be tested before they are applied to production devices where practicable. The network team maintains a test firewall instance where rule ordering and rule content can be validated. If a suitable test instance is not available, changes must be implemented in a way that allows immediate rollback — typically by placing new rules below existing allow rules in the rule order and verifying connectivity before removing any deny rules.

No rollback plan is required for changes submitted under this policy. The implementing engineer is expected to retain the ability to revert any change immediately in the event of an unexpected impact.

## 7 Post-change verification

After a change is implemented, the implementing engineer should verify that the change works as expected and that no unintended traffic is now passing. This verification is informal and does not require a formal test procedure. Any issues identified during verification should be addressed before the change ticket is closed.

## 8 Rule review

All firewall rules are reviewed quarterly as part of the network team's routine maintenance. During the quarterly review, rules that have not carried traffic for more than six months are flagged for removal. The network team will also check for overlapping rules and redundant entries during the review.

The Network Manager is responsible for sign-off on any rule removals identified during the quarterly review.

## 9 Emergency changes

In the event of an emergency — for example, a critical security vulnerability that must be mitigated by closing a port, or a service outage caused by a firewall rule — the network team may apply a change immediately and notify the Network Manager by phone or email as soon as possible. The Network Manager will confirm the change in writing within 24 hours. Emergency changes are logged on a change ticket with a description of the emergency and the action taken.

## 10 Records

All firewall change tickets are retained in the ITSM system. Records include the ticket number, the category of change, the approval record (email or ticket note), and a description of the work performed. Ticket records are available to members of the network team and to the Service Desk for reference.