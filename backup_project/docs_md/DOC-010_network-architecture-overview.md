---
doc_id: DOC-010
title: Network Architecture Overview
doc_type: reference
owner: Marko Heinänen
version: "6.0"
status: current
classification: internal
created: 2016-09-22
updated: 2026-05-04
review_due: 2027-05-04
source_location: //fs01.norvane.internal/infra/network/architecture-overview-v6.0.pdf
related: [DOC-011, DOC-012, DOC-019]
supersedes: [v5.0]
synthetic: true
---

# Network Architecture Overview

## 1. Purpose and scope

This document provides the authoritative overview of Norvane Managed IT Services Oy's network architecture. It describes the physical layout, logical topology, and inter-site connectivity for the two data centres (DC1 Helsinki and DC2 Tampere) as well as the upstream circuits that provide internet and MPLS access. The scope covers all equipment in the data centre and edge network. Customer site architectures are documented separately in the individual site plans.

The primary audience is the infrastructure team, the service desk, and any engineer who must understand the network for incident response or change management.

## 2. Physical topology

DC1, the primary data centre, is located in Pasila, Helsinki. It houses six VMware vSphere 8 ESXi hosts, two core switches operating in a StackWise virtual pair, a border router, an edge firewall pair, and a VPN concentrator. Power is delivered through dual PDUs fed by separate UPS circuits with backup generator support.

DC2, the disaster recovery site, is located in Kaleva, Tampere. It contains three vSphere 8 hosts, a single Catalyst 9300-48P access switch (core-sw-11), and the termination point for the DC1-to-DC2 L2 circuit. DC2 has no local internet breakout — all internet-bound traffic from DC2 backhauls to DC1 over the L2 tunnel carried by the VF-HEL-4473 circuit.

## 3. Logical topology and VLANs

The logical topology follows the VLAN plan defined in DOC-011. Each site uses the standard VLAN set: 10 (Data), 20 (Voice), 30 (Corporate Wi-Fi), 40 (Guest Wi-Fi), 50 (Print/IoT), 60 (CCTV, retail and plant sites only), 99 (Management), and 999 (Transit).

The transit VLAN 999 connects DC1 and DC2 over the L2 circuit and carries inter-site traffic only. The Management VLAN 99 runs to all network devices, including the border router, firewalls, core switches, and ESXi management interfaces.

At DC1 the core is built around two Cisco Catalyst 9500-48Y4C switches in StackWise virtual mode (core-sw-01 / core-sw-02). The Cisco ASR 1001-X border router (core-rtr-01) sits upstream of the FortiGate 400F edge firewall pair (fw-edge-01 and fw-edge-02). The FortiGate 201F VPN concentrator (vpn-conc-01) handles all remote-access and site-to-site tunnels.

## 4. Data centre interconnect

DC1 and DC2 are connected via the Vantage Fibre circuit VF-HEL-4473, a 1 Gbit/s L2 link carrying VLAN 999. This circuit provides the transport for all DC2 inter-site traffic, including management, replication, and server traffic.

Upstream connectivity terminates at DC1 only. The primary circuit (VF-HEL-4471) delivers 1 Gbit/s symmetric, with the backup circuit (VF-HEL-4472) providing 300 Mbit/s up / 100 Mbit/s down as a fallback. Internet and cloud access flows through the firewall pair at DC1.

## 5. Resilience and redundancy

DC1 employs a fully redundant core design: the StackWise virtual pair on the Catalyst 9500s provides link-level and device-level redundancy, and the FortiGate 400F edge pair runs active-active with automatic failover. The border router connects to both core switches for upstream diversity.

DC1 and DC2 sit on geographically diverse fibre paths with no shared physical infrastructure. The two sites are connected over separate right-of-way routes, eliminating any single-point-of-failure risk in the transport layer between them.

DC1 hosts six ESXi nodes; the cluster can tolerate the loss of two hosts while maintaining full workload coverage. DC2's three hosts provide sufficient capacity for failover of the most critical workloads.

## 6. Known limitations

The current design has the following constraints:

- DC2 uses a single Catalyst 9300-48P switch (core-sw-11) with no redundancy at the access layer. A failure of core-sw-11 takes the entire DR site offline.
- DNS resolution in both DC1 and DC2 depends on the same two domain controllers located at DC1. No local DNS resolvers exist at DC2.
- No traffic engineering exists between the primary (VF-HEL-4471) and backup (VF-HEL-4472) upstream circuits; failover is controlled solely by the edge firewalls.
- DC2 has no local internet connectivity. If the L2 backhaul to DC1 fails, DC2 workloads lose all external access.

## 7. Document control

| Version | Date       | Author             | Change summary |
|---------|------------|--------------------|----------------|
| 6.0     | 2026-05-04 | Marko Heinänen     | Updated firmware baselines and host counts; clarified DC2 backhaul design |
| 5.0     | 2024-08-15 | Marko Heinänen     | Added DC2 Catalyst 9300 detail; aligned with DR plan v3.0 |
| 4.0     | 2022-01-10 | Marko Heinänen     | Major revision after migration to vSphere 8 |
| 3.0     | 2019-06-20 | Ilkka Rantala      | Initial DC2 site description |