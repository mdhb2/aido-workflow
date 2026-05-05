# OpenCode Integration Guide

## Install to OpenCode

Wrapper only:

```bash
npx skills add https://github.com/mdhb2/aido-workflow -a opencode -y
```

Full setup:

```bash
curl -fsSL https://raw.githubusercontent.com/mdhb2/aido-workflow/master/scripts/install-aido.sh | bash
```

Alternative:

```bash
curl -fsSL https://raw.githubusercontent.com/mdhb2/aido-workflow/master/scripts/install-aido.sh -o /tmp/install-aido.sh
bash /tmp/install-aido.sh
```

## Check Skill Is Active

1. Confirm skill name is `aido-workflow`.
2. Run:
   - `aido-status`
   - `/aido-status`
3. Confirm both forms are handled consistently.

## Run Commands

Use any of these forms:

- `aido-init`
- `/aido-init`
- `aido-brainstorm: <prompt>`
- `/aido-grill <context>`

## Verify Command Detection

Smoke test commands:

1. `aido-init`
2. `aido-status`
3. `/aido-status`
4. `aido-resume`

Expected:

- Commands recognized by OpenCode
- Routed to `aido-workflow`
- State stored under `.aido-workflow/`

## Troubleshooting: Command Not Detected

- Reinstall wrapper skill:
  - `npx skills add https://github.com/mdhb2/aido-workflow -a opencode -y`
- Ensure command matches official list.
- Retry with slash and without slash.
- Restart OpenCode session.

## Troubleshooting: Dependency Skill Missing

Install dependencies:

```bash
npx skills add https://github.com/othmanadi/planning-with-files -a opencode -y
npx skills add https://github.com/Jeffallan/claude-skills/blob/main/skills/code-documenter/SKILL.md -a opencode -y
npx skills add https://raw.githubusercontent.com/Jeffallan/claude-skills/main/skills/code-documenter/SKILL.md -a opencode -y
npx skills add https://github.com/mattpocock/skills -a opencode -y
npx skills add https://github.com/samhvw8/dot-claude -a opencode -y
npx skills add https://github.com/catlog22/claude-code-workflow -a opencode -y
npx skills add https://github.com/juliusbrussee/caveman -a opencode -y
```

Then verify:

```bash
npx skills list -a opencode
```
