# Day 01 — Identity Foundation Tests

## Objective

Validate delegated administration, least-privilege boundaries, emergency access accounts and Microsoft Entra auditability.

| Check | Expected Result | Actual Result | Evidence |
|---|---|---|---|
| `adm-lab` has the `User Administrator` role | Active role assignment is present | Pass | [03-adm-lab-user-administrator.png](../evidence/day-01/03-adm-lab-user-administrator.png) |
| `adm-lab` can update an employee's `JobTitle` | Attribute can be modified and restored | Pass | [07-audit-log-user-update.png](../evidence/day-01/07-audit-log-user-update.png) |
| `adm-lab` can remove and re-add `thomas.it` in `SG-CA-Pilot` | Membership change succeeds and final membership is restored | Pass | [06-audit-log-group-membership.png](../evidence/day-01/06-audit-log-group-membership.png) |
| `adm-lab` cannot assign privileged directory roles | Role assignment control is unavailable or denied | Pass | [04-permission-denied-role-assignment.png](../evidence/day-01/04-permission-denied-role-assignment.png) |
| `anna.finance` can complete a fresh sign-in | User authentication succeeds | Pass | — |
| `bg01` can complete an administrative sign-in | Emergency account can access the Entra admin center | Pass | [05-break-glass-accounts.png](../evidence/day-01/05-break-glass-accounts.png) |
| `bg02` can complete an administrative sign-in | Emergency account can access the Entra admin center | Pass | [05-break-glass-accounts.png](../evidence/day-01/05-break-glass-accounts.png) |
| Group membership changes are recorded in Audit Logs | Event shows initiator, target and successful result | Pass | [06-audit-log-group-membership.png](../evidence/day-01/06-audit-log-group-membership.png) |
| User attribute changes are recorded in Audit Logs | `Update user` event shows modified property and initiator | Pass | [07-audit-log-user-update.png](../evidence/day-01/07-audit-log-user-update.png) |

## Result

All planned Day 01 identity foundation and administrative boundary tests completed successfully.
