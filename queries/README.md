# KQL Queries

These six query files transcribe the KQL visible in the published Day 16 and Day 18 screenshots. Formatting and source comments were added; filters and query behavior match the captures. They were not rerun against Azure during the repository review.

## Usage

Open Logs for `law-bfl-identity` using an account with query access to the relevant workspace/tables, paste one query and run it. Diagnostic Settings must already be sending the corresponding Entra categories. `SigninLogs` and `AuditLogs` are the table names used here.

The original queries use `ago(7d)`. Change the window when investigating retained historical events; an empty result does not prove there were no events before export started or outside retention. Export does not backfill earlier Entra history.

| Source file | Purpose | Original evidence |
| --- | --- | --- |
| [01-failed-signins.kql](day-16/01-failed-signins.kql) | Nonzero sign-in errors and recorded reasons | [Day 16 / 10](../evidence/day-16/10-kql-failed-signins.png) |
| [02-signins-by-user.kql](day-16/02-signins-by-user.kql) | Per-user zero/nonzero error counts | [Day 16 / 11](../evidence/day-16/11-kql-authentication-failures-by-user.png) |
| [03-conditional-access-summary.kql](day-16/03-conditional-access-summary.kql) | Sign-in-level CA outcomes | [Day 16 / 12](../evidence/day-16/12-kql-conditional-access.png) |
| [04-audit-activity-summary.kql](day-16/04-audit-activity-summary.kql) | Counts by audit operation | [Day 16 / 13](../evidence/day-16/13-kql-audit-activity-summary.png) |
| [05-expense-portal-signins.kql](day-16/05-expense-portal-signins.kql) | Sign-ins whose app name contains `Expense` | [Day 16 / 14](../evidence/day-16/14-kql-application-signins.png) |
| [01-conditional-access-policy-results.kql](day-18/01-conditional-access-policy-results.kql) | Expand individual CA policy results | [Day 18 / 24](../evidence/day-18/24-final-kql-review.png) |

## Interpretation

- Nonzero error codes require interpretation: they can include interrupted flows, not only final access denials. The captured Day 16 event was `50126`.
- The audit query is an activity summary. Its screenshot uses the Logs chart view; the source query does not contain a `render` operator or isolate privileged-role changes.
- The Day 18 query has no app filter in the captured text. Its displayed rows concern Expense Portal, but rerunning it can return other apps. Filter by the intended application's stable identifier for a scoped investigation.
- The Day 18 query excludes exactly `notApplied`; it intentionally retains results such as `reportOnlyNotApplied` and `notEnabled`. Sign-in-level `ConditionalAccessStatus` is separate from an individual policy's result.
- The saved custom Workbook's actual JSON is still required to reproduce its layout. These query files are not a Workbook export.
