# Access Matrix

This document describes the identities, administrative roles and security groups used in the Baltic Finance Lab.

## Workforce Users

| Account | Display Name | Department | Directory Role |
|---|---|---|---|
| `anna.finance` | Anna Finance | Finance | None |
| `peter.finance` | Peter Finance | Finance | None |
| `eva.hr` | Eva HR | HR | None |
| `thomas.it` | Thomas IT | IT | None |
| `jan.mover` | Jan Mover | Finance | None |
| `alexandra.leaver` | Alexandra Leaver | Finance | None |

All workforce accounts are configured as Microsoft Entra `Member` users.

The `Usage location` for workforce users is Poland.

Peter Finance is configured as the manager for selected Finance users, including Anna Finance, Jan Mover and Alexandra Leaver.

---

## Administrative Accounts

| Account | Display Name | Directory Role | Purpose |
|---|---|---|---|
| `adm-lab` | Lab Identity Administrator | User Administrator | Delegated day-to-day identity administration |
| `appops-lab` | Cloud Application Administrator | Cloud Application Administrator | Application registrations and Enterprise Application administration |
| `roleops-lab` | Privileged Role Administrator | Privileged Role Administrator | Privileged role assignment and PIM administration |
| `bg01` | Emergency Access 01 | Global Administrator | Emergency / break-glass access |
| `bg02` | Emergency Access 02 | Global Administrator | Emergency / break-glass access |
| Tenant bootstrap account | Tenant Bootstrap Administrator | Global Administrator | Initial tenant administration and recovery |

The emergency access accounts use permanent active `Global Administrator` assignments.

Administrative accounts are separated from normal workforce identities and are not used for regular employee access.

---

## Security Groups

All groups are configured as:

- Type: `Security`
- Membership type: `Assigned`
- Role assignable: `No`

| Group | Purpose | Members |
|---|---|---|
| `SG-Dept-Finance` | Finance department membership | `anna.finance`, `peter.finance`, `jan.mover`, `alexandra.leaver` |
| `SG-Dept-HR` | HR department membership | `eva.hr` |
| `SG-Dept-IT` | IT department membership | `thomas.it` |
| `SG-App-Expense-Users` | Expense Portal submitter access | All six workforce users |
| `SG-App-Expense-Approvers` | Expense Portal approval access | `peter.finance` |
| `SG-CA-Pilot` | Conditional Access pilot group | `anna.finance`, `thomas.it` |
| `SG-External-Contractors` | Future B2B contractor access | Empty until the B2B phase |

---

## Expense Portal Access

| Group | Application Role |
|---|---|
| `SG-App-Expense-Users` | `Expense.Submitter` |
| `SG-App-Expense-Approvers` | `Expense.Approver` |

Application access is assigned through security groups rather than directly to individual users.

This supports centralized access management and prepares the environment for future Joiner / Mover / Leaver automation.

---

## Administrative Model

The lab follows a separation-of-duties model:

```text
Tenant Bootstrap Administrator
        |
        +-- Emergency Access 01 / 02
        |      Global Administrator
        |
        +-- roleops-lab
        |      Privileged Role Administrator
        |
        +-- appops-lab
        |      Cloud Application Administrator
        |
        +-- adm-lab
               User Administrator
