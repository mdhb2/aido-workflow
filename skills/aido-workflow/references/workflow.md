# AIDO Main Workflow

Ideal order:

`aido-init` -> `aido-enhance` (optional) -> `aido-brainstorm` -> `aido-grill` -> `aido-plan-with-file` -> `aido-breakdown` -> `aido-execute-next` -> `aido-caveman-review` (optional/recommended) -> `aido-document` -> `aido-archive` -> `aido-clean`

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

8. `aido-caveman-review` (recommended)
   - Mandatory when changes are significant.
   - If blocking findings exist, stop workflow.

9. `aido-document`
   - Produce module docs and doc coverage report.

10. `aido-archive`
    - Archive plan/progress/decisions only after docs exist.

11. `aido-clean`
    - Allowed only after archive+docs are complete.

## When Standalone Commands Are Used

- `aido-enhance`: optimize prompt before any workflow step.
- `aido-compact`: shrink long context/state into actionable summary.
- `aido-caveman`: simplify ambiguous requirements into direct language.

Standalone commands should not modify `task_plan.md` unless explicitly requested.

## Workflow Stop Conditions

Stop and resolve before moving forward if:

- `aido-caveman-review` reports blocking issues.
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
