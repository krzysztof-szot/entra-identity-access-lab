# Day 09 — Privileged Identity Management

## Objectives

The goal of Day 09 was to replace standing Conditional Access administrative access for `adm-lab` with a Just-in-Time privilege elevation workflow using Microsoft Entra Privileged Identity Management (PIM).

The lab focused on:

- Eligible versus Active role assignments,
- one-hour activation duration,
- MFA and business justification requirements,
- approval by a separate identity,
- proving access boundaries before and after activation,
- performing a controlled privileged action,
- PIM resource audit and automatic expiration.

## Implemented

### Roles and responsibilities

The lab separated the requesting identity from the approving identity:

- `adm-lab` — permanent Eligible role holder, requester and temporary privileged operator;
- `pim-approver` — separate identity handling the activation approval;
- `bg01` and `bg02` — emergency-access identities, not used as the approver in the recorded workflow.

The `07-bg01-pim-approval.png` filename was retained, but its screenshot shows `pim-approver`, not `bg01`.

### Conditional Access Administrator activation settings

PIM role settings for `Conditional Access Administrator` were configured with:

| Setting | Configured value |
| --- | --- |
| Maximum activation duration | 1 hour |
| MFA on activation | Azure MFA |
| Justification on activation | Required |
| Ticket information on activation | Not required |
| Approval to activate | Required |
| Approvers | One designated member |
| Permanent Eligible assignments | Allowed |

The recorded settings also allow permanent Active assignments at the **role-policy level**. This does not mean that `adm-lab` has a permanent Active assignment; the lab's user-specific assignment was Eligible.

### Eligible assignment

`adm-lab` was assigned `Conditional Access Administrator` as:

```text
Assignment type: Eligible
Scope: Baltic Finance Lab
End time: Permanent
```

The distinction is intentional:

`Permanent Eligible ≠ Permanent Active`

An Eligible assignment permits the user to request activation. The one-hour maximum applies to the resulting temporary Active role, not to the lifetime of the Eligible assignment.

### Access before activation

Before activation, `adm-lab` attempted to open Conditional Access Policies.

The portal returned:

```text
You don't have access
Error code: 401
Insufficient privileges to complete the operation.
```

This was the negative test confirming the administrative access boundary prior to Just-in-Time elevation.

### Activation and approval

`adm-lab` submitted a PIM activation request for `Conditional Access Administrator` with a one-hour duration and the business justification:

```text
Day 09 lab - temporary privileged access required to validate Conditional Access administration.
```

The request entered `Pending approval`.

A separate `pim-approver` session handled the approval. After approval, `adm-lab`'s role appeared under Active assignments as `Activated`, with a defined end time.

Azure MFA was required in the role settings. The screenshots document the requirement, but do not independently establish that a new MFA prompt was displayed during this specific activation; an already-satisfied MFA session may meet that requirement.

### Privileged administrative action

During the activation window, `adm-lab` accessed Conditional Access Policies. The lab notes report creating the dedicated validation policy:

`CA009-PIM-Validation`

The policy was left:

`State: Off`

This demonstrates access to the administrative surface after elevation while avoiding enforcement of a new Conditional Access rule in the lab. The policy-list screenshot documents the resulting object and a creation time within the activation window; it does not independently establish who created it. Creator attribution remains partially evidenced until a matching Audit log entry is captured.

### PIM audit and automatic expiration

PIM Resource audit recorded the activation workflow, including:

- `Add member to role requested (PIM activation)`;
- `Add member to role approval requested (PIM activation)`;
- `Add member to role request approved (PIM activation)`;
- `Add member to role completed (PIM activation)`.

After the activation window, the role returned to the Eligible view with `Activate` available.

A subsequent Resource audit event explicitly recorded:

`Remove member from role (PIM activation expired)`

with `Azure AD PIM` as the requestor and a successful status. This confirms automatic expiry rather than relying only on a later Eligible-state screenshot.

## Design Decisions

### Just-in-Time privilege instead of standing access

The user retains a permanent **right to request** the role, not a permanent Active privilege. PIM activation provides temporary administrative access only when needed.

### Separation of duties

The requester (`adm-lab`) and approver (`pim-approver`) were separate identities. The approver was not the same account that requested the privileged activation.

### Short activation window and auditability

The role was limited to a maximum of one hour. Justification and approval produced a traceable workflow in PIM Resource audit, including the automatic removal event.

### Safe validation policy

The lab used the dedicated `CA009-PIM-Validation` policy with enforcement Off. Existing Conditional Access policies from earlier days were not modified as part of this proof.

### Scope boundary

The practical implementation covers PIM for a Microsoft Entra role. PIM for Groups and PIM for Azure resources were reviewed as related concepts, not claimed as deployed or tested in this day's evidence.

## Verification

The following scenarios were validated:

- `adm-lab` has a permanent Eligible assignment for `Conditional Access Administrator`.
- PIM settings require Azure MFA, justification and approval, with a one-hour maximum activation duration.
- Conditional Access Policies returned an insufficient-privileges error before activation.
- The activation request entered Pending approval.
- A separate `pim-approver` identity handled the request.
- `adm-lab` subsequently held the temporarily Activated role.
- `CA009-PIM-Validation` appeared in Conditional Access with State Off.
- PIM Resource audit recorded the request, approval and completed activation.
- The role returned to Eligible after the activation window.
- Resource audit recorded `Remove member from role (PIM activation expired)`.

These results demonstrate the observed JIT workflow from Eligible to temporary Active access and back to Eligible through automatic expiration.

## Evidence and Tests

- [Day 09 test results](../tests/day-09.md)
- [Day 09 evidence](../evidence/day-09/README.md)

Sensitive credentials, identifiers and tenant-specific values were redacted from published screenshots.
