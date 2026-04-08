#!/usr/bin/env bash
set -euo pipefail
G='\033[1;32m'; Y='\033[1;33m'; N='\033[0m'

echo -e "${Y}Removing geo-lens from ~/.claude/ ...${N}"
rm -rf "$HOME/.claude/skills/geo-lens"
for a in geo-lens geo-crawler geo-measurer geo-prober geo-opportunities geo-reporter; do
  rm -f "$HOME/.claude/agents/$a.md"
done
echo -e "${G}✓ Uninstalled.${N} (Your ~/geo-audits/ reports are untouched.)"
