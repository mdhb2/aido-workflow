# AIDO Commands Reference

All commands accept both forms: with slash (`/aido-*`) and without slash (`aido-*`).

## /aido-init

- Purpose: Initialize `.aido-workflow/` and migrate legacy `.aido/` data.
- Input: Optional module context.
- Output files: core state files and directories under `.aido-workflow/`.
- Dependency: Internal workflow bootstrap.
- Mode: Workflow-integrated.
- Next command: `/aido-brainstorm`.
- Triggers `/aido-plan-with-file`: No.

## /aido-brainstorm

- Purpose: Role-based brainstorming for module direction and risks.
- Input: Problem or module statement.
- Output files: `.aido-workflow/findings.md`, `.aido-workflow/decisions.md`.
- Dependency: GStack-style brainstorming pattern.
- Mode: Workflow-integrated.
- Next command: `/aido-grill`.
- Triggers `/aido-plan-with-file`: Yes (required).

## /aido-grill

- Purpose: Stress-test requirements and remove ambiguity.
- Input: Brainstormed module context.
- Output files: `findings.md`, `decisions.md`, `specs/<module>-grill-notes.md`.
- Dependency: Grill With Docs.
- Mode: Workflow-integrated.
- Next command: `/aido-plan-with-file`.
- Triggers `/aido-plan-with-file`: Yes (required).

## /aido-enhance

- Purpose: Improve prompt clarity and precision.
- Input: Raw prompt or instruction.
- Output files: Optional append to `.aido-workflow/findings.md` if active module exists.
- Dependency: Prompt Enhancer.
- Mode: Standalone.
- Next command: `/aido-init` (if no active module) or `/aido-brainstorm`.
- Triggers `/aido-plan-with-file`: Conditional.

## /aido-plan-with-file

- Purpose: Create/update active module plan files.
- Input: Current module scope.
- Output files: `active_module.md`, `task_plan.md`, `specs/<module>-spec.md`.
- Dependency: planning-with-files.
- Mode: Workflow-integrated and callable standalone.
- Next command: `/aido-breakdown`.
- Triggers `/aido-plan-with-file`: N/A (this is the planner).

## /aido-breakdown

- Purpose: Break active module into executable phases.
- Input: Active module and current spec.
- Output files: `task_plan.md`, `progress.md`, optional `decisions.md` updates.
- Dependency: GSD-style breakdown.
- Mode: Workflow-integrated.
- Next command: `/aido-execute-next`.
- Triggers `/aido-plan-with-file`: Yes (required).

## /aido-execute-next

- Purpose: Execute next `PENDING` phase using TDD.
- Input: `.aido-workflow/task_plan.md`.
- Output files: `task_plan.md`, `progress.md`, `test_report.md`, `decisions.md`.
- Dependency: Superpowers-style TDD execution via `/tdd`.
- Mode: Workflow-integrated.
- Next command: `/aido-caveman-review` (recommended after significant code change).
- Triggers `/aido-plan-with-file`: No.

## /aido-caveman-review

- Purpose: Direct, sharp review to catch complexity and logic issues.
- Input: Current code/test changes.
- Output files: append to `progress.md`, `test_report.md`, `decisions.md`.
- Dependency: Caveman Review.
- Mode: Workflow-integrated or standalone.
- Next command: `/aido-document` if non-blocking; otherwise fix and rerun.
- Triggers `/aido-plan-with-file`: Conditional.

## /aido-debug

- Purpose: Diagnose errors or unexpected workflow behavior without changing code.
- Input: Error output, failing step, or anomaly context.
- Output files: `.aido-workflow/reports/<module>-debug-report.md` or timestamp fallback file in `reports/`.
- Dependency: Diagnose pattern from `mattpocock/skills`.
- Mode: Workflow utility (read-only diagnosis).
- Next command: `/aido-debug-fix` or return to previous workflow step with targeted actions.
- Triggers `/aido-plan-with-file`: No.

## /aido-debug-fix

- Purpose: Apply targeted autofix for diagnosed issues.
- Input: Active phase context + debug findings.
- Output files: append to `progress.md`, append to `test_report.md`, write `reports/<module>-debug-fix-report.md`.
- Dependency: Diagnose pattern from `mattpocock/skills` with fix pass.
- Mode: Workflow-integrated recovery command.
- Scope rule: may only modify files in active phase scope; otherwise mark `BLOCKED`.
- Next command: `/aido-caveman-review` (recommended) or return to `/aido-execute-next`.
- Triggers `/aido-plan-with-file`: No.

## /aido-document

- Purpose: Produce module docs and coverage report.
- Input: Implemented module state.
- Output files: `modules/<module>.md`, `reports/<module>-doc-coverage.md`.
- Dependency: code-documenter pattern.
- Mode: Workflow-integrated.
- Next command: `/aido-archive`.
- Triggers `/aido-plan-with-file`: No.

## /aido-archive

- Purpose: Archive plan/progress/decisions snapshots.
- Input: Active module and current date.
- Output files: archive snapshots under `.aido-workflow/archive/...`.
- Dependency: Internal archive policy.
- Mode: Workflow-integrated.
- Next command: `/aido-clean`.
- Triggers `/aido-plan-with-file`: No.

## /aido-clean

- Purpose: Clean active transient files after doc+archive complete.
- Input: Archive and documentation status.
- Output files: resets selected active files.
- Dependency: Internal cleanup policy.
- Mode: Workflow-integrated.
- Next command: `/aido-status` or new `/aido-init` for next module.
- Triggers `/aido-plan-with-file`: No.

## /aido-status

- Purpose: Show current workflow status summary.
- Input: Current `.aido-workflow/` state.
- Output files: None (read/report only).
- Dependency: Internal status reporter.
- Mode: Workflow utility.
- Next command: `/aido-resume` or recommended workflow step.
- Triggers `/aido-plan-with-file`: No.

## /aido-resume

- Purpose: Resume from latest known workflow state.
- Input: Current state files.
- Output files: None required; optional notes in progress.
- Dependency: Internal resume logic.
- Mode: Workflow utility.
- Next command: Depends on state.
- Triggers `/aido-plan-with-file`: No.

## /aido-compact

- Purpose: Compress long context into actionable summary.
- Input: Long notes/discussion/state.
- Output files: Optional append to `progress.md` or `findings.md`.
- Dependency: Compact.
- Mode: Standalone.
- Next command: Workflow command based on output.
- Triggers `/aido-plan-with-file`: Conditional.

## /aido-caveman

- Purpose: Rewrite requirement/instructions in direct low-ambiguity style.
- Input: Requirement text.
- Output files: Optional append to `findings.md`.
- Dependency: Caveman.
- Mode: Standalone.
- Next command: `/aido-brainstorm` or `/aido-plan-with-file`.
- Triggers `/aido-plan-with-file`: Conditional.
