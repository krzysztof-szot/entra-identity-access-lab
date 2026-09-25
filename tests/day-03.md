# Day 03 — Conditional Access and MFA Tests

## Objective

Validate Conditional Access scope, staged MFA deployment, authentication strength enforcement, sign-in logging and risk-based access controls for the Expense Portal.

| Check | Expected Result | Actual Result | Evidence |
|---|---|---|---|
| `adm-lab` has the required administrative roles | `Conditional Access Administrator` and `Reports Reader` are active | Pass | [01-adm-lab-ca-admin-role.png](../evidence/day-03/01-adm-lab-ca-admin-role.png) |
| CA001 is initially deployed in `Report-only` mode | Policy targets `SG-CA-Pilot`, excludes `SG-Emergency-Access`, targets Expense Portal and requires MFA authentication strength | Pass | [02-ca001-report-only.png](../evidence/day-03/02-ca001-report-only.png) |
| CA001 applies to `anna.finance` in the pilot group | What If evaluation shows CA001 will apply and require MFA | Pass | [03-whatif-anna-ca001-applies.png](../evidence/day-03/03-whatif-anna-ca001-applies.png) |
| CA001 is evaluated during a real sign-in while in `Report-only` mode | Sign-in log shows `Report-only: User action required` without enforcing the policy | Pass | [04-ca001-report-only-signin-log.png](../evidence/day-03/04-ca001-report-only-signin-log.png) |
| CA001 requires MFA after enforcement is enabled | Anna receives a Microsoft Authenticator MFA challenge | Pass | [05-anna-mfa-challenge.png](../evidence/day-03/05-anna-mfa-challenge.png) |
| `anna.finance` can access Expense Portal after successful MFA | Application access succeeds and `Expense.Submitter` remains assigned | Pass | [06-anna-expense-portal-after-mfa.png](../evidence/day-03/06-anna-expense-portal-after-mfa.png) |
| CA001 enforcement is recorded in Sign-in logs | MFA succeeds and `CA001-ExpensePortal-Require-MFA` returns `Success` | Pass for authentication steps and policy evaluation; overall event is Interrupted (keep-me-signed-in prompt) | [07-ca001-enforced-success.png](../evidence/day-03/07-ca001-enforced-success.png) |
| High sign-in risk triggers the expected Conditional Access evaluation | What If shows CA001 requiring MFA and CA002 evaluating `Block access` | Pass | [08-whatif-high-signin-risk.png](../evidence/day-03/08-whatif-high-signin-risk.png) |

## Result

All planned Day 03 Conditional Access and MFA tests completed successfully.

The tests support staged Conditional Access deployment and MFA authentication-strength evaluation. The high-risk test is a What If simulation with CA002 in Report-only; it does not confirm a real risky-sign-in block. Initial CA001 captures include `-Pilot-` in the name; later captures omit it, without a published rename event.
