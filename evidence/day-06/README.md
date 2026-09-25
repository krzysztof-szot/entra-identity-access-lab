# Day 06 — Evidence

This folder contains evidence of identity lifecycle management and scoped administration using Microsoft Entra ID.

## Evidence

- `01-finance-group-expense-portal-assignment.png` — `SG-Finance-Users` assigned to the Expense Portal with the `Expense.Submitter` application role.

- `02-au-finance-membership.jpg` — `SG-Finance-Users` added to the `AU-Finance` Administrative Unit.

- `03-joiner-finance-group-membership.png` — new Joiner `Marc Joiner` added to `SG-Finance-Users`.

- `04-joiner-expense-portal-access.png` — Joiner successfully authenticated to the Expense Portal and received the `Expense.Submitter` application role.

- `05-mover-finance-to-it.png` — `Jan Mover` moved from Finance to IT and assigned to `SG-IT-Users`.

- `06-mover-expense-portal-access-denied.png` — Expense Portal access denied after the Mover was removed from the Finance access group.

- `07-leaver-deprovisioning-completed.png` — Leaver account disabled with group memberships, application assignments, and administrative roles removed.

- `08-leaver-signin-blocked.png` — sign-in attempt blocked after the Leaver account was disabled.

- `09-au-finance-scoped-user-administrator.png` — `User Administrator` role assigned to the Finance Scoped Administrator with scope limited to `AU-Finance`.

- `10-scoped-admin-finance-success.png` — Finance Scoped Administrator successfully managed a user within `AU-Finance`.

- `11-scoped-admin-hr-denied.png` — Finance Scoped Administrator was unable to manage an HR user outside the assigned Administrative Unit.

Sensitive and environment-specific values were redacted from the screenshots before publication.
