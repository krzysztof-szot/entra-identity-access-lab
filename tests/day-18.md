# Day 18 — Security Assessment and Final Validation Tests

Day 18 tests the **current state** of the Baltic Finance Lab after Days 01–17. Outcomes distinguish confirmed remediation, verified controls, residual hardening opportunities and monitoring boundaries. **Pass** means the captured evidence supports the stated result; it does not imply formal compliance or absence of all remaining risk.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D18-01 | Assessment baseline and Graph inventory | Review the correct tenant and successfully export selected tenant state including CA summary | Baltic Finance Lab / Entra ID P2 shown; users, groups, memberships, roles, apps and CA summary exported | Pass |
| D18-02 | Standing Conditional Access Administrator access | No unnecessary Active assignment should remain | Active assignments view shows **No results** | Pass |
| D18-03 | Day 17 privileged-role cleanup | Remove the temporary direct role assignment and record the change | Audit Logs show successful `Remove member from role` for `graph.operator` / Conditional Access Administrator | Pass |
| D18-04 | Emergency access roles and CA exclusions | Two emergency GA role assignments and effective exclusions from reviewed CA policies are present | Two permanent Active GAs; emergency group effective for both accounts across ten reviewed policies | Pass |
| D18-05 | PIM current assignment | Routine CA administration remains Eligible rather than standing Active | `adm-lab` is permanently Eligible; no Active assignment shown | Pass |
| D18-06 | PIM activation controls | Activation is short-lived and controlled | 1 hour, Azure MFA, justification, approval and separate approver configured | Pass (hardening observation: permanent Active allowed by role policy) |
| D18-07 | Authentication methods review | Record current method availability and scope | FIDO2, Authenticator, SMS, TAP and Email OTP enabled for configured targets | Pass (review; SMS remains broad) |
| D18-08 | Phishing-resistant Expense Portal control | Expense Portal requires phishing-resistant Authentication Strength | CA003 is On and requires Phishing-resistant MFA | Pass |
| D18-09 | Conditional Access inventory | Review current policy states without assuming every policy is enforced | Main inventory captured; CA002 Report-only, CA009 Off; CA010 appears in final ten-policy review | Pass (point-in-time inventory) |
| D18-10 | What If versus real sign-in | Policies predicted by What If should match the fresh Expense Portal event | CA001 and CA003 predicted; both show Success on Anna's real sign-in | Pass |
| D18-11 | External contractor group state | No direct external-contractor membership should remain | `SG-External-Contractors` has zero direct members | Pass |
| D18-12 | Access Package governance state | Scoped external policy requires governance and has no active assignment | Approval + justification + 30-day expiration; zero active assignments; External Auditor shown Expired / Governed | Pass (natural expiry not evidenced) |
| D18-13 | External negative access test | Guest without assignment cannot access Expense Portal | Fresh External Auditor sign-in fails with `AADSTS50105` | Pass |
| D18-14 | Application API permission least privilege | Temporary broad Application permission should be removed | Only Microsoft Graph `User.Read` Delegated remains; admin consent confirmed | Pass |
| D18-15 | Application credential inventory | Record the remaining app credentials | 0 certificates, 0 client secrets, 0 federated credentials | Pass (inventory; Easy Auth credential path requires follow-up) |
| D18-16 | Captured post-cleanup application regression | The captured portal session retains the intended app role and Graph profile | Anna authenticated; `Expense.Submitter`; Graph HTTP 200 with Delegated `User.Read` | Pass (captured session; fresh code redemption and refresh not independently evidenced) |
| D18-17 | Workload identity RBAC | Managed identities should retain read-only storage authorization | Both identities have `Storage Blob Data Reader` at Storage Account scope | Pass |
| D18-18 | Diagnostic Settings coverage | Confirm exactly which Entra log categories are centralized | Audit, user sign-in and Provisioning selected; Service Principal / Managed Identity sign-ins not selected | Partial / gap documented |
| D18-19 | Final KQL Conditional Access review | Centralized logs should corroborate recent CA outcomes | CA001 + CA003 success; CA002 reportOnlyNotApplied; CA009 notEnabled | Pass |

## D18-01 — Baseline and tenant-state inventory

**Acting identity:** `adm-lab`.  
**Expected:** confirm the Baltic Finance Lab tenant and rerun the existing Graph inventory successfully, including Conditional Access.  
**Observed:** tenant overview shows Entra ID P2. The export reports users, groups, group memberships, role assignments, App Registrations, Enterprise Applications and Conditional Access summary as exported.  
**Result:** Pass. This closes the Day 17 CA-export evidence gap.  
**Evidence:** [01](../evidence/day-18/01-assessment-baseline.png), [02](../evidence/day-18/02-graph-inventory.png).

## D18-02–D18-06 — Privileged access, emergency access and PIM

**Acting identities:** authorized Entra / PIM administrators; emergency accounts are assessed as dedicated recovery identities.  
**Expected:** remove temporary routine standing privilege, retain the intended PIM Eligible model, preserve dedicated emergency access and verify PIM activation controls.  
**Observed:** Conditional Access Administrator has no Active assignment; the Day 17 `graph.operator` role removal is present in Audit Logs; `adm-lab` remains Eligible; both emergency accounts are permanent Active Global Administrators and resolve to effective CA exclusions through the emergency group for all ten reviewed policies; PIM requires one-hour activation, Azure MFA, justification and separate approval.  
**Result:** Pass for current state and recorded remediation.  
**Evidence:** [03](../evidence/day-18/03-privileged-role-inventory.png), [04](../evidence/day-18/04-standing-privilege-assessment.png), [05](../evidence/day-18/05-privilege-remediation.png), [06](../evidence/day-18/06-break-glass-assessment.png), [07](../evidence/day-18/07-pim-current-state.png), [08](../evidence/day-18/08-pim-security-settings.png).  
**Evidence boundary:** the PIM role policy still permits permanent Active assignments. The screenshots prove that none are currently present for Conditional Access Administrator; they do not prove that future permanent Active assignments are technically impossible.

## D18-07–D18-10 — Authentication and Conditional Access

**Acting identities:** `adm-lab` for configuration review; `anna.finance` for the real application test.  
**Expected:** document enabled methods, confirm phishing-resistant protection of Expense Portal and correlate policy simulation with a real sign-in.  
**Observed:** authentication methods and scopes are visible; CA003 is On and requires Phishing-resistant MFA; What If predicts CA001 and CA003 for Anna / Expense Portal / Windows / Browser; the corresponding real sign-in shows both policies with Success.  
**Result:** Pass.  
**Evidence:** [09](../evidence/day-18/09-authentication-methods-review.png), [10](../evidence/day-18/10-phishing-resistant-mfa.png), [11](../evidence/day-18/11-conditional-access-inventory.png), [12](../evidence/day-18/12-conditional-access-what-ifvalidation.png), [13](../evidence/day-18/13-conditional-access-validation.png).  
**Evidence boundary:** SMS remains enabled for all users; this is method availability, not proof that SMS satisfies CA003. CA002 remains Report-only and CA009 remains Off. CA010 was added after the main policy-list capture and appears in screenshot 06.

## D18-11–D18-13 — External access and governance

**Acting identities:** authorized Identity Governance administrator and External Auditor for the negative test.  
**Expected:** no stale group-derived access should remain; the governance policy should be visible; fresh guest access without assignment should fail.  
**Observed:** `SG-External-Contractors` has zero direct members; the selected external-auditor policy requires justification, approval and 30-day assignment expiration with zero active assignments; External Auditor appears Expired / Governed; fresh Expense Portal access fails with `AADSTS50105`.  
**Result:** Pass for the selected governed access path.  
**Evidence:** [14](../evidence/day-18/14-guest-access-review.png), [15](../evidence/day-18/15-access-package-lifecycle.png), [16](../evidence/day-18/16-access-package-assignments.png), [17](../evidence/day-18/17-external-access-denied.png).  
**Evidence boundary:** screenshot 14 is final group state, not the Access Review decision page. Screenshot 16 does not prove natural 30-day expiry. The separate visible `Initial Policy` is not assessed in this Day 18 evidence set.

## D18-14–D18-16 — Application permissions, credentials and regression

**Acting identities:** authorized application administrator for review; `anna.finance` for regression.  
**Expected:** retain only the required delegated Graph permission, remove the temporary credential and broad app-only permission, then confirm the portal still works.  
**Observed:** App Registration contains only delegated `User.Read`; Enterprise Application shows the corresponding Admin consent; no certificates, secrets or federated credentials remain; Anna's portal session succeeds and Graph profile retrieval returns HTTP 200 under Delegated `User.Read`.  
**Result:** Pass.  
**Evidence:** [18](../evidence/day-18/18-app-registration-permissions.png), [19](../evidence/day-18/19-enterprise-app-consent.png), [20](../evidence/day-18/20-no-client-secrets.png), [21](../evidence/day-18/21-expense-portal-regression.png).  
**Evidence boundary:** the final credential list proves current absence of app credentials; it does not independently show the exact earlier deletion action, a fresh authorization-code redemption or successful token renewal after removal. The Easy Auth credential path and `/.auth/refresh` remain [follow-up checks](../docs/remaining-work.md).

## D18-17 — Workload identity RBAC

**Acting identity:** authorized Azure RBAC reader.  
**Expected:** workload identities use the narrow read-only storage role at the intended resource scope.  
**Observed:** both `aa-bfl-identity-lab` and `mi-bfl-shared-reader` have `Storage Blob Data Reader` at the Storage Account scope.  
**Result:** Pass.  
**Evidence:** [22](../evidence/day-18/22-workload-rbac.png).  
**Evidence boundary:** this is an RBAC assignment review. Day 13 contains the separate runtime read-success / write-denial tests.

## D18-18–D18-19 — Monitoring coverage and KQL

**Acting identity:** authorized Entra / Log Analytics reader.  
**Expected:** document exactly which logs are centralized and use KQL to corroborate recent Conditional Access outcomes.  
**Observed:** `AuditLogs`, `SignInLogs`, `NonInteractiveUserSignInLogs` and `ProvisioningLogs` are selected for `law-bfl-identity`; Service Principal and Managed Identity sign-in categories are not selected. KQL expands Conditional Access policies from recent Expense Portal records and shows CA001 / CA003 success, CA002 report-only not applied and CA009 not enabled.  
**Result:** D18-18 Partial / gap documented; D18-19 Pass.  
**Evidence:** [23](../evidence/day-18/23-monitoring-coverage.png), [24](../evidence/day-18/24-final-kql-review.png).  
**Evidence boundary:** selected categories do not imply historical backfill or prove event presence in every corresponding table. Workload identity sign-ins are not centrally exported by the shown Diagnostic Setting.

## Residual findings / not fully assessed

| Area | Status | Explanation |
| --- | --- | --- |
| PIM permanent Active policy allowance | Hardening opportunity | The role policy allows permanent Active assignments although none are currently present |
| SMS authentication scope | Hardening opportunity | SMS remains enabled for all users; Expense Portal separately requires phishing-resistant MFA |
| High sign-in-risk CA | Residual / pilot state | `CA002-ExpensePortal-HighSignInRisk` remains Report-only |
| Workload identity centralized sign-in logging | Partial | `ServicePrincipalSignInLogs` and `ManagedIdentitySignInLogs` are not selected |
| Access Package `Initial Policy` | Not assessed | Visible in screenshot 15 but not evaluated in this evidence set |
| Natural 30-day Access Package expiry | Not evidenced | Day 10 documented earlier manual revocation before the configured end date |
| Final Identity Secure Score improvement | Not evidenced | Day 18 evidence set does not include a final score comparison |
| Easy Auth credential path and token renewal | Follow-up required | Verify fresh authentication and Graph token refresh after credential cleanup |
| Emergency-group membership protection | Not tested | Confirm delegated group administrators cannot change the exclusion group |
| Emergency-account sign-in and alert validation | Not repeated in Day 18 | Day 01 sign-ins are historical; current strong-authentication and alert evidence require separate validation |
| Formal compliance | Out of scope | Day 18 is a lab security assessment, not a certified audit |

## Final state

The Day 18 evidence closes the Day 17 direct-role cleanup and CA-export evidence gaps. It revalidates PIM configuration, emergency role assignments and CA exclusions, phishing-resistant Conditional Access, external-access removal, delegated application permissions and workload RBAC. The captured portal session succeeds. Fresh Easy Auth code redemption, token renewal, emergency-group protection and emergency-use alert delivery remain separate follow-up checks alongside the documented hardening and monitoring gaps.

See [Day 18 implementation notes](../docs/day-18.md) and [Day 18 evidence](../evidence/day-18/README.md).
