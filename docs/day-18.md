# Day 18 — Security Assessment and Final Validation

## Objectives

Day 18 is the final, point-in-time security assessment of the Baltic Finance Lab after the implementation work from Days 01–17. The goal is no longer to add new IAM features, but to review the current state, verify that earlier controls still work, close selected evidence gaps, remediate confirmed test leftovers and document remaining hardening opportunities.

The assessment covers:

- privileged roles and standing access;
- emergency / break-glass administration;
- Privileged Identity Management;
- authentication methods and Authentication Strengths;
- Conditional Access configuration and runtime enforcement;
- external identities, Access Packages and stale access;
- App Registration permissions, consent and credentials;
- workload identities and Azure RBAC;
- centralized logging and KQL validation.

## Assessment Performed

### Baseline and Microsoft Graph inventory

The Entra ID P2 Baltic Finance tenant was reviewed as the assessment baseline. The existing Day 17 tenant-state export was then rerun.

The final export successfully reported:

- users;
- groups;
- group memberships;
- role assignments;
- App Registrations;
- Enterprise Applications;
- Conditional Access summary.

This closes the Day 17 evidence gap where the captured export had skipped Conditional Access because the required Graph scope was missing from that earlier session.

### Privileged access and Day 17 cleanup

The current `Conditional Access Administrator` assignments were reviewed through PIM.

`adm-lab` remains a direct, permanent **Eligible** assignment rather than a standing Active administrator. The Active assignments view returned **No results**.

The temporary direct role assignment created for `graph.operator` during the Day 17 authorization lab was removed. Microsoft Entra Audit Logs record:

`Remove member from role` → `Success`

and identify the removed role as `Conditional Access Administrator`.

This closes the outstanding Day 17 cleanup item with both final-state and audit evidence.

### Emergency access / break-glass

Two dedicated emergency identities remain permanent Active `Global Administrator` accounts:

- `Emergency Access 01`;
- `Emergency Access 02`.

A Microsoft Graph policy review checked all ten Conditional Access policies. The emergency users are not excluded one-by-one; instead, the centralized emergency-access group is excluded and both accounts resolve to effective exclusions.

The reviewed policy set included:

- `CA-BFL-InternalPortal-Require-MFA`;
- `CA-External-Auditor-ToU`;
- `CA-GSA-Web-Filtering`;
- `CA-MDCA-Session-Control`;
- `CA001-ExpensePortal-Require-MFA`;
- `CA002-ExpensePortal-HighSignInRisk`;
- `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot`;
- `CA008-Expense Portal - Block Non-Hybrid Devices`;
- `CA009-PIM-Validation`;
- `CA010-Block-Legacy-Authentication`.

The permanent emergency assignments are intentional and are treated separately from routine standing privilege.

### Privileged Identity Management

The Day 09 PIM design remains in place for `Conditional Access Administrator`.

Current role settings show:

| Setting | Current state |
| --- | --- |
| Maximum activation duration | 1 hour |
| MFA on activation | Azure MFA |
| Justification | Required |
| Approval | Required |
| Approver | Separate `PIM Approver` identity |
| `adm-lab` assignment | Permanent Eligible |
| Current Active assignment | None |

The role policy also permits permanent Active assignments. This does **not** mean that a permanent Active administrator currently exists; the Active assignment view is empty. It remains a hardening opportunity because the role policy could allow future standing access.

### Authentication methods and phishing-resistant MFA

The current Authentication Methods Policy includes:

- Passkey (FIDO2);
- Microsoft Authenticator;
- SMS;
- Temporary Access Pass;
- Email OTP.

The scopes differ by method. In particular, SMS remains available to all users, which is recorded as a broader authentication-method exposure rather than evidence that SMS can satisfy every protected-resource requirement.

Expense Portal is protected by `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot`, which is On and requires the `Phishing-resistant MFA` Authentication Strength.

This separates **method availability** from **resource assurance requirements**.

### Conditional Access assessment

The policy inventory was reviewed in the Entra portal. At the time of the main inventory capture:

- enforced Expense Portal MFA and phishing-resistant policies were On;
- `CA002-ExpensePortal-HighSignInRisk` was Report-only;
- `CA009-PIM-Validation` was Off by design.

`CA010-Block-Legacy-Authentication` was added later and appears in the final ten-policy emergency-access review.

A What If test for Anna Finance accessing Expense Portal from Windows / Browser predicted that:

- `CA001-ExpensePortal-Require-MFA`;
- `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot`

would apply.

A fresh real sign-in then showed both policies with **Success**, confirming the expected enforcement path.

The same policy outcomes were later visible again through Log Analytics KQL.

### External identity governance

The external-access path built across Days 05, 10 and 11 was reassessed.

Current state:

- `SG-External-Contractors` has zero direct members;
- `POL-Amber-External-Auditors` is enabled;
- requester justification is required;
- approval is required;
- one approval stage is configured;
- assignments are configured to expire after 30 days;
- the selected policy shows zero active assignments;
- External Auditor remains in Access Package history as `Expired` and `Governed`.

A fresh External Auditor sign-in to Expense Portal returned `AADSTS50105`, confirming that the guest has neither a direct application assignment nor qualifying group membership.

The separate visible `Initial Policy` in the Access Package was not evaluated in this evidence set.

The `Expired` assignment screenshot does not prove natural 30-day expiry; the earlier Day 10 workflow documented manual revocation before the configured end date.

### Application permissions and credential cleanup

Expense Portal was reviewed from both the App Registration and Enterprise Application sides.

Final permission state:

- Microsoft Graph `User.Read`;
- Delegated permission;
- Admin consent granted;
- no `User.Read.All` Application permission.

The App Registration also shows:

- Certificates: 0;
- Client secrets: 0;
- Federated credentials: 0.

This verifies cleanup of the temporary Day 12 app-only experiment.

A fresh Anna Finance regression test succeeded after cleanup:

- Microsoft Entra authentication successful;
- `Expense.Submitter` app role present;
- Microsoft Graph profile returned HTTP 200;
- permission model: Delegated;
- permission: `User.Read`.

The application therefore retains its required functionality after least-privilege cleanup.

### Workload identities and Azure RBAC

The two Day 13 workload identities were reviewed at the Storage Account IAM scope:

- `aa-bfl-identity-lab`;
- `mi-bfl-shared-reader`.

Both hold:

`Storage Blob Data Reader`

at the Storage Account resource scope.

The final evidence does not show Owner, Contributor or a privileged administrator role for either workload identity. The current assignment therefore matches the read-only storage scenario implemented in Day 13.

### Monitoring coverage and KQL validation

`diag-bfl-identity-monitoring` continues to send the following categories to `law-bfl-identity`:

- `AuditLogs`;
- `SignInLogs`;
- `NonInteractiveUserSignInLogs`;
- `ProvisioningLogs`.

The following workload-oriented categories are not selected:

- `ServicePrincipalSignInLogs`;
- `ManagedIdentitySignInLogs`.

This is a documented centralized-monitoring boundary rather than an unverified assumption.

A final KQL review expanded `ConditionalAccessPolicies` from recent Expense Portal sign-ins and returned:

- `CA001` → `success`;
- `CA003` → `success`;
- `CA002` → `reportOnlyNotApplied`;
- `CA009` → `notEnabled`.

This creates a three-layer Conditional Access validation chain:

`What If prediction → real Entra sign-in → centralized KQL result`.

## Assessment Summary

| Area | Result | Notes |
| --- | --- | --- |
| Day 17 direct privileged assignment | Remediated | Role removed; audit event and empty Active view captured |
| PIM JIT model | Verified | `adm-lab` remains Eligible; 1h + MFA + justification + approval |
| Emergency access | Verified | Two permanent GA emergency accounts; effective CA exclusions across ten reviewed policies |
| Phishing-resistant Expense Portal access | Verified | CA policy, What If, real sign-in and KQL all correlate |
| External contractor access | Revoked / verified | Group empty, Access Package inactive, fresh app access denied |
| Expense Portal Graph permissions | Least privilege verified | Delegated `User.Read` only; no app credential remains |
| Workload Azure RBAC | Least privilege verified | Both identities use `Storage Blob Data Reader` at resource scope |
| Graph tenant export | Evidence gap closed | CA summary now exports successfully |
| High sign-in-risk policy | Residual / pilot state | Remains Report-only |
| PIM role policy | Hardening opportunity | Permanent Active assignments are permitted by policy although none exist |
| Authentication methods | Hardening opportunity | SMS remains enabled for all users |
| Workload sign-in central logging | Monitoring gap | Service Principal / Managed Identity sign-in categories are not selected |
| Access Package `Initial Policy` | Not assessed | Visible in policy list but not evaluated in Day 18 evidence |

## Design Decisions

- Perform a **point-in-time assessment** instead of rebuilding earlier controls.
- Preserve real residual risks and incomplete coverage rather than marking every item as Fixed.
- Distinguish configuration evidence from runtime evidence: policy state, What If, actual sign-in and KQL are separate proof layers.
- Treat emergency-access permanent Global Administrator roles separately from routine standing administrative privilege.
- Use Microsoft Graph for one aggregated effective-exclusion check instead of ten repetitive GUI screenshots.
- Reuse the existing Baltic Finance identities, applications, governance objects and workload identities so the assessment measures the environment built during Days 01–17.
- Keep credentials, access tokens, client secrets and raw tenant exports out of the public repository.

## Verification and Limitations

**Verified by the published Day 18 evidence:** complete selected Graph inventory including CA summary; no Active Conditional Access Administrator assignment; removal of the Day 17 test role; two permanent emergency Global Administrators with effective group-based CA exclusions across ten reviewed policies; PIM Eligible state and activation controls; authentication-method configuration; phishing-resistant Expense Portal control; What If and real CA enforcement; empty external-contractor group; governed/expired external assignment and fresh AADSTS50105 denial; delegated `User.Read` only; no app credentials; successful post-cleanup application regression; read-only workload RBAC; selected Diagnostic Settings coverage; and final KQL CA results.

**Not established / not claimed:** a formal compliance audit; natural 30-day Access Package expiration; assessment of the separate `Initial Policy`; elimination of every possible stale account or permission path; final Identity Secure Score improvement; centralized Service Principal or Managed Identity sign-in export; or proof that no future permanent Active PIM assignment can be created under the current role policy.

## Evidence and Tests

- [Day 18 test results](../tests/day-18.md)
- [Day 18 evidence](../evidence/day-18/README.md)

Sensitive identifiers were redacted where appropriate. No passwords, client secrets or access tokens are published.
