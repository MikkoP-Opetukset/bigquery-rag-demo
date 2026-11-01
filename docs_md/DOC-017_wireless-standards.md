---
doc_id: DOC-017
title: Wireless Standards
doc_type: standard
owner: Marko Heinänen
version: "1.1"
status: current
classification: internal
created: 2019-10-01
updated: 2021-03-11
review_due: 2022-03-11
source_location: //fs01.norvane.internal/infra/wireless/wireless-standards-v1.1.docx
related: [DOC-011]
supersedes: [v1.0]
synthetic: true
---

# Wireless Standards

## 1. Scope

This document defines the wireless networking standards for Norvane Managed IT Services Oy. It applies to all wireless infrastructure owned or operated by Norvane, including sites hosted for customers under the Aurora Health District and Feldspar Manufacturing service agreements.

## 2. Controller platform

Wireless management uses Cisco Catalyst 9800-series controllers in HA pairs: one pair per data centre. DC1 (Helsinki Pasila) runs the primary controller; DC2 (Tampere Kaleva) holds a standby pair to maintain SSID broadcasts and roaming state during a DC1 outage. Controllers are on management VLAN 99.

## 3. SSID design

Three SSIDs are provisioned across all managed sites:

- **norvane-corporate** — WPA2-Enterprise with 802.1X authentication against Active Directory. Users authenticate with domain credentials; devices use machine auth via Cisco ISE posture profiling. Maps to VLAN 30.
- **norvane-guest** — Pre-shared key with a captive portal for end-user registration. Rate-limited to 50/10 Mbit/s per user. Maps to VLAN 40 and is subject to content filtering.
- **norvane-iot** — WPA2-PSK with MAC filtering enforced by ISE. Reserved for printers, sensors, and POS devices. Maps to VLAN 50 with restricted ACLs permitting only necessary outbound endpoints.

Band steering is enabled to direct 802.11n/ac/ax-capable clients to 5 GHz. The 2.4 GHz band is retained for legacy devices.

## 4. Security

The corporate SSID uses 802.1X with EAP-PEAP-MSCHAPv2. TKIP is not permitted; CCMP/AES is required. The guest SSID uses a shared PSK rotated quarterly through change management and stored in the vault. The IoT SSID uses MAC filtering as an additional layer; MAC addresses alone are not sufficient for high-security zones.

WPA3 is not currently enabled. WPA3 'will be enabled during 2022 once the controller firmware upgrade completes'.

## 5. Radio design

Design targets: minimum RSSI −67 dBm at the client for data services, −60 dBm for voice-over-Wi-Fi. Sites use Cisco Prime WIPS for predictive heat-mapping before deployment.

Channel planning: 5 GHz at 40 MHz width; 2.4 GHz at 20 MHz on channels 1, 6, and 11 only. Transmit power is auto-adjusted via the RF Profile (18–22 dBm). Dynamic RF is enabled for channel and power optimisation.

## 6. Site survey process

A predictive or validated site survey is required for every new site before AP placement is signed off. Deliverables include a floorplan with AP locations, expected RSSI coverage, and channel assignments. No AP procurement order is raised until the survey is approved by the Head of Infrastructure.

## 7. AP inventory

Access points are deployed per site as follows:

| Site | AP count |
|---|---|
| aurora-hq | 14 |
| cobalt-hq | 9 |
| feldspar-plant | 11 |
| brambleby-hq | 6 |
| dunmore-hq | 4 |
| eastgate-offices | 5 |

All access points are Cisco Catalyst 9115-series (2×2:MIMO, 802.11ac Wave 2).

## 8. Roadmap

The Wi-Fi 6 rollout 'is planned for Q3 2021'. Once AP hardware is in place, WPA3 'will be enabled during 2022 once the controller firmware upgrade completes'. A further review of this document will be carried out after both migrations are complete.