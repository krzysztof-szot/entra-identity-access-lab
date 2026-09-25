# Day 09 — Privileged Identity Management Tests

Tests validate the Just-in-Time activation lifecycle for the Microsoft Entra `Conditional Access Administrator` role: Eligible assignment, pre-activation access denial, justification, approval, temporary access, audit and automatic expiration.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D9-01 | PIM role settings | MFA, justification and approval are required; activation is limited to one hour | Role settings show Azure MFA, justification Yes, approval Yes, one approver and a one-hour maximum | Pass |
| D9-02 | Eligible assignment | `adm-lab` is permanently Eligible rather than permanently Active | Assignment and My roles show `Conditional Access Administrator` as Eligible with a permanent end time | Pass |
| D9-03 | Pre-activation access boundary | `adm-lab` cannot administer Conditional Access Policies without activating the role | Policies view returned 401, insufficient privileges | Pass |
| D9-04 | Activation request | `adm-lab` requests a one-hour activation with a business justification | Activation form shows one hour and the lab justification | Pass |
| D9-05 | Approval gate | The request waits for a separate approver | My requests showed Pending approval; `pim-approver` received the request | Pass |
| D9-06 | Temporary role activation | Approved request produces an Activated role with an end time | My roles showed Conditional Access Administrator as Activated with a scheduled end time | Pass |
| D9-07 | Privileged operation | After elevation, the operator can reach Conditional Access and create a disabled validation policy | `adm-lab` could view `CA009-PIM-Validation` with State Off; creator-specific audit not captured | Partial evidence |
| D9-08 | Activation audit trail | Request, approval and completed activation are recorded | PIM Resource audit showed the request, approval request, approval and completed activation | Pass |
| D9-09 | Automatic expiration | Temporary privilege expires while Eligible assignment remains | My roles returned to Eligible with Activate available | Pass |
| D9-10 | Expiration audit trail | Audit explicitly identifies the automatic expiry | Resource audit recorded `Remove member from role (PIM activation expired)` with success | Pass |

## D9-01 — PIM role settings

**Acting identity:** PIM administrator  
**Target role:** `Conditional Access Administrator`  
**Expected:** activation requires MFA, business justification and approval, and lasts no more than one hour.  
**Observed:** settings showed one-hour activation maximum, Azure MFA, justification Yes, approval Yes and one designated approver. The role-policy setting also permits permanent Active assignments, but this is not the assignment type used for `adm-lab`.  
**Result:** Pass  
**Evidence:** `../evidence/day-09/01-conditional-access-admin-pim-settings.png`

## D9-02 — Eligible role assignment

**Acting identity:** `adm-lab` (role holder)  
**Expected:** `adm-lab` can request the Conditional Access Administrator role without retaining a permanent Active assignment.  
**Observed:** role assignments and My roles showed a direct Eligible assignment for Baltic Finance Lab with `End time: Permanent` and an `Activate` action.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-09/02-adm-lab-eligible-conditional-access-admin.png`
- `../evidence/day-09/03-adm-lab-my-roles-eligible.png`

## D9-03 — Access before activation

**Acting identity:** `adm-lab`  
**Precondition:** Conditional Access Administrator has not been activated.  
**Expected:** the user cannot administer Conditional Access Policies by virtue of Eligible status alone.  
**Observed:** the Conditional Access Policies view returned `You don't have access`, error code `401` and `Insufficient privileges to complete the operation`.  
**Result:** Pass  
**Evidence:** `../evidence/day-09/04-before-pim-activation-no-admin-access.png`

## D9-04 — Activation request and justification

**Acting identity:** `adm-lab`  
**Expected:** the activation request specifies a one-hour duration and a business justification.  
**Observed:** the form showed `Duration (hours): 1` and:

```text
Day 09 lab - temporary privileged access required to validate Conditional Access administration.
```

**Result:** Pass  
**Evidence:** `../evidence/day-09/05-pim-activation-request.png`

**Note:** the role setting requires Azure MFA, but this screenshot does not separately prove whether a fresh MFA prompt occurred during activation.

## D9-05 — Approval workflow and separation of duties

**Acting identities:** `adm-lab` (requester) and `pim-approver` (approver)  
**Expected:** the activation does not proceed directly; a separate identity handles the pending request.  
**Observed:** `adm-lab`'s My requests showed `Pending approval`; the `pim-approver` session displayed the selected activation request with Approve/Deny controls. Resource audit subsequently confirmed the request was approved.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-09/06-pim-request-pending-approval.png`
- `../evidence/day-09/07-bg01-pim-approval.png`
- `../evidence/day-09/10-pim-resource-audit-activation.png`

**Filename note:** `07-bg01-pim-approval.png` was retained for evidence continuity; the screenshot shows `pim-approver`, not `bg01`.

## D9-06 — Temporary Active role

**Acting identity:** `adm-lab`  
**Precondition:** the activation request was approved.  
**Expected:** the role becomes Active temporarily, with a defined expiration time.  
**Observed:** My roles displayed `Conditional Access Administrator` in Active assignments, state `Activated`, with an end time of `9/21/2026, 8:52:42 AM` as displayed by the portal.  
**Result:** Pass  
**Evidence:** `../evidence/day-09/08-conditional-access-admin-active.png`

## D9-07 — Privileged Conditional Access action

**Acting identity:** `adm-lab` after PIM activation  
**Expected:** the elevated identity can access Conditional Access Policies and create a safe validation policy.  
**Observed:** `CA009-PIM-Validation` appeared in the policy inventory with `State: Off`.  
**Result:** Partial evidence (policy visible to the elevated user; creation actor not independently established).  
**Evidence:** `../evidence/day-09/09-privileged-action-ca-policy-created.png`

**Evidence boundary:** this screenshot confirms the policy exists after elevation; it does not independently show the creator in Entra Audit logs.

**Follow-up:** capture the policy-creation Audit event with `adm-lab` as initiator and `CA009-PIM-Validation` as target, preserving time/correlation context while masking sensitive values.

## D9-08 — Activation audit history

**Acting identity:** PIM auditor/administrator  
**Expected:** the PIM activation workflow is traceable through request, approval and activation.  
**Observed:** Resource audit showed successful events for role requested, approval requested, request approved and activation completed.  
**Result:** Pass  
**Evidence:** `../evidence/day-09/10-pim-resource-audit-activation.png`

## D9-09 — Automatic expiration

**Acting identity:** `adm-lab`  
**Precondition:** the activation window has ended without manually deactivating the role.  
**Expected:** the temporary Active role expires while the original Eligible assignment remains available.  
**Observed:** My roles displayed `Conditional Access Administrator` under Eligible assignments with `Activate` available and `End time: Permanent`.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-09/08-conditional-access-admin-active.png`
- `../evidence/day-09/11-pim-automatic-expiration.png`

## D9-10 — Expiration audit history

**Acting identity:** PIM auditor/administrator  
**Expected:** automatic role removal is recorded as an expiration rather than as manual deactivation.  
**Observed:** Resource audit showed a successful `Remove member from role (PIM activation expired)` event, with `Azure AD PIM` as requestor and `Conditional Access Administrator` as primary target.  
**Result:** Pass  
**Evidence:** `../evidence/day-09/12-pim-audit-automatic-expiration.png`

## Final state

- `adm-lab` retains its permanent Eligible Conditional Access Administrator assignment.
- The recorded one-hour Active assignment expired automatically.
- PIM activation settings require Azure MFA, justification and approval.
- `pim-approver` served as the separate approver in the tested workflow.
- The validation policy `CA009-PIM-Validation` was observed in the Off state.
- PIM audit history confirms the request-to-activation sequence and automatic expiration.
- PIM for Groups and PIM for Azure resources were conceptual review topics, not practical tests in this lab.

## Evidence

See [Day 09 evidence](../evidence/day-09/README.md).
