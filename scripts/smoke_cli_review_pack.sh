#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TMP_OUTPUT="$(mktemp)"
swift run EcoTideCLI --scenario stable --motion live >"$TMP_OUTPUT"

python3 - "$TMP_OUTPUT" <<'PY'
import json
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text(encoding="utf-8")
start = text.find("{")
if start < 0:
    raise SystemExit("JSON payload not found in EcoTideCLI output")
payload = json.loads(text[start:])
assert payload["selected_scenario"] == "stable"
assert payload["status"] == "fallback-ready"
assert payload["proof_bundle"]["motion_mode"] == "coremotion-live"
print("ecotide-cli-smoke: ok")
PY

rm -f "$TMP_OUTPUT"
