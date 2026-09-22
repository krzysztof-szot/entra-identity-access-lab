# Day 11 — Access Reviews Tests

Tests validate real recertification of the existing External Auditor's group-derived Expense Portal access: an independent `Deny` decision, continued access before results are applied, and successful revocation after Apply.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D11-01 | Starting group baseline | Reviewed group initially has no members after Day 10 | `SG-External-Contractors` showed zero members | Pass |
| D11-02 | Restore guest membership | Existing auditor can be added directly to the group | External Auditor appeared as a Guest member | Pass |
| D11-03 | Positive access baseline | Auditor can sign in to Expense Portal before review | Successful authentication with `Expense.Submitter` | Pass |
| D11-04 | Review scope and reviewer | Group guests only; Anna is the selected reviewer | Correct group, guest scope and Anna; one-time, one-day review | Pass |
| D11-05 | Completion and decision settings | Auto-apply off; no-response No change; justification required | Settings showed the intended choices; denied-guest-action text partially clipped | Pass (partial settings visibility) |
| D11-06 | Review creation and reviewer task | Review is created and later appears in Anna's My Access | Initially `Not started`; auditor later appeared for review | Pass |
| D11-07 | Justified business Deny | Anna records Deny and provides an engagement-based reason | `Denied` with the completed-audit justification | Pass |
| D11-08 | Recommendation is not decision | Reviewer can deny even when recommendation says Approve | `Recommended action: Approve`; `Outcome: Denied` | Pass |
| D11-09 | No immediate revocation | With auto-apply off, portal access works before Apply | Auditor's portal session still showed `Expense.Submitter` | Pass (session screenshot has no timestamp) |
| D11-10 | Apply review results | Completed review results are applied successfully | `Result applied` and `Apply review / Success` | Pass |
| D11-11 | Group access removed | Auditor no longer belongs to reviewed group | Group returned to zero members | Pass |
| D11-12 | Negative sign-in | Fresh Expense Portal access is denied after membership removal | `AADSTS50105`: no qualifying group/direct assignment | Pass |
| D11-13 | Sign-in log correlation | Failure is recorded for Expense Portal | Failure, code `50105` and assignment-related reason | Pass |
| D11-14 | Apply audit event | Review application is recorded in audit history | `Apply review`, `Success`, actor `Identity Governance` | Pass |
| D11-15 | Separate member-removal audit event | Individual group-member removal appears as its own audit entry | Not captured; group final state and negative sign-in were captured | Not independently evidenced |

## D11-01–D11-03 — Baseline, restoration and positive access

**Acting identities:** Baltic Finance administrator (group), existing External Auditor from Amber Audit Partners (application).  
**Expected:** the Day 10 baseline is empty; restored direct group membership provides a working access path before review.  
**Observed:** the group had zero members, then displayed External Auditor as a Guest; Expense Portal subsequently authenticated the auditor and displayed `Expense.Submitter`.  
**Result:** Pass.  
**Evidence:**

- [01 — Empty group baseline](../evidence/day-11/01-contractor-group-before-review.png)
- [02 — Guest membership restored](../evidence/day-11/02-contractor-group-membership-restored.png)
- [03 — Positive Expense Portal access](../evidence/day-11/03-auditor-expense-portal-access-before-review.png)

**Boundary:** group membership was restored directly for this test. The removed Day 10 access-package assignment was not renewed; the portal's `Expense.Submitter` is the existing lab role, not read-only auditor authorization.

## D11-04–D11-06 — Access Review configuration and reviewer task

**Acting identities:** Baltic Finance Identity Governance administrator (configuration), `anna.finance` (reviewer).  
**Expected:** a one-time review covers guests of `SG-External-Contractors`, directs decisions to Anna, requires justification and defers applying results until an administrator acts.  
**Observed:** scope was `Guest users only`, inactive-only filtering disabled, single-stage Anna reviewer selected, one-day one-time schedule, auto-apply unchecked, no-response `No change`, justification and notifications enabled. The review first showed `Not started`, then appeared in Anna's My Access with the auditor awaiting a decision.  
**Result:** Pass (guest-action field partially clipped in the settings screenshot).  
**Evidence:**

- [04 — Review scope](../evidence/day-11/04-access-review-scope.png)
- [05 — Reviewer and recurrence](../evidence/day-11/05-access-review-reviewer-and-schedule.png)
- [06 — Completion settings](../evidence/day-11/06-access-review-completion-settings.png)
- [07 — Review created](../evidence/day-11/07-access-review-created.png)
- [08 — Reviewer task](../evidence/day-11/08-reviewer-pending-access-review.png)

## D11-07–D11-08 — Business decision versus recommendation

**Acting identity:** `anna.finance`, acting as designated reviewer.  
**Target identity:** External Auditor.  
**Expected:** Anna can explicitly deny continuation of access with a business justification, regardless of the usage-based suggestion.  
**Observed:** Anna recorded `Denied` and wrote that the external audit engagement had finished. My Access and the administrator's Results view showed the decision; the separate system recommendation remained `Approve`.  
**Result:** Pass.  
**Evidence:**

- [09 — Anna's Deny and justification](../evidence/day-11/09-reviewer-denied-auditor-access.png)
- [11 — Denied outcome vs Approve recommendation](../evidence/day-11/11-access-review-decision-results.png)

**Interpretation:** a recent sign-in may inform a recommendation but does not establish an ongoing business requirement.

## D11-09 — Access after Deny and before Apply

**Acting identity:** External Auditor.  
**Expected:** with `Auto apply results to resource` disabled, Deny does not instantly remove the membership or existing access.  
**Observed:** Expense Portal still showed successful authentication and `Expense.Submitter` when tested before the results were applied.  
**Result:** Pass (workflow-observed, with limited timestamp evidence).  
**Evidence:**

- [09 — Deny decision](../evidence/day-11/09-reviewer-denied-auditor-access.png)
- [10 — Portal access before Apply](../evidence/day-11/10-auditor-access-before-results-applied.png)

**Evidence boundary:** screenshot 10 has no visible timestamp and by itself cannot independently establish the timing relative to Deny and Apply.

## D11-10–D11-11 — Apply and group-membership removal

**Acting identity:** Baltic Finance Identity Governance administrator; Identity Governance service applied the result.  
**Expected:** after review completion and Apply, the decision is executed and the auditor's membership in the reviewed group is removed.  
**Observed:** Access Reviews displayed `Result applied`. The group subsequently showed `0 group members found`, compared with the restored Guest membership before review. A separate audit record showed successful `Apply review`.  
**Result:** Pass.  
**Evidence:**

- [02 — Membership before review](../evidence/day-11/02-contractor-group-membership-restored.png)
- [12 — Result applied](../evidence/day-11/12-access-review-results-applied.png)
- [13 — Empty group after Apply](../evidence/day-11/13-contractor-membership-removed.png)
- [16 — Apply review audit event](../evidence/day-11/16-access-review-apply-audit-log.png)

**Evidence boundary:** the audit event confirms Apply and does not itself depict a member-removal operation.

## D11-12–D11-13 — Negative application test and Sign-in log

**Acting identity:** External Auditor, in a fresh Expense Portal sign-in.  
**Expected:** after losing the reviewed group membership, the auditor cannot authenticate to this assignment-required app through that access path.  
**Observed:** Expense Portal returned `AADSTS50105`, explaining that the user had neither qualifying group membership nor direct application assignment. The corresponding Entra Sign-in log recorded `Failure`, error `50105` and the assignment-related failure reason.  
**Result:** Pass.  
**Evidence:**

- [14 — Access denied](../evidence/day-11/14-auditor-expense-portal-access-denied.png)
- [15 — Failed sign-in log](../evidence/day-11/15-auditor-denied-sign-in-log.png)

**Interpretation:** the demonstrated failure is an application-assignment denial, not proof that the guest account was blocked or deleted.

## D11-14–D11-15 — Audit evidence boundary

**Acting system:** Identity Governance.  
**Expected:** audit history identifies successful application of review results; an individual membership-removal event would be separate evidence.  
**Observed:** `Service: Access Reviews`, `Activity: Apply review`, `Status: Success`, target `AR-External-Contractors-Q3-2026`, actor `Identity Governance`. No separate screenshot of `Remove member from group` was captured.  
**Result:** Apply audit event Pass; separate removal audit event Not independently evidenced.  
**Evidence:** [16 — Apply review audit event](../evidence/day-11/16-access-review-apply-audit-log.png)

## Final state

- `AR-External-Contractors-Q3-2026`: review results applied; historical record preserved.
- `SG-External-Contractors`: zero members after applying the Deny result.
- External Auditor: guest identity retained; access through the reviewed group removed.
- Expense Portal: preserved; fresh auditor sign-in denied with `AADSTS50105`.
- Day 10 package: earlier removed assignment not represented as an active Day 11 assignment.

See [Day 11 evidence](../evidence/day-11/README.md) and [Day 11 implementation notes](../docs/day-11.md).
