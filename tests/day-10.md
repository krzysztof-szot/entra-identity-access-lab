# Day 10 — Entitlement Management Tests

Tests validate governed, time-limited access for the existing `External Auditor` from Amber Audit Partners: catalog and package configuration, self-service request, approval by Anna Finance, automated provisioning to a security group and Expense Portal, Terms of Use, and access revocation.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D10-01 | External auditor baseline | Package-managed group access is absent before the Day 10 workflow | `SG-External-Contractors` showed zero members | Pass |
| D10-02 | Connected organization | Amber Audit Partners is configured as an external partner | Connected organization showed `Configured` and one internal sponsor | Pass |
| D10-03 | External-enabled catalog | `BFL-External-Audit` is enabled for external users | Catalog showed `Enabled: Yes` and `Enabled for external users: Yes` | Pass |
| D10-04 | Catalog resources and access package | Package bundles the intended group and application roles | Group `Member` and Expense Portal `Expense Submitter` selected | Pass |
| D10-05 | Request and approval policy | Scope is Amber only; request requires justification and independent approval | Amber selected, Self enabled, Anna Finance designated, three-day decision window | Pass |
| D10-06 | Assignment lifecycle | The policy specifies 30-day access without user-selected timelines or extensions | `Number of days: 30`, timeline No, extension No, Access Reviews not enabled | Pass |
| D10-07 | External package discovery | Existing auditor can see and request the package in My Access | `AP-External-Auditor-30D` appeared with `Request` action | Pass |
| D10-08 | Request submission and Pending evidence | Submitted request enters the approval workflow | Approval history confirms submission and decision; Pending state was not captured | Partial evidence |
| D10-09 | Separate business approval | Anna Finance approves the auditor’s request with business context | Approval history showed Anna, Approved and the request’s answers | Pass |
| D10-10 | Assignment delivery | Approval results in a delivered, time-limited assignment | Assignment showed `Delivered`, future end date and `Governed` | Pass |
| D10-11 | Group and application provisioning | Auditor receives both resource roles through the package | Group member and Expense Portal `Expense Submitter` assignment appeared | Pass |
| D10-12 | Positive application access | Assigned auditor can open Expense Portal with the expected App Role | Successful portal authentication; `Expense.Submitter` displayed | Pass |
| D10-13 | Terms of Use enforcement | Auditor sees Terms of Use and satisfies CA grant control | Terms prompt displayed; CA policy and sign-in result showed `Success` | Pass |
| D10-14 | Manual assignment removal | Administrator removes package assignment before scheduled expiration | Assignment subsequently showed `Expired` with original future end date | Pass |
| D10-15 | Resource access revocation | Group access is removed and fresh application sign-in is denied | Group returned to zero members; Expense Portal returned `AADSTS50105` | Pass |
| D10-16 | Natural 30-day expiration | Assignment would expire after 30 days without manual removal | Only configured expiration and manual removal were observed | Not tested |

## D10-01 — External auditor access baseline

**Acting identity:** `adm-lab` (Baltic Finance administrator)  
**Target identity:** existing `External Auditor` B2B guest from Day 05  
**Expected:** before granting the Day 10 access package, the auditor is not a member of the package-managed `SG-External-Contractors` group.  
**Observed:** the group’s Direct members view showed `0 group members found`. This establishes the group-membership baseline; it does not independently prove the absence of every other possible application assignment.  
**Result:** Pass  
**Evidence:** `../evidence/day-10/01-auditor-baseline-no-access.png`

## D10-02 — Amber Audit Partners connected organization

**Acting identity:** Baltic Finance Identity Governance administrator  
**Expected:** the existing external partner can be selected as a specific connected organization for an external request policy.  
**Observed:** `Amber Audit Partners` appeared in Connected organizations with state `Configured` and one internal sponsor.  
**Result:** Pass  
**Evidence:** `../evidence/day-10/02-connected-organization-amber.png`

## D10-03 — External-enabled catalog

**Acting identity:** Baltic Finance Identity Governance administrator  
**Expected:** the catalog is enabled and permits access-package requests from eligible external users.  
**Observed:** `BFL-External-Audit` displayed `Enabled: Yes` and `Enabled for external users: Yes`. The initial catalog listing showed zero packages and resources before subsequent configuration.  
**Result:** Pass  
**Evidence:** `../evidence/day-10/03-external-audit-catalog.png`

## D10-04 — Catalog resources and access package resource roles

**Acting identity:** Baltic Finance Identity Governance administrator  
**Expected:** the package contains the intended group and application, with membership rather than ownership of the group and an explicit App Role for Expense Portal.  
**Observed:** the resources selection showed `SG-External-Contractors` and `Expense Portal`. The access-package review displayed:

| Resource | Role |
|---|---|
| `SG-External-Contractors` | `Member` |
| `Expense Portal` | `Expense Submitter` |

**Result:** Pass  
**Evidence:**

- `../evidence/day-10/04-catalog-resources.png`
- `../evidence/day-10/05-access-package-resource-roles..png`

**Design note:** `Expense Submitter` is the existing Day 02 lab role. It allows expense submission and should not be described as read-only auditor access.

## D10-05 — External request policy and separation of duties

**Acting identity:** Baltic Finance Identity Governance administrator  
**Requestor:** External Auditor, Amber Audit Partners  
**Approver:** Anna Finance, Baltic Finance  
**Expected:** self-service requests are scoped to Amber Audit Partners, require justification and need a decision by a separate internal approver.  
**Observed:** the policy configuration showed:

- `For users not in your directory` and `Specific connected organizations`;
- `Amber Audit Partners` as the selected organization;
- `Self` enabled for requesting access;
- requestor justification required;
- one approval stage, `Choose specific approvers`, Anna Finance;
- three days to make the decision and approver justification required.

**Result:** Pass  
**Evidence:** `../evidence/day-10/06-assignment-policy-approval.png`

## D10-06 — Thirty-day assignment lifecycle configuration

**Acting identity:** Baltic Finance Identity Governance administrator  
**Expected:** assignments have a fixed, 30-day expiration; requestors cannot select their own timeline or extend access under this policy.  
**Observed:** Lifecycle showed:

```
Access package assignments expire: Number of days
Assignments expire after: 30
Users can request specific timeline: No
Allow users to extend access: No
Require access reviews: Unchecked
```

**Result:** Pass  
**Evidence:** `../evidence/day-10/07-access-package-lifecycle-30d.png`

**Scope:** this proves policy configuration, not that a 30-day timer actually elapsed.

## D10-07 — External auditor can discover the access package

**Acting identity:** `External Auditor` in My Access  
**Expected:** an eligible member of Amber Audit Partners can see `AP-External-Auditor-30D` and start a request.  
**Observed:** My Access displayed the package, its description and the `Request` action.  
**Result:** Pass  
**Evidence:** `../evidence/day-10/08-auditor-access-package-available.png`

**Evidence boundary:** screenshot 08 displays availability, **not** `Pending approval`. It is deliberately retained because it documents the requestor’s view.

## D10-08 — Submission and Pending-state evidence

**Acting identity:** `External Auditor` (requestor)  
**Expected:** a submitted request is routed into the approval workflow before resource provisioning.  
**Observed:** screenshot 08 continued to show `Request` after submission and did not capture the transient `Pending` state. Anna Finance’s later approval-history entry identifies the auditor as requester and contains the submitted justification, which confirms that a request was processed.  
**Result:** Partial evidence  
**Evidence:**

- `../evidence/day-10/08-auditor-access-package-available.png`
- `../evidence/day-10/09-auditor-request-approved.png`

**Limitation:** no claim is made that a Pending-state screenshot was collected, or that group and app roles were independently verified absent during the approval window.

## D10-09 — Business approval by Anna Finance

**Acting identity:** `anna.finance` (approver)  
**Target identity:** `External Auditor`  
**Expected:** an internal person other than the requester approves the named package request and can review its business context.  
**Observed:** Approvals → History displayed:

- decision: `Approved`;
- decision by: Anna Finance;
- package: `AP-External-Auditor-30D`;
- business justification referring to expense-record review;
- audit engagement answer `BFL-2026-External-Audit`;
- group resource role `Member` and app resource role `Expense Submitter`.

**Result:** Pass  
**Evidence:** `../evidence/day-10/09-auditor-request-approved.png`

## D10-10 — Delivered access-package assignment

**Acting identity:** Baltic Finance Identity Governance administrator  
**Target identity:** `External Auditor`  
**Expected:** the approved package request results in a delivered, time-limited assignment tied to the configured policy.  
**Observed:** Assignments showed:

```
Access package: AP-External-Auditor-30D
Policy: POL-Amber-External-Auditors
Status: Delivered
End date: 10/21/2026, 10:24:44 AM
User lifecycle: Governed
```

**Result:** Pass  
**Evidence:** `../evidence/day-10/10-access-package-assignment.png`

**Note:** the policy name above is the name actually shown in the lab; it differs from the illustrative policy name in the original lesson.

## D10-11 — Automatic group and application provisioning

**Acting identity:** Baltic Finance administrator (verification)  
**Target identity:** `External Auditor`  
**Precondition:** the access-package assignment has been delivered.  
**Expected:** the auditor appears both in `SG-External-Contractors` and in Expense Portal’s users-and-groups app-role assignments.  
**Observed:** the group Members view showed External Auditor as a Guest member. Expense Portal’s Users and groups view showed External Auditor assigned `Expense Submitter`.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-10/10-access-package-assignment.png`
- `../evidence/day-10/11-auditor-group-membership.png`
- `../evidence/day-10/12-auditor-expense-portal-assignment.png`

## D10-12 — Positive Expense Portal sign-in

**Acting identity:** `External Auditor` (Amber Audit Partners)  
**Precondition:** group and app resource roles have been provisioned.  
**Expected:** a fresh sign-in succeeds and the application exposes the intended role.  
**Observed:** Expense Portal displayed `Microsoft Entra ID authentication successful`, the External Auditor identity, `Submit expense requests`, and `Expense.Submitter`.  
**Result:** Pass  
**Evidence:** `../evidence/day-10/13-auditor-expense-portal-access.png`

## D10-13 — Terms of Use and Conditional Access

**Acting identities:** Baltic Finance Conditional Access administrator (configuration); `External Auditor` (sign-in)  
**Expected:** the target user and Expense Portal fall within an enabled Terms of Use grant control; the auditor is prompted to accept before successful access.  
**Observed:** `CA-External-Auditor-ToU` targeted `SG-External-Contractors` and Expense Portal, used `BFL-External-Auditor-ToU` as the selected grant control, and was set to On. The auditor received the Terms of Use prompt. Sign-in logs subsequently showed this policy with result `Success`.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-10/14-conditional-access-terms-of-use.png`
- `../evidence/day-10/15-auditor-terms-of-use.png`
- `../evidence/day-10/16-terms-of-use-ca-success.png`

**Evidence boundary:** the sign-in log proves successful evaluation of the grant control; a separate Terms of Use acceptance-report record was not included.

## D10-14 — Manual access-package assignment removal

**Acting identity:** Baltic Finance Identity Governance administrator  
**Target identity:** `External Auditor`  
**Precondition:** the original assignment was delivered and its configured end date had not yet arrived.  
**Expected:** manual removal terminates the package-managed entitlement.  
**Observed:** after the removal action, the assignment remained visible in Assignments with status `Expired`, policy `POL-Amber-External-Auditors`, and original end date `10/21/2026, 10:24:44 AM`.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-10/10-access-package-assignment.png`
- `../evidence/day-10/17-access-package-assignment-removed.png`

**Important:** the UI state `Expired` follows the manual removal test. It does not show that 30 days elapsed naturally.

## D10-15 — Revocation of group and application access

**Acting identities:** Baltic Finance administrator (membership check); `External Auditor` (fresh sign-in)  
**Precondition:** the Day 10 package assignment has been removed.  
**Expected:** package-managed group membership is removed and the auditor cannot access Expense Portal without another qualifying assignment.  
**Observed:** `SG-External-Contractors` returned to zero members. A fresh Expense Portal sign-in failed with `AADSTS50105`: the user was neither assigned directly to the application nor a direct member of a group with access.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-10/17-access-package-assignment-removed.png`
- `../evidence/day-10/18-auditor-group-membership-removed.png`
- `../evidence/day-10/19-auditor-expense-portal-denied.png`

**Interpretation:** this is an application-assignment denial after entitlement revocation, not proof that the B2B account was deleted. A separate account-lock message encountered during troubleshooting is not used as this test’s evidence.

## D10-16 — Automatic 30-day expiration

**Acting identity:** Entitlement Management service (scheduled lifecycle)  
**Expected:** an assignment left active for its configured 30-day duration expires without an administrator manually removing it; package-managed resource roles are then withdrawn.  
**Observed:** the policy specified 30 days, but the test assignment was removed manually before its scheduled end date. Natural expiration and its automated cleanup were not observed.  
**Result:** Not tested  
**Evidence:** `../evidence/day-10/07-access-package-lifecycle-30d.png`

## Final state

- `BFL-External-Audit`, `AP-External-Auditor-30D` and `POL-Amber-External-Auditors` remain configured in the documented lab.
- The tested auditor’s assignment was manually removed and subsequently displayed `Expired`.
- `SG-External-Contractors` returned to zero members.
- Expense Portal denied the fresh unassigned auditor sign-in with `AADSTS50105`.
- The Terms of Use Conditional Access policy was documented as enabled.
- The configured 30-day lifecycle was verified; its natural expiration was not tested.
- The `Governed` lifecycle state was observed, but no claim is made that the guest identity was deleted.

## Evidence

See [Day 10 evidence](../evidence/day-10/README.md).
