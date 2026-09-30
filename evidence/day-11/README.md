# Day 11 — Evidence

This folder documents a completed Microsoft Entra Access Review of the existing `SG-External-Contractors` group: restored B2B guest access, a separate business review by Anna Finance, a `Deny` decision, manual application of the review results, and verified removal of access to Expense Portal.

## 01 — Empty group before restoration

![Empty group before restoration](01-contractor-group-before-review.png)

**Shows:** `SG-External-Contractors` has zero direct members.

**Why it matters:** Establishes the Day 11 starting point after the earlier access-package removal.

## 02 — Guest membership restored

![Guest membership restored](02-contractor-group-membership-restored.png)

**Shows:** External Auditor appears as a direct Guest member of `SG-External-Contractors`.

**Why it matters:** Provides the membership to recertify in this lab; the expired Day 10 access-package assignment is not being reviewed.

## 03 — Positive application-access baseline

![Positive application-access baseline](03-auditor-expense-portal-access-before-review.png)

**Shows:** Expense Portal displays External Auditor, successful authentication and `Expense.Submitter`.

**Why it matters:** Records working application access before the documented review sequence.

## 04 — Guest group review scope

![Guest group review scope](04-access-review-scope.png)

**Shows:** The review selects `SG-External-Contractors`, `Guest users only` and no inactive-users-only filter.

**Why it matters:** Defines which group members are included in the recertification exercise.

## 05 — Reviewer and review schedule

![Reviewer and review schedule](05-access-review-reviewer-and-schedule.png)

**Shows:** Anna Finance is the selected reviewer for a single-stage, one-time review lasting one day.

**Why it matters:** Documents a separate business reviewer and a bounded review period.

## 06 — Completion and decision settings

![Completion and decision settings](06-access-review-completion-settings.png)

**Shows:** Auto-apply is disabled, non-responses leave access unchanged, and justification, sign-in recommendations, notifications and reminders are enabled. The denied-guest membership-removal label is partly clipped.

**Why it matters:** Explains why recording Deny and applying the results are separate steps. The final group view independently shows membership removal.

## 07 — Review created

![Review created](07-access-review-created.png)

**Shows:** `AR-External-Contractors-Q3-2026` appears for the contractor group with status `Not started`.

**Why it matters:** Records creation of the review; this initial state is not a completed review.

## 08 — Reviewer's pending decision

![Reviewer's pending decision](08-reviewer-pending-access-review.png)

**Shows:** Anna Finance's My Access view lists External Auditor with an `Approve` recommendation and no recorded decision.

**Why it matters:** Shows the reviewer's task before a business decision is submitted.

## 09 — Justified Deny decision

![Justified Deny decision](09-reviewer-denied-auditor-access.png)

**Shows:** Anna Finance's decision is `Denied`, with justification that the external audit engagement is complete; the recommendation remains `Approve`.

**Why it matters:** Demonstrates a business decision that differs from a usage-based recommendation.

## 10 — Portal session before Apply

![Portal session before Apply](10-auditor-access-before-results-applied.png)

**Shows:** The auditor's Expense Portal session still displays successful authentication and `Expense.Submitter`.

**Why it matters:** Documents the session reported as after Deny and before Apply. No visible timestamp or fresh-sign-in detail independently establishes that sequence.

## 11 — Decision in the administrator's results view

![Decision in the administrator's results view](11-access-review-decision-results.png)

**Shows:** The results view records `Denied` by Anna Finance and a separate recommended action of `Approve`.

**Why it matters:** Corroborates the reviewer decision without conflating it with the system recommendation or an applied result.

## 12 — Review results applied

![Review results applied](12-access-review-results-applied.png)

**Shows:** The named contractor-group review has status `Result applied`.

**Why it matters:** Records the transition from a review decision to application of the results.

## 13 — Reviewed membership removed

![Reviewed membership removed](13-contractor-membership-removed.png)

**Shows:** `SG-External-Contractors` has zero direct members after the documented Apply step.

**Why it matters:** Shows the resulting group state, compared with the restored guest membership earlier in the sequence.

## 14 — Auditor's sign-in denied

![Auditor's sign-in denied](14-auditor-expense-portal-access-denied.png)

**Shows:** Expense Portal rejects External Auditor with `AADSTS50105`, stating that no qualifying group or direct assignment exists.

**Why it matters:** Records the negative application-access result after membership removal.

## 15 — Denied sign-in in Entra logs

![Denied sign-in in Entra logs](15-auditor-denied-sign-in-log.png)

**Shows:** The Expense Portal sign-in for External Auditor is `Failure` with code `50105` and an assignment-related reason.

**Why it matters:** Corroborates the user-facing denial with the same displayed event time and application.

## 16 — Apply review audit event

![Apply review audit event](16-access-review-apply-audit-log.png)

**Shows:** Access Reviews logs show `Apply review` / `Success`, initiated by Identity Governance for `AR-External-Contractors-Q3-2026`.

**Why it matters:** Adds an audit record for applying the review. It does not independently show a `Remove member from group` event.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
