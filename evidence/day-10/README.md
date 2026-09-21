# Day 10 — Evidence

This folder documents Microsoft Entra Entitlement Management for the existing External Auditor from Amber Audit Partners: access request, business approval, automated group and application provisioning, Terms of Use, and access revocation.

## Evidence

- `01-auditor-baseline-no-access.png` — shows `SG-External-Contractors` with zero members before the Day 10 access package grants membership.
- `02-connected-organization-amber.png` — shows Amber Audit Partners as a configured connected organization with an internal sponsor.
- `03-external-audit-catalog.png` — shows `BFL-External-Audit` enabled and available for external users.
- `04-catalog-resources.png` — shows `SG-External-Contractors` and `Expense Portal` selected as catalog resources.
- `05-access-package-resource-roles..png` — shows `AP-External-Auditor-30D` with group role `Member` and application role `Expense Submitter`.
- `06-assignment-policy-approval(1).png` — shows the external request scope restricted to Amber Audit Partners, self-service request, required justification, and one-stage approval by Anna Finance within three days.
- `07-access-package-lifecycle-30d.png` — shows 30-day assignment expiration, with user-selected timelines, extensions and access reviews disabled for this lab.
- `08-auditor-access-package-available.png` — shows the package available to External Auditor in My Access with the `Request` action. **It does not show a Pending request**; the portal continued displaying Request after submission.
- `09-auditor-request-approved.png` — shows Anna Finance's approved request, requester details, business justification, questions and package resource roles.
- `10-access-package-assignment.png` — shows the auditor's `Delivered` assignment, policy `POL-Amber-External-Auditors`, 30-day end date and `Governed` lifecycle state.
- `11-auditor-group-membership.png` — confirms that External Auditor became a member of `SG-External-Contractors`.
- `12-auditor-expense-portal-assignment.png` — confirms the `Expense Submitter` app-role assignment in Expense Portal.
- `13-auditor-expense-portal-access.png` — shows successful application authentication and the `Expense.Submitter` role exposed by the portal.
- `14-conditional-access-terms-of-use(1).png` — shows `CA-External-Auditor-ToU` targeting the contractors group and Expense Portal, with `BFL-External-Auditor-ToU` as the grant control and the policy set to On.
- `15-auditor-terms-of-use.png` — shows the Terms of Use prompt presented to the external auditor before acceptance.
- `16-terms-of-use-ca-success.png` — shows a successful Expense Portal sign-in with the Terms of Use Conditional Access grant control satisfied. This is not a separate acceptance-report record.
- `17-access-package-assignment-removed.png` — shows the auditor's assignment in `Expired` status after **manual removal**, with the original future end date still displayed. It does not demonstrate automatic expiration after 30 days.
- `18-auditor-group-membership-removed.png` — shows zero members in `SG-External-Contractors` after the assignment was removed.
- `19-auditor-expense-portal-denied.png` — shows `AADSTS50105`: a fresh Expense Portal sign-in was denied because the auditor had neither direct application assignment nor qualifying group access.

The evidence uses the lab's existing `Expense Submitter` role; this is a demonstration role, **not** read-only auditor access. Sensitive identifiers and tenant-specific details were redacted where appropriate.
