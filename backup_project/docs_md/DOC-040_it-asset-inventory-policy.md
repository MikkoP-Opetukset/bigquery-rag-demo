---
doc_id: DOC-040
title: IT Asset Inventory Policy
doc_type: policy
owner: Sanna Rautio
version: "1.8"
status: current
classification: internal
created: 2019-02-20
updated: 2025-05-19
review_due: 2027-05-19
source_location: SharePoint /Operations/Asset Inventory Policy v1.8.docx
related: [DOC-011, DOC-012, DOC-025]
supersedes: [v1.7]
synthetic: true
---

# IT Asset Inventory Policy

## 1. Purpose

This policy establishes the requirements for maintaining a complete and accurate inventory of all IT assets managed by Norvane Managed IT Services Oy. The asset register forms the single source of truth for asset ownership, lifecycle tracking, patch group assignment, and compliance reporting. It supports audit readiness under customer contracts and enables the procurement team to plan replacements before end-of-life dates are reached.

## 2. Scope

This policy applies to every managed device in the Norvane asset database — at a Norvane data centre, a customer site, or in transit. "Managed device" covers network equipment, servers, storage appliances, hypervisor hosts, VPN concentrators, and any hardware Norvane provisions, maintains, or monitors. End-user desktops and laptops are governed separately by the Service Desk.

## 3. What is recorded

Every managed device is entered into the inventory at the point of commissioning. The record is created from the deployment checklist that accompanies the change request (DOC-024) before the device is powered on or connected to the production network. Devices are removed from the inventory at decommissioning; they are not retained in an "active" table simply because the paperwork has not yet been processed. If a device is temporarily pulled from service for repair or firmware testing, it remains in the register with its criticality and patch group unchanged.

## 4. Record fields

The following fields are mandatory for every asset record in the inventory database (assets.csv and the corresponding BigQuery table):

| Field | Description |
|---|---|
| `asset_id` | Unique inventory identifier assigned at commissioning (format: `ASSET-YYYY-NNNN`). |
| `customer_id` | Customer contract code; use `NORVANE` for Norvane's own infrastructure. |
| `site` | Site identifier matching the canonical site names in DOC-011 (e.g. `dc1`, `dc2`, `aurora-hq`). |
| `hostname` | Device hostname following the naming convention in DOC-012 (e.g. `core-sw-01`). |
| `device_type` | Category of the device: switch, router, firewall, server, storage, hypervisor, or other. |
| `vendor_model` | Vendor name and model string (e.g. `Cisco Catalyst 9500-48Y4C`). |
| `mgmt_ip` | Management-plane IP address as documented in DOC-011. |
| `firmware_version` | Current running firmware or OS version (e.g. `IOS-XE 17.9.4a`). |
| `end_of_life_date` | Vendor-published end-of-life or end-of-sale date. |
| `criticality` | Classification of `critical`, `high`, `medium`, or `low`. |
| `patch_group` | Automated patch group derived from the criticality value (see §5). |

## 5. Ownership and reconciliation

The Service Delivery Manager owns the inventory for customer-provided devices; the Head of Infrastructure owns Norvane-owned infrastructure. Reconciliation against Zabbix (DOC-021) and the DHCP reservations database occurs quarterly. The diff report flags devices in monitoring but absent from the register — or vice versa — triggering an investigation ticket within two business days. The report is filed in the SharePoint asset management library.

## 6. End-of-life management

Devices approaching end of life are identified through the `end_of_life_date` field. A replacement plan must be initiated twelve months before the vendor's end-of-sale date. The plan includes budget allocation, procurement lead-time assessment, and a migration window coordinated with the customer as a change request. Devices that have passed their end-of-life date without an approved replacement plan are flagged as `critical - at risk` and escalated to the Head of Infrastructure for resolution within thirty days.

## 7. Disposal

Disposal of a physical asset requires certified data wiping using a tool approved by the Security Lead under DOC-025. Wiping is verified and a certificate of destruction or data sanitisation is generated. The asset record is updated to reflect the disposal date, the method of wiping, and the certificate reference. The disposal record — including the certificate — is retained for six years after the date of disposal and is stored in the document management system alongside the original change ticket. Physical assets are removed from the customer site only after written confirmation from the customer's site representative where the device was located.

## 8. Exceptions

Any deviation from this policy — including failure to record a device or incorrect criticality — must be documented with justification and approved by the asset's designated owner. Exceptions are reviewed at each quarterly reconciliation. Persistent non-compliance is escalated to the Service Delivery Manager.