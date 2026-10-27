#!/usr/bin/env bash
# After `clj -M:cljd flutter`, merge file-picker entitlements into the
# generated macOS runner (required for desktop Import / file_selector).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEY='com.apple.security.files.user-selected.read-write'
TEMPLATE_DIR="$ROOT/macos/Runner"
for name in DebugProfile.entitlements Release.entitlements; do
  f="$TEMPLATE_DIR/$name"
  if [[ ! -f "$f" ]]; then
    echo "skip: $f not found (run clj -M:cljd flutter first)" >&2
    continue
  fi
  if grep -q "$KEY" "$f"; then
    echo "ok: $name already has $KEY"
    continue
  fi
  python3 - "$f" "$KEY" <<'PY'
import plistlib, sys
path, key = sys.argv[1], sys.argv[2]
with open(path, "rb") as fp:
    data = plistlib.load(fp)
data[key] = True
with open(path, "wb") as fp:
    plistlib.dump(data, fp)
print(f"patched: {path}")
PY
done
