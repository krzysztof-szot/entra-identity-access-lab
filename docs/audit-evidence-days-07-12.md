# Independent evidence audit — Days 07–12

Review date: 2026-09-25. Every image listed below was opened individually at readable resolution; filenames and earlier descriptions were not accepted as evidence. **Full** means the visible capture supports the stated narrow observation, **Partial** means part of the broader documented claim is not visible, and **Inconclusive** means the capture cannot establish that claim. These are historical screenshot assessments, not fresh tenant tests. Masked identifiers were not reconstructed. Screenshots are unchanged.

## Checkpoint — Day 07 complete (10/10 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-07/01-hybrid-ad-ds-users-group.png) | **Full:** ADUC on `BFL-DC01.bfl.local` shows `Hybrid Finance` in `HybridLab/Users`. | No user properties or timestamps. |
| [02](../evidence/day-07/02-domain-configuration.png) | **Full:** `SG-Hybrid-Finance`, a global security group in `HybridLab/Groups`, lists Hybrid Finance as a member. | Filename does not describe the actual view. |
| [03](../evidence/day-07/03-bfl-dc01-domain-joined.png) | **Full:** Server Manager identifies BFL-DC01, `bfl.local`, Windows Server 2022 Datacenter. | Not an inventory of all installed roles. |
| [04](../evidence/day-07/04-entra-connect-phs-ou-scope.png) | **Full:** Connect wizard selects HybridLab/Users and Groups; other visible OUs are unchecked. | Configuration selection, not export results; PHS settings are not on this page. |
| [05](../evidence/day-07/05-entra-connect-sync-success.png) | **Partial:** Connect configuration succeeded and synchronization was initiated. | Does not say the first synchronization cycle or export finished. |
| [06](../evidence/day-07/06-synchronized-user-entra.png) | **Full:** Hybrid Finance appears as Member with on-premises sync enabled Yes. | UPN truncated; supports user export, not all group exports. |
| [07](../evidence/day-07/07-password-hash-sync-test.png) | **Partial:** My Account displays an authenticated Hybrid Finance session. | No password-change operation, fresh authentication, password version or authentication method visible. |
| [08](../evidence/day-07/08-hybrid-user-expense-portal.png) | **Full:** Expense Portal displays Hybrid Finance and `Expense.Submitter`. | Assignment path and server-side business enforcement not visible. |
| [09](../evidence/day-07/09-hybrid-user-signin-log-ca.png) | **Full:** Hybrid Finance / Expense Portal events on 2026-09-18 show success, Password Hash Sync, successful mobile-app MFA and CA001 Success; CA003 Not applied. | Composite views; masked/truncated identifiers prevent full correlation independently. |
| [10](../evidence/day-07/10-entra-connect-health.png) | **Full:** BFL-DC01 Healthy, zero active alerts and zero sync errors; last export displayed. | Point-in-time health only. |

Day 07 finding: screenshot 05 proves initialization, not a completed sync run. Screenshot 06 corroborates the user's synchronized state. PHS sign-in is supported by 09, but the reported on-premises password-change sequence is not independently captured by 07. No failed tenant outcome is inferred from this evidence gap.

## Checkpoint — Day 08 complete (13/13 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-08/01-entra-registered-dsregcmd.png) | **Full:** BFL-REG01: AzureAdJoined No, DomainJoined No, WorkplaceJoined Yes. | Local prompt is `azureuser1`; cloud identity is not shown here. |
| [02](../evidence/day-08/02-entra-registered-device.png) | **Full:** BFL-REG01 registered; owner Hybrid Finance; MDM None, compliant N/A. | Device identifiers masked. |
| [03](../evidence/day-08/03-ca008-device-filter-report-only.png) | **Full:** CA008 targets Hybrid Finance and Expense Portal, Report-only, Block, exclude `device.trustType -eq "ServerAD"`. | Configuration capture; not runtime enforcement. |
| [04](../evidence/day-08/04-registered-ca-report-only.png) | **Full:** Hybrid Finance / Expense Portal Success at 2026-09-18 12:40:36Z; registered join type; CA008 Report-only Failure. | Device ID masked, so matching it to BFL-REG01 relies on the lab sequence. No enforced registered-device block shown. |
| [05](../evidence/day-08/05-entra-joined-dsregcmd.png) | **Full:** BFL-EJ01 AzureAdJoined Yes, DomainJoined No. | Local prompt `azureuser2`; no cloud identity. |
| [06](../evidence/day-08/06-entra-joined-device-properties.png) | **Full:** BFL-EJ01 joined; Hybrid Finance owner; MDM None, compliant N/A. | IDs masked. |
| [07](../evidence/day-08/07-entra-joined-expense-portal-blocked.png) | **Full:** Hybrid Finance / Expense Portal denied with 53003 at 13:44:24.520Z. | Device and correlation IDs masked. |
| [08](../evidence/day-08/08-entra-joined-ca-block-result.png) | **Full:** Hybrid Finance / Expense Portal Failure at 13:43:18Z, Azure AD joined, CA008 Block Failure. | Different timestamp from 07: same scenario, not a demonstrated exact-event correlation. |
| [09](../evidence/day-08/09-hybrid-device-active-directory.png) | **Full:** BFL-HJ01 computer in `bfl.local/HybridLab/Devices`. | Connect OU-selection update is not shown. |
| [10](../evidence/day-08/10-hybrid-joined-dsregcmd.png) | **Full:** BFL-HJ01.bfl.local AzureAdJoined Yes, DomainJoined Yes, DomainName BFL. | No token/PRT state or timestamp. |
| [11](../evidence/day-08/11-hybrid-device-expense-portal-success.png) | **Partial:** Expense Portal displays Hybrid Finance and Expense.Submitter. | Device and timestamp absent; hybrid device type is supported separately by 12. |
| [12](../evidence/day-08/12-hybrid-device-ca-success.png) | **Full:** Hybrid Finance / Expense Portal Success at 16:26:05Z; Hybrid Azure AD joined; CA001 Success, CA008 Not applied. | Filter exclusion is consistent with 03; log does not show exclusion reasoning or unmasked device ID. |
| [13](../evidence/day-08/13-three-device-identity-types.png) | **Full:** BFL-REG01 registered, BFL-EJ01 joined, BFL-HJ01 hybrid joined; all displayed compliance values N/A. | Inventory says five devices; crop shows four rows including BFL-DC01 registered. It does not prove VM deletion. |

Day 08 finding: local state and runtime join-type scenarios are supported. Masked device IDs prevent independent host-to-log matching. Screenshots 07 and 08 are separate attempts; the configured HybridLab/Devices sync-scope update and VM deletions are reported implementation steps without direct screenshots.

## Checkpoint — Day 09 complete (12/12 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-09/01-conditional-access-admin-pim-settings.png) | **Full:** one-hour Conditional Access Administrator activation, Azure MFA, justification and approval required, one approver; permanent eligible and active assignments allowed at policy level. | Named approver not shown; no fresh MFA challenge. |
| [02](../evidence/day-09/02-adm-lab-eligible-conditional-access-admin.png) | **Full:** adm-lab / Lab Identity Administrator direct Eligible, Baltic Finance scope, Permanent; start 2026-09-21 07:22:05. | Does not inventory other active roles. |
| [03](../evidence/day-09/03-adm-lab-my-roles-eligible.png) | **Full:** adm-lab session, permanent Eligible role with Activate. | Active tab not shown. |
| [04](../evidence/day-09/04-before-pim-activation-no-admin-access.png) | **Full:** adm-lab session gets 401 / insufficient privileges at CA Policies. | Portal denial, not a captured create/update API call. |
| [05](../evidence/day-09/05-pim-activation-request.png) | **Full:** adm-lab activation form: one hour, lab justification. | Form alone does not prove submission; 06 does. |
| [06](../evidence/day-09/06-pim-request-pending-approval.png) | **Full:** Pending approval request at 07:43:12 on 2026-09-21. | No decision yet. |
| [07](../evidence/day-09/07-bg01-pim-approval.png) | **Full:** signed-in pim-approver sees Lab Identity Administrator request and Approve/Deny controls. | Filename mentions bg01 incorrectly; completion is in 10. |
| [08](../evidence/day-09/08-conditional-access-admin-active.png) | **Full:** adm-lab temporary Activated role, end 08:52:42. | Capture does not show other role assignments. |
| [09](../evidence/day-09/09-privileged-action-ca-policy-created.png) | **Partial:** adm-lab can view policy inventory; CA009-PIM-Validation Off, created 08:00:02 within activation window. | Creator-specific audit entry absent; viewing resulting policy alone does not prove adm-lab created it. |
| [10](../evidence/day-09/10-pim-resource-audit-activation.png) | **Full:** request 07:43:12, approval request 07:43:28, approval by PIM Approver 07:52:42, activation complete 07:52:49; all success. | Display names rather than full identifiers. |
| [11](../evidence/day-09/11-pim-automatic-expiration.png) | **Partial:** adm-lab Eligible assignment and Activate remain available. | Eligible view alone does not prove automatic removal; 12 supplies it. |
| [12](../evidence/day-09/12-pim-audit-automatic-expiration.png) | **Full:** Azure AD PIM successfully removed Lab Identity Administrator from role at 08:52:50 with explicit activation-expired action. | No post-expiry CA-denial attempt published. |

Day 09 finding: request, independent approval, activation and automatic expiry have coherent timestamps. Policy creation attribution is only partially evidenced; settings prove MFA requirement, not a fresh MFA prompt. The retained misleading approval filename is already explained correctly.

## Checkpoint — Day 10 complete (19/19 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-10/01-auditor-baseline-no-access.png) | **Full:** SG-External-Contractors has zero direct members. | Does not exclude other application assignments. |
| [02](../evidence/day-10/02-connected-organization-amber.png) | **Full:** Amber Audit Partners Configured, one internal sponsor, connected by adm-lab on 2026-09-21. | Partner directory/domain and sponsor identity not visible. |
| [03](../evidence/day-10/03-external-audit-catalog.png) | **Full:** BFL-External-Audit enabled for external users; zero resources/packages at this stage. | Billing banner requests a linked Azure subscription; linkage not demonstrated. |
| [04](../evidence/day-10/04-catalog-resources.png) | **Partial:** selected security group and Expense Portal in Add resources. | Group name truncated; save/delivery not shown here. |
| [05](../evidence/day-10/05-access-package-resource-roles..png) | **Full:** review/create page for AP-External-Auditor-30D in BFL-External-Audit with group Member and Expense Submitter. | Review screen is configuration; subsequent delivery in 10. |
| [06](../evidence/day-10/06-assignment-policy-approval.png) | **Full:** Amber scope, Self, required requestor/approver justification, one stage, Anna Finance, three days. | Configuration, not an out-of-scope denial test. |
| [07](../evidence/day-10/07-access-package-lifecycle-30d.png) | **Full:** 30-day expiration, no timeline choice, no extension, reviews unchecked. | Natural expiration not tested. |
| [08](../evidence/day-10/08-auditor-access-package-available.png) | **Full:** External Auditor sees package with Request action. | **Inconclusive** for submission timing or Pending state. |
| [09](../evidence/day-10/09-auditor-request-approved.png) | **Full:** Anna approval history shows Approved, auditor request, submitted 2026-09-21 10:08 CEST, business responses and resource roles. | Dimmed backdrop remains readable; no prior Pending capture. |
| [10](../evidence/day-10/10-access-package-assignment.png) | **Full:** External Auditor Delivered, POL-Amber-External-Auditors, Governed, end 10/21/2026 **10:20:44 AM**. | Previous test text incorrectly transcribed 10:24:44. |
| [11](../evidence/day-10/11-auditor-group-membership.png) | **Full:** External Auditor sole direct Guest member. | Membership write/audit actor not pictured. |
| [12](../evidence/day-10/12-auditor-expense-portal-assignment.png) | **Full:** External Auditor directly assigned Expense Submitter on Expense Portal. | No assignment audit operation. |
| [13](../evidence/day-10/13-auditor-expense-portal-access.png) | **Full:** auditor portal session with Expense.Submitter. | No fresh sign-in timestamp or business transaction. |
| [14](../evidence/day-10/14-conditional-access-terms-of-use.png) | **Full:** enabled CA-External-Auditor-ToU targets contractor group and Expense Portal; named ToU selected. | Configuration, not acceptance record. |
| [15](../evidence/day-10/15-auditor-terms-of-use.png) | **Full:** auditor sees Terms of Use, Accept/Decline. | No acceptance action captured. |
| [16](../evidence/day-10/16-terms-of-use-ca-success.png) | **Full:** auditor Expense Portal Success at 2026-09-21 11:13:55Z; ToU policy Success. | Supports satisfied grant, not separate acceptance-report entry. |
| [17](../evidence/day-10/17-access-package-assignment-removed.png) | **Partial:** assignment Expired, original future end **10:20:44 AM**, Governed. | Manual-removal action itself not shown; interpretation relies on recorded lab sequence and subsequent denial, not natural expiry. |
| [18](../evidence/day-10/18-auditor-group-membership-removed.png) | **Full:** contractor group zero direct members. | No membership-removal audit record. |
| [19](../evidence/day-10/19-auditor-expense-portal-denied.png) | **Full:** auditor Expense Portal AADSTS50105 at 2026-09-21 11:52:41Z; no qualifying direct/group assignment. | Does not prove guest deletion or immediate invalidation of existing sessions. |

Day 10 finding: assignment end-time transcription corrected to 10:20:44. Current documentation already distinguishes package discovery from Pending, manual removal from scheduled expiration, and the lab Submitter role from read-only audit access. Manual-removal actor and guest-governance subscription linkage remain unproven in these captures.

## Checkpoint — Day 11 complete (16/16 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-11/01-contractor-group-before-review.png) | **Full:** contractor group zero direct members. | No timestamp. |
| [02](../evidence/day-11/02-contractor-group-membership-restored.png) | **Full:** External Auditor sole direct Guest member. | Addition operation not pictured. |
| [03](../evidence/day-11/03-auditor-expense-portal-access-before-review.png) | **Full:** auditor portal session with Expense.Submitter. | No timestamp or sign-in freshness evidence. |
| [04](../evidence/day-11/04-access-review-scope.png) | **Full:** Teams + Groups, SG-External-Contractors, Guests only, inactive filter off. | Guest-governance subscription banner; billing linkage not shown. |
| [05](../evidence/day-11/05-access-review-reviewer-and-schedule.png) | **Full:** Anna reviewer, single stage, one day, one time, starts 2026-09-21. | Does not show subsequent completion. |
| [06](../evidence/day-11/06-access-review-completion-settings.png) | **Partial:** auto-apply off; no-response No change; membership removal label truncated; 30-day activity helper, justification, notifications/reminders on. | Full denied-user option text clipped. |
| [07](../evidence/day-11/07-access-review-created.png) | **Full:** AR-External-Contractors-Q3-2026 for intended group, Not started, created 2026-09-21. | Not completed state. |
| [08](../evidence/day-11/08-reviewer-pending-access-review.png) | **Full:** Anna reviewer task for auditor, recommendation Approve, decision empty. | No decision timestamp. |
| [09](../evidence/day-11/09-reviewer-denied-auditor-access.png) | **Full:** Anna Denied at 2026-09-21 15:11 CEST, completed-engagement justification; recommendation Approve. | Last-sign-in helper says Sep 17 despite later Day10 sign-ins; helper is a captured recommendation signal, not a complete live sign-in history. |
| [10](../evidence/day-11/10-auditor-access-before-results-applied.png) | **Partial:** auditor portal still displays Expense.Submitter. | No timestamp or new-sign-in proof; cannot independently establish Deny-before-Apply order or active entitlement from a retained session. |
| [11](../evidence/day-11/11-access-review-decision-results.png) | **Full:** Denied by Anna, recommendation Approve; Apply result blank. | No exact capture time. |
| [12](../evidence/day-11/12-access-review-results-applied.png) | **Full:** named review Result applied. | Membership-level operation not visible. |
| [13](../evidence/day-11/13-contractor-membership-removed.png) | **Full:** zero direct group members. | No timestamp/member-removal audit. |
| [14](../evidence/day-11/14-auditor-expense-portal-access-denied.png) | **Full:** auditor Expense Portal AADSTS50105 at 2026-09-22 04:45:42Z. | Correlation identifiers masked. |
| [15](../evidence/day-11/15-auditor-denied-sign-in-log.png) | **Full:** same 04:45:42Z, auditor / Expense Portal Failure, 50105 assignment-denial reason. | Masked request IDs; user/app/time/error provide corroboration. |
| [16](../evidence/day-11/16-access-review-apply-audit-log.png) | **Full:** Access Reviews Apply review Success by Identity Governance for named review, 2026-09-21 21:15:17 local. | No individual group-member-removal action; local timezone not shown. |

Day 11 finding: applied-review and later sign-in denial supported, with user/app/time/error correlation. D11-09's original Pass exceeded what an untimestamped retained-session screenshot establishes; record it as partial evidence and request a fresh sign-in plus timestamped membership between Deny and Apply.

## Checkpoint — Day 12 complete (16/16 images)

| Image | Visible observation and assessment | Limitations |
| --- | --- | --- |
| [01](../evidence/day-12/01-delegated-user-read.png) | **Full:** Expense Portal API permissions show User.Read Delegated, Granted for Baltic Finance Lab. | Consent status, not the consent action. |
| [02](../evidence/day-12/02-delegated-admin-consent.png) | **Full:** same permission/consent view as 01. | Byte-identical to 01, independently confirmed by SHA-256; not a second event. |
| [03](../evidence/day-12/03-enterprise-app-permissions.png) | **Full:** Expense Portal enterprise app User.Read Delegated, Admin consent, granted by administrator. | No user-consent prompt or all-tenant grant inventory. |
| [04](../evidence/day-12/04-graph-explorer-anna-profile.png) | **Full:** Graph Explorer GET `/me` with selected fields, HTTP 200, Anna Finance / Financial Analyst / Finance, mail and office null. | Separate OAuth client; not an Expense Portal token test. |
| [05](../evidence/day-12/05-app-service-token-store.png) | **Full:** bfl-expense-ks01 Authentication Enabled, Require authentication, redirect Microsoft, Token store Enabled, Expense Portal provider. | Provider credential configuration not shown. |
| [06](../evidence/day-12/06-graph-scope-configuration.png) | **Full:** ARM GET authsettingsV2 for bfl-expense-ks01; loginParameters request code/id_token and openid, offline_access, profile, Graph User.Read. | Partial configuration response; no credential state or successful token renewal. |
| [07](../evidence/day-12/07-anna-graph-profile.png) | **Full:** app displays Anna, Expense.Submitter, own profile and Graph HTTP 200 / Delegated / User.Read. | App-displayed diagnostics, not independent backend source or JWT validation. |
| [08](../evidence/day-12/08-anna-graph-api-response.png) | **Full:** `/graph/profile` JSON displays Anna profile, source Microsoft Graph, permissionModel Delegated. | Source implementation and underlying Graph response headers not shown. |
| [09](../evidence/day-12/09-peter-graph-profile.png) | **Full:** Peter, Submitter and Approver, Peter profile / Finance Manager / Finance, displayed HTTP 200 / Delegated / User.Read. | Business transaction enforcement and delegated claims not independently captured. |
| [10](../evidence/day-12/10-delegated-vs-application-permissions.png) | **Full:** User.Read Delegated Granted, User.Read.All Application Not granted. | Does not show token issuance. |
| [11](../evidence/day-12/11-application-admin-consent.png) | **Full:** consent success banner; User.Read.All Application now Granted. | Approving identity not displayed. |
| [12](../evidence/day-12/12-client-credentials-graph-users.png) | **Partial:** bearer request to Graph `/users?$select=displayName,userPrincipalName&$top=5` returns five identities. | Starts with pre-existing tokenResponse; acquisition request and token client/tenant binding not published. |
| [13](../evidence/day-12/13-app-only-me-denied.png) | **Full:** GET `/me` using headers catches response status BadRequest. | Broad catch labels any failure expected; error body omitted, so precise cause unverified. |
| [14](../evidence/day-12/14-app-only-token-claims.png) | **Partial:** `$claims` projection shows Graph audience, User.Read.All roles, blank scp and expiry value. | No decode code, client ID, issuer, signature verification or distinction between absent/empty scp. |
| [15](../evidence/day-12/15-least-privilege-final-state.png) | **Partial:** configured list now contains only granted delegated User.Read. | No independent credential-deletion or service-principal consent-revocation action. |
| [16](../evidence/day-12/16-final-expense-portal-graph.png) | **Partial:** Anna session still displays Submitter, own profile, HTTP 200 / Delegated / User.Read. | No timestamp, fresh redemption, token expiry/renewal or proof of post-cleanup credential functionality. |

Day 12 finding: screenshots support permission/consent states, displayed profiles and REST outcomes. They do not independently prove token-acquisition implementation, client attribution, all cleanup actions or fresh post-cleanup authentication. Existing operator reports were retained as reports; corresponding test outcomes are Partial evidence. Displayed `BadRequest` is consistent with app-only `/me` limitations but is not a captured Graph error explanation.

## Technical sources checked on 2026-09-25

- [Microsoft Graph Get user](https://learn.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0): `/me` requires a signed-in user and delegated permission; Application permissions are unsupported. This supports the expected negative case, not the uncaptured error body.
- [Manage OAuth tokens in App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-oauth-tokens): token store/provider credential and refresh-token requirements explain why a working retained session does not validate fresh token exchange after cleanup. Historical observed sessions remain valid observations.

## Audit completion and follow-up

All 18 owned day documentation/test/evidence-index files were read and all **86/86** screenshots were visually inspected. Root README and access matrix were read for cross-day context. No screenshots were modified; no Entra or Azure operations were executed.

Confirmed corrections: Day 07 sync initialization and password-change evidence boundary; Day 08 distinct denial-event timestamps; Day 09 creator attribution marked partial; Day 10 exact end-time transcription; Day 11 pre-Apply retained-session result marked partial; Day 12 token-acquisition, claim-display, cleanup and fresh-session limits aligned across docs/tests/evidence.

Remaining lab evidence: password-change/fresh-PHS chronology; optional exact host-to-log pseudonymous correlation and Connect device-OU scope capture; CA009 creator audit; timestamped membership plus fresh sign-in between Deny and Apply; sanitized client-credentials acquisition and Graph error detail; fresh delegated code redemption and renewal after verifying provider credential and grant state. Guest-governance billing linkage was not independently shown. Existing deferred natural 30-day expiration, standalone Terms of Use acceptance report and group-member-removal audit remain untested/unpublished as already documented.

Local validation: all relative Markdown links resolve across the 18 owned files and this report; all 86 image filenames occur in the inventory. Day 12 images 01/02 have matching SHA-256 hashes. The owned-file diff was reviewed. `git -c core.whitespace=-blank-at-eol diff --check` passes with the repository's existing Markdown two-space hard-break convention allowed; ordinary `git diff --check` flags those intentional hard breaks on changed test lines. These are local documentation checks, not tenant test results.
