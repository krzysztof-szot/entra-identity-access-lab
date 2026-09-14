# Day 1 validation

**Execution status:** Not run.  
**Execution date:** Not recorded.

Use Pass, Fail, Blocked, or Not run for each outcome. An expected denial is a passing result when it demonstrates the intended permission boundary.

## Results

| ID | Acting identity | Expected behavior | Actual result | Outcome | Evidence |
|---|---|---|---|---|---|
| D1-01 | adm-lab | Can update the ordinary user's Job title | Not recorded | Not run | Not attached |
| D1-02 | adm-lab | Can manage SG-CA-Pilot membership | Not recorded | Not run | Not attached |
| D1-03 | adm-lab | Cannot assign Microsoft Entra administrator roles | Not recorded | Not run | Not attached |
| D1-04 | anna.finance | Can sign in to My Account | Not recorded | Not run | Not attached |
| D1-05 | bg01 and bg02 | Both can complete a new administrative sign-in | Not recorded | Not run | Not attached |
| D1-06 | Account permitted to read activity logs | Can identify the tested changes in audit logs | Not recorded | Not run | Not attached |

## D1-01: User administration

1. Sign in as adm-lab in a separate browser profile.
2. Open tomasz.it and record the current Job title.
3. Change it to a temporary lab value and save.
4. Confirm the saved value.
5. Restore the original value, including an empty value if applicable.
6. Record the result and the restoration.

## D1-02: Group administration

1. Confirm that SG-CA-Pilot contains Anna and Tomasz.
2. As adm-lab, remove Tomasz and verify membership.
3. Add Tomasz again.
4. Confirm the final count is two and that both original members are present.
5. Record the observed changes.

## D1-03: Role-assignment boundary

1. Confirm that adm-lab has User Administrator and no additional privilege that grants role assignment.
2. In Roles and administrators, inspect whether adm-lab can add an administrator role assignment.
3. Record the unavailable action or authorization denial.
4. If the action is unexpectedly available, investigate additional assignments or the signed-in identity before changing any role.

Assigning Entra roles requires an appropriate role such as Privileged Role Administrator. [Role assignment guidance](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/manage-roles-portal).

## D1-04: Employee sign-in

1. Use a fresh session for anna.finance.
2. Sign in to My Account.
3. Complete any required initial password change or method registration.
4. Record the observed authentication behavior and result.

This checks account access. Expense Portal access is a later test.

## D1-05: Backup administrative sign-in

1. Perform a new sign-in separately for bg01 and bg02.
2. Verify access to the Entra admin center.
3. Record the authentication method type and result for each account.
4. Record shared dependencies separately, including use of a single phone.

A passing sign-in test establishes that the tested sign-in works. Independent emergency recovery remains a separate design and validation requirement.

## D1-06: Audit evidence

1. Sign in with an account permitted to read directory activity logs.
2. Open Entra ID > Monitoring & health > Audit logs.
3. Find the relevant user or group changes from the tests.
4. Record the operation, time, initiator, target, and status.
5. Link sanitized evidence.

If the event cannot yet be located, record what was checked and leave the outcome pending investigation. Do not infer success from the expected result. [Access activity logs](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-access-activity-logs).

## Restoration record

| Item | Required final state | Observed final state |
|---|---|---|
| tomasz.it Job title | Original value | Not recorded |
| SG-CA-Pilot | anna.finance and tomasz.it | Not recorded |
| Administrator role assignments | No unintended additions | Not recorded |
