# Users and groups

This is the planned setup. Update it if the lab configuration changes.

## Accounts

| Account | Department | Directory role |
|---|---|---|
| anna.finance | Finance | None |
| piotr.finance | Finance | None |
| ewa.hr | HR | None |
| tomasz.it | IT | None |
| jan.mover | Finance | None |
| ola.leaver | Finance | None |
| adm-lab | IT | User Administrator |
| bg01 | - | Global Administrator, permanent Active |
| bg02 | - | Global Administrator, permanent Active |

Employee accounts: Member, Usage location Poland.
Piotr is the planned manager for Anna, Jan and Ola.
The existing tenant administrator is additional to these nine accounts.

## Groups

All groups are Security, Assigned and non-role-assignable.
The planned owner is adm-lab. Memberships are direct.

| Group | Members |
|---|---|
| SG-Dept-Finance | anna.finance, piotr.finance, jan.mover, ola.leaver |
| SG-Dept-HR | ewa.hr |
| SG-Dept-IT | tomasz.it |
| SG-App-Expense-Users | All six employees |
| SG-App-Expense-Approvers | piotr.finance |
| SG-CA-Pilot | anna.finance, tomasz.it |
| SG-External-Contractors | Empty until the B2B phase |
