# CANON — shared facts for the Norvane demo corpus

Every document in this corpus MUST be consistent with this file. Do not invent
facts that contradict it. If a document needs a fact not listed here, use a
plausible one that does not conflict with anything in this file.

This corpus is **entirely fictional**, for a BigQuery + RAG teaching demo.
Company, people, customers, vendors, phone numbers and IP ranges are invented.
No real organisation is described.

---

## 1. The company

**Norvane Managed IT Services Oy** — fictional Finnish managed-IT-services
provider, ~85 staff. HQ and primary data centre in Helsinki (Pasila);
secondary data centre / DR site in Tampere (Kaleva).

Staff referenced in documents (keep roles fixed):

| Person | Role | Notes |
|---|---|---|
| Petra Lindqvist | Service Delivery Manager; owns Legal & Compliance documents | |
| Marko Heinänen | Head of Infrastructure | owns most infrastructure documents |
| Aino Salo | Security Lead | owns security/vault/firewall policy |
| Tuomas Virta | Service Desk Team Lead | owns delivery process + postmortems |
| Emil Nyberg | Backup & Storage Engineer | owns backup runbook + one postmortem |
| Sanna Rautio | Procurement | owns vendor contracts, asset inventory |
| Ilkka Rantala | **former** Network Manager, left the company in 2022 | appears ONLY in the superseded 2019 firewall policy (DOC-014) |

Vendor: **Vantage Fibre Oy** — upstream connectivity provider (fictional).

Phone convention: `+358 10 555 0xxx`. Email: `firstname.lastname@norvane.internal`.
Customer contacts use `@<customer>.example.com` (see customer table).

## 2. Customers

| ID | Name | Tier | Seats | Sites | Contract |
|---|---|---|---|---|---|
| CUST-01 | Aurora Health District | Platinum | 480 | 3 | 2021-04-01 → 2027-03-31 |
| CUST-02 | Brambleby Logistics Ltd | Silver | 190 | 2 | 2023-03-01 → 2026-02-28 (lapsed) |
| CUST-03 | Cobalt Retail Group | Gold | 760 | 6 | 2022-09-01 → 2026-08-31 |
| CUST-04 | Feldspar Manufacturing Oy | Gold | 320 | 2 | 2020-01-15 → 2027-01-14 |
| CUST-05 | Dunmore & Fisk Legal LLP | Silver | 65 | 1 | 2024-06-01 → 2027-05-31 |
| CUST-06 | Eastgate Housing Association | Bronze | 110 | 2 | 2019-10-01 → 2025-09-30 (lapsed) |

Sites (hostname prefix = site name):

- CUST-01: `aurora-hq` (Helsinki), `aurora-clinic` (Tampere), `aurora-archive` (Helsinki)
- CUST-02: `brambleby-hq` (Turku), `brambleby-depot` (Turku)
- CUST-03: `cobalt-hq` (Helsinki), `cobalt-store-01` … `cobalt-store-05`
- CUST-04: `feldspar-plant`, `feldspar-office`
- CUST-05: `dunmore-hq` (Helsinki)
- CUST-06: `eastgate-offices`, `eastgate-sheltered-housing`

## 3. Service tiers and committed targets

These numbers are authoritative. They are also held in `data/sla_targets.csv`.

| Tier | Availability | P1 response | P1 resolution | RTO | RPO | Max credit |
|---|---|---|---|---|---|---|
| Platinum | 99.95% | 15 min | 4 h | 4 h | 1 h | 30% |
| Gold | 99.90% | 30 min | 8 h | 8 h | 4 h | 20% |
| Silver | 99.50% | 60 min | 12 h | 24 h | 12 h | 10% |
| Bronze | 99.00% | 4 business hours | 24 business hours | 48 h | 24 h | 5% |

Business hours: 07:00–18:00 EET/EEST, Mon–Fri, excl. Finnish public holidays.
Platinum and Gold are supported 24x7 for P1/P2. Silver and Bronze: business
hours, except a P1 out of hours pages the on-call rota.

P2/P3 response (DOC-006): Platinum 30 min / 4 h; Gold 1 h / 8 h;
Silver 2 h / 1 business day; Bronze 4 business hours / 2 business days.

Severities: P1 total loss of a covered service; P2 major degradation; P3
degradation with workaround or single user; P4 cosmetic/request.

## 4. Infrastructure facts

- Core: 2 x Cisco Catalyst 9500-48Y4C stack at DC1; Cisco ASR 1001-X border
  router; 2 x FortiGate 400F edge firewalls; FortiGate 201F VPN concentrators.
- DC2 Tampere: 1 x Catalyst 9300-48P, no local internet breakout — traffic
  backhauls to DC1 over the VF-HEL-4473 L2 circuit.
- Current firmware baseline: IOS-XE 17.9.4a (core), FortiOS 7.2.9 (edge).
  Older access-layer devices run 17.6.5 or 17.3.8.
- Backup: 2 x Dell PowerProtect DP4400 appliances (`bkparr-01` at DC1,
  `bkparr-02` at DC2). Nightly image backups, replicated DC1 → DC2.
- Virtualisation: VMware vSphere 8, 6 hosts at DC1, 3 at DC2.
- Upstream: Vantage Fibre VF-HEL-4471 (1 Gbit/s primary) and VF-HEL-4472
  (300/100 Mbit/s backup) at DC1; VF-HEL-4473 (1 Gbit/s) at DC2.
- Monitoring: Zabbix, 60-second polling, synthetic ICMP/HTTP probes at 1 min.
- ITSM: ticket IDs are `INC-YYYY-NNNN` (e.g. `INC-2026-0095`). Changes are
  `CHG-YYYY-NNNN`.

## 5. IP and VLAN plan (authoritative — assets.csv depends on it)

Documentation ranges (RFC 5737) are used deliberately: **198.51.100.0/24** =
DC1 Helsinki, **203.0.113.0/24** = DC2 Tampere + two customer sites,
**192.0.2.0/24** = customer site management.

| Block | Use |
|---|---|
| 198.51.100.0/26 | DC1 management (VLAN 99) |
| 198.51.100.64/26 | DC1 server VLAN 10 |
| 198.51.100.128/26 | DC1 DMZ |
| 198.51.100.192/26 | Transit VLAN 999 |
| 203.0.113.0/26 | DC2 management |
| 203.0.113.64/26 | CUST-05 dunmore-hq |
| 203.0.113.128/26 | CUST-06 eastgate |
| 192.0.2.0/26 | CUST-01 (aurora-hq, aurora-clinic) |
| 192.0.2.64/26 | CUST-02 (brambleby-hq, brambleby-depot) |
| 192.0.2.128/26 | CUST-03 (cobalt-hq + stores) |
| 192.0.2.192/26 | CUST-04 (feldspar) |

Named addresses: core-rtr-01 198.51.100.11, core-sw-01 .12, core-sw-02 .13,
fw-edge-01 .21, fw-edge-02 .22, vpn-conc-01 .23, bkparr-01 .41,
core-sw-11 (DC2) 203.0.113.31, bkparr-02 203.0.113.42.

VLANs (same scheme at every customer site unless a schedule says otherwise):
10 Data, 20 Voice, 30 Corporate Wi-Fi, 40 Guest Wi-Fi, 50 Print/IoT,
60 CCTV (retail/plant sites only), 99 Management, 999 Transit.

## 6. Deliberate inconsistencies — implement these EXACTLY

The corpus is "moderately messy" on purpose. These are the only intentional
defects; everything else must be internally consistent.

**(a) Duplicate/competing firewall policy.** DOC-013 (v3.0, 2025, owner Aino
Salo) is current: changes go through the CAB, 5 business days' lead time,
rollback plan required, changes affecting more than 5 ports or any internet-
facing rule need CAB sign-off. DOC-014 (v1.0, 2019, owner Ilkka Rantala) is
marked `status: superseded` but is still sitting on the same file share with
near-identical title. Its process is different and obsolete: approval by email
from the Network Manager, 48 hours' notice, no CAB, no rollback requirement.
DOC-014 must not mention CAB, Aino Salo, or 2025. DOC-014 should read as though
written in 2019 (references to "the new FortiGate estate", Ilkka as approver).

**(b) Document with no owner.** DOC-016 (DNS and DHCP Standards) has
`owner:` empty (write `owner: ""`) — realistic orphaned knowledge. The body
must not name a responsible team.

**(c) Stale document.** DOC-017 (Wireless Standards) last updated 2021-03-11,
`review_due: 2022-03-11`. It must state that WPA3 "will be enabled during
2022 once the controller firmware upgrade completes" and that the Wi-Fi 6
rollout "is planned for Q3 2021". Do not correct these.

**(d) The single factual contradiction: DR objectives vs reality.**
DOC-019 (Disaster Recovery Plan, v5.0, 2025-10-02) claims: the per-tier RTO/RPO
table in §3 is validated; a full DR test was carried out on **2024-11-16** and
"all tiers were exercised and all objectives were met"; restore testing is
"performed twice yearly across all backup tiers". DOC-032 (postmortem of
INC-2026-0095, Aurora) contradicts this: the restore took 11 h 05 min against a
4 h RTO, the last good restore point was 9 h old against a 1 h RPO, and it
states plainly that the 2024-11-16 test exercised **only the file-services
tier** and that the clinical database tier "had never been restored end to end
outside a vendor lab". Do not reconcile these two documents. DOC-018 (backup
runbook) should support DOC-032 rather than DOC-019: it says restore tests are
"twice yearly, file-services tier only, database restores tested at vendor
level".

**(e) Escalation timing drift.** DOC-020 (On-Call and Escalation Policy) says a
P1 must be escalated to the duty manager "within 15 minutes of ticket
creation". DOC-023 (Incident Management Process) says "within 30 minutes". Both
are current documents. Do not add a note reconciling them; the drift is the
point.

**(f) Geographic-diversity claim.** DOC-010 (Network Architecture Overview)
describes DC1 and DC2 as being on "geographically diverse fibre paths with no
shared physical infrastructure". DOC-007 (already written) records that the
backup circuit shares a 400 m duct with the primary. Do not soften DOC-010.

## 7. Document register

Write only the documents assigned to you. Use this metadata exactly.
Frontmatter keys in this order: doc_id, title, doc_type, owner, version,
status, classification, created, updated, review_due, source_location,
related, supersedes, synthetic.

`synthetic: true` on every document.

| doc_id | title | doc_type | owner | version | status | class | created | updated | review_due | source_location |
|---|---|---|---|---|---|---|---|---|---|---|
| DOC-010 | Network Architecture Overview | reference | Marko Heinänen | 6.0 | current | internal | 2016-09-22 | 2026-05-04 | 2027-05-04 | //fs01.norvane.internal/infra/network/architecture-overview-v6.0.pdf |
| DOC-011 | IP Addressing and Subnet Plan | reference | Marko Heinänen | 4.1 | current | internal | 2017-02-14 | 2026-02-19 | 2027-02-19 | Confluence /Infrastructure/Network/IP Plan (page 20417) |
| DOC-012 | Core Switch Configuration Standard | standard | Marko Heinänen | 2.4 | current | internal | 2019-06-03 | 2025-12-08 | 2026-12-08 | //fs01.norvane.internal/infra/network/standards/core-switch-config-v2.4.docx |
| DOC-013 | Firewall Change Management Policy | policy | Aino Salo | 3.0 | current | internal | 2022-05-30 | 2025-03-02 | 2027-03-02 | SharePoint /Security/Policies/Firewall Change Management Policy v3.0.docx |
| DOC-014 | Firewall Change Management Policy | policy | Ilkka Rantala | 1.0 | superseded | internal | 2019-04-17 | 2019-04-17 | 2020-04-17 | //fs01.norvane.internal/policies/archive/firewall-change-policy-v1.0.doc |
| DOC-015 | VPN and Remote Access Guide | guide | Aino Salo | 2.2 | current | internal | 2020-11-05 | 2025-07-21 | 2027-07-21 | Confluence /Security/Access/Remote Access Guide |
| DOC-016 | DNS and DHCP Standards | standard | (empty) | 1.3 | current | internal | 2018-03-08 | 2024-04-09 | 2026-04-09 | //fs01.norvane.internal/infra/network/standards/dns-dhcp-standards.docx |
| DOC-017 | Wireless Standards | standard | Marko Heinänen | 1.1 | current | internal | 2019-10-01 | 2021-03-11 | 2022-03-11 | //fs01.norvane.internal/infra/wireless/wireless-standards-v1.1.docx |
| DOC-018 | Backup and Restore Runbook | runbook | Emil Nyberg | 3.6 | current | internal | 2018-07-19 | 2026-01-27 | 2027-01-27 | Confluence /Infrastructure/Backup/Restore Runbook |
| DOC-019 | Disaster Recovery Plan | plan | Marko Heinänen | 5.0 | current | confidential | 2017-11-02 | 2025-10-02 | 2026-10-02 | //fs01.norvane.internal/infra/dr/norvane-dr-plan-v5.0.pdf |
| DOC-020 | On-Call and Escalation Policy | policy | Tuomas Virta | 2.5 | current | internal | 2019-01-28 | 2026-03-16 | 2027-03-16 | Confluence /Service Delivery/On-Call |
| DOC-021 | Monitoring and Alert Thresholds | reference | Marko Heinänen | 3.1 | current | internal | 2018-08-14 | 2026-06-11 | 2027-06-11 | Confluence /Infrastructure/Monitoring/Thresholds |
| DOC-022 | Patching and Maintenance Windows | policy | Marko Heinänen | 2.0 | current | internal | 2020-04-06 | 2025-08-25 | 2026-08-25 | Confluence /Infrastructure/Operations/Patching |
| DOC-023 | Incident Management Process | process | Tuomas Virta | 4.2 | current | internal | 2017-05-11 | 2026-03-16 | 2027-03-16 | Confluence /Service Delivery/Incident Management |
| DOC-024 | Change Management Policy | policy | Marko Heinänen | 3.3 | current | internal | 2017-05-11 | 2026-04-30 | 2027-04-30 | Confluence /Service Delivery/Change Management |
| DOC-025 | Data Classification and Handling Policy | policy | Aino Salo | 2.1 | current | confidential | 2018-09-13 | 2026-07-08 | 2027-07-08 | SharePoint /Security/Policies/Data Classification v2.1.docx |
| DOC-030 | Postmortem PM-2025-17 — Core Switch Failure at Cobalt | postmortem | Tuomas Virta | 1.0 | current | internal | 2025-09-26 | 2025-09-26 | — | Confluence /Service Delivery/Postmortems/PM-2025-17 |
| DOC-031 | Postmortem PM-2026-03 — DNS Misconfiguration at Brambleby | postmortem | Tuomas Virta | 1.0 | current | internal | 2026-02-20 | 2026-02-20 | — | Confluence /Service Delivery/Postmortems/PM-2026-03 |
| DOC-032 | Postmortem PM-2026-07 — Failed Backup Restore at Aurora | postmortem | Emil Nyberg | 1.0 | current | confidential | 2026-05-06 | 2026-05-06 | — | Confluence /Service Delivery/Postmortems/PM-2026-07 |
| DOC-033 | Postmortem PM-2026-11 — Upstream Fibre Outage at Eastgate | postmortem | Tuomas Virta | 1.0 | current | internal | 2026-07-14 | 2026-07-14 | — | Confluence /Service Delivery/Postmortems/PM-2026-11 |
| DOC-040 | IT Asset Inventory Policy | policy | Sanna Rautio | 1.8 | current | internal | 2019-02-20 | 2025-05-19 | 2027-05-19 | SharePoint /Operations/Asset Inventory Policy v1.8.docx |
| DOC-041 | Privileged Access Management Policy | policy | Aino Salo | 2.0 | current | confidential | 2020-10-08 | 2026-05-27 | 2027-05-27 | SharePoint /Security/Policies/PAM Policy v2.0.docx |
| DOC-042 | New Starter IT Onboarding Checklist | checklist | Tuomas Virta | 3.4 | current | internal | 2019-08-27 | 2026-09-01 | 2027-09-01 | Confluence /People/IT Onboarding Checklist |

For postmortems use `review_due: ""`.

## 8. Writing rules

1. **Length.** Body 450–750 words after the frontmatter. Not shorter.
2. **Voice.** Professional Nordic IT English. Concrete, operational, slightly
   bureaucratic — the way a real internal policy reads. No marketing language,
   no "in today's fast-paced world", no bullet-point soup.
3. **Structure.** Use `#` for the title, then `##` numbered sections. Tables are
   welcome where a real document would use one. Do not use emoji.
4. **Cross-references.** Refer to other documents by ID in prose, e.g. "as
   defined in DOC-006". Only reference IDs that exist in the register above.
5. **Numbers must match this canon exactly.** If a document states a target,
   downtime figure, date, IP, hostname or tier, it comes from this file.
6. **No synthetic-data disclaimers inside the body.** The `synthetic: true`
   frontmatter field and the project README carry that. A real corporate
   document does not announce that it is fictional.
7. **No real credentials, keys, or secrets** anywhere, even as examples. Refer
   to "the vault entry" instead.
8. **Vendor realism is fine** (Cisco, Fortinet, Dell, VMware, Zabbix, Veeam-free
   choice), but keep configuration snippets generic and non-exploitable.

## 9. Incident facts for postmortem authors

| Incident | Customer | When | Downtime | Outcome |
|---|---|---|---|---|
| INC-2025-0311 | CUST-03 Cobalt | 2025-09-12 03:20 → 07:32 | 252 min | P1, hardware failure, SLA breached, EUR 18,400 credit |
| INC-2026-0052 | CUST-02 Brambleby | 2026-02-08 07:40 → 09:45 | 0 min (degraded) | P2, config error, SLA breached, no credit (under cap) |
| INC-2026-0095 | CUST-01 Aurora | 2026-04-21 01:15 → 12:20 | 665 min | P1, process failure, SLA breached, EUR 24,000 credit |
| INC-2026-0128 | CUST-06 Eastgate | 2026-06-29 05:05 → 11:45 | 400 min | P1, upstream provider, SLA breached, EUR 3,100 credit |

Postmortem structure (all four): Summary · Timeline · Impact · Root cause ·
Detection · Response · Contributing factors · What went well · Action items
(with owner and due date) · Lessons learned. Action items must be concrete and
some should still be open at the time of writing — the corpus is deliberately
imperfect.