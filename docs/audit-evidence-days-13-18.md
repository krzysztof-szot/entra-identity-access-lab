# Independent evidence audit — Days 13–18

Audit date: 2026-09-25. Screenshots were opened visually at readable size, individually in day batches. Original files and masking were preserved. `Full` means the visible image supports the stated narrow observation, not every implementation claim. `Partial` identifies a supported observation with material missing context; `Inconclusive` means the claimed result cannot be resolved. Portal configuration is not runtime proof, and printed PASS text is not an independent review of unavailable source. Redacted values were not inferred.

## Review checkpoints

- Day 13: all 17 images and all three day text files reviewed.
- Day 14: all 21 images and all three day text files reviewed.
- Day 15: all 16 images and all three day text files reviewed.
- Day 16: all 17 images and all three day text files reviewed; five KQL transcriptions compared.
- Day 17: all 17 images and all three day text files reviewed.
- Day 18: all 24 images and all three day text files reviewed; KQL transcription compared.
- Total: 112 original images visually reviewed; no tenant operations executed.

## Day 13

The resource, identity attachment, RBAC and workload sign-in observations are consistent. The published job follows the visible role-change timestamp. The write test has only a self-reported handled-denial result; retain it as partial pending the raw Storage authorization error and runbook source. Complete runbook source is absent, so claims about all credential paths cannot be independently inspected.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-storage-account-created.png](../evidence/day-13/01-storage-account-created.png) | Full | Completed Storage deployment for `bflmi13a7k29`, resource group `rg-bfl-identity-lab`, 22 September 2026. |
| [02-private-blob-container.png](../evidence/day-13/02-private-blob-container.png) | Partial | `identity-lab/bfl-identity-proof.txt` visible; portal uses Access key. Anonymous-access setting and blob content are not displayed. |
| [03-automation-account-created.png](../evidence/day-13/03-automation-account-created.png) | Full | Automation deployment completed; `aa-bfl-identity-lab` created. |
| [04-system-assigned-managed-identity.png](../evidence/day-13/04-system-assigned-managed-identity.png) | Full | System-assigned identity On for `aa-bfl-identity-lab`; principal ID masked. |
| [05-managed-identity-service-principal.png](../evidence/day-13/05-managed-identity-service-principal.png) | Full | Enterprise Application named `aa-bfl-identity-lab`; IDs masked, so exact ID correlation cannot be repeated. |
| [06-managed-identity-rbac-denied.png](../evidence/day-13/06-managed-identity-rbac-denied.png) | Partial | Test reports MI authentication success and Blob access failure with raw 403 / AuthorizationPermissionMismatch. No pre-assignment RBAC inventory or timestamp visible. |
| [07-managed-identity-storage-rbac.png](../evidence/day-13/07-managed-identity-storage-rbac.png) | Full | `aa-bfl-identity-lab` has Storage Blob Data Reader at This resource on the named Storage Account. |
| [08-managed-identity-blob-access-success.png](../evidence/day-13/08-managed-identity-blob-access-success.png) | Partial | Completed test reports Blob read and BFL-MI-READ-SUCCESS. Full executed source and token identity are not shown. |
| [09-runbook-published.jpg](../evidence/day-13/09-runbook-published.jpg) | Full | Runbook Published, PowerShell, runtime named re-bfl-ps74, modified 08:31 on 22 September; Recent Jobs empty at capture. |
| [10-published-runbook-job-success.png](../evidence/day-13/10-published-runbook-job-success.png) | Partial | Separate job created 08:33, Completed with read-success output and marker. The job source snapshot is not included. |
| [11-storage-role-assignment-activity.png](../evidence/day-13/11-storage-role-assignment-activity.png) | Partial | Create role assignment Succeeded at 08:21 local time; actor partly masked and role/principal details unopened. Chronology precedes published job. |
| [12-user-assigned-identity-created.png](../evidence/day-13/12-user-assigned-identity-created.png) | Full | `mi-bfl-shared-reader` is Microsoft.ManagedIdentity/userAssignedIdentities in the lab group; IDs masked. |
| [13-user-assigned-identity-attached.png](../evidence/day-13/13-user-assigned-identity-attached.png) | Full | User-assigned list on Automation Account contains `mi-bfl-shared-reader`. |
| [14-user-assigned-identity-success.png](../evidence/day-13/14-user-assigned-identity-success.png) | Partial | Completed test reports the named user-assigned identity, successful read and proof marker; name is script output. |
| [15-managed-identity-write-denied.png](../evidence/day-13/15-managed-identity-write-denied.png) | Partial | Completed test prints attempted upload and expected denial; no raw service error or exception-filtering source. Cannot establish that a Storage authorization denial, rather than another caught error, caused this result. |
| [16-managed-identity-sign-in-log.png](../evidence/day-13/16-managed-identity-sign-in-log.png) | Full | Managed identity tab shows both named identities with Success to Storage and Resource Manager; UTC timestamps visible, IDs masked. Confirms authentication only. |
| [17-user-assigned-identity-code.png](../evidence/day-13/17-user-assigned-identity-code.png) | Partial | Visible code uses Connect-AzAccount -Identity -AccountId $userAssignedClientId -ErrorAction Stop and runtime PowerShell 7.4. Client ID value, storage call and remainder of source are not visible. |


## Day 14

Checkpoint: all 21 images and all three day text files reviewed. Proxy runtime success and assignment denial are supported; earlier captures include disabled-service banners and Report-only configuration, so capture numbering cannot establish a complete state-transition timeline. Password replay remains a historical reported observation; screenshot 21 independently verifies only the destination session.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-oidc-app-registration.png](../evidence/day-14/01-oidc-app-registration.png) | Full | Expense Portal Web callback ending /.auth/login/aad/callback and Single tenant only; hostname partly masked. |
| [02-oidc-successful-signin.png](../evidence/day-14/02-oidc-successful-signin.png) | Full | Anna Finance session, Expense.Submitter and Graph profile reporting HTTP 200 / Delegated User.Read; no raw protocol trace. |
| [03-oidc-signin-log.png](../evidence/day-14/03-oidc-signin-log.png) | Full | Anna / Expense Portal / Microsoft Graph success 22 September 08:06:45Z; MFA satisfied by token claim; CA001 and CA003 Success, not a new prompt. |
| [04-saml-configuration.png](../evidence/day-14/04-saml-configuration.png) | Full | Toolkit entity ID, ACS, sign-on URL and user.userprincipalname NameID configured. |
| [05-saml-successful-sso.png](../evidence/day-14/05-saml-successful-sso.png) | Partial | Toolkit greeting Anna and BFL SAML Lab Success at 09:12:29Z; no assertion or session-to-event correlation ID. |
| [06-linked-sso-redirect.png](../evidence/day-14/06-linked-sso-redirect.png) | Full | Linked URL, Anna's tile and Expense Portal destination visible; screenshot does not capture click itself. |
| [07-internal-web-application.png](../evidence/day-14/07-internal-web-application.png) | Partial | localhost serves static page identifying BFL-APP01; page text alone is not server inventory or backend SSO. |
| [08-private-network-connector.png](../evidence/day-14/08-private-network-connector.png) | Partial | BFL-APP01 Active in Default; banner also says Private Network disabled. This is not a final enabled-state capture. |
| [09-connector-group.png](../evidence/day-14/09-connector-group.png) | Full | BFL-Internal-Apps with BFL-APP01 Active and one application; control says Disable private network connectors. |
| [10-application-proxy-configuration.png](../evidence/day-14/10-application-proxy-configuration.png) | Partial | localhost backend, HTTPS msappproxy URL, Entra pre-authentication and intended group; Private Network disabled banner still visible. No capture timestamp resolves state order. |
| [11-proxy-app-assignment.png](../evidence/day-14/11-proxy-app-assignment.png) | Full | SG-APP-InternalPortal assigned as User. |
| [12-proxy-conditional-access.png](../evidence/day-14/12-proxy-conditional-access.png) | Full | Named MFA policy targets SG-APP-InternalPortal and proxy app; Require MFA, Report-only at capture. |
| [13-proxy-successful-access.png](../evidence/day-14/13-proxy-successful-access.png) | Partial | Static portal at external msappproxy URL. User identity not displayed; Anna attribution is supported separately by 15. |
| [14-proxy-access-denied.png](../evidence/day-14/14-proxy-access-denied.png) | Full | Peter / BFL Internal Portal - Proxy AADSTS50105 missing assignment, 11:18:50Z; request IDs masked. |
| [15-proxy-signin-logs.png](../evidence/day-14/15-proxy-signin-logs.png) | Full | Anna proxy success 11:17:33Z with named MFA policy Success; Peter failure 11:18:50Z despite correct password. |
| [16-provisioning-attribute-mappings.png](../evidence/day-14/16-provisioning-attribute-mappings.png) | Full | Selected users, SG-APP-Provisioning-Pilot, UPN-to-userName matching precedence 1 and jobTitle-to-title mapping. |
| [17-provisioning-on-demand.png](../evidence/day-14/17-provisioning-on-demand.png) | Full | Anna all five stages Success; title updated to Senior Finance Analyst in customappsso. Initial creation not demonstrated. |
| [18-provisioning-deprovisioning.png](../evidence/day-14/18-provisioning-deprovisioning.png) | Full | Anna Assigned False, IsActive True, RedundantSoftDelete skip; separate Disable Success log at 17:19:34 local. No target-side final account screen. |
| [19-password-based-sso-configuration.png](../evidence/day-14/19-password-based-sso-configuration.png) | Full | Password SSO app login URL and detected sign-in form. |
| [20-password-sso-myapps-assignment.png](../evidence/day-14/20-password-sso-myapps-assignment.png) | Full | Anna My Apps contains legacy Password SSO tile. |
| [21-password-based-sso.png](../evidence/day-14/21-password-based-sso.png) | Partial | Test site /secure shows successful session; neither acting Entra identity nor credential-replay step is visible. Cannot independently distinguish replay from manual sign-in. |


## Day 15

Checkpoint: all 16 images and all three day text files reviewed. Existing text correctly limits the Internet block to the earlier policy state and distinguishes catalog review from Cloud Discovery. Exact central-to-client private transaction correlation and the SharePoint acting identity are not visible in the supplied crops. No substantive configuration discrepancy established.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-gsa-pilot-group.png](../evidence/day-15/01-gsa-pilot-group.png) | Full | SG-GSA-Pilot shows one direct Member: Anna Finance. |
| [02-gsa-traffic-forwarding-final-state.png](../evidence/day-15/02-gsa-traffic-forwarding-final-state.png) | Full | Microsoft, Private and Internet profiles enabled; one group each. Private last modified 09:51 on 23 September, after captured private traffic. |
| [03-microsoft-traffic-pilot-assignment.png](../evidence/day-15/03-microsoft-traffic-pilot-assignment.png) | Partial | Traffic forwarding breadcrumb and SG-GSA-Pilot Default Access assignment; application/profile name not visible. |
| [04-gsa-client-connected.png](../evidence/day-15/04-gsa-client-connected.png) | Full | Anna, Baltic Finance Lab, Entra Joined; Entra/M365/Private/Internet channels Connected; device ID masked. |
| [05-gsa-microsoft-traffic-verification.png](../evidence/day-15/05-gsa-microsoft-traffic-verification.png) | Full | Anna Microsoft 365 / Entra Allow connections around 07:41–07:44 local on 23 September; addresses partly masked. |
| [06-private-access-app-configuration.png](../evidence/day-15/06-private-access-app-configuration.png) | Full | BFL-Internal-Finance; CG-BFL-PrivateAccess - Europe; client enabled; 10.20.0.4:80 TCP segment Success. |
| [07-private-app-access-by-ip.png](../evidence/day-15/07-private-app-access-by-ip.png) | Partial | HTTP 10.20.0.4 serves page labeled BFL-CON01; no user identity or network route in page. |
| [08-private-access-client-traffic.png](../evidence/day-15/08-private-access-client-traffic.png) | Full | msedge.exe TCP 10.20.0.4:80, Private Access, Tunnel, around 08:06. Demonstrates route separately from page. |
| [09-private-access-central-traffic-logs.png](../evidence/day-15/09-private-access-central-traffic-logs.png) | Partial | Anna Private Allow transactions at 08:09 local; destination and correlation fields not shown, so not exact transaction correlation to 08. |
| [10-internet-access-block-policy.png](../evidence/day-15/10-internet-access-block-policy.png) | Full | example.org/www.example.org rule, enabled SP-GSA-Web and scoped On CA policy; profile last modified 10:52. |
| [11-internet-access-blocked-traffic.png](../evidence/day-15/11-internet-access-blocked-traffic.png) | Partial | Anna example.org Block around 10:22, other destinations Allow; earlier than profile modification, no final-version retest. |
| [12-cloud-app-catalog-risk-analysis.png](../evidence/day-15/12-cloud-app-catalog-risk-analysis.png) | Full | Dropbox catalog security score 10 and factors; no discovered usage or sanction action. |
| [13-oauth-app-permissions-review.png](../evidence/day-15/13-oauth-app-permissions-review.png) | Full | Expense Portal Microsoft Graph User.Read Delegated through Admin consent; no Defender OAuth enforcement. |
| [14-ca-mdca-session-control.png](../evidence/day-15/14-ca-mdca-session-control.png) | Full | On CA policy scopes SG-GSA-Pilot and SharePoint to custom Conditional Access App Control. |
| [15-mdca-block-download-policy.png](../evidence/day-15/15-mdca-block-download-policy.png) | Full | MDCA-Block-Download; filename contains BFL-Test-Download.docx; Inspection None; Block. No activity-source filter selected in displayed form. |
| [16-mdca-download-blocked.png](../evidence/day-15/16-mdca-download-blocked.png) | Partial | SharePoint shows Defender Download blocked for the exact file. User, request timestamp and matched policy ID not displayed; narrow denial observed. |


## Day 16

Checkpoint: all 17 images and all three day text files reviewed. Text correctly distinguishes historical records, new ingestion, MFA denial and separate 50126 event. The screenshot queries were read directly; no tenant query was executed during this audit. Workbook source remains unavailable for implementation review. No substantive evidence contradiction established.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-failed-signin-investigation.png](../evidence/day-16/01-failed-signin-investigation.png) | Full | Peter proxy sign-in 22 September 11:18:50Z; 50105 assignment denial; correct password. |
| [02-conditional-access-investigation.png](../evidence/day-16/02-conditional-access-investigation.png) | Full | Anna Expense Portal / Graph 09:20:45Z Success; token claim satisfies MFA; CA001/CA003 Success. |
| [03-role-and-pim-audit.png](../evidence/day-16/03-role-and-pim-audit.png) | Full | adm-lab approval request success on 21 September, one-hour requested interval and Day 09 justification; not completed activation. |
| [04-guest-activity-investigation.png](../evidence/day-16/04-guest-activity-investigation.png) | Full | External Auditor Guest/B2B; Expense Portal 50105 at 04:45:42Z; correct password, assignment missing. |
| [05-expense-portal-signins.png](../evidence/day-16/05-expense-portal-signins.png) | Full | Historical internal/guest Success, Interrupted, Failure rows; CA Success/not applied differ by event. |
| [06-log-analytics-workspace.png](../evidence/day-16/06-log-analytics-workspace.png) | Full | law-bfl-identity Active, lab resource group, Poland Central, Pay-as-you-go. |
| [07-diagnostic-settings.png](../evidence/day-16/07-diagnostic-settings.png) | Full | Audit, SignIn, NonInteractive and Provisioning selected to workspace; ServicePrincipal/ManagedIdentity unchecked. Configuration only. |
| [08-successful-test-signin.png](../evidence/day-16/08-successful-test-signin.png) | Full | Anna Expense.Submitter, Senior Finance Analyst, Graph HTTP 200 / Delegated User.Read displayed. |
| [09-failed-test-signin.png](../evidence/day-16/09-failed-test-signin.png) | Full | Peter Request denied Authenticator interaction; no event ID/application/time visible. |
| [10-kql-failed-signins.png](../evidence/day-16/10-kql-failed-signins.png) | Full | Visible 7-day SigninLogs query and Peter Expense Portal 50126 invalid-credentials row at 23 September 14:37:05.694 UTC. |
| [11-kql-authentication-failures-by-user.png](../evidence/day-16/11-kql-authentication-failures-by-user.png) | Full | countif aggregation: Peter failed 1/success 0, adm-lab failed 0/success 1. |
| [12-kql-conditional-access.png](../evidence/day-16/12-kql-conditional-access.png) | Full | 7-day CA aggregate shows notApplied 2, limited to ingested records. |
| [13-kql-audit-activity-summary.png](../evidence/day-16/13-kql-audit-activity-summary.png) | Full | AuditLogs operation counts show Execution, Import and other activity; not a PIM-change query. |
| [14-kql-application-signins.png](../evidence/day-16/14-kql-application-signins.png) | Full | AppDisplayName contains Expense query returns same Peter 50126/notApplied event as 10. |
| [15-conditional-access-workbook.png](../evidence/day-16/15-conditional-access-workbook.png) | Full | law-bfl-identity workbook, last 24 hours, all enabled policies, two users Not applied; missing service-principal export warning. |
| [16-custom-identity-workbook.png](../evidence/day-16/16-custom-identity-workbook.png) | Partial | Named Workbook with 6 successful/1 failed, notApplied 7, Azure Portal 6/Expense Portal 1. Underlying saved JSON and individual queries absent. |
| [17-identity-secure-score-and-recommendations.png](../evidence/day-16/17-identity-secure-score-and-recommendations.png) | Full | 43.82%, All 14/Security 13; visible risk and MI recommendations. Baseline only. |


## Day 17

Checkpoint: all 17 images and all three day text files reviewed. Historical creation, group membership and role-authorization observations agree with the screenshots. Day 17-only export and cleanup gaps must remain historical; Day 18 provides separate follow-up evidence. Revised repository scripts and offline checks are not tenant reruns. Raw CSV contents are unavailable for completeness inspection.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-graph-powershell-installed.png](../evidence/day-17/01-graph-powershell-installed.png) | Full | PowerShell 7.6.6; Microsoft.Graph.Authentication/Connect-MgGraph 2.40.0. |
| [02-graph-delegated-connection.png](../evidence/day-17/02-graph-delegated-connection.png) | Full | adm-lab delegated Read mode, actual context includes write scopes; no Policy.Read.All in list. |
| [03-graph-read-users-groups-apps.png](../evidence/day-17/03-graph-read-users-groups-apps.png) | Full | Get-MgUser/Group/Application return selected named objects; read operations only. |
| [04-graph-user-created.png](../evidence/day-17/04-graph-user-created.png) | Full | Existing graph.operator, IT, enabled, Identity Automation Test User; explicitly User already exists, not creation console. |
| [05-graph-user-idempotency.png](../evidence/day-17/05-graph-user-idempotency.png) | Full | Rerun returns User already exists for graph.operator. |
| [06-graph-security-group-created.png](../evidence/day-17/06-graph-security-group-created.png) | Full | Creation output and Graph properties: SecurityEnabled True, MailEnabled False, empty GroupTypes; IsAssignableToRole blank, not explicit false. |
| [07-graph-group-validation.png](../evidence/day-17/07-graph-group-validation.png) | Full | Cloud Security Assigned group, zero direct members, created 24 September 08:47 local. |
| [08-graph-group-membership.png](../evidence/day-17/08-graph-group-membership.png) | Full | Member added, independent ID comparison code returns verified, rerun returns already member. |
| [09-graph-group-membership-portal.png](../evidence/day-17/09-graph-group-membership-portal.png) | Full | One direct member Graph Automation Operator; object ID masked. |
| [10-graph-role-definition.png](../evidence/day-17/10-graph-role-definition.png) | Full | Conditional Access Administrator definition and description returned. |
| [11-graph-role-assignment-dry-run.png](../evidence/day-17/11-graph-role-assignment-dry-run.png) | Partial | Named target/role/tenant and no-assignment message; absent write inferred from historical script behavior, no before/after audit here. |
| [12-graph-role-assignment-denied.png](../evidence/day-17/12-graph-role-assignment-denied.png) | Full | adm-lab, -Execute/ASSIGN, 403 Authorization_RequestDenied at 24 September 07:38:26Z. |
| [13-graph-role-assignment-authorized.png](../evidence/day-17/13-graph-role-assignment-authorized.png) | Full | roleops-lab delegated RoleManagement.ReadWrite.Directory; ASSIGN; created assignment with DirectoryScopeId / and CA role definition ID. |
| [14-graph-tenant-export.png](../evidence/day-17/14-graph-tenant-export.png) | Partial | Six categories report exported; CA skipped missing Policy.Read.All. CSV contents not published; export reports are not completeness inspection. |
| [15-graph-applications-query.png](../evidence/day-17/15-graph-applications-query.png) | Full | Separate app and service-principal queries show Expense Portal, BFL SAML Lab, BFL Provisioning Lab. |
| [16-graph-conditional-access-query.png](../evidence/day-17/16-graph-conditional-access-query.png) | Full | Eight policies listed; CA002 report-only, CA009 disabled, others enabled. No CSV output shown. |
| [17-graph-automation-audit-logs.png](../evidence/day-17/17-graph-automation-audit-logs.png) | Full | Add user Success at 08:33 local, target graph.operator, actor adm-lab / Microsoft Graph Command Line Tools; IDs masked. |


## Day 18

Checkpoint: all 24 images and all three day text files reviewed. Role cleanup is independently supported by the removal audit and empty Active list. Custom emergency-exclusion output lacks its implementation and membership inputs; only its reported values can be audited. The Storage warning area is masked and does not establish warning remediation. KQL and portal show matching policy outcomes on different sign-ins. Existing credential-refresh and natural-expiration limitations remain valid.

| Image | Support | Visible observation and limitation |
| --- | --- | --- |
| [01-assessment-baseline.png](../evidence/day-18/01-assessment-baseline.png) | Full | Baltic Finance Lab overview: P2 label, 20 users, 19 groups, 13 apps, 5 devices; IDs masked. Tenant label is not per-user feature-license verification. |
| [02-graph-inventory.png](../evidence/day-18/02-graph-inventory.png) | Partial | adm-lab historical export prints all seven categories including CA. CSV contents and completeness not inspectable. |
| [03-privileged-role-inventory.png](../evidence/day-18/03-privileged-role-inventory.png) | Full | adm-lab Direct, Permanent Eligible CA Administrator. |
| [04-standing-privilege-assessment.png](../evidence/day-18/04-standing-privilege-assessment.png) | Full | Unfiltered CA Administrator Active assignments: No results; role-specific snapshot only. |
| [05-privilege-remediation.png](../evidence/day-18/05-privilege-remediation.png) | Full | Remove member from role Success 24 September 09:51:24 local; target graph.operator, old role CA Administrator; confirms cleanup. |
| [06-break-glass-assessment.png](../evidence/day-18/06-break-glass-assessment.png) | Partial | bg01/bg02 Permanent Active GA shown. Custom console lists ten policies, direct False/group True/effective True; source, group identifiers and membership calculation absent, so effective exclusions cannot be independently recalculated. |
| [07-pim-current-state.png](../evidence/day-18/07-pim-current-state.png) | Full | Tenant Eligible list confirms adm-lab permanent/direct CA Administrator. |
| [08-pim-security-settings.png](../evidence/day-18/08-pim-security-settings.png) | Full | 1-hour max, MFA, justification, approval, PIM Approver; permanent Active allowed; configuration, not fresh activation test. |
| [09-authentication-methods-review.png](../evidence/day-18/09-authentication-methods-review.png) | Full | FIDO2 two groups, Authenticator/SMS all users, TAP one group, Email OTP all users enabled; group identities not shown. |
| [10-phishing-resistant-mfa.png](../evidence/day-18/10-phishing-resistant-mfa.png) | Full | CA003 On, Expense Portal, phishing-resistant strength; specific users included/excluded, so not every app user covered. |
| [11-conditional-access-inventory.png](../evidence/day-18/11-conditional-access-inventory.png) | Full | Nine policies, CA002 Report-only and CA009 Off; no CA010 here. Creation/modified columns visible, some times truncated. |
| [12-conditional-access-what-ifvalidation.png](../evidence/day-18/12-conditional-access-what-ifvalidation.png) | Full | Anna / Expense Portal / Windows / Browser; CA001/CA003 predicted On with strengths. Simulation only. |
| [13-conditional-access-validation.png](../evidence/day-18/13-conditional-access-validation.png) | Full | Anna Expense Portal Success at 25 September 07:48:34Z; CA001/CA003 Success, other results not applied/disabled. No authentication-method detail shown. |
| [14-guest-access-review.png](../evidence/day-18/14-guest-access-review.png) | Full | SG-External-Contractors zero direct members, no search filter; not review decision screen. |
| [15-access-package-lifecycle.png](../evidence/day-18/15-access-package-lifecycle.png) | Full | POL-Amber enabled, partner scope, approval/justification, one stage, 30-day expiry, zero active; Initial Policy also enabled but unevaluated. |
| [16-access-package-assignments.png](../evidence/day-18/16-access-package-assignments.png) | Full | External Auditor Expired/Governed, future 21 October end date; natural expiry not established. |
| [17-external-access-denied.png](../evidence/day-18/17-external-access-denied.png) | Full | External Auditor Expense Portal AADSTS50105 at 25 September 08:29:28Z, no qualifying assignment; request IDs masked. |
| [18-app-registration-permissions.png](../evidence/day-18/18-app-registration-permissions.png) | Full | One configured Graph User.Read Delegated grant; consent shown. No configured User.Read.All Application. |
| [19-enterprise-app-consent.png](../evidence/day-18/19-enterprise-app-consent.png) | Full | Enterprise app admin-consent view shows Graph User.Read Delegated; user-consent tab not opened. |
| [20-no-client-secrets.png](../evidence/day-18/20-no-client-secrets.png) | Full | App registration certificates/secrets/federated credentials all zero; no deletion timestamp or Easy Auth credential path. |
| [21-expense-portal-regression.png](../evidence/day-18/21-expense-portal-regression.png) | Partial | Anna Expense.Submitter, Graph HTTP 200 / Delegated User.Read; job title Finance Monitoring Test. No timestamp, code-redemption or refresh proof. |
| [22-workload-rbac.png](../evidence/day-18/22-workload-rbac.png) | Partial | Each identity name-filtered at bflmi13a7k29: Storage Blob Data Reader, This resource; IDs masked. Banner text blanked, so prior elevated-access warning resolution cannot be inferred. Not a full effective-permission report. |
| [23-monitoring-coverage.png](../evidence/day-18/23-monitoring-coverage.png) | Full | Audit/SignIn/NonInteractive/Provisioning selected to law-bfl-identity; ServicePrincipal/ManagedIdentity unchecked. |
| [24-final-kql-review.png](../evidence/day-18/24-final-kql-review.png) | Full | 7-day query expands all app policies, filters only notApplied. Anna Expense Portal rows 09:07–09:11 UTC show CA001/CA003 success, CA002 reportOnlyNotApplied, CA009 notEnabled. Different timestamps from 13; policy-level corroboration, not exact event correlation. |

## Query transcription checkpoint

All five Day 16 KQL source files match the readable queries in screenshots 10–14, including `toint(Status.errorCode)` and the application filter `AppDisplayName contains "Expense"`. The Day 18 source matches screenshot 24: there is no app filter, and `PolicyResult != "notApplied"` still retains report-only and disabled outcomes. This is visual source comparison, not a new Log Analytics execution.


## Current guidance checked separately from historical execution

Checked Microsoft Learn on 2026-09-25. [Azure Automation managed identity guidance](https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation) uses process-scoped context-autosave disabling and explicit Azure context selection. The missing complete Day 13 source prevents verifying these safeguards; the audit does not assert they were absent.

[Emergency access guidance](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access) supports permanent Active emergency GA assignments, phishing-resistant authentication, exclusions from restrictive Conditional Access policies, monitoring and regular validation. A group-exclusion design is supported, but a printed effective-exclusion column alone does not expose the lab's implementation.

## Confirmed corrections and remaining lab evidence

- D13-09: changed to Partial; capture the raw upload authorization error and sanitized Runbook exception handling. Publish full Runbook source to inspect credential and context handling.
- D14-21: changed to Partial; retain the reported historical replay observation and capture a fresh tile launch without manual form entry. Configuration and destination-session checks remain supported.
- Day 14: record the disabled-service banners and missing transition chronology while retaining independently corroborated external access success.
- Day 17: qualify the old cleanup/export gaps as historical and distinguish revised source from captured tenant runs.
- D18-04: changed to Partial for exclusions; publish the review source and policy/group membership inputs or matching What If exclusions for both emergency accounts. Permanent GA assignments remain confirmed.
- Day 18: remove the inferred resolution of the blanked Storage warning; narrow RBAC conclusions to the shown assignments and CA correlation to matching outcomes on different events.
- Unchanged limitations: missing full application/runbook/workbook source, no Easy Auth credential-refresh proof, no workload sign-in export, no natural package-expiry proof and no final Secure Score improvement.

No screenshots were changed, no masked values inferred, and no test was promoted to Pass by documentation or source edits.


## Final local verification

All 19 owned text files (18 day documents/indexes plus this audit) were checked for relative Markdown links: 318 local links resolved, with zero missing targets. The inventory covers every one of the 112 Day 13–18 image files. The scoped final `git diff --check` passed. No tracked screenshot changes were present. These are repository checks, not new tenant or Azure tests.
