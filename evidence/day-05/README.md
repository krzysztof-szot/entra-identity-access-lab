# Day 05 — Evidence

Screenshots documenting B2B collaboration between Baltic Finance Lab and Amber Audit Partners, including guest access, application authorization and cross-tenant access controls.

## Evidence

- `01-external-collaboration-settings.png` — Restrictive guest access and administrator-only guest invitation settings.

- `02-b2b-cross-tenant-audit-logs.png` — Audit logs confirming partner configuration, external user invitation and successful invitation redemption.

- `03-external-contractors-expense-assignment.png` — `SG-External-Contractors` assigned to Expense Portal with the `Expense.Submitter` application role.

- `04-guest-denied-without-group.png` — External Auditor denied access to Expense Portal before receiving access through the assigned group.

- `05-external-contractors-membership.png` — External Auditor added as a Guest member of `SG-External-Contractors`.

- `06-guest-expense-portal-success.png` — Successful Expense Portal access with the `Expense.Submitter` role after group assignment.

- `07-cross-tenant-signin.jpg` — Successful B2B sign-in showing the External Auditor as a Guest and `B2B collaboration` as the cross-tenant access type.

- `08-cross-tenant-amber-organization.png` — Amber Audit Partners configured as a partner organization in Baltic Finance cross-tenant access settings.

- `09-baltic-inbound-b2b.png` — Baltic Finance inbound B2B collaboration restricted to a selected Amber Audit Partners user and the Expense Portal application.

- `10-amber-inbound-trust.png` — Inbound trust configured to accept MFA claims from Amber Audit Partners while device trust remains disabled.

- `11-amber-outbound-b2b.png` — Amber Audit Partners outbound B2B access scoped to the External Auditor and the selected Baltic Finance application.

- `12-cross-tenant-inbound-denied.png` — Negative test confirming that blocking inbound B2B access prevents the External Auditor from accessing Expense Portal.

- `13-cross-tenant-signin-success.png` — Successful Expense Portal sign-in after restoring the intended inbound cross-tenant access configuration.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
