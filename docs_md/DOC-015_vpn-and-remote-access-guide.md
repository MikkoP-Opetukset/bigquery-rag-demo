---
doc_id: DOC-015
title: VPN and Remote Access Guide
doc_type: guide
owner: Aino Salo
version: "2.2"
status: current
classification: internal
created: 2020-11-05
updated: 2025-07-21
review_due: 2027-07-21
source_location: Confluence /Security/Access/Remote Access Guide
related: [DOC-011, DOC-041]
supersedes: [v2.0]
synthetic: true
---

# VPN and Remote Access Guide

## 1 Scope

This guide covers remote access to Norvane's network services via the site-to-site and remote-user VPN infrastructure. It describes the VPN concentrators, client software, authentication, session policies, split tunnelling rules, contractor-specific procedures, common troubleshooting scenarios, and support boundaries. This guide applies to all personnel who connect using the remote-user VPN and to the service engineers who manage the concentrators.

The VPN infrastructure does not grant unrestricted network access. The tunnel carries business traffic only. Access to management interfaces on network devices is outside the scope of this guide and is governed by DOC-041.

## 2 Client software and profiles

The standard VPN client for all Norvane users is FortiClient, using IPsec IKEv2. The client is deployed to all employee endpoints via the configuration management system, and to contractor endpoints on a case-by-case basis after security screening.

There is a single VPN gateway address, presented to users as vpn.norvane.internal. The gateway is load-balanced across two FortiGate 201F concentrators located at DC1 Helsinki (vpn-conc-01 as primary, vpn-conc-02 as secondary in active/passive mode). Users do not configure the gateway address directly; FortiClient resolves it automatically.

Portal profiles are configured per customer. Each customer profile is named after the customer's short name (for example, aurora, cobalt, feldspar) and contains the customer-specific address pools, DNS settings, and access rules. Users are assigned a single profile based on their employment relationship or contractor agreement. The profile determines which internal networks the user can reach after the tunnel is established.

## 3 Authentication

Authentication is performed against Microsoft Entra ID using SAML as the primary factor. All users authenticate with their corporate credentials through the SAML assertion flow. FortiClient handles the SAML exchange transparently; the user sees only the standard Microsoft login prompt.

When SAML is unavailable — for example, due to an Entra ID outage or a network condition that prevents the SAML redirect — TOTP serves as the fallback factor. TOTP is configured through the Norvane mobile authentication application. The TOTP code is entered manually into FortiClient after the primary SAML attempt fails. Fallback to TOTP is automatic; the user is not required to request it.

Multi-factor authentication is mandatory on every VPN profile. There are no exceptions. Both the SAML + TOTP combination and the standalone TOTP fallback satisfy the MFA requirement. Password-only access is never granted.

## 4 Session policy

The maximum session lifetime is 10 hours. After 10 hours of continuous connection, the VPN session is terminated and the user must re-authenticate. This applies to all users and all profiles regardless of customer tier or role.

The idle timeout is 30 minutes. If a user is inactive on the VPN for 30 minutes or more, the session is dropped. The user must re-authenticate to reconnect. Active sessions are identified by sustained traffic through the tunnel; users who leave sessions open without activity are expected to be re-authenticated by the idle timeout.

Sessions are logged in the concentrator's authentication log and forwarded to the SIEM for monitoring. Session records include the user identity, the customer profile, the timestamp, and the source IP address.

## 5 Split tunnelling

Split tunnelling is permitted only for the profiles listed in the approved allow-list, which is maintained by the security engineering team and referenced in the concentrator configuration. The allow-list identifies the specific customer profiles for which the user's local network traffic is not required to traverse the VPN tunnel.

For all profiles not on the allow-list, full tunnelling is enforced. This means that all IP traffic from the client is routed through the VPN tunnel to the destination network. Split tunnelling is not available for contractor profiles, for emergency access profiles, or for any profile that grants access to the management VLAN.

The allow-list is reviewed quarterly by the security engineering team. Changes to the allow-list must be approved by the Security Lead.

## 6 Contractor access

Contractors connecting via the VPN are subject to additional security requirements beyond those applied to employees. Before the VPN tunnel is established, FortiClient performs a posture check on the contractor device. The posture check verifies three conditions:

1. Disk encryption is active (BitLocker on Windows, FileVault on macOS).
2. The operating system is at or above the minimum patch level defined in the current patch standard.
3. A supported antivirus agent is installed, active, and up to date.

If any one of these checks fails, the tunnel is not established. Instead, the user is redirected to the remediation page, which provides instructions and the download links for the required software or configuration steps. The user may retry the connection after the remediation steps are complete.

Contractor VPN sessions are subject to the same session and idle timeouts as employee sessions. Contractor access is reviewed monthly by the service delivery team and is revoked automatically when the contractor agreement expires.

## 7 Troubleshooting

The following are the most commonly encountered VPN issues and their standard resolutions:

**Stale DNS after a customer move.** When a customer relocates to a new IP range and the address pool is updated, FortiClient may retain the old DNS entries in its cache. The user sees intermittent name resolution failures for previously reachable hosts. The standard resolution is to disconnect and reconnect the VPN, or to run the client DNS flush command. If the issue persists after reconnection, the concentrator's DNS settings should be verified against the customer's current IP plan in DOC-011.

**MTU or MSS problems on IPsec.** Users report that some web pages load incompletely or that large file transfers hang. This is typically caused by the IPsec encapsulation reducing the effective MTU below what the application expects. The standard resolution is to set the MSS clamping value on the VPN interface to match the minimum MTU of the tunnel path, or to enable automatic MTU discovery on the client profile.

**Expired client certificate.** FortiClient uses a device certificate for the initial IKE exchange. If the device certificate has expired — for example, after a device rebuild — the connection fails with an authentication error. The standard resolution is to request a new certificate through the certificate management portal and reinstall it on the device via the configuration management system.

**Locked AD account.** After multiple failed login attempts, the user's Active Directory account is locked and VPN authentication fails. The standard resolution is for the user to unlock the account through the self-service password reset portal or by contacting the service desk. After unlocking, the user reconnects the VPN.

**Profile mismatch after a customer site change.** When a customer adds or removes sites, the VPN profile may no longer match the user's expected access. The user reports missing resources or unexpected access to previously unreachable networks. The standard resolution is to verify the user's profile assignment in the concentrator configuration against the current site-to-profile mapping and to refresh the profile on the client if required.

## 8 Support boundaries

The service desk handles initial VPN connectivity triage: verifying the user's account status, confirming the VPN client is running, and testing basic authentication. Escalation to the network or security engineering teams is required when the issue involves concentrator configuration, profile assignment, or posture check failures.

Administrative access to network devices via the VPN is explicitly prohibited. Administrators must use the bastion host and the privileged access path defined in DOC-041. Any attempt to access management VLANs or management interfaces through the VPN tunnel is logged and may result in account suspension pending review.