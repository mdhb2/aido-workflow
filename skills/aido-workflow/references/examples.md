# Example: Login Module End-to-End

## Input

`aido-brainstorm: create login module with email/password, input validation, invalid credential error, session handling, redirect after success, and tests.`

Then:

`aido-grill: grill the login module requirements and find missing edge cases, security concerns, auth/session ambiguity, validation gaps, and testing gaps.`

Then run:

1. `aido-plan-with-file`
2. `aido-breakdown`
3. `aido-execute-next`
4. `aido-caveman-review`
5. `aido-document`
6. `aido-archive`
7. `aido-clean`

## File Updates by Step

### `aido-brainstorm`

- Create/update `.aido-workflow/findings.md`
- Create/update `.aido-workflow/decisions.md`
- Auto-call `/aido-plan-with-file`

### `aido-grill`

- Update `.aido-workflow/findings.md`
- Update `.aido-workflow/decisions.md`
- Create `.aido-workflow/specs/login-grill-notes.md`
- Auto-call `/aido-plan-with-file`

### `aido-plan-with-file`

- Update `.aido-workflow/active_module.md`
- Create/update `.aido-workflow/specs/login-spec.md`
- Update `.aido-workflow/task_plan.md`

### `aido-breakdown`

- Update `.aido-workflow/task_plan.md`
- Update `.aido-workflow/progress.md`
- Update `.aido-workflow/decisions.md` if needed
- Auto-call `/aido-plan-with-file`

### `aido-execute-next`

- Update `.aido-workflow/task_plan.md`
- Update `.aido-workflow/progress.md`
- Update `.aido-workflow/test_report.md`
- Update `.aido-workflow/decisions.md`

### `aido-caveman-review`

- Append findings to `.aido-workflow/progress.md`
- Append findings to `.aido-workflow/test_report.md`
- Append key decisions to `.aido-workflow/decisions.md`

### `aido-document`

- Create `.aido-workflow/modules/login.md`
- Create `.aido-workflow/reports/login-doc-coverage.md`

### `aido-archive`

- Create `.aido-workflow/archive/task_plans/<date>-login-task-plan.md`
- Create `.aido-workflow/archive/progress/<date>-login-progress.md`
- Create `.aido-workflow/archive/decisions/<date>-login-decisions.md`

### `aido-clean`

- Clear `.aido-workflow/task_plan.md`
- Clear `.aido-workflow/progress.md`
- Clear `.aido-workflow/test_report.md`
- Clear `.aido-workflow/active_module.md`

## Files Expected in This Example

- `.aido-workflow/active_module.md`
- `.aido-workflow/findings.md`
- `.aido-workflow/decisions.md`
- `.aido-workflow/specs/login-spec.md`
- `.aido-workflow/specs/login-grill-notes.md`
- `.aido-workflow/task_plan.md`
- `.aido-workflow/progress.md`
- `.aido-workflow/test_report.md`
- `.aido-workflow/modules/login.md`
- `.aido-workflow/reports/login-doc-coverage.md`
- `.aido-workflow/archive/task_plans/<date>-login-task-plan.md`
- `.aido-workflow/archive/progress/<date>-login-progress.md`
- `.aido-workflow/archive/decisions/<date>-login-decisions.md`
