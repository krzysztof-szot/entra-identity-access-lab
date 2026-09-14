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
| adm-lab can change an employee's Job title and restore it. | The updated Job title is saved and visible after refreshing the profile. The original value is then restored and verified. |
| adm-lab can remove and re-add Thomas in SG-CA-Pilot; final membership is Anna and Thomas. | Membership changes from Anna and Thomas (2 members) to Anna (1 member), then returns to Anna and Thomas (2 members). |
| adm-lab cannot assign tenant-wide administrative roles; expected denial counts as Pass. | The role-assignment action is unavailable or returns an authorization denial. No administrative role assignment is created. This expected restriction counts as Pass. |
| anna.finance can sign in to My Account in a fresh session. | My Account opens successfully after the required authentication steps, including any prompted password change or MFA registration. |
| bg01 and bg02 can each complete a fresh administrative sign-in. | Each account successfully signs in to the Entra admin center in a separate fresh session and completes the required authentication. |
| An authorized account can find the tested changes in Audit logs. | Relevant user-update and group-membership events are found. The initiator, target, activity time and result match the actions performed during the tests. |

## Notes from the lab

Add the actual license, authentication methods, problems and fixes here.
Record any shared recovery dependency, such as both emergency accounts
using the same phone. Successful sign-in alone does not prove independent recovery.

Link supporting [screenshots or log excerpts](../evidence/day-01/).
Keep temporary test changes restored to their original values.

## Next

Resolve unfinished Day 1 checks, then start Expense Portal integration.
