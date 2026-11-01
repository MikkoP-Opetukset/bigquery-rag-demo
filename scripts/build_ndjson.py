#!/usr/bin/env python3
"""Build data/documents.ndjson from docs_md/*.md frontmatter + body.

Zero dependencies (no PyYAML). Tolerant of quoted values, bare lists and
em-dash placeholders for missing dates.
"""
import json, os, re, sys, glob, codecs

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "docs_md")
OUT = os.path.join(ROOT, "data", "documents.ndjson")

FM_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n(.*)$", re.S)
KV_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$")

FIELDS = ["doc_id","title","doc_type","owner","version","status","classification",
          "created","updated","review_due","source_location","related","supersedes","synthetic"]
LIST_FIELDS = {"related", "supersedes"}
NULLISH = {"", "—", "-", "null", "none", "~"}


def unquote(v):
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
        inner = v[1:-1]
        # decode YAML double-quoted escapes such as \u2014 (em dash)
        if "\\u" in inner or "\\n" in inner:
            try:
                inner = codecs.decode(inner, "unicode_escape")
            except Exception:
                pass
        return inner
    return v


def parse_value(key, raw):
    raw = raw.strip()
    if key in LIST_FIELDS:
        inner = raw.strip()
        if inner.startswith("[") and inner.endswith("]"):
            inner = inner[1:-1].strip()
        if not inner or inner.lower() in NULLISH:
            return []
        return [unquote(x) for x in inner.split(",") if x.strip()]
    v = unquote(raw)
    if key == "synthetic":
        return v.lower() in ("true", "yes", "1")
    if v.lower() in NULLISH or v in NULLISH:
        return None
    return v


def parse(path):
    text = open(path, encoding="utf-8").read()
    m = FM_RE.match(text)
    if not m:
        raise SystemExit(f"no frontmatter: {path}")
    fm, body = m.group(1), m.group(2)
    meta = {}
    for line in fm.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        km = KV_RE.match(line)
        if km:
            meta[km.group(1)] = parse_value(km.group(1), km.group(2))
    body = body.strip()
    rec = {f: meta.get(f) for f in FIELDS}
    rec["related"] = rec["related"] or []
    rec["supersedes"] = rec["supersedes"] or []
    rec["synthetic"] = bool(rec["synthetic"])
    rec["body"] = body
    rec["body_word_count"] = len(body.split())
    rec["body_char_count"] = len(body)
    rec["source_file"] = os.path.basename(path)
    return rec


def main():
    paths = sorted(glob.glob(os.path.join(SRC, "*.md")))
    if not paths:
        raise SystemExit("no input files in " + SRC)
    recs, seen, problems = [], set(), []
    for p in paths:
        r = parse(p)
        if not r["doc_id"]:
            problems.append(f"{p}: missing doc_id")
            continue
        if r["doc_id"] in seen:
            problems.append(f"{p}: duplicate doc_id {r['doc_id']}")
            continue
        seen.add(r["doc_id"])
        recs.append(r)
    recs.sort(key=lambda r: r["doc_id"])
    with open(OUT, "w", encoding="utf-8") as f:
        for r in recs:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    words = sum(r["body_word_count"] for r in recs)
    print(f"wrote {len(recs)} documents -> {OUT}")
    print(f"total body words: {words}  (mean {words//max(len(recs),1)}/doc)")
    bad = [r["doc_id"] for r in recs if r["body_word_count"] < 400]
    if bad:
        print("SHORT DOCS (<400 words):", ", ".join(bad))
    for r in recs:
        print(f"  {r['doc_id']}  {r['body_word_count']:>4}w  {r['doc_type']:<14} "
              f"{r['status']:<10} {r['classification']:<12} {r['title'][:52]}")
    if problems:
        print("\nPROBLEMS:")
        for p in problems:
            print("  " + p)


if __name__ == "__main__":
    main()
