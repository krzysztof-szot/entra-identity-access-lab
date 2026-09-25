# Day 13 — Evidence

This folder documents workload authentication with Microsoft Entra Managed Identities in Baltic Finance: Azure Automation accessing a private Azure Blob through Microsoft Entra ID, an initial access denial, least-privilege Azure RBAC, successful read access, denied write access, and a separate user-assigned identity test.

## Evidence

- `01-storage-account-created.png` — shows the successful deployment of Storage Account `bflmi13a7k29` in `rg-bfl-identity-lab`.
- `02-private-blob-container.png` — shows the `identity-lab` container with the test file `bfl-identity-proof.txt`. The portal view uses an access key; this screenshot does not demonstrate Managed Identity authentication.
- `03-automation-account-created.png` — shows successful deployment of Automation Account `aa-bfl-identity-lab`.
- `04-system-assigned-managed-identity.png` — confirms the Automation Account's system-assigned Managed Identity is enabled.
- `05-managed-identity-service-principal.png` — shows `aa-bfl-identity-lab` represented in Microsoft Entra Enterprise Applications.
- `06-managed-identity-rbac-denied.png` — shows successful Managed Identity authentication but a Blob read denied with HTTP 403 / `AuthorizationPermissionMismatch` before the required data role was assigned.
- `07-managed-identity-storage-rbac.png` — shows `Storage Blob Data Reader` assigned to `aa-bfl-identity-lab` at the Storage Account scope.
- `08-managed-identity-blob-access-success.png` — shows successful Microsoft Entra authentication and private Blob read after the RBAC assignment (`BFL-MI-READ-SUCCESS`).
- `09-runbook-published.jpg` — shows `rb-bfl-managed-identity` published with the PowerShell 7.4 runtime environment.
- `10-published-runbook-job-success.png` — shows a completed published Runbook job and successful Blob read, beyond the Test pane execution.
- `11-storage-role-assignment-activity.png` — shows the successful `Create role assignment` operation in Azure Activity Log; it records the permission change, not the Blob read itself.
- `12-user-assigned-identity-created.png` — shows the standalone `mi-bfl-shared-reader` user-assigned Managed Identity.
- `13-user-assigned-identity-attached.png` — confirms `mi-bfl-shared-reader` is attached to the Automation Account.
- `14-user-assigned-identity-success.png` — shows successful authentication and Blob read using `mi-bfl-shared-reader`.
- `15-managed-identity-write-denied.png` — reports an attempted Blob upload and expected denial (`Least Privilege: PASS`). The raw Storage error and exception-filtering source are absent, so authorization-denial validation is Partial.
- `16-managed-identity-sign-in-log.png` — shows successful sign-ins for both Managed Identities to Azure Storage and Azure Resource Manager. Sign-in success confirms authentication, not authorization for every Blob operation.
- `17-user-assigned-identity-code.png` — shows the User-assigned Runbook selecting a specific identity with `Connect-AzAccount -Identity -AccountId $userAssignedClientId`.

The recorded design and job output describe Microsoft Entra authentication without stored application or Storage credentials. Only a connection-code fragment is published; complete credential handling and exception handling are not independently inspectable. Sensitive identifiers were redacted where appropriate; no access tokens or credentials are visible in these captures.
