# Documentation Policy

`aido-document` must run before `aido-archive`.

## Module Documentation Format

Write module docs to `.aido-workflow/modules/<module>.md` with these required sections:

1. Purpose
2. User Flow
3. Related Files
4. Components
5. API Endpoints
6. Services/Helpers
7. Database/Schema
8. Validation
9. Auth/Session Behavior
10. Error Handling
11. Security Notes
12. Tests
13. Extension Notes
14. Known Limitations

## Doc Coverage Report Format

Write coverage report to `.aido-workflow/reports/<module>-doc-coverage.md`.

Recommended fields:

- Module name
- Last update date
- Section coverage checklist
- Missing coverage items
- Risks from missing docs
- Follow-up actions

## Example Module Doc Skeleton

```md
# Module: login

## Purpose
...

## User Flow
...

## Related Files
...

## Components
...

## API Endpoints
...

## Services/Helpers
...

## Database/Schema
...

## Validation
...

## Auth/Session Behavior
...

## Error Handling
...

## Security Notes
...

## Tests
...

## Extension Notes
...

## Known Limitations
...
```

## Example Coverage Report Skeleton

```md
# Documentation Coverage: login

- Date: YYYY-MM-DD
- Module doc: .aido-workflow/modules/login.md

## Coverage Checklist
- Purpose: DONE
- User Flow: DONE
- Related Files: DONE
- Components: DONE
- API Endpoints: DONE
- Services/Helpers: DONE
- Database/Schema: DONE
- Validation: DONE
- Auth/Session Behavior: DONE
- Error Handling: DONE
- Security Notes: DONE
- Tests: DONE
- Extension Notes: DONE
- Known Limitations: DONE

## Missing Items
- None

## Follow-ups
- None
```

## Pre-Archive Requirement

Archive is blocked unless both files exist:

- `.aido-workflow/modules/<module>.md`
- `.aido-workflow/reports/<module>-doc-coverage.md`
