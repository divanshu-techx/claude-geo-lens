#!/usr/bin/env bash
#
# geo-lens installer
# Installs the skill and 6 agents (orchestrator + 5 sub-agents) into ~/.claude/
#
set -euo pipefail

G='\033[1;32m'; B='\033[1;34m'; Y='\033[1;33m'; R='\033[1;31m'; N='\033[0m'

echo -e "${B}geo-lens installer${N}"
echo "==================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/skills/geo-lens/SKILL.md" ]]; then
  SRC="$SCRIPT_DIR"
else
  TMP="$(mktemp -d)"
  echo -e "${Y}Cloning geo-lens to $TMP ...${N}"
  git clone --depth=1 https://github.com/divanshu-techx/claude-geo-lens.git "$TMP"
  SRC="$TMP"
fi

SKILL_DIR="$HOME/.claude/skills/geo-lens"
AGENT_DIR="$HOME/.claude/agents"

TS=$(date +%s)
if [[ -d "$SKILL_DIR" ]]; then
  echo -e "${Y}Backing up existing skill → $SKILL_DIR.backup.$TS${N}"
  mv "$SKILL_DIR" "$SKILL_DIR.backup.$TS"
fi
for a in geo-lens geo-crawler geo-measurer geo-prober geo-opportunities geo-reporter; do
  if [[ -f "$AGENT_DIR/$a.md" ]]; then
    mv "$AGENT_DIR/$a.md" "$AGENT_DIR/$a.md.backup.$TS"
    echo -e "${Y}Backed up existing agent: $a${N}"
  fi
done

mkdir -p "$SKILL_DIR" "$AGENT_DIR"
cp "$SRC/skills/geo-lens/SKILL.md" "$SKILL_DIR/SKILL.md"
for a in geo-lens geo-crawler geo-measurer geo-prober geo-opportunities geo-reporter; do
  cp "$SRC/agents/$a.md" "$AGENT_DIR/$a.md"
  echo -e "${G}✓${N} Agent installed: $a"
done
echo -e "${G}✓${N} Skill installed: geo-lens"

echo ""
echo -e "${B}Next steps:${N}"
echo "  1. Restart Claude Code (or open a new session)"
echo "  2. Say: ${G}audit GEO for yoursite.com${N}"
echo "  3. Bundle appears at: ~/geo-audits/{domain}-{date}/"
echo "  4. Open report: ${G}open ~/geo-audits/{domain}-{date}/index.html${N}"
echo "  5. Ship fixes: ${G}~/geo-audits/{domain}-{date}/remediation.md${N}"
echo ""
echo -e "${B}Docs:${N} https://github.com/divanshu-techx/claude-geo-lens"
