#!/usr/bin/env bash
# groove: PostToolUse/Bash hook — buffer git commits for memory log
input=$(cat)
command=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)
if echo "$command" | grep -q "git commit"; then
  msg=$(echo "$command" | grep -oP '(?<=-m ")[^"]+' | head -1)
  mkdir -p .groove/.cache
  echo "$(date '+%Y-%m-%d %H:%M') | ${msg:-<no message>}" >> .groove/.cache/git-activity-buffer.txt
fi
