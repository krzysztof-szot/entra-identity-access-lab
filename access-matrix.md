# Identity and access matrix

**Status:** Planned baseline. Confirm each entry against the tenant and record actual results in the [Day 1 execution record](day-01.md).

The aliases below are the fictional identities agreed for the lab. If different fictional names are used in the tenant, update this matrix and the test references consistently.

## Identities

Append the actual lab domain to each alias when creating an account. Public examples should use a placeholder domain.

| Alias | Display name | Department | Planned Entra directory role | Purpose |
|---|---|---|---|---|
| anna.finance | Anna Finance | Finance | No administrator role | Standard employee |
| piotr.finance | Piotr Finance | Finance | No administrator role | Future application approver |
| ewa.hr | Ewa HR | HR | No administrator role | HR employee |
| tomasz.it | Tomasz IT | IT | No administrator role | IT employee and pilot user |
| jan.mover | Jan Mover | Finance | No administrator role | Future department-change test |
| ola.leaver | Ola Leaver | Finance | No administrator role | Future offboarding test |
| adm-lab | Lab Identity Administrator | IT | User Administrator, Active | Ordinary user and group administration |
| bg01 | Emergency Access 01 | Not applicable | Global Administrator, Active permanent | Emergency access |
| bg02 | Emergency Access 02 | Not applicable | Global Administrator, Active permanent | Emergency access |

For Anna, Jan, and Ola, the planned Manager is Piotr. The employee accounts use Member as User type and Poland as Usage location.

## Security groups

Planned settings: Security type, Assigned membership, and Microsoft Entra roles can be assigned to the group = No. The planned owner is adm-lab.

| Group | Direct members | Expected member count | Purpose |
|---|---|---:|---|
| SG-Dept-Finance | anna.finance, piotr.finance, jan.mover, ola.leaver | 4 | Finance membership |
| SG-Dept-HR | ewa.hr | 1 | HR membership |
| SG-Dept-IT | tomasz.it | 1 | IT membership |
| SG-App-Expense-Users | All six employee accounts | 6 | Future employee role assignment |
| SG-App-Expense-Approvers | piotr.finance | 1 | Future approver role assignment |
| SG-CA-Pilot | anna.finance, tomasz.it | 2 | Conditional Access pilot |
| SG-External-Contractors | None yet | 0 | Future B2B assignments |

All employee membership is direct. The delegated administrator and emergency accounts are not included in the employee application groups.

## Planned application authorization

| Application role | Planned assignment | Intended permission | Status |
|---|---|---|---|
| Employee | SG-App-Expense-Users | Submit reimbursement requests | Planned |
| Approver | SG-App-Expense-Approvers | Approve reimbursement requests | Planned |

These assignments will be configured and tested when the Expense Portal is integrated. Creating a group alone does not enforce application permissions.

## Emergency access validation

Record the registered authentication method, successful sign-in checks, and remaining dependencies in the Day 1 execution record. If both emergency accounts depend on the same phone, document that shared dependency; account creation alone does not establish independent recovery.

Microsoft recommends cloud-only emergency accounts, permanent active Global Administrator assignments, and strong authentication such as FIDO2. [Emergency access guidance](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access).
