# Users and groups

This is the planned setup. Update it if the lab configuration changes.

## Accounts

| Account | Department | Directory role |
|---|---|---|
| anna.finance | Finance | None |
| peter.finance | Finance | None |
| eva.hr | HR | None |
| thomas.it | IT | None |
| jan.mover | Finance | None |
| alexandra.leaver | Finance | None |
| adm-lab | IT | User Administrator |
| bg01 | - | Global Administrator, permanent Active |
| bg02 | - | Global Administrator, permanent Active |

Employee accounts: Member, Usage location Poland.
Peter is the planned manager for Anna, Jan and Alexandra.
The existing tenant administrator is additional to these nine accounts.

## Groups

All groups are Security, Assigned and non-role-assignable.
The planned owner is adm-lab. Memberships are direct.

| Group | Members |
|---|---|
| SG-Dept-Finance | anna.finance, peter.finance, jan.mover, alexandra.leaver |
| SG-Dept-HR | eva.hr |
| SG-Dept-IT | thomas.it |
| SG-App-Expense-Users | All six employees |
| SG-App-Expense-Approvers | peter.finance |
| SG-CA-Pilot | anna.finance, thomas.it |
| SG-External-Contractors | Empty until the B2B phase |
