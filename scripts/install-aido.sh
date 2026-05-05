#!/usr/bin/env bash
set -euo pipefail

# If executed via pipe (e.g. curl ... | bash), re-exec from a temp file.
# This avoids stdin being consumed by nested CLIs during install steps.
# Guard: only trigger this path when running from stdin (not normal script execution).
if [ ! -t 0 ] && [ "${AIDO_REEXEC:-0}" != "1" ] && [[ "$0" == "bash" || "$0" == "-bash" ]]; then
  tmp_script="$(mktemp "${TMPDIR:-/tmp}/aido-install.XXXXXX.sh")"
  cat > "$tmp_script"
  chmod +x "$tmp_script"
  AIDO_REEXEC=1 bash "$tmp_script" "$@"
  exit $?
fi

AIDO_COMMAND_NAMES=(
  "aido-init"
  "aido-brainstorm"
  "aido-grill"
  "aido-enhance"
  "aido-plan-with-file"
  "aido-breakdown"
  "aido-execute-next"
  "aido-caveman-review"
  "aido-debug"
  "aido-debug-fix"
  "aido-document"
  "aido-archive"
  "aido-clean"
  "aido-status"
  "aido-resume"
  "aido-compact"
  "aido-caveman"
)

run_add() {
  local url="$1"
  npx skills add "$url" -a opencode -y --yes < /dev/null
}

install_opencode_commands() {
  local base="${AIDO_OPENCODE_BASE:-${HOME}/.config/opencode}"
  local dir1="${base}/command"
  local dir2="${base}/commands"

  mkdir -p "$dir1" "$dir2"

  write_cmd() {
    local name="$1"
    local desc="$2"
    local target
    for target in "$dir1/$name.md" "$dir2/$name.md"; do
      cat > "$target" <<EOF
---
description: ${desc}
---
You are executing '${name}' with arguments:


\$ARGUMENTS

Route to the aido-workflow skill behavior for '${name}'.

Rules:
1. Treat this as workflow command orchestration, not a shell executable.
2. Use only '.aido-workflow/' for state (never '.aido/' for new work).
3. Follow policies in 'skills/aido-workflow/SKILL.md' and references.
4. For 'aido-debug': diagnosis only, no autofix.
5. For 'aido-debug-fix': autofix allowed only within active phase scope.
EOF

      if [ "$name" = "aido-execute-next" ]; then
        cat >> "$target" <<'EOF'
6. Invoke /tdd before implementation and execute one red-green-refactor vertical slice at a time.
EOF
      fi
    done
  }

  write_cmd "aido-init" "Initialize AIDO workflow state in .aido-workflow"
  write_cmd "aido-brainstorm" "Run AIDO role-based brainstorming and persist outcomes"
  write_cmd "aido-grill" "Run AIDO grill-with-docs stress test for active module"
  write_cmd "aido-enhance" "Run AIDO prompt enhancement flow"
  write_cmd "aido-plan-with-file" "Create or update active module plan files"
  write_cmd "aido-breakdown" "Break active module into executable phases"
  write_cmd "aido-execute-next" "Execute next pending phase with TDD"
  write_cmd "aido-caveman-review" "Run caveman-style review before documentation"
  write_cmd "aido-debug" "Diagnose errors without applying code fixes"
  write_cmd "aido-debug-fix" "Diagnose and auto-fix within active phase scope"
  write_cmd "aido-document" "Generate module documentation and coverage report"
  write_cmd "aido-archive" "Archive module workflow artifacts"
  write_cmd "aido-clean" "Clean transient active workflow files"
  write_cmd "aido-status" "Show AIDO workflow status summary"
  write_cmd "aido-resume" "Resume AIDO workflow from current state"
  write_cmd "aido-compact" "Compact long context into actionable summary"
  write_cmd "aido-caveman" "Rewrite requirements into direct low-ambiguity language"

  echo "[AIDO][OK] OpenCode slash command files installed/updated in:"
  echo "[AIDO][OK]  - $dir1"
  echo "[AIDO][OK]  - $dir2"
}

verify_opencode_commands() {
  local base="${AIDO_OPENCODE_BASE:-${HOME}/.config/opencode}"
  local dir
  local cmd
  local file
  local ok=0

  for dir in "${base}/command" "${base}/commands"; do
    if [ ! -d "$dir" ]; then
      echo "[AIDO][ERROR] Missing command directory: $dir"
      return 1
    fi

    for cmd in "${AIDO_COMMAND_NAMES[@]}"; do
      file="$dir/$cmd.md"
      if [ ! -f "$file" ]; then
        echo "[AIDO][ERROR] Missing command file: $file"
        ok=1
        continue
      fi

      if ! grep -q "aido-workflow" "$file"; then
        echo "[AIDO][ERROR] Invalid command file (missing route): $file"
        ok=1
      fi

      if grep -q "You are executing \\ with arguments:" "$file"; then
        echo "[AIDO][ERROR] Corrupted placeholder content detected: $file"
        ok=1
      fi
    done
  done

  if [ "$ok" -ne 0 ]; then
    return 1
  fi

  return 0
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

echo "[AIDO] Starting full OpenCode skill setup..."

if [ "${AIDO_SKIP_SKILL_INSTALL:-0}" != "1" ]; then
  if ! command -v npx >/dev/null 2>&1; then
    echo "[AIDO][ERROR] npx is not available. Install Node.js (includes npm/npx) and retry."
    exit 1
  fi

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
else
  echo "[AIDO][INFO] AIDO_SKIP_SKILL_INSTALL=1, skipping skills add/list verification."
fi

echo
echo "[AIDO] Installing OpenCode slash command wrappers..."
install_opencode_commands

echo "[AIDO] Verifying OpenCode slash command wrappers..."
if verify_opencode_commands; then
  echo "[AIDO][OK] OpenCode slash command wrappers verified."
else
  echo "[AIDO][ERROR] OpenCode slash command wrappers verification failed."
  exit 1
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
