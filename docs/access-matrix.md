# Access Matrix

This document describes the identities, administrative roles, security groups and application access model used in the Baltic Finance Lab.

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
| `appops-lab` | Cloud Application Administrator | Cloud Application Administrator | App Registration and Enterprise Application administration |
| `roleops-lab` | Privileged Role Administrator | Privileged Role Administrator | Privileged role assignment and PIM administration |
| `bg01` | Emergency Access 01 | Global Administrator | Emergency / break-glass access |
| `bg02` | Emergency Access 02 | Global Administrator | Emergency / break-glass access |
| Tenant bootstrap account | Tenant Bootstrap Administrator | Global Administrator | Initial tenant administration and recovery |

Administrative accounts are separated from standard workforce identities.

Emergency access accounts use permanent active `Global Administrator` assignments and are reserved for recovery scenarios.

---

## Security Groups

All groups are configured as:

- Group type: `Security`
- Membership type: `Assigned`
- Role assignable: `No`

| Group | Purpose | Members |
|---|---|---|
| `SG-App-Expense-Approvers` | Expense Portal approval access | `peter.finance` |
| `SG-App-Expense-Users` | Expense Portal submitter access | All six workforce users |
| `SG-CA-Pilot` | Pilot scope for Conditional Access testing | `anna.finance`, `thomas.it` |
| `SG-Dept-Finance` | Finance department membership | `anna.finance`, `peter.finance`, `jan.mover`, `alexandra.leaver` |
| `SG-Dept-HR` | HR department membership | `eva.hr` |
| `SG-Dept-IT` | IT department membership | `thomas.it` |
| `SG-Emergency-Access` | Dedicated group for emergency / break-glass accounts | `bg01`, `bg02` |
| `SG-External-Contractors` | B2B contractor access | Empty until the External Identities phase |

---

## Group Design

Department groups represent organizational membership:

- `SG-Dept-Finance`
- `SG-Dept-HR`
- `SG-Dept-IT`

Application groups control access to the Expense Portal:

- `SG-App-Expense-Users` → `Expense.Submitter`
- `SG-App-Expense-Approvers` → `Expense.Approver`

`SG-CA-Pilot` is used to test Conditional Access policies on a limited set of users before wider deployment.

`SG-Emergency-Access` separates emergency access identities from standard administrative and workforce accounts and can be used as a defined scope for Conditional Access exclusions.

`SG-External-Contractors` is reserved for future B2B collaboration scenarios.

---

## Expense Portal Access

| Group | Application Role |
|---|---|
| `SG-App-Expense-Users` | `Expense.Submitter` |
| `SG-App-Expense-Approvers` | `Expense.Approver` |

Application access is assigned through security groups instead of directly to individual users.

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
