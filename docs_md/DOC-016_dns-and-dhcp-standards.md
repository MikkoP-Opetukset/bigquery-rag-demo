---
doc_id: DOC-016
title: DNS and DHCP Standards
doc_type: standard
owner: ""
version: "1.3"
status: current
classification: internal
created: 2018-03-08
updated: 2024-04-09
review_due: 2026-04-09
source_location: //fs01.norvane.internal/infra/network/standards/dns-dhcp-standards.docx
related: [DOC-011, DOC-012]
supersedes: [v1.0]
synthetic: true
---

# DNS and DHCP Standards

## 1 Scope

This standard defines the architecture, configuration, and operational procedures for DNS and DHCP services across Norvane's data centres and all managed customer sites, covering internal and external authoritative zones, dynamic and static address assignment, and DHCP option consistency. Changes to zone transfers, scope parameters, or option templates must follow the procedures in this document.

## 2 DNS architecture

Internal zones are authoritative on Windows Server AD-integrated DNS, hosted on the two domain controllers with automatic multi-master replication via Active Directory. All devices resolve internal names through the domain controllers.

External authoritative zones are served by BIND, which answers internet queries for Norvane's public domains; that zone data is maintained independently of the internal zones.

Both data centres forward non-authoritative queries to the internal resolvers, which in turn forward unresolved queries to the ISP resolvers provided by Vantage Fibre, completing the chain client -> local DC -> internal resolver -> ISP resolver -> internet.

Scavenging is enabled on all dynamic records with a seven-day interval: records not refreshed within seven days are treated as stale and removed in the next cycle. Static records are not scavenged and persist until explicitly deleted by a network administrator.

## 3 Record management

A and AAAA records follow the naming convention in the IP addressing plan (DOC-011); customer device records follow the naming rules in the onboarding package.

PTR records are maintained for the management, server, and DMZ subnets; on data VLANs they are best-effort and not guaranteed for DHCP-assigned addresses.

Zone transfers are permitted only between the two AD-integrated domain controllers and between the BIND primary and its configured secondary; no external zone transfer is allowed. Record changes are logged in the configuration management system; manual BIND zone edits require the infrastructure lead's approval during a maintenance window.

## 4 DHCP architecture

DHCP is split 80/20 between the two domain controllers: DC1 operates the primary scope with an 80% address range, DC2 the secondary with 20%. The split applies uniformly across all customer site and internal scopes. Sites with a local domain controller host their scopes there; sites without one draw addresses from the DC1/DC2 pool.

Reservations are used for printers, CCTV cameras, and Wi-Fi controllers. Reservation records include device type, MAC address, assigned IP, and site identifier, consistent across sites sharing the same VLAN IDs.

## 5 Option standards

The following options apply to every scope unless a documented exception exists:

- Option 003 (default gateway): the gateway for the VLAN's subnet.
- Option 006 (DNS servers): the two domain controller addresses.
- Option 015 (domain name): the internal DNS domain suffix.
- Option 042 (NTP servers): the primary and secondary NTP server addresses.
- Option 043 (vendor-specific information): the VoIP handset boot server, applied only to the Voice VLAN scope.
- Option 119 (domain search list): the internal and customer DNS search suffixes from the onboarding package.

Option values are managed through the configuration management system. Scope changes require a documented request and a two-business-day lead time.

Lease times are 8 days on data VLANs and 30 days on IoT VLANs. No leases are issued on the management VLAN (see exclusions).

## 6 Exclusions

No DHCP service is provided on management VLAN 99; all addresses there are static, assigned manually from the management subnets in the IP addressing plan (DOC-011), configured to the switch baseline in DOC-012, and recorded in the asset inventory.

Customer sites with a single layer-2 switch and no local DHCP relay are covered by the internal scopes: the relay agent on the customer edge device forwards requests to the DC1 primary, and no scope is created on customer premises.

## 7 Known weaknesses

Resolution is deferred until resources are available:

- No quarterly review of stale static records is performed; static records no longer tied to active devices accumulate in the zone files until the next infrastructure audit cycle.
- Split-scope exclusions - the address ranges where the 20% secondary DC is excluded from issuing leases - are maintained by hand in a spreadsheet whose location is recorded nowhere in this document. It must be migrated into the configuration management system at the next standards revision.
- Scavenging is disabled on two legacy scopes still in use for the Brambleby Logistics and Eastgate Housing sites; these scopes predate the standardisation of scavenging and are targeted for replacement at the next VLAN restructuring.
