# Day 17 — Microsoft Graph PowerShell Automation — Evidence

**Follow-up:** Day 18 adds the [successful CA CSV export](../day-18/02-graph-inventory.png) and [test-role removal audit](../day-18/05-privilege-remediation.png). The screenshots below remain the original Day 17 record.

The screenshots document delegated Microsoft Graph PowerShell administration in Baltic Finance Lab: read operations, lab-user and security-group provisioning, membership idempotency, a real Entra role-authorization boundary, selected tenant inventory and an Entra audit event.

- [01 — PowerShell and Graph SDK](01-graph-powershell-installed.png) — PowerShell 7.6.6, Microsoft.Graph.Authentication 2.40.0 and the available `Connect-MgGraph` cmdlet.
- [02 — Delegated connection](02-graph-delegated-connection.png) — `adm-lab` connected with delegated authentication in Read mode. The displayed context also includes previously available write scopes: the mode label **does not** prove a read-only token.
- [03 — Read existing objects](03-graph-read-users-groups-apps.png) — filtered Graph queries return Baltic Finance users, groups and earlier lab applications.
- [04 — Lab-user properties](04-graph-user-created.png) — `Graph Automation Operator` exists with IT department, test job title and enabled account. The captured output says **User already exists**; the image alone is not the successful `New-MgUser` response.
- [05 — User idempotency](05-graph-user-idempotency.png) — a repeated provisioning run finds the existing user rather than creating a duplicate.
- [06 — Security-group creation](06-graph-security-group-created.png) — PowerShell reports creation of `SG-Graph-Automation-Lab`; subsequent query shows SecurityEnabled True and MailEnabled False.
- [07 — Initial group validation](07-graph-group-validation.png) — Entra portal confirms a cloud Security group with Assigned membership and **zero direct members before** the membership test.
- [08 — Add and verify group member](08-graph-group-membership.png) — script adds `graph.operator`, a Graph lookup verifies membership and a repeat run reports an existing member.
- [09 — Portal membership validation](09-graph-group-membership-portal.png) — Entra displays Graph Automation Operator as the group's direct member.
- [10 — Role definition](10-graph-role-definition.png) — Graph resolves the `Conditional Access Administrator` definition; reading a definition is not permission to assign it.
- [11 — Role-assignment dry run](11-graph-role-assignment-dry-run.png) — the role-assignment script prints target, role and tenant scope without creating an assignment.
- [12 — Insufficient privilege](12-graph-role-assignment-denied.png) — `adm-lab` explicitly requests an assignment but Graph responds **403 Forbidden / Authorization_RequestDenied**.
- [13 — Authorized role assignment](13-graph-role-assignment-authorized.png) — a separate delegated `roleops-lab` context has `RoleManagement.ReadWrite.Directory`; the same operation reports **Role assignment created**. This is a direct tenant-wide assignment, **not** a PIM Eligible assignment or time-limited activation. Removal is not shown.
- [14 — Local tenant export](14-graph-tenant-export.png) — users, groups, group membership, role assignments, App Registrations and Enterprise Applications exported to local CSV files. **Conditional Access was skipped** in this captured run because `Policy.Read.All` was absent; the image must not be described as a complete seven-file export.
- [15 — Application and service-principal inventory](15-graph-applications-query.png) — separate `Get-MgApplication` and `Get-MgServicePrincipal` queries show Expense Portal, BFL SAML Lab and BFL Provisioning Lab.
- [16 — Conditional Access inventory](16-graph-conditional-access-query.png) — a separate successful query lists eight Conditional Access policies and their states. This proves query access, **not** that `conditional-access.csv` was written in screenshot 14.
- [17 — Add-user audit event](17-graph-automation-audit-logs.png) — successful `Add user` / UserManagement record targets `graph.operator`, identifies `adm-lab` and Microsoft Graph Command Line Tools. Combined with 04–05, this corroborates provisioning without recreating the account.

**Evidence boundaries:** screenshot 13 does not show the test role being removed; no privileged-role cleanup screenshot is present. Screenshot 14 remains a partial export even though the checked-in `01-connect-graph.ps1` now requests `Policy.Read.All` in Read mode and the separate CA query succeeds. The separate Day 18 screenshot 02 reports a successful CA CSV export; its contents are not published. Neither day's captures constitute a tenant rerun of the subsequently audited scripts. The CSV exports are local and excluded through `.gitignore`; they are not a full Entra backup. Identifiers and user-specific details are redacted where appropriate; no password, access token or client secret is shown.
