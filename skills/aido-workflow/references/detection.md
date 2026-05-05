# OpenCode Detection Rules

## Supported Command Forms

All commands must be recognized in both forms:

- Without slash: `aido-*`
- With slash: `/aido-*`

Examples:

- `aido-init` == `/aido-init`
- `aido-plan-with-file` == `/aido-plan-with-file`

## Full Command Set

- `aido-init`
- `aido-brainstorm`
- `aido-grill`
- `aido-enhance`
- `aido-plan-with-file`
- `aido-breakdown`
- `aido-execute-next`
- `aido-caveman-review`
- `aido-debug`
- `aido-debug-fix`
- `aido-document`
- `aido-archive`
- `aido-clean`
- `aido-status`
- `aido-resume`
- `aido-compact`
- `aido-caveman`

## Trigger Phrases

Skill should trigger when user types:

- exact command token (with/without slash)
- command followed by colon and instruction
- command followed by natural-language arguments

Examples:

- `aido-brainstorm: create login module...`
- `/aido-grill login module requirements`
- `aido-status`

## Routing Policy

Every `aido-*` command must route to one skill: `aido-workflow`.

No command should route to `.aido/` storage behavior.

## Alias Guidance

If aliases are added, they must resolve to official command names above and preserve same behavior.

## Troubleshooting

If command is not detected:

1. Verify skill installed with:
   - `npx skills add https://github.com/mdhb2/aido-workflow -a opencode -y`
2. Confirm `skills/aido-workflow/SKILL.md` exists in installed skill.
3. Retry both forms:
   - `aido-status`
   - `/aido-status`
4. Ensure no conflicting local skill with same command names.
5. Reinstall and restart OpenCode session.
