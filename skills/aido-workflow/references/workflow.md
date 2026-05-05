# AIDO Main Workflow

Ideal order:

`aido-init` -> `aido-enhance` (optional) -> `aido-brainstorm` -> `aido-grill` -> `aido-plan-with-file` -> `aido-breakdown` -> `aido-execute-next` -> `aido-caveman-review` (optional/recommended) -> `aido-debug` or `aido-debug-fix` (when needed) -> `aido-document` -> `aido-archive` -> `aido-clean`

## Stage Rules

1. `aido-init`
   - Ensure `.aido-workflow/` exists and legacy migration policy is applied.

2. `aido-enhance` (optional)
   - Standalone prompt optimization.

3. `aido-brainstorm`
   - Multi-role ideation and decision capture.
   - Must auto-call `/aido-plan-with-file`.

4. `aido-grill`
   - Pressure-test assumptions, requirements, and edge cases.
   - Must auto-call `/aido-plan-with-file`.

5. `aido-plan-with-file`
   - Establish active module, spec, and active-only plan.

6. `aido-breakdown`
   - Create executable phases.
   - Must auto-call `/aido-plan-with-file`.

7. `aido-execute-next`
    - Run strict TDD for next `PENDING` phase.
    - Invoke `/tdd` and execute vertical red-green-refactor slices.
    - If failing unexpectedly or repeatedly, run `aido-debug` before continuing.

8. `aido-caveman-review` (recommended)
    - Mandatory when changes are significant.
    - If blocking findings exist, stop workflow.

9. `aido-debug` or `aido-debug-fix` (conditional recovery)
   - `aido-debug`: diagnosis only, no code mutation.
   - `aido-debug-fix`: autofix allowed only inside active phase file scope.
   - If fix needs files outside active phase scope, mark `BLOCKED` and stop.

10. `aido-document`
    - Produce module docs and doc coverage report.

11. `aido-archive`
     - Archive plan/progress/decisions only after docs exist.

12. `aido-clean`
     - Allowed only after archive+docs are complete.

## When Standalone Commands Are Used

- `aido-enhance`: optimize prompt before any workflow step.
- `aido-compact`: shrink long context/state into actionable summary.
- `aido-caveman`: simplify ambiguous requirements into direct language.

Standalone commands should not modify `task_plan.md` unless explicitly requested.

## Workflow Stop Conditions

Stop and resolve before moving forward if:

- `aido-caveman-review` reports blocking issues.
- `aido-debug-fix` requires changes outside active phase scope.
- Documentation files are missing before archive.
- Archive files are missing before clean.
- Active module is undefined for non-standalone commands.

## Review Blocking Rules

`aido-document` is blocked when review has unresolved critical issues.

Resolve issues and rerun review before continuing.

## Cleanup Readiness

`aido-clean` is allowed only when all are true:

- `.aido-workflow/modules/<module>.md` exists
- `.aido-workflow/reports/<module>-doc-coverage.md` exists
- archive snapshots for task plan, progress, and decisions exist
