#!/bin/bash
set -e

echo "Setting up groove backends..."

# Task backend
echo ""
echo "→ Installing task backend..."
npx --yes groove task install

# Memory/sessions backend
echo ""
echo "→ Installing memory/sessions backend..."
npx --yes groove memory install

# Skills/finder backend
echo ""
echo "→ Installing skills/finder backend..."
npx --yes groove skills install

echo ""
echo "Done. Run 'groove memory session start' to begin your session."
