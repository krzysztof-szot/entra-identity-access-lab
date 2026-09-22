# Day 11 — Evidence

This folder documents a completed Microsoft Entra Access Review of the existing `SG-External-Contractors` group: restored B2B guest access, a separate business review by Anna Finance, a `Deny` decision, manual application of the review results, and verified removal of access to Expense Portal.

## Evidence

- `01-contractor-group-before-review.png` — shows zero members in `SG-External-Contractors` after Day 10, before the controlled Day 11 access restoration.
- `02-contractor-group-membership-restored.png` — shows the existing External Auditor added directly to `SG-External-Contractors` as a Guest.
- `03-auditor-expense-portal-access-before-review.png` — confirms successful Expense Portal authentication with the existing `Expense.Submitter` App Role.
- `04-access-review-scope.png` — shows the review scoped to `SG-External-Contractors`, `Guest users only`, with the inactive-users-only filter disabled.
- `05-access-review-reviewer-and-schedule.png` — shows Anna Finance selected as reviewer, a single stage, one-time recurrence, and a one-day review duration.
- `06-access-review-completion-settings.png` — shows auto-apply disabled, `No change` for non-responses, guest-membership removal selected, sign-in activity recommendations, required justification, notifications, and reminders. The membership-removal option text is partly clipped in this image.
- `07-access-review-created.png` — shows `AR-External-Contractors-Q3-2026` created for the group with initial status `Not started`; it is not evidence of a completed review.
- `08-reviewer-pending-access-review.png` — shows Anna Finance's My Access reviewer view, with External Auditor awaiting a decision and a system recommendation of `Approve`.
- `09-reviewer-denied-auditor-access.png` — shows Anna's recorded `Denied` decision and the justification that the external audit engagement was completed.
- `10-auditor-access-before-results-applied.png` — shows Expense Portal still accessible after `Deny` but before results were applied. The portal screenshot itself does not display a timestamp.
- `11-access-review-decision-results.png` — shows the administrator's result: `Denied` by Anna Finance despite the separate `Approve` recommendation.
- `12-access-review-results-applied.png` — shows the review's status `Result applied`.
- `13-contractor-membership-removed.png` — shows zero members in `SG-External-Contractors` after the review results were applied.
- `14-auditor-expense-portal-access-denied.png` — shows a fresh sign-in rejected with `AADSTS50105` because the auditor no longer had an eligible group or direct application assignment.
- `15-auditor-denied-sign-in-log.png` — confirms the failed Expense Portal sign-in in Microsoft Entra logs, with error code `50105` and the application-assignment failure reason.
- `16-access-review-apply-audit-log.png` — shows a successful `Apply review` audit event initiated by Identity Governance for `AR-External-Contractors-Q3-2026`. It does **not**, by itself, show a `Remove member from group` event.

**Evidence boundary:** Day 11 reviews manually restored *group membership*, not an active Day 10 access-package assignment. The Day 10 assignment was already removed. The group state, application denial and apply audit event together support the observed revocation; the `Apply review` log alone does not identify the member-removal operation. The lab retains the existing `Expense.Submitter` role, which is not a read-only auditor role. Sensitive IDs and tenant-specific details were redacted where appropriate.
