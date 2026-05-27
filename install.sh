#!/usr/bin/env bash
#
# Forge cross-tool installer.
#
#   ./install.sh            Auto-detect installed tools and install for each.
#   ./install.sh claude     Install the Claude Code skill + subagents.
#   ./install.sh codex      Install the Codex Agent Skill.
#   ./install.sh cursor     Install the Cursor command (portable single-file build).
#   ./install.sh all        Install for all three regardless of detection.
#   ./install.sh -h|--help  Show this help.
#
# Forge ships only Markdown — this script just copies files into your tool's
# config directory. Re-running it overwrites the previously installed copy.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say()  { printf '%s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }

usage() { sed -n '3,13p' "$0" | sed 's/^# \{0,1\}//'; }

install_claude() {
  say "Claude Code →"
  mkdir -p "$HOME/.claude/skills" "$HOME/.claude/agents"
  rm -rf "$HOME/.claude/skills/forge"
  cp -R "$HERE/skills/forge" "$HOME/.claude/skills/forge"
  cp "$HERE"/agents/forge-*.md "$HOME/.claude/agents/"
  ok "skill → ~/.claude/skills/forge"
  ok "subagents → ~/.claude/agents/forge-*.md"
  ok "invoke with: /forge <idea>"
}

install_codex() {
  # Codex has no subagents/structured-question UI, so install the self-contained
  # single-file build as the skill body (no dangling agent references), with the
  # name/description frontmatter Codex Agent Skills require.
  say "Codex CLI →"
  local dest="$HOME/.codex/skills/forge"
  mkdir -p "$dest"
  {
    printf -- '---\n'
    printf 'name: forge\n'
    printf 'description: %s\n' "Take a software idea to a verified, documented implementation via an agentic pipeline (interview, grounded research, a granular plan, a verification-gated build, optional tests, a security pass, and a final bug sweep). Use when the user wants to build something from an idea with rigor and no grey areas."
    printf -- '---\n\n'
    cat "$HERE/dist/forge.md"
  } > "$dest/SKILL.md"
  ok "Agent Skill → ~/.codex/skills/forge/SKILL.md (self-contained)"
  ok "use it: ask Codex to 'forge <your idea>', or trigger with \$forge / browse /skills"
}

install_cursor() {
  say "Cursor →"
  mkdir -p "$HOME/.cursor/commands"
  cp "$HERE/dist/forge.md" "$HOME/.cursor/commands/forge.md"
  ok "command → ~/.cursor/commands/forge.md"
  ok "invoke with: /forge"
}

detect_and_install() {
  local found=0
  [ -d "$HOME/.claude" ] && { install_claude; found=1; }
  [ -d "$HOME/.codex" ]  && { install_codex;  found=1; }
  [ -d "$HOME/.cursor" ] && { install_cursor; found=1; }
  if [ "$found" -eq 0 ]; then
    warn "No ~/.claude, ~/.codex, or ~/.cursor directory found."
    warn "Specify a target explicitly, e.g.:  ./install.sh claude"
    say ""
    usage
    exit 1
  fi
}

case "${1:-auto}" in
  -h|--help|help) usage; exit 0 ;;
  claude) install_claude ;;
  codex)  install_codex ;;
  cursor) install_cursor ;;
  all)    install_claude; install_codex; install_cursor ;;
  auto)   detect_and_install ;;
  *) warn "Unknown target: $1"; say ""; usage; exit 1 ;;
esac

say ""
say "Done. Restart your assistant if it was running, then start a build with: /forge <your idea>"
