# Day 06 — Evidence

This folder contains evidence of identity lifecycle management and scoped administration using Microsoft Entra ID.

## Evidence

- `01-finance-group-expense-portal-assignment.png` — `SG-Finance-Users` assigned to the Expense Portal with the `Expense.Submitter` application role.

- `02-au-finance-membership.jpg` — `SG-Finance-Users` is a member of `AU-Finance`. The group's users do not inherit AU membership; no direct AU Users list is shown.

- `03-joiner-finance-group-membership.png` — new Joiner `Marc Joiner` added to `SG-Finance-Users`.

- `04-joiner-expense-portal-access.png` — Joiner successfully authenticated to the Expense Portal and received the `Expense.Submitter` application role.

- `05-mover-finance-to-it.png` — `Jan Mover` moved from Finance to IT and assigned to `SG-IT-Users`.

- `06-mover-expense-portal-access-denied.png` — Expense Portal access denied after the Mover was removed from the Finance access group.

- `07-leaver-deprovisioning-completed.png` — Leaver Disabled with zero displayed group/application/role counts and one assigned license. No session revocation is shown.

- `08-leaver-signin-blocked.png` — Alexandra's sign-in blocked with an account-locked message. No error code or sign-in log establishes the exact cause.

- `09-au-finance-scoped-user-administrator.png` — `User Administrator` role assigned to the Finance Scoped Administrator with scope limited to `AU-Finance`.

- `10-scoped-admin-finance-success.png` — the `adm-finance` session shows Marc's Job title and enabled editing controls; no update audit event or direct AU user membership is shown.

- `11-scoped-admin-hr-denied.png` — Edit properties/Delete are disabled for HR Control User in the `adm-finance` session; a runtime denial and the boundary for other operations are not captured.

Sensitive and environment-specific values were redacted from the screenshots before publication.
