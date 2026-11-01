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

This guide covers remote access to Norvane's network services via the site-to-site and remote-user VPN infrastructure. It applies to all remote-user VPN users and to the service engineers managing the concentrators. The tunnel carries business traffic only; administrative access to network devices is not permitted over the client VPN.

## 2 Client software and profiles

The standard client for all users is FortiClient, using IPsec IKEv2, deployed to employee endpoints via the configuration management system and to contractor endpoints case by case after security screening.

The single gateway address vpn.norvane.internal, resolved automatically by FortiClient, is load-balanced across two FortiGate 201F concentrators at DC1 Helsinki: vpn-conc-01 primary, vpn-conc-02 secondary in active/passive mode.

Portal profiles are configured per customer, named after the customer's short name (for example, aurora), and contain customer-specific address pools, DNS settings, and access rules. Users hold a single profile, assigned by employment relationship or contractor agreement, which determines which internal networks they reach.

## 3 Authentication

Authentication runs against Microsoft Entra ID via SAML as the primary factor; users authenticate with corporate credentials and see only the standard Microsoft login prompt. When SAML is unavailable — for example an Entra ID outage — TOTP, configured through the Norvane mobile authentication application, is the automatic fallback factor.

Multi-factor authentication is mandatory on every VPN profile, without exception. Password-only access is never granted.

## 4 Session policy

The maximum session lifetime is 10 hours for all users and profiles, regardless of customer tier or role; on expiry the session terminates and the user re-authenticates. The idle timeout is 30 minutes, measured by sustained traffic through the tunnel.

Sessions are logged in the concentrator's authentication log and forwarded to the SIEM. Records include user identity, customer profile, timestamp, and source IP.

## 5 Split tunnelling

Split tunnelling is permitted only for profiles on the approved allow-list, maintained by the security engineering team and referenced in the concentrator configuration; local traffic on those profiles does not traverse the tunnel. All other profiles are enforced as full tunnel, including contractor, emergency access, and management-VLAN profiles.

## 6 Contractor access

Contractors face additional requirements. Before the tunnel is established, FortiClient runs a posture check on contractor devices verifying three conditions: disk encryption is active, the OS is at or above the minimum patch level in the current patch standard, and a supported antivirus agent is installed, active, and up to date. If any check fails, the tunnel is not established and the user is redirected to the remediation page, where the required fixes are listed and the connection can be retried.

Contractor sessions share the same session and idle timeouts as employee sessions. Contractor access is reviewed monthly by the service delivery team and revoked automatically when the contractor agreement expires.

## 7 Troubleshooting

**Stale DNS after a customer move.** After a customer relocates to a new IP range, FortiClient may retain stale DNS entries in its cache, causing intermittent name resolution failures. Disconnect and reconnect, or run the client DNS flush command. If failures persist, verify the concentrator's DNS settings against the customer's current IP plan in DOC-011.

**MTU or MSS problems on IPsec.** Partial page loads or hanging file transfers typically stem from IPsec encapsulation reducing the effective MTU below what the application expects. Set the MSS clamping value on the VPN interface to the tunnel path's minimum MTU, or enable automatic MTU discovery on the client profile.

**Expired client certificate.** FortiClient uses a device certificate for the initial IKE exchange. An expired certificate causes an authentication error. Request a new certificate through the certificate management portal and reinstall it via the configuration management system.

**Locked AD account.** Repeated failed logins lock the user's Active Directory account and VPN authentication fails. Unlock it through the self-service password reset portal or the service desk, then reconnect.

**Profile mismatch after a customer site change.** After a customer adds or removes sites, the profile may no longer match expected access; resources go missing or appear unexpectedly. Verify the assignment against the current site-to-profile mapping in the concentrator configuration and refresh the client profile if required.

## 8 Support boundaries

The service desk handles initial triage: account status, client status, and basic authentication. Escalation to the network or security engineering teams covers concentrator configuration, profile assignment, and posture check failures. Administrators connect to network devices via the bastion host and the privileged access path defined in DOC-041.
