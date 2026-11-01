---
doc_id: DOC-021
title: Monitoring and Alert Thresholds
doc_type: reference
owner: Marko Heinänen
version: "3.1"
status: current
classification: internal
created: 2018-08-14
updated: 2026-06-11
review_due: 2027-06-11
source_location: Confluence / Infrastructure / Monitoring / Thresholds
related: [DOC-006, DOC-018, DOC-020, DOC-022]
supersedes: [v3.0]
synthetic: true
---

# Monitoring and Alert Thresholds

## 1 Purpose

This document defines the monitoring platform and alert thresholds for Norvane's managed infrastructure. It covers Norvane-owned equipment and customer-premises devices where Norvane operates the monitoring agent. The purpose is to ensure faults are detected within timeframes consistent with DOC-006 and DOC-020.

## 2 Platform and polling

All monitoring is performed through Zabbix. Zabbix polls every monitored device at 60-second intervals for SNMP-based metrics: CPU, memory, interface counters, temperature, power state, and fan status. The poller timeout is set to 55 seconds.

In addition to SNMP polling, Zabbix runs synthetic probes every 60 seconds:
- ICMP reachability checks against every IP in the device register.
- HTTP/HTTPS endpoint checks against VPN concentrator management URLs, verifying application-layer responsiveness.

SNMPv3 traps are accepted from all network devices and both backup appliances; traps bypass the polling interval and are processed immediately.

Syslog from routers, firewalls, switches, and backup appliances is forwarded to the Zabbix syslog receiver at DC1 and correlated against the active trigger table.

## 3 Alert classes and thresholds

The following table defines every alert trigger. Each row maps a condition to a severity and the detection window.

| Condition | Severity | Window |
|---|---|---|
| Link down (any documented interface port) | P1 | Immediate |
| Packet loss above 1 % over 5 minutes on a measured path | P2 | 5 min |
| Round-trip latency above 50 ms sustained for 5 minutes | P2 | 5 min |
| Interface error counters increasing on any uplink (CRC, runts, giants) | P2 | 10 min |
| CPU above 85 % for 10 minutes | P3 | 10 min |
| Memory above 90 % for 10 minutes | P3 | 10 min |
| Disk above 85 % | P3 | 1 poll |
| Power supply failure | P2 | Immediate |
| Fan failure | P2 | Immediate |
| BGP or upstream peer down | P1 | Immediate |
| Hardware temperature above vendor threshold | P2 | Immediate |
| Backup job failed | P2 | Immediate for Platinum/Gold; next morning for Silver/Bronze |
| Switch stack member lost | P1 | Immediate |

Severity grading follows DOC-006. Alerts feed the Zabbix action engine which routes to the on-call rota; de-duplication is applied before a ticket is opened. The Service Desk team lead may re-grade alerts during triage per DOC-006.

The backup-job rule reflects tier differences: Platinum and Gold backups are escalated immediately; Silver and Bronze failures are aggregated into the morning operations review.

## 4 Routing and de-duplication

Alerts route through Zabbix actions to the on-call rota defined in DOC-020, keyed by device asset tag and customer association. Unassigned (Norvane-internal) devices route to the internal infrastructure rota.

De-duplication suppresses repeated alerts for the same device and trigger within 30 minutes; suppressed firings are appended as correlation notes to the existing ticket.

Flapping suppression applies to link and BGP-state events: three state transitions (up/down) within any 10-minute window triggers a dedicated P1 ticket and a 20-minute suppression period. A fourth transition after the suppression window opens a new ticket.

## 5 Maintenance windows

During approved maintenance windows (DOC-022), the ITSM integration marks affected devices in Zabbix as "maintenance mode" at the window start, suppressing all trigger evaluation.

Suppression clears automatically at the window end time. Overruns must be extended in ITSM; cancelled windows require clearance within 15 minutes.

## 6 What is deliberately not alerted

- Replication lag between `bkparr-01` (DC1) and `bkparr-02` (DC2) is collected and displayed on the dashboard but generates no alert. This gap is consistent with DOC-018; the backup schedule pass/fail status is already covered in Section 3.
- Interface error counters on access ports are not alerted. Only uplink counters are monitored per the threshold table.

## 7 Review

Threshold adjustments are submitted as Change Requests per DOC-024.