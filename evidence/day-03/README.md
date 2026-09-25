# Day 03 — Evidence

This folder contains evidence for the Day 03 Conditional Access and MFA implementation and validation.

## Evidence

- `01-adm-lab-ca-admin-role.png` — shows the active `User Administrator`, `Conditional Access Administrator`, and `Reports Reader` roles assigned to `adm-lab`.

- `02-ca001-report-only.png` — shows `CA001-ExpensePortal-Pilot-Require-MFA` configured for `SG-CA-Pilot`, excluding `SG-Emergency-Access`, targeting the Expense Portal, requiring MFA authentication strength, and initially deployed in `Report-only` mode.

- `03-whatif-anna-ca001-applies.png` — confirms through the Conditional Access **What If** tool that CA001 applies to Anna Finance when accessing the Expense Portal from a Windows browser.

- `04-ca001-report-only-signin-log.png` — confirms that CA001 was evaluated during a real sign-in while in `Report-only` mode and returned `Report-only: User action required` without enforcing the MFA requirement.

- `05-anna-mfa-challenge.png` — shows the Microsoft Authenticator number-matching MFA challenge presented to Anna after CA001 was enabled.

- `06-anna-expense-portal-after-mfa.png` — confirms successful Expense Portal access after authentication and shows Anna retaining the `Expense.Submitter` application role.

- `07-ca001-enforced-success.png` — shows successful password/mobile-app-notification steps and `CA001-ExpensePortal-Require-MFA: Success`. The overall event is `Interrupted`, explained by the keep-me-signed-in prompt; it is not an overall Success event.

- `08-whatif-high-signin-risk.png` — shows a simulated `High` sign-in risk where CA001 requires MFA and `CA002-ExpensePortal-HighSignInRisk` evaluates `Block access` in `Report-only` mode.

Sensitive environment-specific values were redacted before publication.

CA001's initial name includes `-Pilot-`, while later captures omit it. The screenshots preserve both historical names but do not include the rename event or policy-ID correlation. CA002 evidence demonstrates simulation only.
