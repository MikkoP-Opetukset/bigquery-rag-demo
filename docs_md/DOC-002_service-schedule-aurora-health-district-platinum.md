---
doc_id: DOC-002
title: Service Schedule — Aurora Health District (Platinum)
doc_type: contract
owner: Legal & Compliance (Petra Lindqvist)
version: "2.1"
status: current
classification: restricted
created: 2021-04-01
updated: 2025-11-20
review_due: 2026-11-20
source_location: SharePoint /Contracts/Customers/Aurora/Service Schedule - Aurora - v2.1.docx
related: [DOC-001, DOC-005, DOC-006, DOC-019, DOC-032]
supersedes: [Service Schedule v1.4 (2021)]
synthetic: true
---

# Service Schedule — Aurora Health District

Customer: **Aurora Health District** (CUST-01)
Tier: **Platinum**
Effective: 2025-11-20. Supersedes v1.4 dated 2021-04-01.
Contract term: 2021-04-01 to 2027-03-31, renewal by 12 months unless cancelled
with 90 days' notice.

## 1. Covered services and committed levels

| Service | Committed level |
|---|---|
| Network & Connectivity | 99.95% monthly availability |
| Backup & Recovery | RTO 4 hours, RPO 1 hour |
| Managed Firewall | P1 response 15 minutes, P1 resolution 4 hours |
| Service Desk | P1 response 15 minutes, 24x7 |

Availability is measured across the three covered sites (aurora-hq,
aurora-clinic, aurora-archive) and reported in aggregate, not per site.

## 2. Site coverage

| Site | Address | Circuits |
|---|---|---|
| aurora-hq | Hallituskatu 12, Helsinki | 2 x 200 Mbit/s Vantage Fibre, diverse paths |
| aurora-clinic | Rautatienkatu 4, Tampere | 1 x 100 Mbit/s Vantage Fibre |
| aurora-archive | Vanha talvitie 9, Helsinki | 1 x 50 Mbit/s Vantage Fibre |

## 3. Clinical systems carve-out

Patient record systems hosted by the District's application provider are
**not** covered by this Schedule. Norvane's responsibility ends at the
network demarcation to the application provider's environment. Where a fault
in the covered network causes loss of access to a clinical system, the incident
is nonetheless treated as P1 and the clock in section 1 applies.

## 4. Backup and recovery

The District's backup scope covers file services, directory services and
configuration data on Norvane-managed infrastructure. Clinical application
data is backed up by the application provider and is out of scope.

Committed objectives: **RTO 4 hours, RPO 1 hour**, measured from declaration
of a disaster. Norvane performs a restore test of the file service tier at
least twice per year; the District may witness one test per contract year.

## 5. Reporting and review

In addition to the standard monthly report, Norvane provides a quarterly
service review attended by the District's IT lead and clinical operations
representative. Aurora receives incident notification for all P1 and P2
incidents by telephone within the response window, followed by email.

## 6. Regulatory obligations

Norvane acknowledges that the District operates under Finnish health data
regulation and the EU GDPR. Personnel with access to District data hold
criminal-record clearance for social and health care work. All access is
logged and reviewed quarterly. Data classification for District material is
Confidential at minimum; clinical data is Restricted (see DOC-025).

## 7. Service credits

Maximum credit: 30% of the monthly fee for the affected service. The credit
schedule in DOC-005 applies without amendment; the Platinum escalator in
section 3 of that policy applies.

## 8. Special terms

Clause 9.2 of the Master SLA's annual review procedure is waived; review is
quarterly. Termination for convenience requires 90 days' notice and a
documented transition plan.
