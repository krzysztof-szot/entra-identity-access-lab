# Day 05 — Evidence

Screenshots documenting B2B collaboration between Baltic Finance Lab and Amber Audit Partners, including guest access, application authorization and cross-tenant access controls.

## Evidence

- `01-external-collaboration-settings.png` — Restrictive guest access, administrator-only invitations and disabled self-service signup selected; the active Save control means persistence is not independently established by this capture.

- `02-b2b-cross-tenant-audit-logs.png` — Successful partner-add, external invitation and redemption audit rows; target and initiator details are not displayed.

- `03-external-contractors-expense-assignment.png` — `SG-External-Contractors` assigned to Expense Portal with the `Expense.Submitter` application role.

- `04-guest-denied-without-group.png` — External Auditor denied access to Expense Portal before receiving access through the assigned group.

- `05-external-contractors-membership.png` — External Auditor added as a Guest member of `SG-External-Contractors`.

- `06-guest-expense-portal-success.png` — Successful Expense Portal access with the `Expense.Submitter` role after group assignment.

- `07-cross-tenant-signin.jpg` — Successful B2B sign-in showing the External Auditor as a Guest and `B2B collaboration` as the cross-tenant access type.

- `08-cross-tenant-amber-organization.png` — Amber Audit Partners exists in Baltic Finance cross-tenant settings; inbound/outbound are still `Inherited from default` in this capture.

- `09-baltic-inbound-b2b.png` — Baltic Finance inbound B2B collaboration allows one selected Amber user and Expense Portal. The user's identity is masked.

- `10-amber-inbound-trust.png` — Inbound MFA trust configured while device trust remains disabled; actual partner MFA-claim acceptance is not shown.

- `11-amber-outbound-b2b.png` — Amber outbound access toward Baltic Finance allows External Auditor and one selected external application; the application's value is masked.

- `12-cross-tenant-inbound-denied.png` — Negative test confirming that blocking inbound B2B access prevents the External Auditor from accessing Expense Portal.

- `13-cross-tenant-signin-success.png` — Successful Expense Portal sign-in after restoring the intended inbound cross-tenant access configuration.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
