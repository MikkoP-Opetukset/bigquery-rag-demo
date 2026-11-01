#!/usr/bin/env python3
"""Verify the four long documents after the deep review pass.

Checks, per document:
  - body word count is in 600-780 (target 650-740, tolerance for editing)
  - frontmatter is byte-identical to the recorded expectation
  - every preserve-list fact is still present (substring, case-insensitive)
  - the deliberate defects the document carries are intact

Run: python3 scripts/verify_preserve.py
Exits non-zero if anything fails.
"""
import json, os, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS = os.path.join(ROOT, "docs_md")

EXPECT_FM = {
    "DOC-015": {
        "doc_type": "guide", "owner": "Aino Salo", "version": "2.2",
        "status": "current", "classification": "internal",
        "created": "2020-11-05", "updated": "2025-07-21",
        "review_due": "2027-07-21", "related": ["DOC-011", "DOC-041"],
    },
    "DOC-016": {
        "doc_type": "standard", "owner": "", "version": "1.3",
        "status": "current", "classification": "internal",
        "created": "2018-03-08", "updated": "2024-04-09",
        "review_due": "2026-04-09", "related": ["DOC-011", "DOC-012"],
    },
    "DOC-032": {
        "doc_type": "postmortem", "owner": "Emil Nyberg", "version": "1.0",
        "status": "current", "classification": "confidential",
        "created": "2026-05-06", "updated": "2026-05-06",
        "review_due": None, "related": ["DOC-018", "DOC-019", "DOC-021", "DOC-002"],
    },
    "DOC-033": {
        "doc_type": "postmortem", "owner": "Tuomas Virta", "version": "1.0",
        "status": "current", "classification": "internal",
        "created": "2026-07-14", "updated": "2026-07-14",
        "review_due": None, "related": ["DOC-005", "DOC-007", "DOC-010"],
    },
}

PRESERVE = {
    "DOC-015": [
        "201f", "active/passive", "vpn-conc-01", "forticlient", "ikev2",
        "entra", "totp", "multi-factor authentication", "10 hours", "30 minutes",
        "split tunnel", "allow-list", "posture", "remediation",
        "bastion", "doc-041", "doc-011",
        "stale dns", "mtu", "certificate", "locked", "profile mismatch",
    ],
    "DOC-016": [
        "ad-integrated", "bind", "forward", "isp", "seven days", "80/20",
        "reservation", "printer", "cctv", "wi-fi controller",
        "8 day", "30 day", "003", "006", "015", "042", "043", "119",
        "vlan 99", "two-business-day",
        "quarterly review", "spreadsheet", "legacy scopes",
        "doc-011", "doc-012",
    ],
    "DOC-032": [
        "inc-2026-0095", "aurora", "665", "24,000" if False else "24000",
        "storage controller", "9 hour", "2026-04-20 16:00",
        "8 hour", "11 hour", "4-hour rto", "bkparr-01", "bkparr-02",
        "2024-11-16", "clinical database tier", "vendor lab",
        "protected-object", "job status",
        "2026-06-11", "emil nyberg", "marko heinänen",
        "doc-018", "doc-019", "doc-021", "doc-002",
    ],
    "DOC-033": [
        "inc-2026-0128", "eastgate", "400", "3100", "upstream_provider",
        "vf-hel-4471", "vf-hel-4472", "400 m", "duct", "2023",
        "gsm", "telecare", "11:20", "6 hours 15", "1850", "doc-005",
        "5%", "2027-03-31", "2026-08-31", "2026-09-30", "2026-10-31",
        "doc-005", "doc-007", "doc-010",
    ],
}

# Alternatives: any of these satisfies the item (accepts 1,850 or 1850 etc.)
ALTS = {
    "1850": ["1850", "1,850"],
    "24000": ["24000", "24,000"],
    "3100": ["3100", "3,100"],
}


def load(doc_id):
    p = glob.glob(os.path.join(DOCS, f"{doc_id}_*.md"))[0]
    text = open(p, encoding="utf-8").read()
    parts = text.split("---", 2)
    return p, parts[0], parts[1], parts[2]


def main():
    # reuse the project's frontmatter parser
    sys.path.insert(0, os.path.join(ROOT, "scripts"))
    import build_ndjson as b
    failures = 0
    for doc_id in ["DOC-015", "DOC-016", "DOC-032", "DOC-033"]:
        path, _, _, body = load(doc_id)
        rec = b.parse(path)
        words = len(body.split())
        print(f"\n=== {doc_id}  {words} words  ({os.path.basename(path)})")
        if not (600 <= words <= 780):
            print(f"  FAIL word count {words} outside 600-780")
            failures += 1
        else:
            print("  ok   word count in range")

        for k, v in EXPECT_FM[doc_id].items():
            got = rec.get(k)
            if k == "owner" and not got and not v:
                continue
            if got != v:
                print(f"  FAIL frontmatter {k}: got {got!r} expected {v!r}")
                failures += 1
        if rec.get("synthetic") is not True:
            print("  FAIL synthetic flag lost")
            failures += 1

        low = body.lower()
        missing = []
        for needle in PRESERVE[doc_id]:
            options = ALTS.get(needle, [needle])
            if not any(o.lower() in low for o in options):
                missing.append(needle)
        if missing:
            print("  FAIL missing facts:", ", ".join(missing))
            failures += len(missing)
        else:
            print(f"  ok   all {len(PRESERVE[doc_id])} preserve items present")

    # cross-document defects
    recs = {d: b.parse(glob.glob(os.path.join(DOCS, f"{d}_*.md"))[0])
            for d in ["DOC-010", "DOC-019", "DOC-020", "DOC-023"]}
    print("\n=== corpus-level defects still intact")
    d19 = (recs["DOC-019"]["body"] or "").lower()
    d32 = (b.parse(glob.glob(os.path.join(DOCS, "DOC-032_*.md"))[0])["body"] or "").lower()
    checks = {
        "DOC-019 claims all tiers tested": "2024-11-16" in d19 and "all tiers" in d19,
        "DOC-032 contradicts it": ("file-services tier only" in d32 or "file-services" in d32
                                   and "only" in d32) and ("vendor lab" in d32 or "never been restored" in d32),
        "DOC-010 diversity claim": "geographically diverse" in (recs["DOC-010"]["body"] or "").lower(),
        "escalation drift 15/30": ("within 15 minutes" in (recs["DOC-020"]["body"] or "")
                                   and "within 30 minutes" in (recs["DOC-023"]["body"] or "")),
    }
    for k, v in checks.items():
        print(("  ok   " if v else "  FAIL ") + k)
        if not v:
            failures += 1

    print(f"\n{'ALL CHECKS PASSED' if failures == 0 else str(failures) + ' FAILURES'}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())