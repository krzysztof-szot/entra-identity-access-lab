# Day 13 — Workload Identities and Managed Identity

**Day 18 follow-up:** the [final Storage IAM evidence](../evidence/day-18/22-workload-rbac.png) separately confirms `Storage Blob Data Reader` at Storage Account scope for both managed identities. The runtime tests below retain their Day 13 context.

## Objectives

The goal of Day 13 was to authenticate an Azure workload to another Azure resource without storing a password, client secret, SAS token or Storage Account key in Runbook code.

The lab compared **System-assigned** and **User-assigned Managed Identities**, implemented Microsoft Entra authentication from Azure Automation to a private Azure Blob, and tested authorization boundaries with Azure RBAC. It extends Day 12's app-only authentication topic, but uses Azure-managed credentials and Storage data-plane RBAC rather than Microsoft Graph application permissions.

## Implemented

### Resources and workload

The lab reused `rg-bfl-identity-lab` in Baltic Finance and created:

| Resource | Name / purpose |
| --- | --- |
| Storage Account | `bflmi13a7k29` |
| Blob container | `identity-lab` |
| Proof blob | `bfl-identity-proof.txt` |
| Automation Account | `aa-bfl-identity-lab` |
| System-assigned Runbook | `rb-bfl-managed-identity` |
| User-assigned identity | `mi-bfl-shared-reader` |
| User-assigned Runbook | `rb-bfl-user-assigned` |
| Write-denial Runbook | `rb-bfl-mi-write-denied` |

The proof blob contained the marker `BFL-MI-READ-SUCCESS`. The Azure Portal container screenshot shows the **administrator's portal session using an access key** to browse the file; it is not evidence of the Runbook's authentication method.

### System-assigned identity and service principal

The Automation Account's System-assigned Managed Identity was enabled, and the corresponding `aa-bfl-identity-lab` service principal was located under Microsoft Entra Enterprise Applications. No separate conventional App Registration or manually managed application credential was required for this workload identity.

The recorded implementation used `Connect-AzAccount -Identity` and `New-AzStorageContext -UseConnectedAccount` for Microsoft Entra-authenticated Blob access. Job output reports authentication without a client secret or password. Only the User-assigned connection fragment is published (screenshot 17); the full Runbook source is unavailable, so credential handling and Azure context isolation cannot be independently inspected.

### Negative test before Storage data RBAC

Before granting the required data-plane role, the System-assigned Managed Identity authenticated but could not read the private Blob. The Runbook test failed with HTTP `403`, `AuthorizationPermissionMismatch`.

This distinguishes **authentication** (getting a token as the workload) from **authorization** (permission to perform a particular Blob operation).

### Least-privilege Azure RBAC and successful read

`Storage Blob Data Reader` was assigned to `aa-bfl-identity-lab` at the Storage Account scope. The Storage IAM view recorded the resulting role assignment, and Azure Activity Log showed a successful `Create role assignment` event.

With the role in place, the same Runbook completed authentication and Blob read successfully. It returned the proof marker `BFL-MI-READ-SUCCESS` and `DAY 13 RESULT: PASS`.

The Runbook was published using the `re-bfl-ps74` PowerShell 7.4 runtime. A separate completed job showed the published Runbook could also read the Blob; the Test pane was not the only successful execution.

### Negative write test

`rb-bfl-mi-write-denied` used the System-assigned identity to attempt an upload to `identity-lab`. The test output recorded:

```text
AUTHENTICATION: SUCCESS
EXPECTED WRITE DENIED
Authorization: FAILED AS EXPECTED
Least Privilege: PASS
DAY 13 WRITE TEST: PASS
```

The reported behavior is consistent with a read-only data role. However, the screenshot does not expose the raw Storage error or the Runbook's exception filter. The write-denial result is therefore **Partial**: the audit cannot distinguish an authorization denial from another error handled as an expected failure. A rerun should capture the Storage authorization error and publish the sanitized upload/catch source.

### User-assigned identity

The standalone `mi-bfl-shared-reader` identity was created and attached to `aa-bfl-identity-lab`. A separate Runbook selected that identity explicitly with:

```powershell
Connect-AzAccount -Identity -AccountId $userAssignedClientId
```

The User-assigned Runbook reported `mi-bfl-shared-reader`, successful authentication, a successful Blob read, and `DAY 13 RESULT: PASS`. Its success demonstrates that this second identity had effective read authorization; the evidence set does not include a separate screenshot of its role assignment.

### Monitoring

Microsoft Entra **Managed identity sign-ins** showed successful entries for both `aa-bfl-identity-lab` and `mi-bfl-shared-reader` targeting Azure Storage and Azure Resource Manager. These sign-ins demonstrate authentication/token issuance; the Runbook outputs provide the separate proof of allowed and denied Blob operations.

## Design Decisions

- Use Azure Automation instead of an additional VM to execute the workload.
- Keep System-assigned and User-assigned identities distinct, including explicit `-AccountId` selection for the latter.
- Authenticate to Storage with Microsoft Entra rather than keys, SAS tokens or manually stored secrets in the Runbook.
- Grant `Storage Blob Data Reader` at the test Storage Account scope instead of broad Contributor/Owner access.
- Record **deny → role assignment → successful read → denied write** to validate least privilege, not only successful connectivity.
- Retain a completed published Runbook job and Entra sign-in evidence in addition to Test pane outputs.

## Verification and Scope

The recorded evidence supports Managed Identity authentication, a reported pre-RBAC read denial with raw `403`, successful read output after Azure RBAC, a successful published Runbook job, explicit User-assigned identity selection and successful sign-ins for both identities. The write test reports denial but remains partially verified; complete Runbook source and the raw write error are missing.

This day did **not** implement a Windows gMSA, test Microsoft Graph permissions for a Managed Identity, or demonstrate automatic infrastructure cleanup. No full access tokens or application credentials are published.

## Evidence and Tests

- [Day 13 test results](../tests/day-13.md)
- [Day 13 evidence](../evidence/day-13/README.md)

Sensitive tenant, subscription and identity identifiers were redacted where appropriate.
