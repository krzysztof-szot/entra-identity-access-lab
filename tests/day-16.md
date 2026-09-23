# Day 16 — Monitoring, KQL, Workbooks and Identity Secure Score Tests

Tests cover historical Entra investigations, diagnostic export, new positive/negative authentication observations, workspace KQL analysis, Workbooks and Identity Secure Score. Outcomes apply to the **captured evidence and queried time range**, not to every event in the tenant.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D16-01 | Failed application sign-in investigation | Identify the user, application and actual denial reason | Peter: BFL Internal Portal - Proxy, `50105`; password succeeded, app assignment missing | Pass |
| D16-02 | Conditional Access investigation | Identify individual policy results for an app sign-in | Anna: Expense Portal Success; MFA and phishing-resistant MFA policies Success; other policies Not applied/Disabled | Pass (successful evaluation, not CA failure) |
| D16-03 | PIM audit investigation | Find a recorded privileged-access workflow event | `adm-lab` PIM activation approval request and justification recorded | Pass (request only) |
| D16-04 | B2B guest investigation | Identify guest and reason for failed app access | External Auditor, B2B guest, `50105`; password succeeded, assignment missing | Pass |
| D16-05 | Application sign-in monitoring | Inspect results for the Enterprise Application | Expense Portal records for internal users and guest show Success, Interrupted and Failure | Pass |
| D16-06 | Log Analytics Workspace | Workspace exists in the intended lab Resource Group | `law-bfl-identity` Active in `rg-bfl-identity-lab`, Poland Central | Pass |
| D16-07 | Diagnostic Settings | Select Entra categories and Log Analytics destination | Audit, interactive, non-interactive and Provisioning categories selected; destination `law-bfl-identity` | Pass (configuration) |
| D16-08 | Positive application access | Assigned Anna signs in and displays app permissions | Expense Portal authenticated Anna, displayed `Expense_Submitter` and Graph `User.Read` HTTP 200 | Pass |
| D16-09 | Negative MFA test | A rejected Authenticator request is visible | Peter received “Request denied” after declining verification | Pass (MFA denial; not the `50126` KQL event) |
| D16-10 | KQL failed sign-ins | Query exported errors and explain their cause | `SigninLogs` returned Peter / Expense Portal, `50126`, invalid username or password | Pass |
| D16-11 | KQL per-user aggregation | Count failure/success per user | `summarize` / `countif()` returned per-user counts | Pass |
| D16-12 | KQL Conditional Access status | Aggregate observed CA results | Exported records returned `notApplied` | Pass (limited sampled period) |
| D16-13 | KQL Audit activity | Summarize ingested audit operations | `AuditLogs` grouped by `OperationName` and charted | Pass (summary, not role-change proof) |
| D16-14 | KQL app sign-ins | Isolate Expense Portal records | Peter's `50126` Expense Portal event shown with `notApplied` | Pass |
| D16-15 | Microsoft CA Workbook | Workbook opens with data from selected workspace | Conditional Access Insights and Reporting shows live impact summary | Pass |
| D16-16 | Custom monitoring Workbook | Saved dashboard visualizes actual identity logs | Sign-in trends, CA outcomes and top applications visible | Pass |
| D16-17 | Identity Secure Score review | Capture tenant baseline and recommendations | 43.82% baseline and recommendation list visible | Pass (review only) |

## D16-01–D16-05 — Existing Microsoft Entra investigations

**Acting identity:** `adm-lab` (log review); historical records concern `anna.finance`, `peter.finance` and External Auditor.  
**Expected:** distinguish log-in outcome, authentication steps, CA evaluation, application authorization and an audit workflow event.  
**Observed:** Peter's Application Proxy error `50105` and the B2B guest's Expense Portal error `50105` were assignment-related denials after successful password steps. Anna's Expense Portal sign-in had successful CA policy evaluations. The PIM audit entry recorded a role-activation approval **request**, not completed approval or activation. Expense Portal history included multiple result types.  
**Result:** Pass for analysis of the recorded events.  
**Evidence:**

- [01 — Proxy assignment denial](../evidence/day-16/01-failed-signin-investigation.png)
- [02 — CA policy evaluation](../evidence/day-16/02-conditional-access-investigation.png)
- [03 — PIM approval request audit](../evidence/day-16/03-role-and-pim-audit.png)
- [04 — Guest assignment denial](../evidence/day-16/04-guest-activity-investigation.png)
- [05 — Expense Portal sign-in history](../evidence/day-16/05-expense-portal-signins.png)

**Evidence boundary:** screenshots 01 and 04 do not show wrong-password failures; screenshot 02 is not a CA failure; screenshot 03 does not prove role activation completed.

## D16-06–D16-07 — Centralized Log Analytics configuration

**Acting identity:** authorized Azure / Entra administrator.  
**Expected:** use the lab Resource Group and route selected Entra logs to a dedicated workspace.  
**Observed:** `law-bfl-identity` was Active in `rg-bfl-identity-lab`, Poland Central. `diag-bfl-identity-monitoring` selected `AuditLogs`, `SignInLogs`, `NonInteractiveUserSignInLogs` and `ProvisioningLogs` with Log Analytics destination `law-bfl-identity`.  
**Result:** Pass for configuration; later KQL results corroborate actual sign-in and audit ingestion.  
**Evidence:**

- [06 — Log Analytics Workspace](../evidence/day-16/06-log-analytics-workspace.png)
- [07 — Diagnostic Settings](../evidence/day-16/07-diagnostic-settings.png)
- [10 — Ingested sign-in event](../evidence/day-16/10-kql-failed-signins.png)
- [13 — Ingested audit activity](../evidence/day-16/13-kql-audit-activity-summary.png)

**Evidence boundary:** enabling a category does not prove the corresponding table contains events. No backfill of earlier Entra activity is claimed.

## D16-08–D16-09 — Controlled authentication tests

**Acting identities:** `anna.finance` (positive application access), `peter.finance` (negative MFA test).  
**Expected:** confirm that the previously built portal remains usable and show a controlled failed authentication interaction.  
**Observed:** Anna authenticated to Expense Portal with `Expense_Submitter` and Graph `User.Read` (HTTP 200). Peter rejected an Authenticator verification request and saw “Request denied.”  
**Result:** Pass for the observed positive and negative interactions.  
**Evidence:**

- [08 — Successful Expense Portal access](../evidence/day-16/08-successful-test-signin.png)
- [09 — Rejected Authenticator request](../evidence/day-16/09-failed-test-signin.png)

**Evidence boundary:** screenshot 09 is a UI-level denial. The later `50126` KQL result is a separate invalid-credentials event, not evidence that this same MFA request produced `50126`.

## D16-10–D16-14 — KQL investigations

**Acting identity:** `adm-lab` with Log Analytics read access.  
**Expected:** query exported events for errors, user aggregates, Conditional Access results, audit operations and a selected application.  
**Observed:** the failed-sign-in query returned Peter's Expense Portal error `50126`; `countif()` aggregated outcomes by user; CA aggregation returned `notApplied` for the sampled workspace data; `AuditLogs` were charted by operation name; Expense Portal filtering returned Peter's failure with CA `notApplied`.  
**Result:** Pass for the queries and their observed outputs.  
**Evidence:**

- [10 — Failed sign-ins and error reason](../evidence/day-16/10-kql-failed-signins.png)
- [11 — Per-user success/failure totals](../evidence/day-16/11-kql-authentication-failures-by-user.png)
- [12 — CA status aggregation](../evidence/day-16/12-kql-conditional-access.png)
- [13 — Audit operation summary](../evidence/day-16/13-kql-audit-activity-summary.png)
- [14 — Expense Portal sign-ins](../evidence/day-16/14-kql-application-signins.png)

**Evidence boundary:** `notApplied` for these exported events does not mean that CA never applied in the tenant. Audit activity counts do not independently establish PIM role changes. No fresh B2B-guest, Provisioning or PIM KQL event is evidenced.

## D16-15–D16-16 — Workbooks

**Acting identity:** authorized Workbook and Log Analytics reader/editor.  
**Expected:** consume workspace data in the Microsoft CA report and a separate reusable identity-monitoring dashboard.  
**Observed:** Conditional Access Insights and Reporting opened against `law-bfl-identity` and displayed an impact summary with two users in the Not applied result for the selected interval. The saved **Baltic Finance — Identity Security Monitoring** Workbook showed successful/failed sign-in trends, CA status distribution and top applications.  
**Result:** Pass.  
**Evidence:**

- [15 — Microsoft Conditional Access Workbook](../evidence/day-16/15-conditional-access-workbook.png)
- [16 — Custom Identity Security Workbook](../evidence/day-16/16-custom-identity-workbook.png)

**Evidence boundary:** screenshots are time-range snapshots, not permanent tenant-wide metrics; Service Principal reporting was not enabled in Diagnostic Settings.

## D16-17 — Identity Secure Score baseline

**Acting identity:** authorized Entra security report reader.  
**Expected:** read the current score and inspect recommendations without changing security controls solely to raise the score.  
**Observed:** Identity Secure Score **43.82%**; 14 recommendations in All and 13 in Security; visible examples included risk-policy and Managed Identity recommendations.  
**Result:** Pass (baseline/review).  
**Evidence:** [17 — Score and recommendations](../evidence/day-16/17-identity-secure-score-and-recommendations.png)

**Evidence boundary:** no mitigation rollout, score increase or improved risk outcome is demonstrated.

## Not tested or not evidenced

| Area | Status | Explanation |
| --- | --- | --- |
| Backfill of Days 01–15 to workspace | Not supported / not claimed | The new export does not retroactively ingest historic Entra records |
| Completed PIM activation in Day 16 | Not evidenced | Screenshot 03 records an approval request only; Day 09 contains its own separate lab |
| KQL RoleManagement / PIM changes | Not evidenced | Screenshot 13 is an overall audit operation summary |
| Fresh guest sign-ins in KQL | Not evidenced | Guest investigation used available Entra history |
| Provisioning and non-interactive ingestion | Not verified | Their categories were selected; no result screenshot demonstrates event ingestion |
| Service Principal / Managed Identity log export | Not configured in shown setting | Not part of the selected categories |
| Alerts or Secure Score remediation | Not tested | Scope covers investigation, dashboards and score review |

## Final state

The evidence set establishes a functioning Entra-to-Log-Analytics monitoring route for sign-in and audit activity, working KQL investigations, two data-backed Workbooks and a documented Secure Score baseline. Historical assignment denials, a PIM approval request, an MFA rejection and a separate invalid-password event are explicitly kept distinct.

See [Day 16 implementation notes](../docs/day-16.md) and [Day 16 evidence](../evidence/day-16/README.md).
