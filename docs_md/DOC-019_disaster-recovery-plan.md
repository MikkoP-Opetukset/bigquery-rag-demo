---
doc_id: DOC-019
title: Disaster Recovery Plan
doc_type: plan
owner: Marko Heinänen
version: "5.0"
status: current
classification: confidential
created: 2017-11-02
updated: 2025-10-02
review_due: 2026-10-02
source_location: //fs01.norvane.internal/infra/dr/norvane-dr-plan-v5.0.pdf
related: [DOC-018, DOC-010]
supersedes: [v4.2]
synthetic: true
---

# Disaster Recovery Plan

## 1. Purpose and scope

This plan establishes procedures for recovering Norvane Managed IT Services Oy's services after a disaster at the primary data centre (DC1, Helsinki Pasila). It covers all infrastructure at both DC1 and DC2 (Tampere Kaleva), and the customer sites for which Norvane is responsible for service recovery.

The plan applies to all service tiers defined in DOC-006 and DOC-018. It is owned by the Head of Infrastructure and coordinated with the Service Delivery Manager for customer communications.

## 2. Assumptions

DC2 remains operational and the Vantage Fibre upstream circuit at DC2 is independent of the DC1 failure. Backup replication has kept the DC2 copy within documented RPO targets. Staff can work remotely or at DC2. The network topology in DOC-010 remains valid.

## 3. Recovery objectives

The following RTO and RPO values match the committed targets in DOC-018 section 4 and are validated against the results of the most recent disaster recovery test.

| Tier | RTO | RPO |
|---|---|---|
| Platinum | 4 h | 1 h |
| Gold | 8 h | 4 h |
| Silver | 24 h | 12 h |
| Bronze | 48 h | 24 h |

## 4. Declaration of disaster

A disaster is declared by the Head of Infrastructure jointly with the Service Delivery Manager, when both agree that DC1 cannot deliver services to one or more Customers within the RTO for the affected tier(s). The Service Delivery Manager notifies affected Customers within 1 hour of declaration for Platinum and Gold services, via registered customer contact channels with expected recovery timeline.

The declaration is logged in the ITSM system as a major incident and triggers the escalation procedures defined in DOC-020.

## 5. Recovery sequence

Recovery at DC2 is executed in five ordered phases:

**01 — Networking and remote access.** Confirm DC2 core switching, routing, and upstream Vantage Fibre circuits are operational. Re-establish management and transit VLANs. Ensure VPN concentrators are functional for engineering staff.

**02 — Identity and DNS.** Bring Active Directory domain controllers at DC2 online and verify replication from the latest backup. Restore DNS servers and confirm authoritative zones resolve. Update DHCP scopes if required.

**03 — File services.** Promote the file server cluster at DC2 from the most recent bkparr-02 image. Validate share permissions and confirm file-level restore capability via the ProtecTIER interface.

**04 — Business applications.** Restore application server virtual machines from DC2 backup images. Validate application connectivity to databases and update configuration to point at DC2 endpoints.

**05 — Voice.** Bring VoIP services online at DC2. Verify SIP registration and call routing through the PBX. Confirm phone service is available to end users.

## 6. Data centre failover

On disaster declaration, bkparr-02 at DC2 is promoted as the primary backup and restore target. Replication jobs are redirected to DC2. DNS records for customer-facing services are updated to resolve to DC2 addresses, and traffic is rerouted through the Vantage Fibre circuit at DC2.

DC2 has a known limitation: a single Catalyst 9300-48P switch with no redundant uplinks. During a disaster, this switch becomes the critical path for all DC2-originated traffic.

## 7. Communication and customer notification

The Service Delivery Manager is responsible for all external communications. For Platinum and Gold tier services, an initial update is provided within 1 hour of declaration, followed by updates every 2 hours until services are restored. For Silver and Bronze, an initial notification is sent within 4 hours. All communications include affected services, estimated recovery time, and current status.

## 8. Validation

A full disaster recovery test was carried out on 2024-11-16. All tiers were exercised and all objectives were met. The test confirmed DC2 promotion, DNS failover, and backup restore processes function within documented RTO targets.

Restore testing is performed twice yearly across all backup tiers. The next scheduled test is in May 2026 and will exercise the full recovery sequence as described in section 5.

## 9. Maintenance of this plan

This plan is reviewed every six months or following any incident affecting DC1 or DC2 availability. Changes to network topology, backup infrastructure, or customer tier assignments require an update. The Head of Infrastructure is responsible for maintaining this plan and ensuring all recovery procedures remain current and tested.