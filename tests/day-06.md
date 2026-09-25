# Day 06 — Identity Lifecycle and Administrative Units Tests

Tests validate Joiner, Mover, Leaver lifecycle scenarios and scoped administration with Microsoft Entra Administrative Units.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D6-01 | Finance group application access | `SG-Finance-Users` provides the `Expense.Submitter` role in Expense Portal | Group assigned to the application with the expected app role | Pass |
| D6-02 | Joiner application access | New Finance user receives Expense Portal access through group membership | `Marc Joiner` authenticated successfully and received `Expense.Submitter` | Pass |
| D6-03 | Mover access change | Finance access is removed after moving the user to IT | `Jan Mover` was moved to `SG-IT-Users` and Expense Portal access was denied | Pass |
| D6-04 | Leaver deprovisioning | Account and existing access are disabled or removed | `Alexandra Leaver` was disabled with no remaining group, application, or administrative role assignments | Pass |
| D6-05 | Leaver sign-in | Disabled Leaver cannot authenticate | New sign-in attempt was blocked | Pass |
| D6-06 | Scoped administrator assignment | Finance administrator receives User Administrator only for `AU-Finance` | `adm-finance` received User Administrator with `AU-Finance` scope | Pass |
| D6-07 | Scoped administration — Finance | Scoped administrator can manage a Finance user inside the Administrative Unit | `adm-finance` successfully updated `Marc Joiner` | Pass |
| D6-08 | Scoped administration — HR | Scoped administrator cannot manage a user outside `AU-Finance` | Management actions for `HR Control User` were unavailable | Pass |

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
**Observed:** account was disabled with zero group memberships, application assignments, and administrative roles.  
**Result:** Pass  
**Evidence:** `../evidence/day-06/07-leaver-deprovisioning-completed.png`

## D6-05 — Leaver sign-in

**Acting identity:** `Alexandra Leaver`  
**Expected:** disabled account cannot complete a new sign-in.  
**Observed:** authentication was blocked.  
**Result:** Pass  
**Evidence:** `../evidence/day-06/08-leaver-signin-blocked.png`

## D6-06 — Scoped administrator assignment

**Acting identity:** privileged administrator  
**Expected:** `adm-finance` receives User Administrator only for `AU-Finance`.  
**Observed:** User Administrator was assigned with Administrative Unit scope instead of tenant-wide scope.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-06/02-au-finance-membership.jpg`
- `../evidence/day-06/09-au-finance-scoped-user-administrator.png`

## D6-07 — Finance scoped administration

**Acting identity:** `adm-finance`  
**Target:** `Marc Joiner`  
**Expected:** scoped administrator can manage a user inside `AU-Finance`.  
**Observed:** `adm-finance` successfully updated the Finance user's Job title.  
**Result:** Pass  
**Evidence:** `../evidence/day-06/10-scoped-admin-finance-success.png`

## D6-08 — HR administration boundary

**Acting identity:** `adm-finance`  
**Target:** `HR Control User`  
**Expected:** Finance scoped administrator cannot manage a user outside `AU-Finance`.  
**Observed:** user management actions were unavailable for the HR account.  
**Result:** Pass  
**Evidence:** `../evidence/day-06/11-scoped-admin-hr-denied.png`

## Final state

- `Marc Joiner` remains a Finance user with Expense Portal access.
- `Jan Mover` belongs to IT and no longer has Finance application access.
- `Alexandra Leaver` is disabled and deprovisioned.
- `adm-finance` has User Administrator permissions limited to `AU-Finance`.
- `HR Control User` remains outside the Finance administrative scope.

## Evidence

See [Day 06 evidence](../evidence/day-06/README.md).
