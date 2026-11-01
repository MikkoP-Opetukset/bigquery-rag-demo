---
doc_id: DOC-041
title: Privileged Access Management Policy
doc_type: policy
owner: Aino Salo
version: "2.0"
status: current
classification: confidential
created: 2020-10-08
updated: 2026-05-27
review_due: 2027-05-27
source_location: SharePoint /Security/Policies/PAM Policy v2.0.docx
related: [DOC-012, DOC-015, DOC-025]
supersedes: [v1.5]
synthetic: true
---

# Privileged Access Management Policy

## 1. Purpose

This policy governs all privileged access to the Norvane infrastructure. It ensures that administrative rights are assigned on a need-to-have basis, that every privileged action is attributable to a named individual, and that privileged sessions are recorded and auditable.

## 2. Scope

This policy applies to every individual requiring privileged access to systems within the Norvane managed environment or customer environments. It covers network devices (switches, routers, firewalls), hypervisor platforms (VMware vSphere), backup appliances (Dell PowerProtect DP4400), domain controllers, and the bastion host. It applies to Norvane employees, contractors, and third-party personnel granted access.

## 3. Principles

Privileged access is governed by the following principles:

- No shared accounts. Every administrator is assigned a named personal account used exclusively by that individual.
- No standing privilege where just-in-time (JIT) elevation is available. Where the platform supports JIT, the default state is privileged-off; elevation requires an approval step.
- Credentials are never stored in documents, spreadsheets, email, or chat applications. All secrets — passwords, API tokens, and keys — are stored exclusively in the vault.
- Access is granted by role and customer contract, never by individual request alone.

## 4. Accounts

Four account categories exist under this policy:

**Personal named accounts.** Every administrator receives a personal account on each platform. On network devices, authentication uses TACACS+. The server enforces per-user credentials and logs all login attempts.

**Break-glass accounts.** Exactly one local break-glass account exists per device family. The credential is held in the vault and is reserved for when the primary authentication system is unavailable. Activation raises an immediate alert to the security team.

**Service accounts.** Service accounts support automated processes, backup jobs, and monitoring integrations. Every service account is inventoried and documented in the vault with its purpose, owner, and last rotation date. Credentials are rotated at least annually as part of the vault rotation cycle.

**Customer break-glass accounts.** For customer sites requiring a break-glass procedure, Norvane maintains one account per device family accessible only via vault checkout. The customer is informed at the time of checkout.

## 5. Access path

All privileged administrative access must be performed through the bastion host. The bastion is the only system permitted for direct SSH, HTTPS, or console access to production devices. Direct management-plane access from user networks and the client VPN is prohibited (see DOC-015). This applies to all administrators, including senior staff.

## 6. Session controls

All privileged sessions are subject to the following controls:

- Multi-factor authentication required for every login to the bastion and any privileged platform.
- Sessions are recorded (terminal audio and command log), retained for twelve months.
- A deny-list of sensitive commands (e.g. firewall rule deletion, VLAN reconfiguration) requires a second approver in the bastion host.
- Idle sessions are terminated after sixty minutes.
- Access is logged to the central syslog collector and forwarded to the SIEM for real-time alerting.

## 7. Emergency access

Emergency access is used when a production-impacting incident requires immediate privileged action:

1. The administrator checks out the break-glass credential from the vault, recording the reason in the audit field.
2. The vault sends automatic notification to the Security Lead.
3. The administrator performs the remediation; all actions are recorded in the vault session log.
4. Within five business days, the Security Lead and Head of Infrastructure conduct a retrospective review to assess whether the emergency was justified.
5. A post-incident report is filed as a change record (CHG-YYYY-NNNN) or a postmortem.

## 8. Recertification

Privileged access is recertified quarterly by the Head of Infrastructure, who reviews each active account and confirms access is still required. Unrecertified accounts are revoked automatically within twenty-four hours of the deadline.

## 9. Records

Session recordings: twelve months. Break-glass checkout logs: indefinitely. Recertification reports: seven years. Emergency access reviews: six years. Service account inventory: updated at every rotation.