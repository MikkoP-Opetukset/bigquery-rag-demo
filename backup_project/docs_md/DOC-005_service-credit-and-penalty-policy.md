---
doc_id: DOC-005
title: Service Credit and Penalty Policy
doc_type: policy
owner: Service Delivery (Petra Lindqvist)
version: "2.3"
status: current
classification: internal
created: 2020-02-11
updated: 2025-04-02
review_due: 2027-04-02
source_location: Confluence / Service Delivery / Credit Policy (page 118822)
related: [DOC-001, DOC-002, DOC-004, DOC-033]
supersedes: [v2.0 (2022)]
synthetic: true
---

# Service Credit and Penalty Policy

This policy operationalises clause 5 of the Master SLA (DOC-001). It applies to
all Customers with an active Service Schedule.

## 1. Principle

Credits are compensation for missed commitments, not a penalty. They are
automatic where monitoring data proves the miss, and are capped per Service
Schedule. Credits are applied to the next invoice; they are never paid in cash
and never exceed the cap.

## 2. Availability credits

Credits are calculated per service per calendar month from achieved
availability:

| Availability achieved vs target | Credit (% of monthly fee for service) |
|---|---|
| Within 0.05 pp of target | 0% |
| 0.05 to 0.20 pp below | 5% |
| 0.20 to 0.50 pp below | 10% |
| 0.50 to 1.00 pp below | 20% |
| More than 1.00 pp below | 30%, capped per Schedule |

"pp" means percentage points. A Silver customer at 99.5% target achieving
99.31% is 0.19 pp below target and receives 5%.

## 3. Platinum escalator

Where a Platinum Customer misses its availability target in two consecutive
months, the second month's credit is doubled before applying the cap. Where
three consecutive months are missed, the Customer may terminate the affected
service without penalty on 30 days' notice.

## 4. Response and resolution credits

A missed P1 response is credited at 2% of the monthly fee for the affected
service per occurrence, to a maximum of 10% in any month. A missed P1
resolution is credited at 5% per occurrence, to a maximum of 15%. Response and
resolution credits are cumulative with availability credits but subject to the
single overall cap in the Service Schedule.

## 5. Claims procedure

Norvane raises credits automatically from the monthly service report. A
Customer disputing the report must raise the dispute within fifteen (15)
business days of the report date. Disputes are resolved by the Service Delivery
Manager; unresolved disputes escalate to the account director.

Customers do not need to claim availability credits. Credits arising from
events where monitoring data is incomplete must be claimed explicitly.

## 6. Worked example

Eastgate Housing Association (Bronze, 99.0% target) suffered a 6 hour 40
minute outage in June 2026 caused by the upstream provider (INC-2026-0128).
Trading/measured window was the full calendar month. Achieved availability was
98.7%, which is 0.3 pp below target → 10% bracket, but the Bronze cap is 5%,
so the credit issued was 5% of the monthly connectivity fee, EUR 3,100.

The upstream provider's own credit to Norvane for the same event was EUR 1,850
under the Vantage Fibre SLA (DOC-007). Norvane does not pass through upstream
credits; the Schedule's cap governs.

## 7. Exclusions

No credit is due for downtime classified as Excused Downtime under DOC-001
clause 2, or for incidents caused by a Customer action taken contrary to
Norvane's written advice.
