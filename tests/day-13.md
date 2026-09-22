# Day 13 — Workload Identities and Managed Identity Tests

Tests validate System-assigned and User-assigned Managed Identity authentication from Azure Automation, private Blob authorization with Azure RBAC, negative access cases, a published Runbook job and Microsoft Entra workload sign-in monitoring.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D13-01 | Resource preparation | Storage, proof Blob and Automation Account exist | Deployments succeeded; `identity-lab/bfl-identity-proof.txt` visible | Pass |
| D13-02 | System-assigned identity | Automation Account has an enabled Managed Identity and corresponding Entra service principal | Identity On; `aa-bfl-identity-lab` shown in Enterprise Applications | Pass |
| D13-03 | Read before data RBAC | Authentication succeeds but private Blob read is denied | Authentication Success; HTTP 403 / `AuthorizationPermissionMismatch` | Pass |
| D13-04 | Scoped reader assignment | System-assigned identity receives `Storage Blob Data Reader` at the test Storage Account | IAM showed the role at `This resource`; Activity Log showed successful role assignment | Pass |
| D13-05 | Read after data RBAC | The System-assigned identity can read the proof Blob | Blob authorization/read Success and `BFL-MI-READ-SUCCESS` | Pass |
| D13-06 | Published Runbook | The published PowerShell Runbook completes the read, not only the Test pane | Published status and completed job output with `DAY 13 RESULT: PASS` | Pass |
| D13-07 | User-assigned identity | Standalone identity attaches to Automation Account and is selected explicitly | `mi-bfl-shared-reader` attached; `-AccountId $userAssignedClientId` in Runbook | Pass |
| D13-08 | User-assigned Blob read | The selected User-assigned identity authenticates and reads the proof Blob | User-assigned identity named in output; authentication and Blob read Success | Pass |
| D13-09 | Denied write under Reader | System-assigned identity cannot upload a new Blob | `EXPECTED WRITE DENIED`; `Least Privilege: PASS` | Pass |
| D13-10 | Managed Identity sign-ins | Both identities show successful workload sign-ins | Success for each identity to Azure Storage and Azure Resource Manager | Pass |

## D13-01 — Resource preparation

**Acting identity:** Baltic Finance Azure resource administrator.  
**Expected:** test Storage Account, Blob container, proof file and Automation Account are available.  
**Observed:** Storage and Automation deployments completed; `identity-lab` displayed `bfl-identity-proof.txt`.  
**Result:** Pass.  
**Evidence:**

- [01 — Storage deployment](../evidence/day-13/01-storage-account-created.png)
- [02 — Proof Blob](../evidence/day-13/02-private-blob-container.png)
- [03 — Automation deployment](../evidence/day-13/03-automation-account-created.png)

**Evidence boundary:** the portal shows `Authentication method: Access key` for its browsing session. This screenshot is not used to prove Managed Identity authentication.

## D13-02 — System-assigned Managed Identity

**Acting identity:** Baltic Finance Azure resource administrator.  
**Expected:** `aa-bfl-identity-lab` has its System-assigned identity enabled and represented in Microsoft Entra.  
**Observed:** Identity showed `On`; Enterprise Applications showed `aa-bfl-identity-lab`.  
**Result:** Pass.  
**Evidence:**

- [04 — System-assigned identity](../evidence/day-13/04-system-assigned-managed-identity.png)
- [05 — Entra service principal](../evidence/day-13/05-managed-identity-service-principal.png)

## D13-03 — Read denied before data RBAC

**Acting identity:** `aa-bfl-identity-lab` System-assigned MI, running the main Runbook.  
**Expected:** authentication succeeds, but reading the private Blob without the required Storage data role fails.  
**Observed:** `AUTHENTICATION: SUCCESS`; `BLOB ACCESS: FAILED`; HTTP `403` / `AuthorizationPermissionMismatch`. The overall test job failed, as expected for this negative scenario.  
**Result:** Pass.  
**Evidence:** [06 — Read denied before RBAC](../evidence/day-13/06-managed-identity-rbac-denied.png)

## D13-04–D13-05 — Reader RBAC and positive Blob read

**Acting identities:** Azure RBAC administrator (assignment); System-assigned MI (read).  
**Expected:** the workload receives `Storage Blob Data Reader` at Storage Account scope and can then read `bfl-identity-proof.txt`.  
**Observed:** IAM displayed `aa-bfl-identity-lab` with `Storage Blob Data Reader` and `This resource` scope. Activity Log showed `Create role assignment` Succeeded. A new Test pane execution reported successful authentication, Blob authorization and read, including `BFL-MI-READ-SUCCESS`.  
**Result:** Pass.  
**Evidence:**

- [07 — Storage role assignment](../evidence/day-13/07-managed-identity-storage-rbac.png)
- [08 — System-assigned read success](../evidence/day-13/08-managed-identity-blob-access-success.png)
- [11 — Activity Log role assignment](../evidence/day-13/11-storage-role-assignment-activity.png)

**Interpretation:** Activity Log records the role change. Successful Blob access is demonstrated by the Runbook output, not by Activity Log alone.

## D13-06 — Published Runbook execution

**Acting identity:** System-assigned MI through `rb-bfl-managed-identity`.  
**Expected:** a published PowerShell Runbook completes and reads the proof Blob outside the Test pane.  
**Observed:** Runbook displayed Published, with `re-bfl-ps74` as Runtime Environment. A separate job showed Completed and `DAY 13 RESULT: PASS`.  
**Result:** Pass.  
**Evidence:**

- [09 — Published Runbook](../evidence/day-13/09-runbook-published.jpg)
- [10 — Completed job](../evidence/day-13/10-published-runbook-job-success.png)

## D13-07–D13-08 — User-assigned identity and read

**Acting identity:** `mi-bfl-shared-reader`, selected by `rb-bfl-user-assigned`.  
**Expected:** a standalone Managed Identity attaches to Automation Account; the Runbook selects it explicitly and successfully reads the Blob.  
**Observed:** identity Overview and Automation Identity view showed `mi-bfl-shared-reader` created and attached. The code used `Connect-AzAccount -Identity -AccountId $userAssignedClientId`. The Test pane output identified `mi-bfl-shared-reader` and showed successful authentication, Blob authorization and read.  
**Result:** Pass.  
**Evidence:**

- [12 — User-assigned identity created](../evidence/day-13/12-user-assigned-identity-created.png)
- [13 — Attached identity](../evidence/day-13/13-user-assigned-identity-attached.png)
- [14 — User-assigned read success](../evidence/day-13/14-user-assigned-identity-success.png)
- [17 — Explicit identity selection in code](../evidence/day-13/17-user-assigned-identity-code.png)

**Evidence boundary:** a standalone IAM screenshot for the User-assigned identity's role is not included; the successful read demonstrates effective access.

## D13-09 — Least-privilege write denial

**Acting identity:** `aa-bfl-identity-lab` System-assigned MI via `rb-bfl-mi-write-denied`.  
**Expected:** the Data Reader identity cannot upload a new Blob.  
**Observed:** `AUTHENTICATION: SUCCESS`, `EXPECTED WRITE DENIED`, `Authorization: FAILED AS EXPECTED`, `Least Privilege: PASS`.  
**Result:** Pass.  
**Evidence:** [15 — Write denied](../evidence/day-13/15-managed-identity-write-denied.png)

**Evidence boundary:** the Runbook reports its handled denial, not the raw HTTP response for this write attempt. HTTP 403 is explicitly shown in D13-03 for the earlier read-denial test.

## D13-10 — Workload sign-in monitoring

**Acting identity:** Baltic Finance sign-in log reader.  
**Expected:** both Managed Identities appear in the Managed identity sign-ins category with successful authentication.  
**Observed:** `aa-bfl-identity-lab` and `mi-bfl-shared-reader` each showed Success for Azure Storage and Azure Resource Manager.  
**Result:** Pass.  
**Evidence:** [16 — Managed Identity sign-ins](../evidence/day-13/16-managed-identity-sign-in-log.png)

**Interpretation:** sign-in logs establish authentication, not whether a specific Blob read or write was authorized.

## Final state

- The System-assigned MI read the proof Blob after `Storage Blob Data Reader` was assigned.
- The same identity's pre-assignment read failed with `403`, and its post-assignment write test was denied as expected.
- The published System-assigned Runbook completed successfully.
- The separate User-assigned MI was attached, explicitly selected and used successfully for Blob read.
- Both identities appeared in successful Microsoft Entra Managed identity sign-ins.
- No gMSA implementation, Microsoft Graph permission assignment for MI, or infrastructure cleanup is claimed.

See [Day 13 evidence](../evidence/day-13/README.md) and [Day 13 implementation notes](../docs/day-13.md).
