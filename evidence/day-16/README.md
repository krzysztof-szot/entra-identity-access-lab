# Day 16 — Evidence

This folder documents Baltic Finance identity monitoring: investigations in Microsoft Entra sign-in and audit logs, export to Log Analytics, KQL analysis of newly collected events, Conditional Access and custom Workbooks, and an Identity Secure Score review.

Screenshots 01–05 examine available Entra history; screenshots 06–17 document the monitoring setup and subsequent tests. Diagnostic Settings do not backfill earlier events into the new workspace.

## Evidence

- `01-failed-signin-investigation.png` — shows Peter's failed sign-in to `BFL Internal Portal - Proxy` with error `50105`: the password step succeeded, but application assignment was missing.
- `02-conditional-access-investigation.png` — shows Anna's successful Expense Portal sign-in and the individual Conditional Access policy results, including successful MFA and phishing-resistant MFA policy evaluations; this is not a CA failure.
- `03-role-and-pim-audit.png` — shows `adm-lab` requesting approval for a Day 09 PIM role activation with justification and a time-bound request. This audit entry records the approval request, not completed activation.
- `04-guest-activity-investigation.png` — shows the external auditor's B2B guest sign-in to Expense Portal denied with error `50105` due to missing application assignment, despite a successful password step.
- `05-expense-portal-signins.png` — shows Expense Portal's interactive sign-in history for internal users and the external auditor, with successful, interrupted, and failed results.
- `06-log-analytics-workspace.png` — shows the active `law-bfl-identity` workspace in `rg-bfl-identity-lab`, located in Poland Central.
- `07-diagnostic-settings.png` — shows `diag-bfl-identity-monitoring` exporting Audit, interactive/non-interactive sign-in, and Provisioning logs to `law-bfl-identity`; selecting a category does not by itself prove that it contains events.
- `08-successful-test-signin.png` — shows Anna authenticated to Expense Portal, assigned the `Expense.Submitter` app role, and retrieving her profile using delegated Microsoft Graph `User.Read` (HTTP 200).
- `09-failed-test-signin.png` — shows Peter denying a Microsoft Authenticator verification request; this is distinct from the invalid-credentials event in the KQL screenshots.
- `10-kql-failed-signins.png` — shows a `SigninLogs` query identifying Peter's failed Expense Portal sign-in, error `50126`, and an invalid username/password failure reason.
- `11-kql-authentication-failures-by-user.png` — uses `summarize` and `countif()` to compare failed and successful sign-ins by user in the exported data.
- `12-kql-conditional-access.png` — aggregates `ConditionalAccessStatus` in the available workspace records, which show `notApplied`; this does not describe every historical sign-in in the tenant.
- `13-kql-audit-activity-summary.png` — groups exported `AuditLogs` by `OperationName` and visualizes event counts; it is an activity summary, not proof of a role change or PIM activation in Log Analytics.
- `14-kql-application-signins.png` — filters `SigninLogs` for Expense Portal and shows Peter's failed application sign-in with error `50126` and CA status `notApplied`.
- `15-conditional-access-workbook.png` — shows Microsoft's Conditional Access Insights and Reporting Workbook using `law-bfl-identity` with actual sign-in and policy-outcome data.
- `16-custom-identity-workbook.png` — shows the saved `Baltic Finance — Identity Security Monitoring` Workbook with successful/failed sign-in trends, Conditional Access outcomes, and top applications.
- `17-identity-secure-score-and-recommendations.png` — shows the tenant's Identity Secure Score baseline and Microsoft Entra security recommendations for review; no remediation is claimed by this screenshot.

Identifiers and user-specific details were redacted where appropriate; no credentials or access tokens are published.
