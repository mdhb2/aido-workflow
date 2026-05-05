#!/usr/bin/env bash
set -euo pipefail

echo "[AIDO] Starting full OpenCode skill setup..."

if ! command -v npx >/dev/null 2>&1; then
  echo "[AIDO][ERROR] npx is not available. Install Node.js (includes npm/npx) and retry."
  exit 1
fi

echo "[AIDO] Installing aido-workflow wrapper skill..."
npx skills add https://github.com/mdhb2/aido-workflow -a opencode -y

echo "[AIDO] Installing planning-with-files..."
npx skills add https://github.com/othmanadi/planning-with-files -a opencode -y

echo "[AIDO] Installing code-documenter source skill bundle..."
npx skills add https://github.com/Jeffallan/claude-skills -a opencode -y

echo "[AIDO] Installing grill-with-docs..."
npx skills add https://skills.sh/mattpocock/skills/grill-with-docs -a opencode -y

echo "[AIDO] Installing prompt-enhancer..."
npx skills add https://skills.sh/samhvw8/dot-claude/prompt-enhancer -a opencode -y

echo "[AIDO] Installing compact..."
npx skills add https://skills.sh/catlog22/claude-code-workflow/compact -a opencode -y

echo "[AIDO] Installing caveman..."
npx skills add https://skills.sh/juliusbrussee/caveman/caveman -a opencode -y

echo "[AIDO] Installing caveman-review..."
npx skills add https://skills.sh/juliusbrussee/caveman/caveman-review -a opencode -y

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
