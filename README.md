# aido-workflow

Unified workflow skill for Zed + OpenCode using `aido-*` commands.

This repository provides one orchestrator skill named `aido-workflow` that routes all AIDO commands, keeps workflow state in `.aido-workflow/`, and integrates planning, grilling, execution, review, and documentation.

## Why `aido-*` Prefix

- Clear command namespace for AI development workflow
- Easy command detection in OpenCode
- Consistent routing to one skill: `aido-workflow`

Both formats are supported and treated equally:

- `aido-init` and `/aido-init`
- `aido-brainstorm` and `/aido-brainstorm`
- ...for all AIDO commands

## Supported Commands

- `aido-init`
- `aido-brainstorm`
- `aido-grill`
- `aido-enhance`
- `aido-plan-with-file`
- `aido-breakdown`
- `aido-execute-next`
- `aido-caveman-review`
- `aido-document`
- `aido-archive`
- `aido-clean`
- `aido-status`
- `aido-resume`
- `aido-compact`
- `aido-caveman`

## Supporting Skills and References

1. planning-with-files: https://github.com/othmanadi/planning-with-files
2. code-documenter: https://github.com/Jeffallan/claude-skills/blob/main/skills/code-documenter/SKILL.md
3. GStack reference: https://github.com/garrytan/gstack
4. Superpowers reference: https://github.com/obra/superpowers
5. GSD reference: https://github.com/gsd-build/get-shit-done
6. Grill With Docs: https://skills.sh/mattpocock/skills/grill-with-docs
7. Prompt Enhancer: https://skills.sh/samhvw8/dot-claude/prompt-enhancer
8. Compact: https://skills.sh/catlog22/claude-code-workflow/compact
9. Caveman: https://skills.sh/juliusbrussee/caveman/caveman
10. Caveman Review: https://skills.sh/juliusbrussee/caveman/caveman-review

## Install

Wrapper only:

```bash
npx skills add https://github.com/mdhb2/aido-workflow -a opencode -y
```

Full setup:

```bash
curl -fsSL https://raw.githubusercontent.com/mdhb2/aido-workflow/master/scripts/install-aido.sh | bash
```

The installer fails fast if any supporting skill cannot be installed.
It also runs `npx skills list -a opencode` at the end for verification.

Note: the installer protects against stdin consumption from nested CLI tools so it works reliably with `curl ... | bash`.

## Verify in OpenCode

1. Ensure skill appears as `aido-workflow`.
2. Run one command with and without slash:
   - `aido-status`
   - `/aido-status`
3. Confirm both route to same workflow behavior.

More details: `skills/aido-workflow/references/opencode.md` and `skills/aido-workflow/references/detection.md`.

## Ideal Workflow

`aido-init` -> `aido-enhance` (optional) -> `aido-brainstorm` -> `aido-grill` -> `aido-plan-with-file` -> `aido-breakdown` -> `aido-execute-next` -> `aido-caveman-review` (optional/recommended) -> `aido-document` -> `aido-archive` -> `aido-clean`

## Storage Policy

All workflow state must live in `.aido-workflow/`.

- Never create or use `.aido/` for new state.
- If legacy `.aido/` exists, migrate contents to `.aido-workflow/`.
- Do not delete legacy `.aido/` unless explicitly requested.

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

`task_plan.md` must only contain the active module.

## Auto Planning Policy

These commands must auto-call `/aido-plan-with-file`:

- `aido-brainstorm`
- `aido-grill`
- `aido-breakdown`

These may call `/aido-plan-with-file` when scope/module/planning changes:

- `aido-enhance`
- `aido-compact`
- `aido-caveman`
- `aido-caveman-review`

These do not auto-call unless explicitly requested:

- `aido-status`
- `aido-resume`
- `aido-document`
- `aido-archive`
- `aido-clean`

## Standalone Command Policy

Standalone commands:

- `/aido-enhance`
- `/aido-compact`
- `/aido-caveman`

Rules:

- No active module required.
- If active module exists, save relevant output to `.aido-workflow/findings.md` or `.aido-workflow/progress.md`.
- If no active module exists, return result directly and suggest `aido-init`.
- Do not mutate `.aido-workflow/task_plan.md` unless explicitly asked.

## Review Policy

- After `aido-execute-next`, if code changed significantly, run or recommend `aido-caveman-review`.
- Save review findings to:
  - `.aido-workflow/progress.md`
  - `.aido-workflow/test_report.md`
  - `.aido-workflow/decisions.md`
- If blocking issue exists, stop before `aido-document`.

## Cleanup Policy

`aido-clean` allowed only when documentation and archive are complete.

Can clean:

- `.aido-workflow/task_plan.md`
- `.aido-workflow/progress.md`
- `.aido-workflow/test_report.md`
- `.aido-workflow/active_module.md`

Must not clean:

- `.aido-workflow/findings.md`
- `.aido-workflow/modules/`
- `.aido-workflow/archive/`
- `.aido-workflow/reports/`
- `.aido-workflow/specs/`

## More Documentation

- `skills/aido-workflow/SKILL.md`
- `skills/aido-workflow/references/commands.md`
- `skills/aido-workflow/references/workflow.md`
- `skills/aido-workflow/references/documentation.md`
- `skills/aido-workflow/references/examples.md`
- `skills/aido-workflow/references/detection.md`
- `skills/aido-workflow/references/opencode.md`
