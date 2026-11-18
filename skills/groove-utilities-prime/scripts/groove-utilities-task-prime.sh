#!/usr/bin/env bash
# groove-utilities-task-prime — run task backend prime if configured

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX=".groove/index.md"

if [ ! -f "$INDEX" ]; then
  exit 0
fi

# Extract tasks.storage from frontmatter (falls back to the pre-0.18.3 key tasks.backend)
extract() {
  sed -n '/^---$/,/^---$/p' "$INDEX" | grep "$1:" | head -1 | sed "s/.*$1:[[:space:]]*//" | tr -d '[:space:]'
}
backend=$(extract storage)
[ -n "$backend" ] || backend=$(extract backend)

if [ -z "$backend" ] || [ "$backend" = "none" ]; then
  exit 0
fi

if [ "$backend" = "beans" ]; then
  if command -v beans &>/dev/null; then
    echo ""
    echo "## Tasks"
    beans prime 2>/dev/null || true
  fi
fi
