---
doc_id: DOC-011
title: IP Addressing and Subnet Plan
doc_type: reference
owner: Marko Heinänen
version: "4.1"
status: current
classification: internal
created: 2017-02-14
updated: 2026-02-19
review_due: 2027-02-19
source_location: Confluence /Infrastructure/Network/IP Plan (page 20417)
related: [DOC-012, DOC-016]
supersedes: [v4.0]
synthetic: true
---

# IP Addressing and Subnet Plan

## 1. Purpose

This document is the authoritative record of Norvane's IP address block allocation, VLAN plan, and named infrastructure addresses. Every subnet assigned to a customer site, internal service, or infrastructure component must be recorded here before it is configured on any device. Assets.csv and all other inventory systems derive their network data from this plan.

## 2. Address block allocation

Norvane's IP plan uses RFC 5737 documentation ranges (198.51.100.0/24, 203.0.113.0/24, 192.0.2.0/24) as the plan of record. The allocation is as follows:

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

## 3. Site addressing

DC1 (Pasila, Helsinki) uses the 198.51.100.0/25 block, subdivided into four /26 subnets for management, servers, DMZ, and the transit VLAN. DC2 (Kaleva, Tampere) uses the 203.0.113.0/26 management block; customer sites at this address space are served directly from the /24.

Customer management addresses are drawn from the 192.0.2.0/24 block. Each customer receives one /26, subdivided further per site as needed. The final /26 of each customer's allocation is reserved for future growth and must not be assigned to active services.

## 4. VLAN standard

The following VLAN identifiers are used across all sites unless a schedule explicitly states otherwise:

| VLAN | Name | Description |
|---|---|---|
| 10 | Data | General data traffic |
| 20 | Voice | VoIP / SIP trunks |
| 30 | Corporate Wi-Fi | Staff wireless network |
| 40 | Guest Wi-Fi | Visitor wireless network |
| 50 | Print/IoT | Printers and IoT devices |
| 60 | CCTV | CCTV (retail and plant sites only) |
| 99 | Management | Network device management |
| 999 | Transit | DC inter-site transit |

## 5. Named infrastructure addresses

| Device | Address | Site |
|---|---|---|
| core-rtr-01 | 198.51.100.11 | DC1 |
| core-sw-01 | 198.51.100.12 | DC1 |
| core-sw-02 | 198.51.100.13 | DC1 |
| fw-edge-01 | 198.51.100.21 | DC1 |
| fw-edge-02 | 198.51.100.22 | DC1 |
| vpn-conc-01 | 198.51.100.23 | DC1 |
| bkparr-01 | 198.51.100.41 | DC1 |
| core-sw-11 | 203.0.113.31 | DC2 |
| bkparr-02 | 203.0.113.42 | DC2 |

## 6. Allocation conventions

Static IP assignment is used exclusively for network infrastructure devices and servers. DHCP reservations are applied to printers, CCTV cameras, and AP controllers — end-user devices receive dynamic addresses from the site-level pool.

No NAT is performed at customer sites. All customer subnets use documentation-range addressing as recorded in this plan. Every new subnet must be recorded here before any configuration takes place.

## 7. Recently reclaimed space

The range 192.0.2.32/27 was assigned to aurora-archive before that customer moved into the CUST-01 block (192.0.2.0/26) in February 2026. The old range is now quarantined and will remain unassigned until at least 2027. Do not reuse this range during the quarantine period.

## 8. Change control

All changes to this plan — new subnets, reallocations, or removals — must be submitted as a change request (CHG-YYYY-NNNN) and recorded in the Confluence page listed in the frontmatter. The IP address plan is owned by Marko Heinänen (Head of Infrastructure).