#!/usr/bin/env bash
set -euo pipefail

# If executed via pipe (e.g. curl ... | bash), re-exec from a temp file.
# This avoids stdin being consumed by nested CLIs during install steps.
if [ ! -t 0 ] && [ "${AIDO_REEXEC:-0}" != "1" ]; then
  tmp_script="$(mktemp "${TMPDIR:-/tmp}/aido-install.XXXXXX.sh")"
  cat > "$tmp_script"
  chmod +x "$tmp_script"
  AIDO_REEXEC=1 bash "$tmp_script" "$@"
  exit $?
fi

echo "[AIDO] Starting full OpenCode skill setup..."

if ! command -v npx >/dev/null 2>&1; then
  echo "[AIDO][ERROR] npx is not available. Install Node.js (includes npm/npx) and retry."
  exit 1
fi

run_add() {
  local url="$1"
  npx skills add "$url" -a opencode -y --yes < /dev/null
}

install_skill_multi() {
  local name="$1"
  shift

  echo "[AIDO] Installing ${name}..."

  local attempt=1
  local url
  for url in "$@"; do
    echo "[AIDO]  - Attempt ${attempt}: ${url}"
    if run_add "$url"; then
      echo "[AIDO][OK] ${name} installed"
      return 0
    fi
    attempt=$((attempt + 1))
  done

  echo "[AIDO][ERROR] Failed to install ${name}"
  echo "[AIDO][ERROR] Tried sources:"
  for url in "$@"; do
    echo "[AIDO][ERROR]  - ${url}"
  done
  return 1
}

FAILED=()

install_skill_multi "aido-workflow wrapper" \
  "https://github.com/mdhb2/aido-workflow" || FAILED+=("aido-workflow")

install_skill_multi "planning-with-files" \
  "https://github.com/othmanadi/planning-with-files" || FAILED+=("planning-with-files")

install_skill_multi "code-documenter" \
  "https://github.com/Jeffallan/claude-skills/blob/main/skills/code-documenter/SKILL.md" \
  "https://raw.githubusercontent.com/Jeffallan/claude-skills/main/skills/code-documenter/SKILL.md" \
  "https://github.com/Jeffallan/claude-skills" || FAILED+=("code-documenter")

install_skill_multi "grill-with-docs" \
  "https://skills.sh/mattpocock/skills/grill-with-docs" \
  "https://github.com/mattpocock/skills/blob/main/skills/grill-with-docs/SKILL.md" \
  "https://raw.githubusercontent.com/mattpocock/skills/main/skills/grill-with-docs/SKILL.md" \
  "https://github.com/mattpocock/skills" || FAILED+=("grill-with-docs")

install_skill_multi "diagnose" \
  "https://github.com/mattpocock/skills/blob/main/skills/diagnose/SKILL.md" \
  "https://raw.githubusercontent.com/mattpocock/skills/main/skills/diagnose/SKILL.md" \
  "https://github.com/mattpocock/skills" || FAILED+=("diagnose")

install_skill_multi "prompt-enhancer" \
  "https://skills.sh/samhvw8/dot-claude/prompt-enhancer" \
  "https://github.com/samhvw8/dot-claude/blob/main/.claude/skills/prompt-enhancer/SKILL.md" \
  "https://raw.githubusercontent.com/samhvw8/dot-claude/main/.claude/skills/prompt-enhancer/SKILL.md" \
  "https://github.com/samhvw8/dot-claude" || FAILED+=("prompt-enhancer")

install_skill_multi "compact" \
  "https://skills.sh/catlog22/claude-code-workflow/compact" \
  "https://github.com/catlog22/claude-code-workflow/blob/main/skills/compact/SKILL.md" \
  "https://raw.githubusercontent.com/catlog22/claude-code-workflow/main/skills/compact/SKILL.md" \
  "https://github.com/catlog22/claude-code-workflow" || FAILED+=("compact")

install_skill_multi "caveman" \
  "https://skills.sh/juliusbrussee/caveman/caveman" \
  "https://github.com/juliusbrussee/caveman/blob/main/skills/caveman/SKILL.md" \
  "https://raw.githubusercontent.com/juliusbrussee/caveman/main/skills/caveman/SKILL.md" \
  "https://github.com/juliusbrussee/caveman" || FAILED+=("caveman")

install_skill_multi "caveman-review" \
  "https://skills.sh/juliusbrussee/caveman/caveman-review" \
  "https://github.com/juliusbrussee/caveman/blob/main/skills/caveman-review/SKILL.md" \
  "https://raw.githubusercontent.com/juliusbrussee/caveman/main/skills/caveman-review/SKILL.md" \
  "https://github.com/juliusbrussee/caveman" || FAILED+=("caveman-review")

if [ ${#FAILED[@]} -gt 0 ]; then
  echo
  echo "[AIDO][ERROR] Some supporting skills failed to install: ${FAILED[*]}"
  echo "[AIDO][ERROR] Re-run installer or install manually with 'npx skills add <url> -a opencode -y'."
  exit 1
fi

echo
echo "[AIDO] Running post-install verification..."
if npx skills list -a opencode > /tmp/aido-skills-list.txt 2>/dev/null; then
  cat /tmp/aido-skills-list.txt

  MISSING=()
  for expected in \
    "aido-workflow" \
    "planning-with-files" \
    "code-documenter" \
    "grill-with-docs" \
    "diagnose" \
    "prompt-enhancer" \
    "compact" \
    "caveman" \
    "caveman-review"; do
    if ! grep -qi "$expected" /tmp/aido-skills-list.txt; then
      MISSING+=("$expected")
    fi
  done

  if [ ${#MISSING[@]} -gt 0 ]; then
    echo "[AIDO][WARN] Could not confirm these exact names in list: ${MISSING[*]}"
    echo "[AIDO][WARN] Some repositories install with different skill names. Please verify available skills manually."
  else
    echo "[AIDO][OK] All expected supporting skills detected in OpenCode list."
  fi
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
echo "  - aido-debug"
echo "  - aido-debug-fix"
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
