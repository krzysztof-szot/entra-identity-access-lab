# Day 06 — Identity Lifecycle and Administrative Units Tests

Tests validate Joiner, Mover, Leaver lifecycle scenarios and scoped administration with Microsoft Entra Administrative Units.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D6-01 | Finance group application access | `SG-Finance-Users` provides the `Expense.Submitter` role in Expense Portal | Group assigned to the application with the expected app role | Pass |
| D6-02 | Joiner application access | New Finance user receives Expense Portal access through group membership | `Marc Joiner` authenticated successfully and received `Expense.Submitter` | Pass |
| D6-03 | Mover access change | Finance access is removed after moving the user to IT | `Jan Mover` was moved to `SG-IT-Users` and Expense Portal access was denied | Pass |
| D6-04 | Leaver deprovisioning | Account and existing access are disabled or removed | Disabled, with zero displayed group/application/role counts; one assigned license remains and session revocation is not shown | Pass for captured account/assignment state only |
| D6-05 | Leaver sign-in | Disabled Leaver cannot authenticate | Alexandra's sign-in is blocked with an account-locked message; no log/error code confirms disablement as the cause | Partial evidence |
| D6-06 | Scoped administrator assignment | Finance administrator receives User Administrator only for `AU-Finance` | AU-scoped assignment shown; complete effective-role inventory is not published | Partial evidence for exclusive scope |
| D6-07 | Scoped administration — Finance | Scoped administrator can manage a Finance user inside the Administrative Unit | Marc's Job title and enabled edit controls shown in `adm-finance` session; update audit and direct AU user membership not shown | Partial evidence |
| D6-08 | Scoped administration — HR | Scoped administrator cannot manage a user outside `AU-Finance` | Edit properties/Delete disabled for HR Control User; no runtime edit denial or complete operation boundary shown | Partial evidence; UI boundary confirmed |

## D6-01 — Finance group application access

**Acting identity:** administrative account  
**Expected:** `SG-Finance-Users` is assigned to Expense Portal with `Expense.Submitter`.  
**Observed:** the group was successfully assigned to the application role.  
**Result:** Pass  
**Evidence:** `../evidence/day-06/01-finance-group-expense-portal-assignment.png`

## D6-02 — Joiner application access

**Acting identity:** `Marc Joiner`  
**Precondition:** user is a member of `SG-Finance-Users`.  
**Expected:** Expense Portal access is granted through group membership.  
**Observed:** authentication succeeded and `Expense.Submitter` was available.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-06/03-joiner-finance-group-membership.png`
- `../evidence/day-06/04-joiner-expense-portal-access.png`

## D6-03 — Mover access change

**Acting identity:** `Jan Mover`  
**Precondition:** user was moved from Finance to IT.  
**Expected:** old Finance access is removed and IT membership is applied.  
**Observed:** `Jan Mover` was assigned to `SG-IT-Users`; Expense Portal returned `AADSTS50105`.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-06/05-mover-finance-to-it.png`
- `../evidence/day-06/06-mover-expense-portal-access-denied.png`

## D6-04 — Leaver deprovisioning

**Acting identity:** administrative account  
**Target:** `Alexandra Leaver`  
**Expected:** account is disabled and existing access assignments are removed.  
**Observed:** account was disabled with zero displayed group, application and role counts, but one assigned license remained. No session-revocation event or existing-session test is shown.  
**Result:** Pass for the captured account/assignment state only; not a complete offboarding validation.  
**Evidence:** `../evidence/day-06/07-leaver-deprovisioning-completed.png`

## D6-05 — Leaver sign-in

**Acting identity:** `Alexandra Leaver`  
**Expected:** disabled account cannot complete a new sign-in.  
**Observed:** Alexandra's authentication was blocked with an account-locked message. The separate overview shows Disabled, but the error code/sign-in log is missing.  
**Result:** Partial evidence: block confirmed; its exact cause is not independently established.  
**Evidence:** `../evidence/day-06/08-leaver-signin-blocked.png`

## D6-06 — Scoped administrator assignment

**Acting identity:** privileged administrator  
**Expected:** `adm-finance` receives User Administrator only for `AU-Finance`.  
**Observed:** the shown User Administrator assignment has AU-Finance scope; a complete active/eligible role inventory is absent. Screenshot 02 shows AU group membership only, not Marc's direct AU membership.  
**Result:** Partial evidence for the claim that this is the administrator's only effective scope.  
**Evidence:**

- `../evidence/day-06/02-au-finance-membership.jpg`
- `../evidence/day-06/09-au-finance-scoped-user-administrator.png`

## D6-07 — Finance scoped administration

**Acting identity:** `adm-finance`  
**Target:** `Marc Joiner`  
**Expected:** scoped administrator can manage a user inside `AU-Finance`.  
**Observed:** the `adm-finance` session shows Marc's Job title as Financial Analyst with editing enabled. The reported update has no before/after audit event, and Marc's direct AU membership is not captured.  
**Result:** Partial evidence; successful mutation by this actor is not independently demonstrated.  
**Evidence:** `../evidence/day-06/10-scoped-admin-finance-success.png`

## D6-08 — HR administration boundary

**Acting identity:** `adm-finance`  
**Target:** `HR Control User`  
**Expected:** Finance scoped administrator cannot manage a user outside `AU-Finance`.  
**Observed:** Edit properties and Delete are disabled in the `adm-finance` session. Reset password is visible, but no attempted reset or edit/API denial is captured. The screenshot does not establish the boundary for every user-management operation.  
**Result:** Partial evidence; the visible Edit/Delete UI boundary is confirmed.  
**Evidence:** `../evidence/day-06/11-scoped-admin-hr-denied.png`

## Day 06 final state

- `Marc Joiner` remains a Finance user with Expense Portal access.
- `Jan Mover` belongs to IT and no longer has Finance application access.
- `Alexandra Leaver` is disabled with zero displayed group/application/role counts; one license remains, and session termination is unverified.
- The shown `adm-finance` User Administrator assignment is scoped to `AU-Finance`; other effective roles are not independently inventoried.
- `HR Control User` is the reported out-of-scope control; the capture confirms disabled Edit/Delete controls, not its full AU membership inventory.

Follow-up: capture the AU Users list, effective administrator roles, a reversible Marc Job title update/restore with actor/target Audit Logs, and a corresponding out-of-scope edit denial. Capture Alexandra's sign-in error code and session-revocation/old-session behavior if claiming full offboarding; review the retained license under the lab's retention requirements.

## Evidence

See [Day 06 evidence](../evidence/day-06/README.md).
