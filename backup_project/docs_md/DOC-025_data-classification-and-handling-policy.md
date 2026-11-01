---
doc_id: DOC-025
title: Data Classification and Handling Policy
doc_type: policy
owner: Aino Salo
version: "2.1"
status: current
classification: confidential
created: 2018-09-13
updated: 2026-07-08
review_due: 2027-07-08
source_location: SharePoint /Security/Policies/Data Classification v2.1.docx
related: [DOC-002, DOC-041]
supersedes: [v2.0]
synthetic: true
---

# Data Classification and Handling Policy

## 1 Purpose

This policy establishes the classification levels used by Norvane and the
handling requirements for information Norvane creates, processes, stores, or
transmits on behalf of its Customers. It ensures data
receives protection commensurate with its sensitivity and helps Norvane meet
obligations under Customer contracts and applicable data-protection regulations.

## 2 Scope

This policy applies to every Norvane employee, contractor, and subcontractor
who handles Customer data or Norvane internal data. It covers all media —
electronic, paper, and cloud-stored — and all environments: on-premise systems
at DC1 and DC2, remote workstations, customer sites, and third-party platforms where Norvane stores or processes data.

DOC-041 governs how privileged access to classified information is provisioned
and audited. Customer-facing data obligations under DOC-002 are set out in the
relevant contracts and service descriptions; this policy defines the internal
requirements Norvane follows to meet them.

## 3 Classification levels

Norvane uses four classification levels:

**Public** — Information Norvane is authorised to make available to anyone.
Examples: marketing material published on the Norvane website, published
service catalogues, and press releases.

**Internal** — Information for use within Norvane and, where contractually
permitted, the Customer's operational teams. Examples: internal policies,
runbooks, network diagrams, and internal reports.

**Confidential** — Information whose unauthorised disclosure could cause
commercial harm, regulatory exposure, or reputational damage. Examples: customer
contracts, incident records, asset inventories, and financial data.

**Restricted** — The highest tier. Information whose compromise could result in
serious harm to individuals, statutory breach, or significant contractual
penalty. Examples: health and patient data, legal client files, credentials and
encryption keys, authentication logs, and data classified as special category
under the EU General Data Protection Regulation.

## 4 Handling requirements

The table below specifies minimum handling requirements for each level:

| Requirement | Public | Internal | Confidential | Restricted |
|---|---|---|---|---|
| **Storage** | Any authorised system | Encrypted at rest | Encrypted at rest | Encrypted at rest and in transit |
| **Transmission** | Unencrypted permitted | TLS or equivalent | TLS 1.2 minimum | End-to-end encryption |
| **Access** | No restriction | Role-based; documented justification | Least-privilege; documented justification | Named-individual; approved by Security Lead and the Customer; access logging reviewed monthly |
| **Retention** | Until obsolete | Minimum two years | Contractual plus two years | Contractual minimum; extended for health data |
| **Destruction** | Standard deletion | Secure deletion (overwrite or degauss) | Cryptographic erasure or certified destruction | Certifiable destruction with witnessed certification |

## 5 Marking and sharing

Every document, file, or data extract produced or held by Norvane carries a
classification label, visible in the document frontmatter and, where feasible,
in the file metadata. Sharing classified data outside Norvane requires the
owner's written approval.

## 6 Third-party and cross-border transfer

Confidential or Restricted data must not be transferred outside the EEA or to
a country without an adequacy decision from the European Commission unless the
Customer has given explicit written approval. When approval is given, Norvane
records it on the relevant service record and notifies the Security Lead.
Third-party vendors processing such data must be subject to a data-processing
agreement incorporating equivalent classification requirements.

## 7 Breach reporting

A suspected data breach must be reported to the Security Lead within 24 hours. The Security Lead assesses the event and, where confirmed, coordinates notification to the supervisory authority and to any affected Customer within 72 hours. Customer notification describes the nature
of the breach, the categories and volume of data affected, and the measures
taken. This policy references GDPR and Finnish health-data obligations without quoting legislation.

## 8 Review

This policy is reviewed at least annually or when triggered by a change in
applicable legislation, a material breach, or a Customer contract amendment.
The Security Lead proposes updates; the Service Delivery Manager reviews
operational impact. Approved changes are communicated to staff and published on SharePoint within five business days.