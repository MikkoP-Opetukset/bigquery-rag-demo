---
doc_id: DOC-012
title: Core Switch Configuration Standard
doc_type: standard
owner: Marko Heinänen
version: "2.4"
status: current
classification: internal
created: 2019-06-03
updated: 2025-12-08
review_due: 2026-12-08
source_location: //fs01.norvane.internal/infra/network/standards/core-switch-config-v2.4.docx
related: [DOC-011, DOC-024, DOC-041]
supersedes: [v2.3]
synthetic: true
---

# Core Switch Configuration Standard

## 1. Scope

This standard defines the gold-image configuration baseline for all Cisco Catalyst switches in the Norvane managed network. It applies to Catalyst 9500 (core), Catalyst 9300 (distribution), and Catalyst 9200 (access layer) platforms. Any switch that is part of the core or distribution fabric must conform to this document unless a formal exception is on file.

## 2. Firmware baseline

The supported firmware baseline for core and distribution switches is IOS-XE 17.9.4a. Access layer switches may run 17.6.5 where full 17.9.x support is not yet available on the target platform.

Two access layer devices are currently outside the supported baseline and are flagged for upgrade:
- The eastgate-offices access switch (running 17.3.8)
- The brambleby-depot access switch (running 17.3.8)

These devices are noted in DOC-041's asset register and must be upgraded to at least 17.6.5 as part of the next maintenance window. Until upgraded, they carry an open exception under this document.

## 3. Base configuration

All switches are configured from a common gold image that sets the following defaults:

- Hostname in the format `site-role-NN` (e.g. dc1-core-01)
- DNS domain set to `norvane.internal`
- NTP synchronised from internal sources only — no public NTP servers
- Syslog directed to the central collector on the management VLAN
- Banner displaying the Norvane security notice on all login banners
- HTTP server disabled; only HTTPS (TLS 1.2 or later) for management access
- CDP and LLDP both enabled globally for interoperability

## 4. Spanning tree and link aggregation

Rapid PVST+ is the spanning tree protocol across all VLANs. An explicit root bridge is configured per VLAN: core-sw-01 is the primary root for all data VLANs, and core-sw-02 is the secondary root. Bridge priority is set explicitly rather than relying on MAC address as the tiebreaker.

Uplinks to the access layer are bundled into LACP port-channels with the switchport in `mode active` (active-only; PAgP is not used). Access layer switchports accept LACP port-channels and reject PAgP.

Jumbo frames (MTU 9000) are enabled on the transit VLAN (999) only. All other VLANs use the standard 1500-byte MTU. This ensures no fragmentation of inter-site replication traffic while avoiding compatibility issues on standard access ports.

## 5. Management plane

Management access follows these rules:

- SNMPv3 is the only supported SNMP version. SNMPv2c is explicitly prohibited on all switchports.
- NTP sources are internal only; the NTP server at DC1 provides time synchronisation to all switches.
- Syslog is forwarded to the central collector. Local logging is retained at debugging level for a rolling 72-hour window.
- The management VLAN (99) is the sole VLAN permitted for out-of-band and in-band management traffic.
- HTTPS is enabled for GUI access; HTTP is disabled across all ports.

## 6. Access control

- TACACS+ is used for all administrative authentication. Per-user accounts are required; shared or group accounts are prohibited.
- Exactly one break-glass local account exists per device. Its credential lives in the vault and is used only when TACACS+ is unavailable. Access via this account triggers an immediate alert to the security team.
- Unused switchports are administratively shut down and parked in a blackhole VLAN (VLAN 9999) to prevent unauthorized device attachment.
- Port security is enabled on all user-facing ports with a maximum of two MAC addresses and shutdown action on violation.

## 7. Configuration backup

The running configuration is backed up to the vault (//fs01.norvane.internal/vault/switch-configs/) after every change. The backup process is triggered automatically through the change management system and also runs as a cron job every six hours. Configuration diffs are generated and compared against the previous backup to detect unauthorized or unrecorded changes.

## 8. Baseline deviations

Any deviation from this gold image — including custom VLANs, non-standard spanning tree settings, or alternative authentication methods — must be documented in a change request with full justification. Approved deviations are recorded as exceptions in this document. No deviation is permissible without an associated change ticket.

## 9. Exceptions

Exceptions require written approval from the Head of Infrastructure and expire after 90 days. Expired exceptions must be renewed or the non-compliant configuration must be reverted. The current exception covering the eastgate-offices and brambleby-depot access switches (IOS-XE 17.3.8) expires on 2026-06-30 and must be renewed if upgrades cannot be completed in the planned maintenance window.