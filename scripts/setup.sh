#!/bin/bash
set -e

LOCK_FILE="$(dirname "$0")/../skills-lock.json"

if [ ! -f "$LOCK_FILE" ]; then
  echo "Error: skills-lock.json not found at $LOCK_FILE"
  exit 1
fi

echo "Setting up groove skills from skills-lock.json..."

SKILLS=$(node -e "
const lock = require('$LOCK_FILE');
const skills = Object.entries(lock.skills || {});
skills.forEach(([name, entry]) => {
  console.log(entry.source || name);
});
")

if [ -z "$SKILLS" ]; then
  echo "No skills in lock file. Nothing to install."
else
  FAILED=0
  while IFS= read -r source; do
    echo "Installing $source..."
    if npx --yes skills add "$source"; then
      echo "  ✓ $source installed"
    else
      echo "  ✗ $source failed"
      FAILED=$((FAILED + 1))
    fi
  done <<< "$SKILLS"

  if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "Error: $FAILED skill(s) failed to install."
    exit 1
  fi
fi

echo ""
echo "Done. Run 'groove memory session start' to begin your session."
