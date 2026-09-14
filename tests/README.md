# Test documentation

Test procedures and execution records for the **Microsoft Entra ID — Secure Employee & Contractor Access** project.

Tests validate the configured behavior against the intended access model. Expected outcomes, observed results, and supporting evidence are recorded separately.

## Test records

- [Day 1: identity baseline](day-01.md) — user and group administration, administrator role-assignment boundaries, employee and emergency account sign-ins, and audit log verification.

Additional test records will be added as later project phases are implemented. Tests that have not been executed remain **Not run**.

## What to record

Each test record should include:

1. **Test ID and objective** — the behavior being checked.
2. **Preconditions** — required configuration and starting state.
3. **Acting identity and permissions** — the account alias and relevant role.
4. **Steps and execution date** — enough detail to repeat the test.
5. **Expected result** — the intended behavior.
6. **Actual result and status** — what was observed.
7. **Evidence and restoration** — supporting records and any changes restored after testing.

## Result statuses

| Status | Meaning |
|---|---|
| Not run | The test has not been executed. |
| Pass | The observed behavior matches the expected result. |
| Fail | The observed behavior differs from the expected result. |
| Blocked | A missing prerequisite or unresolved issue prevents completion. |

An expected access denial can be a **Pass**. For example, a test of the User Administrator role boundary passes when the acting account is prevented from assigning Microsoft Entra administrator roles.

## Evidence

Store screenshots and supporting records in the appropriate evidence folder and reference them from the test record.

- [Day 1 evidence](../evidence/day-01/README.md)
- [Identity and access matrix](../docs/access-matrix.md)

Each evidence item should identify the relevant test and explain what it demonstrates. Keep credentials, tokens, MFA enrollment material, recovery codes, and private information out of published records.

## After testing

Restore temporary changes to user attributes and group membership, and record the final state. Document limitations and unresolved issues, including any shared dependencies of emergency access accounts. A successful sign-in test alone does not establish independent emergency recovery.

