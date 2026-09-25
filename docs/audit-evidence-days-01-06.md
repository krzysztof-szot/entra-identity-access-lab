# Independent Evidence Audit — Days 01–06

Review date: 2026-09-25. This is a read-only review of the published lab evidence, not a new tenant test. Original screenshots and masking are unchanged.

Ratings apply to the stated claim: **Full** means the visible capture supports that observation; **Partial** means it supports only part of the broader claim; **Inconclusive** means it cannot establish the claimed result. Configuration evidence does not establish runtime enforcement. Masked identifiers are not reconstructed. Day numbers describe lab topics, not necessarily capture dates; several images combine panels, so their ordering alone does not establish a continuous session.

## Checkpoints

- Days 01–02: all 19 images visually reviewed; all six day documentation/test/index files read.
- Days 03–05: all 30 images visually reviewed; all nine day documentation/test/index files read.
- Day 06: all 11 images visually reviewed; all three day documentation/test/index files read.
- Total: **60 of 60 images reviewed**, including both JPG files; all 18 day text files reviewed. Corrections applied to the documentation, test results and evidence indexes. Local checks found 116 relative Markdown links and 159 screenshot references with no missing targets; every image is in this inventory. Diff review passed with Markdown hard-break whitespace allowed. No tenant operations or new lab results.

## Day 01 — 8 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-users](../evidence/day-01/01-users.png) | **Full** for the ten listed Member accounts, including workforce, `adm-lab`, `bg01`, `bg02`; on-premises sync is No. **Partial** for the wider admin model: `appops-lab` and `roleops-lab` are absent from this capture. |
| [02-groups](../evidence/day-01/02-groups.png) | **Full** for seven Security/Assigned groups: three department groups, two app groups, CA pilot and contractors. **Inconclusive** for emergency-group creation or membership; that group is absent here. Role-assignable status and owners are not displayed. |
| [03-adm-lab-user-administrator](../evidence/day-01/03-adm-lab-user-administrator.png) | **Full**: `adm-lab` has direct, tenant-scoped User Administrator, Active, Permanent. |
| [04-permission-denied-role-assignment](../evidence/day-01/04-permission-denied-role-assignment.png) | **Full** for the UI boundary: signed-in `adm-lab` has a disabled Add assignments control on Privileged Role Administrator. The active list shows `roleops-lab`. No attempted API denial is shown. |
| [05-break-glass-accounts](../evidence/day-01/05-break-glass-accounts.png) | **Full**: both emergency accounts have direct Global Administrator, Active, Permanent at tenant scope. |
| [06-audit-log-group-membership](../evidence/day-01/06-audit-log-group-membership.png) | **Full** for successful re-add of `thomas.it` to `SG-CA-Pilot` by `adm-lab` on September 15 at 20:50 local; an earlier Remove member row is visible. **Partial** for the removal result: its detail/status is outside the published panel. |
| [07-audit-log-user-update](../evidence/day-01/07-audit-log-user-update.png) | **Full** for successful `adm-lab` update of Anna's JobTitle from IT Manager to Financial Analyst, with two successful Update user rows on September 15 at 21:02 local. The first update's property detail is not expanded. |
| [08-break-glass-signin-logs](../evidence/day-01/08-break-glass-signin-logs.png) | **Full**: interactive Azure Portal sign-ins for `bg01` and `bg02` succeeded on September 16 at 05:01/05:02 UTC, resource Azure Resource Manager, CA Not applied. This does not show use during an outage or the authentication method. |

Finding: the Day 01 Anna fresh-sign-in row has no evidence. Preserve it as a reported result that cannot be independently verified for Day 01; later app sign-ins do not supply the missing Day 01 capture. The emergency-group creation statement is historical, with no Day 01 group capture to substantiate it.

## Day 02 — 11 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-app-registration](../evidence/day-02/01-app-registration.png) | **Full**: Expense Portal App Registration, My organization only, one web redirect URI and one secret. Exact IDs and URI are masked/truncated. |
| [02-app-roles](../evidence/day-02/02-app-roles.png) | **Full**: enabled `Expense.Submitter` and `Expense.Approver` roles, Users/Groups allowed. |
| [03-enterprise-application](../evidence/day-02/03-enterprise-application.png) | **Full** for the named Expense Portal Enterprise Application. **Partial** for exact App Registration-to-service-principal ID correlation because IDs are masked. |
| [04-group-assignments](../evidence/day-02/04-group-assignments.png) | **Full**: approver and user security-group names assigned to Expense Approver and Expense Submitter respectively. Individual group memberships are not displayed. |
| [05-assignment-required](../evidence/day-02/05-assignment-required.png) | **Full** for configuration: sign-in enabled and Assignment required Yes. The denial test is separate evidence. |
| [05a-app-service-authentication](../evidence/day-02/05a-app-service-authentication.png) | **Full** for `bfl-expense-ks01` authentication Enabled, Require authentication, HTTP 302 redirect to Microsoft (Expense Portal), token store Enabled. IDs are masked. |
| [06-anna-portal-access](../evidence/day-02/06-anna-portal-access.png) | **Full** for Anna's visible authenticated portal session and displayed Submitter role only. **Partial** for business authorization: no expense operation or server-side role enforcement is demonstrated. |
| [07-peter-portal-access](../evidence/day-02/07-peter-portal-access.png) | **Full** for Peter's visible authenticated session and displayed Submitter/Approver roles. **Partial** for business authorization for the same reason as image 06. |
| [08-admin-consent](../evidence/day-02/08-admin-consent.png) | **Full**: Microsoft Graph delegated `User.Read` granted for Baltic Finance Lab. The default Admin consent required column is No; this is evidence of a grant, not that this permission universally requires admin consent. |
| [09-anna-and-peter-signin-logs](../evidence/day-02/09-anna-and-peter-signin-logs.png) | **Full**: Anna and Peter successful interactive sign-ins, application Expense Portal, resource Microsoft Graph, CA Not applied on September 15 at 09:13/09:18 UTC. These are not business-operation audit events. |
| [10-unassigned-user-access-denied](../evidence/day-02/10-unassigned-user-access-denied.png) | **Full**: `appops-lab` denied Expense Portal with AADSTS50105 on September 16 at 04:35 UTC because neither direct assignment nor direct membership of an assigned group was present. |

Finding: application session/role display and assignment denial are supported. Successful submit/approve operations and server-side authorization are not published and must not be inferred from UI labels. Consent should name its exact API permission and type.

## Day 03 — 8 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-adm-lab-ca-admin-role](../evidence/day-03/01-adm-lab-ca-admin-role.png) | **Full**: `adm-lab` has direct, tenant-scoped, Active/Permanent User Administrator, Conditional Access Administrator and Reports Reader assignments at this historical point. |
| [02-ca001-report-only](../evidence/day-03/02-ca001-report-only.png) | **Full**: initial name `CA001-ExpensePortal-Pilot-Require-MFA`, pilot group include, emergency group exclude, Expense Portal target, authentication-strength grant and Report-only. The dropdown text is truncated but image 03 spells out Multifactor authentication. |
| [03-whatif-anna-ca001-applies](../evidence/day-03/03-whatif-anna-ca001-applies.png) | **Full** for simulation: Anna, Expense Portal, Windows/Browser match initial CA001 in Report-only with Multifactor authentication strength. No runtime enforcement is shown. |
| [04-ca001-report-only-signin-log](../evidence/day-03/04-ca001-report-only-signin-log.png) | **Full**: Anna's September 16 07:43:38 UTC event is Interrupted for the keep-me-signed-in prompt; CA001 Report-only result is User action required. The 07:43:40 UTC event succeeds with the same visible correlation ID. Overall CA Not applied is consistent with Report-only. Application is Expense Portal; resource is Microsoft Graph. |
| [05-anna-mfa-challenge](../evidence/day-03/05-anna-mfa-challenge.png) | **Full** for Anna receiving an Authenticator number-matching prompt. **Partial** for attribution to CA001/Expense Portal: this image alone shows neither application nor policy. |
| [06-anna-expense-portal-after-mfa](../evidence/day-03/06-anna-expense-portal-after-mfa.png) | **Full** for Anna's authenticated Expense Portal session displaying Submitter. The image has no timestamp or authentication-method field. |
| [07-ca001-enforced-success](../evidence/day-03/07-ca001-enforced-success.png) | **Full** for Anna's successful password and mobile-app-notification authentication steps and CA001 Success at September 16 08:54:46 UTC. **Partial** for overall completed sign-in: Basic info explicitly says Interrupted, with the keep-me-signed-in explanation. App access is separately visible in image 06. |
| [08-whatif-high-signin-risk](../evidence/day-03/08-whatif-high-signin-risk.png) | **Full** for simulation: Anna/Expense Portal/Windows/Browser/High risk match CA001 On and CA002 Block access in Report-only. **Inconclusive** for an actual high-risk block, which was not executed in this evidence. |

Findings: preserve the initial and later CA001 names as captured; the rename event/policy-ID continuity is not published. Distinguish successful authentication steps and policy evaluation from the Interrupted overall event in image 07. High-risk blocking remains a simulation, not a runtime result.

## Day 04 — 9 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-authentication-methods-policy](../evidence/day-04/01-authentication-methods-policy.png) | **Full** for enabled methods: Authenticator and SMS for all users, Passkey for two groups, TAP for one group. **Partial** for exact pilot scopes: group names/memberships are not expanded. Email OTP is also enabled; that does not establish use by the workforce. |
| [02-passkey-registration-campaign](../evidence/day-04/02-passkey-registration-campaign.png) | **Full** for displayed Enabled Passkey campaign and selected `SG-Passwordless-Pilot`; one-day snooze and unlimited snoozes shown. No prompted registration session is shown. |
| [03-temporary-access-pass-bootstrap](../evidence/day-04/03-temporary-access-pass-bootstrap.png) | **Full** for TAP creation for Anna, valid for one hour on September 16 (13:28–14:28 as displayed), with credential redacted. **Inconclusive** for actual TAP sign-in or its use to register the passkey. Anna already has Authenticator, an alternative bootstrap method. |
| [04-anna-passkey-registered](../evidence/day-04/04-anna-passkey-registered.png) | **Full**: Anna's Security info lists a device-bound passkey named `ANNA.FEITIAN-KEY03`, plus Authenticator and password. Registration path is not shown. |
| [05-ca003-phishing-resistant-mfa](../evidence/day-04/05-ca003-phishing-resistant-mfa.png) | **Full** for configuration: CA003 On, hardening pilot included, emergency group excluded, Expense Portal targeted, Phishing-resistant MFA strength. |
| [06-peter-weak-authentication-denied](../evidence/day-04/06-peter-weak-authentication-denied.png) | **Full** for Peter's block/additional-methods-required message. **Partial** for CA003/Expense Portal attribution: no application, policy, error detail, timestamp or sign-in log is visible. |
| [07-anna-passkey-expense-portal-success](../evidence/day-04/07-anna-passkey-expense-portal-success.png) | **Full** for Anna's authenticated portal session and displayed Submitter role. Passkey use is corroborated by image 08, not by this application page alone. |
| [08-anna-fido2-signin-log](../evidence/day-04/08-anna-fido2-signin-log.png) | **Full** for device-bound passkey success at September 16 13:06:17 UTC and CA001/CA003 Success. The list shows an Interrupted event followed by Success at 13:06:21 UTC for Anna/Expense Portal; the full second-event correlation detail is not displayed. |
| [09-sspr-pilot-configuration](../evidence/day-04/09-sspr-pilot-configuration.png) | **Full** for SSPR Selected/`SG-Auth-Hardening-Pilot` and two methods required. **Inconclusive** for completed reset, new-password sign-in or password writeback; none is shown. |

Findings: TAP issuance is not evidence of TAP consumption. Peter's denial is visible but its exact CA003/application attribution is only reported. Preserve the existing SSPR configuration-only boundary. A [TAP can bootstrap passwordless registration](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass), but existing MFA can also do so; no inference of the actual bootstrap method is justified here (Microsoft Learn checked 2026-09-25).

## Day 05 — 13 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-external-collaboration-settings](../evidence/day-05/01-external-collaboration-settings.png) | **Full** for displayed restrictive Guest permissions, invitations by specified admin roles only and self-service signup No. Save is active, so this is **Partial** proof of persisted state without a post-save capture/audit. |
| [02-b2b-cross-tenant-audit-logs](../evidence/day-05/02-b2b-cross-tenant-audit-logs.png) | **Full** for successful Add partner, Invite external user, Redeem external user invite events in sequence on September 16 (17:55, 17:58, 18:15 local). **Partial** for attribution: target and initiator detail are not visible. |
| [03-external-contractors-expense-assignment](../evidence/day-05/03-external-contractors-expense-assignment.png) | **Full**: contractor group assigned Expense Submitter in Expense Portal. The cropped list does not establish the complete application assignment inventory. |
| [04-guest-denied-without-group](../evidence/day-05/04-guest-denied-without-group.png) | **Full**: external.auditor denied Expense Portal with AADSTS50105, no applicable direct/group assignment, September 17 04:56:19 UTC. |
| [05-external-contractors-membership](../evidence/day-05/05-external-contractors-membership.png) | **Full**: External Auditor is the one direct Guest member of the contractor group at capture. |
| [06-guest-expense-portal-success](../evidence/day-05/06-guest-expense-portal-success.png) | **Full**: External Auditor's authenticated portal session displays Submitter only. No actual submit or approve operation is shown. |
| [07-cross-tenant-signin](../evidence/day-05/07-cross-tenant-signin.jpg) | **Full**: September 17 05:02:13 UTC successful interactive Expense Portal sign-in, External Auditor/Guest/B2B collaboration; resource Microsoft Graph, CA Not applied. Home/resource tenant IDs are masked; no MFA-claim acceptance detail is shown. |
| [08-cross-tenant-amber-organization](../evidence/day-05/08-cross-tenant-amber-organization.png) | **Full**: Amber partner exists in Baltic Finance. Inbound/outbound are Inherited from default in this capture; it does not show the later custom scope. |
| [09-baltic-inbound-b2b](../evidence/day-05/09-baltic-inbound-b2b.png) | **Full** for custom inbound Allow, one selected user and Expense Portal. **Partial** for user identity because the selected user is masked. |
| [10-amber-inbound-trust](../evidence/day-05/10-amber-inbound-trust.png) | **Full** for customized inbound MFA trust enabled; compliant-device/hybrid-device trust and automatic redemption unchecked. **Inconclusive** for actual acceptance of a partner MFA claim during sign-in. |
| [11-amber-outbound-b2b](../evidence/day-05/11-amber-outbound-b2b.png) | **Full** for Amber outbound Allow to Baltic Finance scoped to External Auditor and one selected external application. **Partial** for application identity: its value is entirely masked. |
| [12-cross-tenant-inbound-denied](../evidence/day-05/12-cross-tenant-inbound-denied.png) | **Full**: inbound Block configuration and external.auditor denied Expense Portal with AADSTS500213, resource-tenant cross-tenant policy, September 17 07:15:55 UTC. Selected configuration user ID is masked. |
| [13-cross-tenant-signin-success](../evidence/day-05/13-cross-tenant-signin-success.png) | **Full**: inbound Allow restored in displayed configuration and later successful interactive External Auditor/Expense Portal sign-in at September 17 07:28:30 UTC; resource Microsoft Graph, CA Not applied. The selected user is masked. |

Findings: the negative/restore sequence has clear timestamps. Exact inbound user/outbound app values cannot be verified through masking. MFA trust is configured, not runtime-proven. A Submitter role is a lab simplification for an auditor, not demonstrated read-only least privilege. Final-state statements refer to Day 05; later governance labs remove this access.

## Day 06 — 11 images

| Image | Visible observation and assessment |
| --- | --- |
| [01-finance-group-expense-portal-assignment](../evidence/day-06/01-finance-group-expense-portal-assignment.png) | **Full**: `SG-Finance-Users` assigned Expense Submitter in Expense Portal. The crop does not establish the application's complete assignment list. |
| [02-au-finance-membership](../evidence/day-06/02-au-finance-membership.jpg) | **Full**: `SG-Finance-Users` is a Security/Assigned/Cloud group in AU-Finance's Groups view. **Inconclusive** for Marc's direct AU user membership; adding the group does not add its users. |
| [03-joiner-finance-group-membership](../evidence/day-06/03-joiner-finance-group-membership.png) | **Full**: Marc Joiner is the single direct Member user of the Finance group at capture. |
| [04-joiner-expense-portal-access](../evidence/day-06/04-joiner-expense-portal-access.png) | **Full** for Marc's authenticated portal session displaying Submitter. **Partial** for freshness/causal group-assignment correlation: no sign-in timestamp or group-add audit is visible. |
| [05-mover-finance-to-it](../evidence/day-06/05-mover-finance-to-it.png) | **Full** for displayed Department IT and `SG-IT-Users` membership for Jan. Manager remains Peter Finance. The visible group panel shows no Finance row but is cropped; the actual denial in image 06 independently supports absence of effective Expense Portal assignment. |
| [06-mover-expense-portal-access-denied](../evidence/day-06/06-mover-expense-portal-access-denied.png) | **Full**: Jan denied Expense Portal with AADSTS50105 on September 17 09:57:16 UTC for no direct/assigned-group entitlement. This verifies a new sign-in denial, not eviction of an old application session. |
| [07-leaver-deprovisioning-completed](../evidence/day-06/07-leaver-deprovisioning-completed.png) | **Full**: Alexandra Disabled, displayed group/application/assigned-role counts all zero; assigned licenses **1**. **Partial** for complete offboarding: no prior state, removal audit, session revocation or retained-data/license disposition shown. |
| [08-leaver-signin-blocked](../evidence/day-06/08-leaver-signin-blocked.png) | **Full** for Alexandra's blocked password prompt with an account-locked message. **Partial** for attribution to account disablement: no error code, timestamp or sign-in detail is visible. |
| [09-au-finance-scoped-user-administrator](../evidence/day-06/09-au-finance-scoped-user-administrator.png) | **Full**: `adm-finance` has direct User Administrator assignment at AU-Finance scope, Permanent, in the Active assignments tab, start September 17 12:30 local as displayed. **Partial** for exclusive privilege scope: other active/eligible role assignments are not inventoried. |
| [10-scoped-admin-finance-success](../evidence/day-06/10-scoped-admin-finance-success.png) | **Full** for signed-in `adm-finance`, Marc's visible Financial Analyst Job title, and enabled edit controls. **Partial** for successful mutation by that actor/in that scope: no update result, audit event or direct AU user membership is displayed. |
| [11-scoped-admin-hr-denied](../evidence/day-06/11-scoped-admin-hr-denied.png) | **Full** for `adm-finance` viewing HR Control User with Edit properties/Delete disabled. **Partial** for the broader management boundary: Reset password is visible, no attempted operation/API denial or AU membership inventory is shown. A visible control alone does not prove an operation would succeed. |

Findings: AU group membership does not imply AU user membership, per [Microsoft's AU scope documentation](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/administrative-units) (checked 2026-09-25). The positive AU write and full negative-operation boundary need runtime/audit evidence. Disabled-account state and a blocked login are supported, but exact failure cause, license disposition and existing-session termination remain open.

## Required lab follow-up

1. If retaining a separately completed Day 01 Anna sign-in claim, publish its corresponding event; otherwise keep it unverified. Expand the Thomas removal event if claiming its independently confirmed success.
2. If claiming business-action authorization, test an allowed submit/approve action and an unprivileged direct request to the protected operation; retain server-side results, not only role labels.
3. Keep CA002 classified as simulation/Report-only. A real risky-sign-in block requires a separate controlled lab test and correlated logs. Capture CA001's policy ID/rename history if exact historical continuity matters.
4. For Day 04, capture actual TAP authentication and the passkey-registration event; capture Peter's application, authentication details and CA003 result. Expand TAP/FIDO2 target groups. Execute SSPR/new-password sign-in separately if claiming runtime recovery.
5. For Day 05, verify saved collaboration restrictions and correlate invitation audit targets/actors. Preserve stable aliases for the masked inbound user/outbound app without changing existing redactions. Require MFA for a guest test and capture evidence of partner claim acceptance before claiming runtime MFA trust.
6. For Day 06, capture direct AU Users membership, effective admin role assignments, a reversible Marc update/restore with Audit Logs and a corresponding harmless HR edit denial. Capture Alexandra's sign-in error code and test revocation of existing sessions if claiming full offboarding; decide whether the retained license is needed for lab/data retention.

None of these follow-ups was performed as part of this repository-only review.
