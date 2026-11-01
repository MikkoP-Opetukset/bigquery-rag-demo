---
doc_id: DOC-042
title: New Starter IT Onboarding Checklist
doc_type: checklist
owner: Tuomas Virta
version: "3.4"
status: current
classification: internal
created: 2019-08-27
updated: 2026-09-01
review_due: 2027-09-01
source_location: Confluence /People/IT Onboarding Checklist
related: [DOC-015, DOC-025, DOC-041]
supersedes: [v3.3]
synthetic: true
---

# New Starter IT Onboarding Checklist

## 1. Purpose

This checklist ensures new Norvane employees and contractors receive the IT access, equipment, and training required for their role before they begin. The Service Desk executes each item. The hiring manager ensures the request is raised in time and role-specific items are communicated.

## 2. Before day one

The hiring manager raises the onboarding request at least five business days before the start date. It must include the employee's full legal name, job title, department, start date, line manager, and a role description.

- [ ] Confirm the request was raised at least five business days before the start date. Short-notice requests are flagged to the hiring manager for deferral.
- [ ] Verify identity against the HR record. Accounts are created from the HR record, not from the email address.
- [ ] Create the user identity in Active Directory, created in a disabled state to be enabled on first morning.
- [ ] Determine role-specific additions from Section 5. Mark N/A with a reason if none apply.
- [ ] Prepare a laptop with the standard image (DOC-025). Must be encrypted before handover.
- [ ] Reserve a desk and equipment (monitor, docking station, headset) for the workspace.

## 3. Day one

The Service Desk executes these items on the first morning before any team meeting.

- [ ] Enable the Active Directory account. Confirm login by having the new starter change their temporary password.
- [ ] Enrol in MFA using the corporate authenticator. Confirm MFA is active and a backup code recorded.
- [ ] Issue the laptop. Verify full-disk encryption is active and the device is enrolled in endpoint management.
- [ ] Connect to corporate Wi-Fi by distributing the Wi-Fi profile (802.1X with PEAP-MSCHAPv2).
- [ ] Install and configure the VPN client per DOC-015. Confirm VPN connection with the correct network access profile.
- [ ] Create and configure the mailbox. Verify email send/receive and global address list visibility.
- [ ] Provision a ticket system account. Confirm login and test ticket creation.
- [ ] Provide DOC-025 and DOC-041 for reading.
- [ ] Record acknowledgement of DOC-025 and DOC-041 in the onboarding ticket, including timestamp and identity.

## 4. First week

The following items must be completed within the new starter's first seven calendar days.

- [ ] Enrol the new starter in the on-call rota shadow for their team. The shadow rotation runs for two weeks; the new starter is not paged during this period.
- [ ] Assign the security awareness training module. Confirm completion within the first five business days.
- [ ] Verify that the new starter's access entitlements match their role. Compare the assigned groups and permissions against the role matrix maintained by the Service Desk Team Lead.
- [ ] Confirm that the new starter has received and acknowledged the Norvane acceptable-use policy.

## 5. Role-specific additions

Items in this section apply only to certain roles, specified by the hiring manager at request time.

- [ ] **Administrators**: Request bastion host access from the Security Lead per DOC-041. Approval required before creation. Confirm MFA enrolment on the bastion.
- [ ] **Network engineers**: Provision read-only device access for thirty days. Write access is added after thirty days with line manager confirmation.
- [ ] **Customer-facing roles**: Assign customer portal login for assigned accounts. Verify access against the customer contract tier.

## 6. First 30 days

- [ ] Conduct an access review with the line manager. Confirm entitlements are appropriate and no excess access was granted.
- [ ] Confirm no unexplained accounts or permissions in any system.
- [ ] Verify equipment is functioning correctly (laptop, VPN, Wi-Fi, mailbox).
- [ ] Complete and close the onboarding ticket only after all items are ticked.

## 7. Records and audit

Onboarding tickets are retained for six years after the new starter's end date (or contract end) in the ITSM system. Supporting records — MFA enrolment, equipment issue logs, training certificates, and policy receipts — are also retained for six years. The Service Desk Team Lead reviews a random sample of closed tickets each quarter.