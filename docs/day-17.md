# Day 17 — Microsoft Graph PowerShell Automation

## Objectives

Day 17 turns existing Baltic Finance Entra ID administration into a small, reusable set of **six PowerShell scripts**. The lab covers delegated Graph sign-in, identity and group lifecycle operations, membership idempotency, privileged-role authorization and a local inventory export. It reuses the users, apps, groups, Conditional Access and PIM concepts of Days 01–16 rather than deploying another tenant or creating a client secret.

The central troubleshooting case was real: `adm-lab` could resolve `Conditional Access Administrator` but received **403 Forbidden** when trying to assign the role; the authorized `roleops-lab` operator subsequently created the assignment.

**Day 18 follow-up:** the [successful CA export](../evidence/day-18/02-graph-inventory.png) and [audited removal of the test role](../evidence/day-18/05-privilege-remediation.png) close the two outstanding Day 17 items. Results below retain the original Day 17 capture context. See [Day 18 validation](../tests/day-18.md).

## Implemented

### Graph SDK and delegated connection

PowerShell **7.6.6** and Microsoft.Graph.Authentication **2.40.0** were verified. `01-connect-graph.ps1` requests scopes by `Read`, `IdentityWrite` or `RoleWrite` mode, uses `Connect-MgGraph -ContextScope Process`, checks the tenant and prints the authenticated account, auth type and granted scopes.

`adm-lab` successfully queried users, security groups and existing applications. The screenshot for Read mode shows some additional write scopes in the actual context; the mode is a **requested scope set**, not evidence of a least-privileged token with no other permissions.

### User and group provisioning

`02-create-user.ps1` targets the specific lab identity `graph.operator`, checks that it does not already exist and requests a temporary password interactively when creation is needed; password change is required at first sign-in. Screenshot 04 shows the account's properties and an existing-user result, not the original successful `New-MgUser` output. Screenshot 17 independently supplies a successful Microsoft Graph Command Line Tools **Add user** audit event initiated by `adm-lab`.

`03-create-group.ps1` created `SG-Graph-Automation-Lab` as a cloud Security group with Assigned membership. The portal initially showed **zero direct members**. `04-group-membership.ps1` then added `graph.operator`, verified membership by Graph and avoided a second insertion on rerun; the portal subsequently showed the direct member.

The group-creation and membership scripts check the existing state before write operations. They operate on **test objects**, not the earlier CA pilot, external-contractor or emergency-access identities.

### Privileged-role authorization test

`05-role-assignment.ps1` resolves the `Conditional Access Administrator` role, checks existing direct tenant-wide assignments and defaults to a read-only validation. A write requires both `-Execute` and explicit `ASSIGN` confirmation.

| Operator | Observed result | Interpretation |
| --- | --- | --- |
| `adm-lab` | Graph returned `403 Forbidden / Authorization_RequestDenied` | The privileged operation was denied in that delegated context; reading the role did not authorize role assignment |
| `roleops-lab` | `RoleManagement.ReadWrite.Directory` present; **Role assignment created** | Authorized delegated context completed a direct tenant-wide assignment |

Graph delegated scopes and the signed-in administrator's Entra RBAC permissions are **separate authorization layers**. This is a direct assignment, **not** a PIM Eligible grant, temporary activation or automatic one-hour expiry.

**Day 17 evidence boundary:** its 17 screenshots do not show cleanup. The separate [Day 18 removal audit](../evidence/day-18/05-privilege-remediation.png) confirms the later removal; this does not change what the original Day 17 screenshots show.

### Tenant state inventory and audit

`06-export-tenant-state.ps1` writes local timestamped CSV summaries of users, groups, group members, direct role assignments, App Registrations and Enterprise Applications. The code also conditionally exports CA policy names and states when `Policy.Read.All` is present and the Graph request succeeds.

The **captured run** successfully reported the first six CSV categories but skipped Conditional Access for missing `Policy.Read.All`. The subsequently checked-in `01-connect-graph.ps1` requests this scope in Read mode, and screenshot 16 separately shows a successful CA policy query; **a completed CA CSV export after the scope correction is not shown in the Day 17 set**; the separate Day 18 output reports its success.

The application inventory distinguishes `Get-MgApplication` (App Registration) from `Get-MgServicePrincipal` (Enterprise Application / Service Principal). The CA query shows eight policies and states at the time of capture; it does not establish their enforcement outcomes.

A successful Entra `Add user` Audit Log identifies `graph.operator` as target, `adm-lab` as initiating user and Microsoft Graph Command Line Tools as actor display name.

## Scripts

The [script instructions](../scripts/README.md) describe the audited source and local validation. Repository corrections made after these captures have not been rerun against the tenant; the screenshots validate historical runs, not every behavior of the revised scripts.

| Script | Purpose |
| --- | --- |
| [01-connect-graph.ps1](../scripts/01-connect-graph.ps1) | Delegated connection with requested read / identity-write / role-write scopes |
| [02-create-user.ps1](../scripts/02-create-user.ps1) | Lab-user provisioning with existing-user check and interactive password |
| [03-create-group.ps1](../scripts/03-create-group.ps1) | Idempotent test Security group creation |
| [04-group-membership.ps1](../scripts/04-group-membership.ps1) | Add test user once to the dedicated group |
| [05-role-assignment.ps1](../scripts/05-role-assignment.ps1) | Read-only validation or confirmed direct role assignment |
| [06-export-tenant-state.ps1](../scripts/06-export-tenant-state.ps1) | Local selected-configuration CSV snapshot |

## Design Decisions

- Use delegated authentication with distinct everyday and privileged operators; no app secret, certificate, token or password is committed.
- Restrict identity and role writes to named lab objects, check for duplicates and require explicit confirmation for the privileged write.
- Preserve the genuine negative `403` and subsequent positive role assignment rather than presenting all operations as successes by `adm-lab`.
- Separate App Registrations from Service Principals and export only selected human-readable properties.
- Keep `local-output/` out of Git through `.gitignore`; exports contain identity-related information and are **not** published.
- Treat the role export as direct assignment inventory, **not** effective access including PIM Eligible roles, group-based role assignment or all privileged-access paths.

## Verification and Limitations

**Verified by published evidence:** SDK availability; delegated sign-in; object queries; test-user properties and duplicate prevention; successful Add-user audit event; group creation and membership; role definition and dry run; real `adm-lab` authorization denial; successful `roleops-lab` direct assignment; local export of six categories; separate application/Service Principal and CA policy queries.

**Not verified by the Day 17 screenshots:** the original user-creation console success from screenshot 04; the later successful CA CSV export or deletion of the direct test role (both have separate Day 18 evidence); a time-bound PIM activation; a full-fidelity Entra backup; or a complete effective-access report. The export catches membership-read errors and may contain `[non-user or unavailable]` placeholders, so its membership/role-name reports must not be treated as exhaustive object-resolved inventories.

## Evidence and Tests

- [Day 17 test results](../tests/day-17.md)
- [Day 17 evidence](../evidence/day-17/README.md)

Sensitive screenshot identifiers were masked. The source scripts include lab-specific account names and UPN checks, which are identifiers rather than passwords or secrets.
