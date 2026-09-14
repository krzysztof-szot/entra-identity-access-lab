# Day 1 - users, groups and administration

This page contains the setup and checks for Day 1.
Actual lab observations have not yet been added to this version.

## Setup

- Six employee accounts, one delegated administrator and two emergency accounts.
- Seven security groups with memberships from the [access matrix](access-matrix.md).
- Department, Usage location and Manager attributes.
- A check of the available Entra licensing and current authentication settings.

The initial focus is user and group administration. Application access
will be configured in the next phase.

## Checks

A dash means that the result has not been recorded here.

| Check | Result |
|---|---|
| adm-lab can change an employee's Job title and restore it. | - |
| adm-lab can remove and re-add Thomas in SG-CA-Pilot; final membership is Anna and Thomas. | - |
| adm-lab cannot assign tenant-wide administrative roles; expected denial counts as Pass. | - |
| anna.finance can sign in to My Account in a fresh session. | - |
| bg01 and bg02 can each complete a fresh administrative sign-in. | - |
| An authorized account can find the tested changes in Audit logs. | - |

## Notes from the lab

Add the actual license, authentication methods, problems and fixes here.
Record any shared recovery dependency, such as both emergency accounts
using the same phone. Successful sign-in alone does not prove independent recovery.

Link supporting [screenshots or log excerpts](../evidence/day-01/).
Keep temporary test changes restored to their original values.

## Next

Resolve unfinished Day 1 checks, then start Expense Portal integration.
