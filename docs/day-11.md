# Day 11 — Access Reviews

## Objectives

The goal was to recertify an existing external user's access rather than approve a new request. Building on Day 05 B2B collaboration and Day 10 Entitlement Management, this lab performed a **real** Microsoft Entra Access Review: a separate business reviewer recorded a decision, an administrator applied its results, and the external user was denied access to the existing Expense Portal.

## Implemented

### Baseline and controlled restoration

The existing External Auditor from Amber Audit Partners and the Baltic Finance `SG-External-Contractors` security group were reused. After Day 10's manual access-package assignment removal, the group contained zero members. The auditor was added **directly** to the group for Day 11; the expired `AP-External-Auditor-30D` assignment was not renewed or reviewed in this exercise.

A fresh Expense Portal sign-in succeeded and displayed the lab's existing `Expense.Submitter` role. This established a positive access baseline before recertification.

### Group Access Review

`AR-External-Contractors-Q3-2026` was created with the following configuration:

| Setting | Configured value |
| --- | --- |
| Resource type | Teams + Groups |
| Reviewed resource | `SG-External-Contractors` |
| Scope | Guest users only |
| Inactive users only | Disabled |
| Review stages | Single-stage |
| Reviewer | Anna Finance (`anna.finance`) |
| Recurrence | One time |
| Duration | 1 day |
| Auto apply results to resource | Disabled |
| No reviewer response | No change |
| Denied guest action | Remove user's membership from the resource |
| Justification | Required |
| Decision helpers | No sign-in within 30 days enabled |
| Email notifications / reminders | Enabled |

The created-review screenshot captured its initial `Not started` status; later screenshots show the actual review and applied results. The denied-guest-action label is partially clipped in the settings screenshot, while the final removal is independently visible in the group.

### Independent business decision

Anna signed in to My Access as reviewer. The system recommended `Approve`, reflecting recent sign-in activity. Anna submitted `Deny` with a business justification: the external audit engagement had ended and continued access was no longer required.

This demonstrates that **recent usage is not the same as continued business need**. The administrator's results view independently recorded `Denied` by Anna Finance while still displaying `Approve` as the separate recommendation.

### Decision versus enforcement

With automatic application disabled, a subsequent portal test still showed the auditor authenticated with `Expense.Submitter` after the Deny decision and before Apply. This was the intended distinction between a review decision and enforcement. The portal screenshot has no embedded time marker; its placement in the workflow documents the test sequence, not an independently timestamped correlation.

After the review was closed and its results applied, Entra showed `Result applied`. The group returned to zero members. The auditor's fresh Expense Portal sign-in then failed with `AADSTS50105` because no eligible group or direct app assignment remained. The corresponding Sign-in log recorded `Failure` and error `50105`.

The Access Review audit log additionally showed `Apply review` / `Success`, initiated by Identity Governance. This is evidence of applying the review, **not** a standalone `Remove member from group` audit entry.

## Design Decisions

- Review the granting group, rather than assume an application review would revoke every group-derived application assignment.
- Reuse the existing B2B guest, group and Expense Portal to keep the portfolio scenario connected across days.
- Restore direct group membership after Day 10 instead of misrepresenting the expired access-package assignment as active.
- Assign Anna as business reviewer, separate from the administrator applying the results and the user being reviewed.
- Turn off auto-apply to make `Deny → access still granted → Apply → access denied` independently observable.
- Remove only the reviewed group membership; retain the guest identity, group, application and historical review.
- Keep `Expense.Submitter` as the pre-existing lab role; it is **not** least-privilege read-only audit access.

## Verification

The recorded evidence supports:

- a zero-member starting baseline, restored guest membership and successful application access;
- creation and configuration of the intended one-time guest group review;
- Anna's completed, justified `Deny` decision despite a distinct `Approve` recommendation;
- portal access after the decision but before results were applied;
- `Result applied` and a successful `Apply review` audit event;
- removal of the auditor's group membership and fresh sign-in denial (`AADSTS50105`), corroborated by Sign-in logs.

The screenshots do **not** show an independently timestamped pre-Apply portal session, a separate `Remove member from group` audit event, natural expiry of the Day 10 package, or deletion of the B2B guest identity. Review of access-package assignments was outside this day's scope.

## Final State

`AR-External-Contractors-Q3-2026` remains in review history with results applied. `SG-External-Contractors` remains available but has zero members. The existing External Auditor guest and Expense Portal were retained; the auditor no longer has application access through the reviewed group. Day 10's access-package assignment remains the separate previously removed assignment.

## Evidence and Tests

- [Day 11 test results](../tests/day-11.md)
- [Day 11 evidence](../evidence/day-11/README.md)

Sensitive identifiers and tenant-specific details were redacted in the published screenshots where appropriate.
