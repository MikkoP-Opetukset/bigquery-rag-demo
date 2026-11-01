---
doc_id: DOC-018
title: Backup and Restore Runbook
doc_type: runbook
owner: Emil Nyberg
version: "3.6"
status: current
classification: internal
created: 2018-07-19
updated: 2026-01-27
review_due: 2027-01-27
source_location: Confluence /Infrastructure/Backup/Restore Runbook
related: [DOC-019]
supersedes: [v3.5]
synthetic: true
---

# Backup and Restore Runbook

## 1. Scope

This runbook covers backup and restore procedures for all Norvane-managed services, including infrastructure-level image backups, file services, and database tiers. It applies to both data centres (DC1 Helsinki, DC2 Tampere) and is intended for use by the Backup & Storage Engineer and Service Desk team during restore operations. Application-level backups performed directly by vendors on database appliances are documented separately.

## 2. Backup infrastructure

Norvane operates two Dell PowerProtect DP4400 appliances:

- **bkparr-01** — deployed at DC1 (Helsinki Pasila), management address 198.51.100.41. Primary appliance handling all local backup jobs.
- **bkparr-02** — deployed at DC2 (Tampere Kaleva), management address 203.0.113.42. Secondary appliance receiving replicated backups from bkparr-01.

Both appliances are connected to management VLAN 99 and managed through the PowerProtect Data Manager web console. Replication between them runs over the dedicated DC1-to-DC2 fibre link.

## 3. Schedule and retention

Image-level backups run nightly between 01:00 and 06:00 EET/EEST. After each successful job on bkparr-01, a replication job is triggered to bkparr-02. No replication starts until the source job is confirmed successful.

Hourly SQL transaction log shipping is enabled where a database is in scope for backup, preserving point-in-time recovery capability between nightly image snapshots.

Retention: 30 daily copies retained locally on bkparr-01; 12 monthly copies for long-term recovery (one per calendar month, retained 12 months). Replicated copies on bkparr-02 mirror the source retention schedule. All data is encrypted at rest with AES-256. Recovery keys are held in the vault and accessible only to the Backup & Storage Engineer and Head of Infrastructure.

## 4. Recovery objectives

Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) per service tier, from DOC-019 section 3:

| Tier | RTO | RPO |
|---|---|---|
| Platinum | 4 h | 1 h |
| Gold | 8 h | 4 h |
| Silver | 24 h | 12 h |
| Bronze | 48 h | 24 h |

## 5. Restore procedures

**Single-file restore from the ProtecTIER file-level index (~20 min):** Log in to the bkparr-01 console, navigate to the target protection policy, open the most recent successful backup and browse the file-level index. Select the required file or directory, then restore to the original location or an alternate path. The console reports progress in real time.

**Whole-volume restore (~2 hours):** On the bkparr-01 console, select the target protection policy and open the most recent backup image. Choose the entire volume or disk. Restore to the original location, or to an alternate host if the source is unavailable. Monitor progress from the Activity dashboard.

**Database restore from log-shipped copy (~3 hours):** Confirm hourly log shipping is configured for the target database. If not, fall back to whole-volume restore. From the bkparr-01 console, select the restore point closest to the desired recovery time. Initiate a restore to the original or a temporary recovery host, then apply the transaction log chain from the log shipping store to reach the selected point in time. Verify the restored database against the application-level checksum.

**Site-level restore by promoting bkparr-02 (~6 hours):** Notify the Service Delivery Manager and Head of Infrastructure. Log in to the bkparr-02 console at DC2 and confirm the replicated backup set is current via the Replication dashboard. Initiate a Site Failover Restore on the target protection policy. Redirect DNS for affected services to DC2 addresses per DOC-019 section 6. Validate replicated data has been applied and services are responding. Coordinate with the Service Delivery Manager for customer notification.

## 6. Testing

Restore tests are performed twice yearly and cover the file-services tier only. Database restores are tested at vendor level, not end to end in the Norvane environment. Tests are recorded in the ITSM system as a problem ticket and closed upon completion.

## 7. Known gaps

- No automated verification of backup integrity beyond job success status. No checksum or data-level validation is performed after each nightly backup.
- Replication lag between bkparr-01 and bkparr-02 is not alerted on. No Zabbix alert exists if replication falls behind by more than 30 minutes.
- No documented procedure for restoring the clinical database tier end to end. Vendor-level restore tests have been conducted but no Norvane-end-to-end runbook exists for this tier.