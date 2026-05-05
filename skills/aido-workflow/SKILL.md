---
name: aido-workflow
description: unified workflow for zed and opencode. use when the user types commands prefixed with aido such as aido-init, aido-brainstorm, aido-grill, aido-enhance, aido-plan-with-file, aido-breakdown, aido-execute-next, aido-caveman-review, aido-debug, aido-debug-fix, aido-document, aido-archive, aido-clean, aido-status, aido-resume, aido-compact, or aido-caveman. coordinates planning-with-files, grill-with-docs, prompt-enhancer, compact, caveman, caveman-review, diagnose, code-documenter, gstack-style brainstorming, gsd-style breakdown, and superpowers-style tdd execution while storing all workflow state in .aido-workflow.
---

# AIDO Workflow Skill

## Command Detection

Detect and route all of the following as equivalent:

- `aido-init` and `/aido-init`
- `aido-brainstorm` and `/aido-brainstorm`
- `aido-grill` and `/aido-grill`
- `aido-enhance` and `/aido-enhance`
- `aido-plan-with-file` and `/aido-plan-with-file`
- `aido-breakdown` and `/aido-breakdown`
- `aido-execute-next` and `/aido-execute-next`
- `aido-caveman-review` and `/aido-caveman-review`
- `aido-debug` and `/aido-debug`
- `aido-debug-fix` and `/aido-debug-fix`
- `aido-document` and `/aido-document`
- `aido-archive` and `/aido-archive`
- `aido-clean` and `/aido-clean`
- `aido-status` and `/aido-status`
- `aido-resume` and `/aido-resume`
- `aido-compact` and `/aido-compact`
- `aido-caveman` and `/aido-caveman`

Always route to this skill: `aido-workflow`.

## OpenCode Slash Commands

Register and support these slash commands explicitly:

- `/aido-init`
- `/aido-brainstorm`
- `/aido-grill`
- `/aido-enhance`
- `/aido-plan-with-file`
- `/aido-breakdown`
- `/aido-execute-next`
- `/aido-caveman-review`
- `/aido-debug`
- `/aido-debug-fix`
- `/aido-document`
- `/aido-archive`
- `/aido-clean`
- `/aido-status`
- `/aido-resume`
- `/aido-compact`
- `/aido-caveman`

Also support non-slash aliases for each command above (`aido-*`).

## Storage Policy

All workflow state must be inside `.aido-workflow/`.

Never use `.aido/` for new operations.

If legacy `.aido/` exists:

1. Create `.aido-workflow/` if missing.
2. Migrate compatible files into `.aido-workflow/`.
3. Report migration details to user.
4. Do not delete `.aido/` unless explicitly instructed.

Required structure:

```text
.aido-workflow/
  active_module.md
  task_plan.md
  findings.md
  decisions.md
  progress.md
  test_report.md
  specs/
  modules/
  reports/
  archive/
    task_plans/
    progress/
    decisions/
```

`task_plan.md` must contain active module scope only.

## Command Routing and Behavior

### 1) `aido-init`

- Create full `.aido-workflow/` structure.
- Handle legacy `.aido/` migration policy.
- Report created files and migration status.

### 2) `aido-brainstorm`

- Run role-based brainstorming with roles:
  - Product Owner
  - Engineering Manager
  - Security Engineer
  - QA Engineer
  - Developer
- Write output to:
  - `.aido-workflow/findings.md`
  - `.aido-workflow/decisions.md`
- Recommend next: `aido-grill`.
- Must auto-call `/aido-plan-with-file`.

### 3) `aido-grill`

- Use Grill With Docs pattern.
- Focus on ambiguity, missing requirements, edge cases, risks, and test gaps.
- Write output to:
  - `.aido-workflow/findings.md`
  - `.aido-workflow/decisions.md`
  - `.aido-workflow/specs/<module>-grill-notes.md`
- Must auto-call `/aido-plan-with-file`.

### 4) `aido-enhance` (standalone)

- Use Prompt Enhancer pattern.
- No active module required.
- If active module exists, append relevant output to `.aido-workflow/findings.md`.
- If no active module, return enhanced prompt directly.
- Must not mutate `.aido-workflow/task_plan.md` unless explicitly requested.
- May call `/aido-plan-with-file` only if scope/module/planning changed.

### 5) `aido-plan-with-file`

- Use planning-with-files pattern.
- Create/update:
  - `.aido-workflow/active_module.md`
  - `.aido-workflow/specs/<module>-spec.md`
  - `.aido-workflow/task_plan.md`
- Can be called manually or automatically.
- Enforce active-module-only plan scope.

### 6) `aido-breakdown`

- Break active module into small phases.
- Every phase must include:
  - goal
  - likely files
  - tests
  - done criteria
  - status
- Valid statuses:
  - `PENDING`
  - `IN_PROGRESS`
  - `DONE`
  - `BLOCKED`
- Update:
  - `.aido-workflow/task_plan.md`
  - `.aido-workflow/progress.md`
  - `.aido-workflow/decisions.md` (if new decisions)
- Must auto-call `/aido-plan-with-file`.

### 7) `aido-execute-next`

- Execute only next `PENDING` phase.
- Enforce TDD flow:
  1. Read `task_plan.md`
  2. Select next `PENDING`
  3. Set phase `IN_PROGRESS`
  4. Write/update tests first
  5. Run tests and confirm fail
  6. Implement minimum code
  7. Run tests until pass
  8. Set phase `DONE` or `BLOCKED`
- Update:
  - `.aido-workflow/progress.md`
  - `.aido-workflow/test_report.md`
  - `.aido-workflow/decisions.md`
  - `.aido-workflow/task_plan.md`
- If significant code changes occurred, recommend/run `aido-caveman-review`.

### 8) `aido-caveman-review`

- Use Caveman Review style.
- Available as integrated or manual command.
- Use after significant implementation, before `aido-document`, or on demand.
- Append output to:
  - `.aido-workflow/progress.md`
  - `.aido-workflow/test_report.md`
  - `.aido-workflow/decisions.md`
- If blocking issues exist, stop workflow before `aido-document`.

### 9) `aido-document`

- Use code-documenter pattern.
- Generate:
  - `.aido-workflow/modules/<module>.md`
  - `.aido-workflow/reports/<module>-doc-coverage.md`
- Required before archive.

### 10) `aido-debug` (diagnosis only)

- Use Diagnose pattern from `mattpocock/skills`.
- Trigger when user reports errors or behavior that does not run as expected.
- Perform reproduce -> isolate -> hypothesize -> verify loop.
- Never auto-fix code.
- Never mutate:
  - `.aido-workflow/task_plan.md`
  - phase status in `.aido-workflow/task_plan.md`
- Write debug report to:
  - `.aido-workflow/reports/<module>-debug-report.md` (if active module exists)
  - `.aido-workflow/reports/debug-<YYYY-MM-DD>-<HHMM>.md` (if no active module)
- May recommend next: `aido-debug-fix`.

### 11) `aido-debug-fix` (autofix, active phase only)

- Use Diagnose pattern from `mattpocock/skills` with fix pass enabled.
- Scope is restricted to active phase only.
- Only modify files that belong to current active phase scope (likely files in plan).
- If required fix exceeds active phase scope, stop and mark phase `BLOCKED` with reason.
- After fix, run relevant tests and record result.
- Write/update:
  - `.aido-workflow/progress.md`
  - `.aido-workflow/test_report.md`
  - `.aido-workflow/reports/<module>-debug-fix-report.md` (or timestamp fallback when no active module)
- If unresolved, keep phase `BLOCKED` and provide next steps.

### 12) `aido-archive`

- Archive current module state:
  - `task_plan.md` -> `archive/task_plans/<YYYY-MM-DD>-<module>-task-plan.md`
  - `progress.md` -> `archive/progress/<YYYY-MM-DD>-<module>-progress.md`
  - `decisions.md` -> `archive/decisions/<YYYY-MM-DD>-<module>-decisions.md`
- Preconditions:
  - `.aido-workflow/modules/<module>.md` exists
  - `.aido-workflow/reports/<module>-doc-coverage.md` exists

### 13) `aido-clean`

- Only after documentation and archive are complete.
- Clean only:
  - `.aido-workflow/task_plan.md`
  - `.aido-workflow/progress.md`
  - `.aido-workflow/test_report.md`
  - `.aido-workflow/active_module.md`
- Never clean:
  - `.aido-workflow/findings.md`
  - `.aido-workflow/modules/`
  - `.aido-workflow/archive/`
  - `.aido-workflow/reports/`
  - `.aido-workflow/specs/`
- If not allowed, return clear reason.

### 14) `aido-status`

- Read `.aido-workflow/` and report:
  - active module
  - current phase
  - completed phases
  - next phase
  - blockers
  - test status
  - review status
  - documentation status
  - archive status
  - cleanup readiness

### 15) `aido-resume`

- Read current state and output:
  - active module
  - known state
  - next recommended command
  - recommendation reason
  - next files to read/update

### 16) `aido-compact` (standalone)

- Use Compact pattern.
- No active module required.
- If active module exists, may store relevant summary in `.aido-workflow/progress.md` or `.aido-workflow/findings.md`.
- Must not mutate `.aido-workflow/task_plan.md` unless explicitly requested.
- May call `/aido-plan-with-file` only if scope/module/planning changed.

### 17) `aido-caveman` (standalone)

- Use Caveman style simplification.
- No active module required.
- If active module exists, may append relevant output to `.aido-workflow/findings.md`.
- Must not mutate `.aido-workflow/task_plan.md` unless explicitly requested.
- May call `/aido-plan-with-file` only if scope/module/planning changed.

## Auto Planning Policy

Must auto-call `/aido-plan-with-file` after completion:

- `aido-brainstorm`
- `aido-grill`
- `aido-breakdown`

Optional auto-call if planning scope changed:

- `aido-enhance`
- `aido-compact`
- `aido-caveman`
- `aido-caveman-review`

No auto-call unless explicitly requested:

- `aido-status`
- `aido-resume`
- `aido-document`
- `aido-archive`
- `aido-clean`

## Workflow Order

`aido-init` -> `aido-enhance` (optional) -> `aido-brainstorm` -> `aido-grill` -> `aido-plan-with-file` -> `aido-breakdown` -> `aido-execute-next` -> `aido-caveman-review` (optional/recommended) -> `aido-debug` or `aido-debug-fix` (when needed) -> `aido-document` -> `aido-archive` -> `aido-clean`

## Standalone Command Policy

Standalone commands:

- `/aido-enhance`
- `/aido-compact`
- `/aido-caveman`

These never require active module and must not disrupt main workflow state.

## Code Review Policy

- After significant code changes from `aido-execute-next`, run/recommend `aido-caveman-review`.
- Save review outcomes in progress, test report, and decisions.
- Do not continue to documentation on blocking findings.
- On blocking findings or runtime/test anomalies, run `aido-debug` first.
- Use `aido-debug-fix` only when user requests direct autofix and keep fixes inside active phase scope.

## Documentation Before Archive

Archive is blocked until both files exist:

- `.aido-workflow/modules/<module>.md`
- `.aido-workflow/reports/<module>-doc-coverage.md`

## OpenCode Integration

- Detect commands with or without slash.
- Route every `aido-*` command to this skill.
- Keep operational state in `.aido-workflow/` exclusively.
