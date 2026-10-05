#!/bin/bash
# scripts/mkdtboimg.py — DTBO bundle create/dump (ch.03 §611 chain: per-overlay .dtbo -> bundle -> avbtool hash footer).
# Phone-safe pure-python: emits/verifies simple length-prefixed bundle format for text-level tests.
import argparse, struct, sys, pathlib

MAGIC = b"DTBO"
HDR = struct.Struct("<4sII")  # magic, page_size, entry_count
ENTRY = struct.Struct("<IIQI")  # id, rev, offset, size


def create(out, page_size, overlays):
    page = page_size
    entries = []
    blobs = []
    offset = HDR.size + ENTRY.size * max(len(overlays), 1)
    offset = (offset + page - 1) // page * page
    for path, iid, rev in overlays:
        data = pathlib.Path(path).read_bytes()
        entries.append((iid, rev, offset, len(data)))
        blobs.append(data)
        offset += (len(data) + page - 1) // page * page
    with open(out, "wb") as f:
        f.write(HDR.pack(MAGIC, page_size, len(entries)))
        for e in entries:
            f.write(ENTRY.pack(*e))
        pad = (HDR.size + ENTRY.size * len(entries))
        f.write(b"\0" * ((page - pad % page) % page))
        for data, e in zip(blobs, entries):
            f.write(data)
            f.write(b"\0" * ((page - len(data) % page) % page))
    print("mkdtboimg: wrote %s (%d overlays)" % (out, len(entries)))


def dump(img, txt):
    data = pathlib.Path(img).read_bytes()
    magic, page, n = HDR.unpack_from(data, 0)
    if magic != MAGIC:
        print("REFUSED: bad magic"); sys.exit(2)
    lines = ["entries=%d page_size=%d" % (n, page)]
    for i in range(n):
        iid, rev, off, sz = ENTRY.unpack_from(data, HDR.size + i * ENTRY.size)
        lines.append("id=%d rev=%d offset=%d size=%d" % (iid, rev, off, sz))
    out = "\n".join(lines) + "\n"
    if txt:
        pathlib.Path(txt).write_text(out)
        print("mkdtboimg: dumped to %s" % txt)
    else:
        print(out, end="")


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("create")
    c.add_argument("out"); c.add_argument("--page_size", type=int, default=2048)
    c.add_argument("overlays", nargs="+", help="id:rev:path triples")
    d = sub.add_parser("dump")
    d.add_argument("img"); d.add_argument("-b", "--txt")
    a = ap.parse_args()
    if a.cmd == "create":
        ovs = []
        for spec in a.overlays:
            iid, rev, path = spec.split(":", 2)
            ovs.append((path, int(iid), int(rev)))
        create(a.out, a.page_size, ovs)
    else:
        dump(a.img, a.txt)


if __name__ == "__main__":
    main()
