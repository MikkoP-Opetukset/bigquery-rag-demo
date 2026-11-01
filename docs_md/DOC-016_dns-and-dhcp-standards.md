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

This standard defines the architecture, configuration, and operational procedures for DNS and DHCP services across Norvane's data centres and all managed customer sites. It covers internal authoritative zones, external authoritative zones, dynamic and static address assignment, and the DHCP options that must be consistent across all scopes.

This standard applies to all DNS servers, DHCP servers, and configuration management tools used to administer these services. It covers both the internal infrastructure DNS/DHCP and the per-customer scope configurations. Changes to DNS zone transfers, DHCP scope parameters, or option templates must follow the procedures in this document.

## 2 DNS architecture

Internal DNS zones are authoritative on Windows Server AD-integrated DNS. Two domain controllers host the internal zones with automatic multi-master replication via Active Directory. All client devices, application servers, and network devices resolve internal names through the domain controllers.

External authoritative zones are served by BIND. The BIND instances respond to queries from the internet for Norvane's public domains. Zone data for external zones is updated independently of the AD-integrated internal zones.

Both domain controllers forward non-authoritative queries to the internal resolvers, which in turn forward unresolved queries to the ISP resolvers provided by Vantage Fibre. The forwarder chain is: client → local DC → internal resolver → ISP resolver → internet. Internal resolvers cache aggressively to reduce external queries.

DNS scavenging is enabled on all dynamic records. The scavenging interval is seven days: records that are not refreshed within seven days are considered stale and are removed during the next scavenging cycle. Scavenging is not enabled on static records; static records persist until explicitly deleted by a network administrator.

## 3 Record management

A-record and AAAA-record creation must follow a documented naming convention. Hostnames for managed devices use the convention defined in the IP addressing plan (DOC-011). Customer device records are created per the customer-specific schedule and naming rules documented in the onboarding package.

PTR records are maintained for all addresses in the management, server, and DMZ subnets. PTR records for the data VLANs are maintained on a best-effort basis and are not guaranteed to be present for all DHCP-assigned addresses.

DNS zone transfers are enabled between the two AD-integrated domain controllers and between the BIND primary and secondary. No external zone transfer is permitted; only the configured secondary BIND instance receives zone data.

All DNS record changes must be logged in the configuration management system. Manual changes to zone files on the BIND servers require approval from the infrastructure lead and must be performed during a maintenance window.

## 4 DHCP architecture

DHCP service is split 80/20 between the two domain controllers. DC1 operates the primary DHCP scope with an 80% address range; DC2 operates the secondary scope with a 20% address range. A delay of 120 seconds is configured on the DC2 instance to prevent duplicate lease assignments during initial service start-up.

The DHCP split is applied uniformly across all customer site scopes and the Norvane internal scopes. Customer site DHCP scopes are hosted on the local domain controllers at each site where a DC is deployed. Sites without a local domain controller use the Norvane internal DHCP scopes and receive addresses from the DC1/DC2 pool.

DHCP reservations are used for printers, CCTV cameras, and Wi-Fi controllers. Reserved addresses are configured in the DHCP server console and are consistent across all sites that share the same VLAN IDs. Reservation records include the device type, the MAC address, the assigned IP, and the customer or site identifier.

## 5 Option standards

The following DHCP options are applied to every scope unless a documented exception exists:

- Option 003 (default gateway): The gateway for the VLAN's subnet.
- Option 006 (DNS servers): The two domain controller addresses.
- Option 015 (domain name): The internal DNS domain suffix.
- Option 042 (NTP servers): The primary and secondary NTP server addresses.
- Option 043 (vendor-specific information): The VoIP handset boot server address. This option is applied only to the Voice VLAN scope.
- Option 119 (domain search list): The DNS search suffixes for the internal domain and the customer domains listed in the onboarding package.

All scopes must include options 003, 006, 015, 042, and 119. Option 043 is optional and is applied only where VoIP handsets are in use. Scope parameters and option values are managed through the configuration management system; manual changes to the DHCP server console are prohibited except in emergency recovery scenarios.

Lease times are set as follows:
- Data VLANs: 8 days.
- IoT VLANs: 30 days.
- Management VLAN: leases are not issued; see exclusions below.

## 6 Exclusions

No DHCP service is provided on management VLAN 99. All addresses on the management VLAN are static. Management IP addresses are assigned manually from the management subnets defined in the IP addressing plan (DOC-011) and recorded in the asset inventory.

Customer sites that have only a single layer-2 switch and no local DHCP relay are covered by the Norvane internal DHCP scopes. The DHCP relay agent (IP helper) on the customer edge device forwards requests to the DC1 primary. No scope is created on the customer premises.

## 7 Known weaknesses

The following items are documented here for awareness. Resolution is deferred until resources are available:

- No quarterly review of stale static records is currently performed. Static records that are no longer associated with active devices accumulate in the zone files over time. The next scheduled review is to be included in the upcoming infrastructure audit cycle.
- Split-scope exclusions — the address ranges where the 20% secondary DC is excluded from issuing leases — are maintained by hand in a spreadsheet whose location is recorded nowhere in this document. The spreadsheet must be migrated into the configuration management system as part of the next standards revision.
- Scavenging is disabled on two legacy scopes that are still in use for the Brambleby Logistics and Eastgate Housing sites. These scopes were originally created before scavenging was standardised and have not been updated. The scopes are targeted for replacement during the next VLAN restructuring initiative.