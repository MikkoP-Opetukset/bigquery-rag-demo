---
doc_id: DOC-022
title: Patching and Maintenance Windows
doc_type: policy
owner: Marko Heinänen
version: "2.0"
status: current
classification: internal
created: 2020-04-06
updated: 2025-08-25
review_due: 2026-08-25
source_location: Confluence / Infrastructure / Operations / Patching
related: [DOC-004, DOC-012, DOC-024]
supersedes: [v1.0]
synthetic: true
---

# Patching and Maintenance Windows

## 1 Purpose

This policy defines the patching cadence and maintenance windows for Norvane's infrastructure. It applies to all network equipment, servers, and appliances managed by Norvane at DC1 (Helsinki) and DC2 (Tampere), as well as customer-premises devices. The purpose is to ensure security and operational patches are applied promptly and consistently, with minimal disruption to customer services.

## 2 Patch cadence

Norvane performs monthly firmware and OS patching on all managed equipment. A quarterly review of the firmware baseline is carried out to evaluate new releases and plan adoption. The current firmware baseline is IOS-XE 17.9.4a on core switches and FortiOS 7.2.9 on edge firewalls, as recorded in DOC-012.

Critical security patches on internet-facing equipment must be applied within 14 days of vendor release. Critical security patches on internal-only systems must be applied within 30 days.

Any patch that cannot be applied within the applicable window becomes a tracked exception. Exceptions are documented in the ITSM system and reviewed quarterly.

## 3 Maintenance windows

The standard maintenance window for all patching and firmware changes is Sunday 01:00–05:00 EET. Windows may be shortened or extended at the discretion of the Head of Infrastructure.

Platinum Customers may have individual maintenance windows agreed in their service schedule. These take precedence over the standard window when they conflict.

Maintenance windows are excluded during peak trading periods for retail Customers. The exclusion periods are defined in DOC-004 section 3 and are applied automatically by the change calendar. No patching work occurs during those periods except under a P1 incident.

## 4 Notification

The Service Desk sends notification to every customer's nominated technical contact and copies the notification to the Service Desk mailbox. A standard maintenance window is announced at least 5 business days before the window start. A change to the firmware baseline (i.e. a version update not covered by the current quarterly review) requires 10 business days' advance notice.

Notifications include the affected equipment, the patch level, the expected downtime, and the backout procedure summary. Customers may reply with a documented objection within the notice period; unresolved objections are escalated to the Head of Infrastructure.

## 5 Backout

Every patch job requires a documented backout plan before the window opens. Acceptable backout methods are:

- Configuration restore from the configuration vault for software and configuration changes.
- Image rollback for major version upgrades where a previous image is retained on the device.

No change may proceed without an approved backout plan. The Service Desk verifies the backout plan is present in the change record before the window opens. A window without a documented backout is automatically cancelled.

Backout testing must confirm the device is operational and customer-facing services are restored. The duty engineer records the result in the change record.

## 6 Testing

All patches are applied to the staging lab at DC1 before production deployment. The staging lab mirrors the production topology for the device family being patched. A patch that causes a device to fail staging checks is held back until the root cause is identified and a remediation plan is recorded.

Staging test outcomes are recorded in the change record. A failed staging test does not automatically block production deployment; the Head of Infrastructure assesses risk and may authorise a targeted rollout with enhanced monitoring.

## 7 Exceptions

Exceptions to this policy — for example, an equipment vendor that no longer provides patches, or a legacy device for which no staged test environment exists — require written approval from the Head of Infrastructure.

An exception is tracked in ITSM and expires after 90 days. The owner of the exception must request a renewal before expiry. Unrenewed exceptions are escalated to the Service Delivery Manager.

The Head of Infrastructure reviews all open exceptions quarterly as part of the baseline review described in Section 2.