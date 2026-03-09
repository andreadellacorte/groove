#!/usr/bin/env bash
# groove: sessionStart hook — inject workflow context after session start / compaction
if [ -f ".groove/index.md" ]; then
  echo '{"additional_context": "groove: run /groove-utilities-prime to load workflow context. This ensures conventions, config, and CLI reference are available in this session."}'
else
  echo '{"additional_context": "groove: .groove/index.md not found — run /groove-admin-install to set up groove."}'
fi
