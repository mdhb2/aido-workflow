#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT_DIR/scripts/install-aido.sh"

EXPECTED_COMMANDS=(
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

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  echo "PASS: $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  echo "FAIL: $1"
}

TMP_HOME="$(mktemp -d "${TMPDIR:-/tmp}/aido-test-home.XXXXXX")"
TMP_OPENCODE_BASE="$(mktemp -d "${TMPDIR:-/tmp}/aido-test-opencode.XXXXXX")"
LOG_FILE="$(mktemp "${TMPDIR:-/tmp}/aido-test-log.XXXXXX")"
trap 'rm -rf "$TMP_HOME" "$TMP_OPENCODE_BASE" "$LOG_FILE"' EXIT

if HOME="$TMP_HOME" AIDO_OPENCODE_BASE="$TMP_OPENCODE_BASE" AIDO_SKIP_SKILL_INSTALL=1 bash "$INSTALLER" >"$LOG_FILE" 2>&1; then
  pass "installer_runs_in_test_mode"
else
  fail "installer_runs_in_test_mode"
fi

CMD_DIR="$TMP_OPENCODE_BASE/command"
CMDS_DIR="$TMP_OPENCODE_BASE/commands"

if [ -d "$CMD_DIR" ] && [ -d "$CMDS_DIR" ]; then
  pass "command_directories_created"
else
  fail "command_directories_created"
fi

MISSING=0
for cmd in "${EXPECTED_COMMANDS[@]}"; do
  if [ ! -f "$CMD_DIR/$cmd.md" ] || [ ! -f "$CMDS_DIR/$cmd.md" ]; then
    MISSING=1
    break
  fi
done
if [ "$MISSING" -eq 0 ]; then
  pass "all_expected_commands_exist_in_both_dirs"
else
  fail "all_expected_commands_exist_in_both_dirs"
fi

if grep -R -E "You are executing \\ with arguments:|Route to the \\ skill behavior for \\.|Use only \\ for state" "$TMP_OPENCODE_BASE" >/dev/null 2>&1; then
  fail "no_corrupted_placeholder_content"
else
  pass "no_corrupted_placeholder_content"
fi

if grep -q "\$ARGUMENTS" "$CMD_DIR/aido-debug.md" && grep -q "aido-workflow" "$CMD_DIR/aido-debug.md"; then
  pass "debug_wrapper_contains_route_and_arguments_placeholder"
else
  fail "debug_wrapper_contains_route_and_arguments_placeholder"
fi

if grep -q "/tdd" "$CMD_DIR/aido-execute-next.md" && grep -q "/tdd" "$CMDS_DIR/aido-execute-next.md"; then
  pass "execute_next_invokes_tdd"
else
  fail "execute_next_invokes_tdd"
fi

if grep -q "diagnosis only, no autofix" "$CMD_DIR/aido-debug.md" && grep -q "active phase scope" "$CMD_DIR/aido-debug-fix.md"; then
  pass "debug_policy_invariants_present"
else
  fail "debug_policy_invariants_present"
fi

echo "RESULT: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
if [ "$FAIL_COUNT" -ne 0 ]; then
  exit 1
fi
