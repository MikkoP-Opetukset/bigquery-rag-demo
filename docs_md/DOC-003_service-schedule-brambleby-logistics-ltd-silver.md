---
doc_id: DOC-003
title: Service Schedule — Brambleby Logistics Ltd (Silver)
doc_type: contract
owner: Legal & Compliance (Petra Lindqvist)
version: "1.2"
status: current
classification: confidential
created: 2023-03-01
updated: 2024-05-08
review_due: 2026-03-01
source_location: Email attachment — "Brambleby SLA final signed.pdf" (Service Desk mailbox archive, 2023-03-14)
related: [DOC-001, DOC-005, DOC-006, DOC-031]
supersedes: []
---

# Service Schedule — Brambleby Logistics Ltd

Customer: **Brambleby Logistics Ltd** (CUST-02)
Tier: **Silver**
Effective: 2023-03-01. Version 1.2 dated 2024-05-08 (address change only).
Contract term: 2023-03-01 to 2026-02-28.

> **Note on this file:** This is a scan of the signed PDF, received by email
> rather than filed in SharePoint. Section numbering is retained from the
> signed document. A renewal discussion is outstanding and the contract term
> shown above has lapsed — see the account note in the CRM.

## 1. Covered services

| Service | Committed level |
|---|---|
| Network & Connectivity | 99.5% monthly availability |
| Backup & Recovery | RTO 24 hours, RPO 12 hours |
| Service Desk | P1 response 60 minutes, business hours |

Managed Firewall is **not** included in this Schedule. Brambleby operates its
own branch firewall; Norvane provides monitoring alerts only and has no
change responsibility for it.

## 2. Sites

| Site | Address | Circuits |
|---|---|---|
| brambleby-hq | Satamakatu 3, Turku | 1 x 100 Mbit/s Vantage Fibre |
| brambleby-depot | Varastotie 18, Turku | 1 x 50 Mbit/s Vantage Fibre, shared with HQ |

Both sites share a single upstream circuit at HQ. A circuit fault at HQ
therefore affects both sites and counts as one incident against a single
availability target.

## 3. Service hours

The service desk operates 07:00–18:00 EET, Monday to Friday. Out of hours,
the on-call rota answers P1 calls within 60 minutes for Network incidents only.
Backup failures detected overnight are picked up at 07:00 the following
business day and are treated as P2 from that point; the response clock does not
run overnight.

## 4. Backup scope

Nightly image backups of two Windows file servers and one ERP application
server, retained 30 days, replicated to DC2 Tampere. Databases with SQL Server
native backups are excluded — Brambleby's application vendor retains
responsibility for those.

## 5. Reporting

Monthly report only. No quarterly service review is included at Silver tier.

## 6. Service credits

Maximum credit 10% of monthly fee for the affected service, per DOC-005.

## 7. Data handling

Brambleby data is classified Confidential. No Restricted data is permitted in
scope. Norvane personnel access is granted per ticket and logged.

## 8. Excluded

- End-user devices and local application support
- The warehouse management system's hosted tenancy
- Any change to the Customer-managed branch firewall
