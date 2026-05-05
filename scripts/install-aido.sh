#!/usr/bin/env bash
set -euo pipefail

echo "[AIDO] Starting full OpenCode skill setup..."

if ! command -v npx >/dev/null 2>&1; then
  echo "[AIDO][ERROR] npx is not available. Install Node.js (includes npm/npx) and retry."
  exit 1
fi

run_add() {
  local url="$1"
  npx skills add "$url" -a opencode -y
}

install_skill() {
  local name="$1"
  local primary_url="$2"
  local fallback_url="${3:-}"

  echo "[AIDO] Installing ${name}..."

  if run_add "$primary_url"; then
    echo "[AIDO][OK] ${name} installed from primary source"
    return 0
  fi

  if [ -n "$fallback_url" ]; then
    echo "[AIDO][WARN] Primary source failed for ${name}, trying fallback..."
    if run_add "$fallback_url"; then
      echo "[AIDO][OK] ${name} installed from fallback source"
      return 0
    fi
  fi

  echo "[AIDO][ERROR] Failed to install ${name}"
  echo "[AIDO][ERROR] Primary:  ${primary_url}"
  if [ -n "$fallback_url" ]; then
    echo "[AIDO][ERROR] Fallback: ${fallback_url}"
  fi
  return 1
}

FAILED=()

install_skill "aido-workflow wrapper" "https://github.com/mdhb2/aido-workflow" || FAILED+=("aido-workflow")
install_skill "planning-with-files" "https://github.com/othmanadi/planning-with-files" || FAILED+=("planning-with-files")
install_skill "code-documenter" "https://github.com/Jeffallan/claude-skills/blob/main/skills/code-documenter/SKILL.md" "https://raw.githubusercontent.com/Jeffallan/claude-skills/main/skills/code-documenter/SKILL.md" || FAILED+=("code-documenter")
install_skill "grill-with-docs" "https://skills.sh/mattpocock/skills/grill-with-docs" || FAILED+=("grill-with-docs")
install_skill "prompt-enhancer" "https://skills.sh/samhvw8/dot-claude/prompt-enhancer" || FAILED+=("prompt-enhancer")
install_skill "compact" "https://skills.sh/catlog22/claude-code-workflow/compact" || FAILED+=("compact")
install_skill "caveman" "https://skills.sh/juliusbrussee/caveman/caveman" || FAILED+=("caveman")
install_skill "caveman-review" "https://skills.sh/juliusbrussee/caveman/caveman-review" || FAILED+=("caveman-review")

if [ ${#FAILED[@]} -gt 0 ]; then
  echo
  echo "[AIDO][ERROR] Some supporting skills failed to install: ${FAILED[*]}"
  echo "[AIDO][ERROR] Re-run installer or install manually with 'npx skills add <url> -a opencode -y'."
  exit 1
fi

echo
echo "[AIDO] Running post-install verification..."
if npx skills list -a opencode >/dev/null 2>&1; then
  npx skills list -a opencode
  echo "[AIDO][OK] Skill list command completed. Confirm supporting skills appear above."
else
  echo "[AIDO][WARN] Could not run 'npx skills list -a opencode'."
  echo "[AIDO][WARN] Please verify manually in OpenCode by running: aido-status and /aido-status"
fi

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
