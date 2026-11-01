---
doc_id: DOC-007
title: Upstream Connectivity SLA — Vantage Fibre (vendor copy)
doc_type: vendor_contract
owner: Procurement (Sanna Rautio)
version: "1.0"
status: current
classification: confidential
created: 2021-01-12
updated: 2023-11-30
review_due: 2026-12-31
source_location: //fs01.norvane.internal/procurement/contracts/vantage-fibre/sla-annex-b.pdf
related: [DOC-005, DOC-010, DOC-033]
supersedes: []
---

# Upstream Connectivity SLA — Vantage Fibre

Vendor: **Vantage Fibre Oy** (fictional)
Contract: VF-HEL-4471 (primary) and VF-HEL-4472 (backup)
Service: Layer 2 point-to-point and internet transit for DC1 Helsinki
Annex B — Service Levels. This is a copy of the vendor's standard annex; it is
governed by Finnish law and the vendor's general terms.

## 1. Committed availability

| Circuit | Committed availability | Measurement |
|---|---|---|
| VF-HEL-4471 (1 Gbit/s primary) | 99.9% per calendar month | Vendor NOC, 5-minute polling |
| VF-HEL-4472 (300/100 Mbit/s backup) | 99.5% per calendar month | Vendor NOC |
| VF-HEL-4473 (1 Gbit/s, DC2 Tampere) | 99.9% per calendar month | Vendor NOC |

Availability is measured at the vendor's handover point. Faults in Norvane's
own equipment, or in Norvane's cabling beyond the handover, are excluded.

## 2. Fault response

| Priority | Definition | Response | Target repair |
|---|---|---|---|
| Critical | Total loss of a circuit | 30 minutes, 24x7 | 4 hours |
| Major | Degradation > 30% of committed bandwidth | 2 hours | 8 hours |
| Minor | Everything else | 1 business day | 5 business days |

"Target repair" is a target, not a commitment. The **only** committed measure
in this annex is the availability percentage in section 1.

## 3. Credits

| Availability achieved | Credit (% of monthly circuit fee) |
|---|---|
| 99.9% to 99.5% | 5% |
| 99.5% to 98.5% | 10% |
| below 98.5% | 25% |

Credits must be claimed in writing within 30 days of month end. Unclaimed
credits are forfeited. The vendor's maximum aggregate liability under the
contract is 30% of annual circuit fees.

## 4. Maintenance

The vendor may perform planned maintenance on 10 business days' notice, in the
window 00:00–05:00 local. Planned maintenance is excluded from availability
measurement up to four hours per month.

## 5. Escalation contacts

Vendor NOC is reachable 24x7 on the number held by Norvane's duty manager.
Escalation beyond first-line NOC goes to the named account manager; the
current named contact is recorded in the procurement CRM, not in this document.

## 6. Norvane note (added 2023-11-30)

Procurement annotation: the backup circuit VF-HEL-4472 is **not** a diverse
path — it shares a duct with the primary for the last 400 m into the building.
Norvane's own architecture documentation (DOC-010) claims geographic diversity.
This discrepancy was noted in the 2023 contract review and has not been
resolved.
