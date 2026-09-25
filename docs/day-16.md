# Day 16 — Monitoring, KQL, Workbooks and Identity Secure Score

## Objectives

Day 16 connects Baltic Finance's earlier identity and application labs to operational monitoring. The goals were to investigate available Microsoft Entra sign-in and audit history, configure a Log Analytics destination, query newly exported events with KQL, build a custom monitoring Workbook, inspect Microsoft's Conditional Access Workbook, and review Identity Secure Score recommendations.

This day reuses the Expense Portal, Application Proxy, B2B guest and PIM scenarios from previous days. **Historic Entra events and newly exported Log Analytics events are separate data sets:** the new Diagnostic Settings do not backfill events recorded before export was enabled.

## Implemented

### Investigation of existing Microsoft Entra logs

The existing sign-in and audit history was reviewed before setting up central export:

| Investigation | Observed result |
| --- | --- |
| Application Proxy denial | `peter.finance` failed to access `BFL Internal Portal - Proxy` with error `50105`: his password step succeeded, but he lacked the necessary application assignment. |
| Conditional Access | Anna's successful Expense Portal sign-in showed successful MFA and phishing-resistant MFA policy evaluations; another policy was not applied and the PIM validation policy was disabled. |
| PIM audit | An `adm-lab` event recorded a Day 09 role activation **approval request** with justification and a time-bound request. This record alone does not prove approval or completed activation. |
| B2B guest access | External Auditor appeared as a guest using B2B collaboration and was denied Expense Portal access with `50105` despite a successful password step; application assignment was missing. |
| Enterprise Application activity | Expense Portal sign-in history contained Success, Interrupted and Failure events for internal users and the external auditor. |

The Proxy and guest events demonstrate application **authorization/assignment** failures rather than incorrect passwords or a Conditional Access block. The successful CA event must not be described as a CA failure.

### Centralized export to Log Analytics

The Azure Log Analytics Workspace `law-bfl-identity` was created in Resource Group `rg-bfl-identity-lab`, region **Poland Central**, on the Pay-as-you-go tier.

Microsoft Entra Diagnostic Settings `diag-bfl-identity-monitoring` were configured with **Send to Log Analytics workspace** targeting `law-bfl-identity`. The selected categories were:

- `AuditLogs`
- `SignInLogs`
- `NonInteractiveUserSignInLogs`
- `ProvisioningLogs`

The screenshots establish the configured destination and actual ingestion of sign-in and audit events through the later KQL results. They do **not** establish that non-interactive sign-in or Provisioning events were generated or ingested, nor that Service Principal or Managed Identity sign-ins were exported.

### New sign-in tests and KQL investigations

Anna successfully authenticated to Expense Portal. The application displayed her `Expense.Submitter` app role and retrieved her profile with delegated Microsoft Graph `User.Read` (HTTP 200). A separate negative test showed Peter **denying a Microsoft Authenticator request**.

The exported `SigninLogs` records were investigated with KQL:

- A failed Expense Portal sign-in for Peter produced `50126`, with an invalid username/password failure reason. **This is a different event from the denied MFA request**, and different again from the historic `50105` missing-assignment events.
- `summarize` and `countif()` counted successful and failed sign-ins by user.
- `ConditionalAccessStatus` aggregation returned `notApplied` for the sampled exported records. This does not contradict the earlier Entra portal record showing successful application of specific Conditional Access policies; the sources cover different events and periods.
- `AuditLogs` were summarized by `OperationName` and visualized by event count. This is an **audit activity summary**, not KQL proof of PIM activation or role changes.
- Expense Portal events were filtered by application name, including Peter's `50126` failure and `notApplied` CA status.

The screenshots demonstrate log filtering, field selection, error-code interpretation, aggregation and application-specific investigations using **real workspace data**, rather than sample/demo records.

### Workbooks and security posture

Microsoft's **Conditional Access Insights and Reporting** Workbook was opened against `law-bfl-identity`. Its captured impact summary showed two users with a `Not applied` outcome in the selected range. Service Principal sign-in reporting was not configured in this day's Diagnostic Settings.

A separate, saved custom Workbook — **Baltic Finance — Identity Security Monitoring** — displayed sign-in trends (Successful vs Failed), Conditional Access outcomes and Top Applications by Sign-ins, using workspace data. The captured dashboard showed six successful and one failed sign-in; those values are a point-in-time view, not a fixed daily total.

Identity Secure Score was reviewed as a **baseline**: the captured value was **43.82%**, with 14 recommendations across the All view and 13 in Security. Visible examples included user-risk and sign-in-risk policies and a Managed Identity recommendation. No score improvement, recommendation remediation or policy rollout is claimed.

## Design Decisions

- Investigate earlier Entra history separately from events ingested after Diagnostic Settings were configured; do not imply retroactive export.
- Reuse existing Baltic Finance identities, apps and PIM evidence rather than recreate the previous 15 days.
- Preserve the distinction between authentication failure (`50126`), application assignment denial (`50105`), rejected MFA and Conditional Access outcomes.
- Export a limited set of relevant Entra log categories to the existing lab Resource Group rather than enabling every telemetry source or Microsoft Sentinel.
- Use both direct KQL investigation and Workbooks so the results can be reviewed as individual events and aggregated trends.
- Record Identity Secure Score as an observed configuration baseline, not proof of improved security or a mandate to maximize the score.

## Verification and Limitations

**Verified by the evidence:** historical sign-in/CA/guest/PIM-request investigations; active Log Analytics workspace; configured Entra diagnostic export; successful Expense Portal app access; rejected MFA test; ingested sign-in and audit records queried through KQL; functioning Microsoft Conditional Access Workbook and custom monitoring Workbook; Identity Secure Score baseline and recommendation review.

**Not shown / not claimed:** PIM approval or successful role activation from screenshot 03 alone; a CA failure in screenshot 02; retroactive ingestion of Day 01–15 logs; fresh guest or PIM records in KQL; Provisioning or non-interactive event ingestion; Service Principal / Managed Identity log export; a KQL role-change investigation; automated alerts; or remediation that changed Secure Score. The Audit Logs chart shows operations by name, not proof of a privileged role change.

## Reusable Queries

Five [KQL source files](../queries/README.md) reproduce the queries visible in screenshots 10–14. They were transcribed during the repository review; the screenshots remain the evidence of the original executions.

## Evidence and Tests

- [Day 16 test results](../tests/day-16.md)
- [Day 16 evidence](../evidence/day-16/README.md)

Sensitive identifiers and user-specific details were redacted where appropriate. No credentials, secrets or access tokens are published.
