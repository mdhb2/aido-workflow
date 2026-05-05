#!/usr/bin/env bash
set -euo pipefail

echo "[AIDO] Starting full OpenCode skill setup..."

if ! command -v npx >/dev/null 2>&1; then
  echo "[AIDO][ERROR] npx is not available. Install Node.js (includes npm/npx) and retry."
  exit 1
fi

install_skill() {
  local name="$1"
  local url="$2"

  echo "[AIDO] Installing ${name}..."
  if npx skills add "$url" -a opencode -y; then
    echo "[AIDO][OK] ${name} installed"
  else
    echo "[AIDO][ERROR] Failed to install ${name} from ${url}"
    exit 1
  fi
}

install_skill "aido-workflow wrapper" "https://github.com/mdhb2/aido-workflow"
install_skill "planning-with-files" "https://github.com/othmanadi/planning-with-files"
install_skill "code-documenter" "https://github.com/Jeffallan/claude-skills/blob/main/skills/code-documenter/SKILL.md"
install_skill "grill-with-docs" "https://skills.sh/mattpocock/skills/grill-with-docs"
install_skill "prompt-enhancer" "https://skills.sh/samhvw8/dot-claude/prompt-enhancer"
install_skill "compact" "https://skills.sh/catlog22/claude-code-workflow/compact"
install_skill "caveman" "https://skills.sh/juliusbrussee/caveman/caveman"
install_skill "caveman-review" "https://skills.sh/juliusbrussee/caveman/caveman-review"

echo
echo "[AIDO] Setup complete."
echo "[AIDO] Try these commands in OpenCode:"
echo "  - aido-init"
echo "  - aido-brainstorm"
echo "  - aido-grill"
echo "  - aido-enhance"
echo "  - aido-plan-with-file"
echo "  - aido-breakdown"
echo "  - aido-execute-next"
echo "  - aido-caveman-review"
echo "  - aido-document"
echo "  - aido-archive"
echo "  - aido-clean"
echo "  - aido-status"
echo "  - aido-resume"
echo "  - aido-compact"
echo "  - aido-caveman"
echo
echo "[AIDO] Verification quick check:"
echo "  1) Run: aido-status"
echo "  2) Run: /aido-status"
echo "  3) Confirm both are detected and routed to aido-workflow"
