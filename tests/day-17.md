# Day 17 — Microsoft Graph PowerShell Automation Tests

Results below reflect **published screenshots and the checked-in scripts**. A script that supports an operation is not, by itself, proof that the operation was successfully rerun after a code change. **Pass** means the described observation is evidenced; **Partial / not evidenced** marks the narrower proof boundary.

**Day 18 follow-up:** the [successful CA export](../evidence/day-18/02-graph-inventory.png) and [audited removal of the test role](../evidence/day-18/05-privilege-remediation.png) close the two outstanding Day 17 items. Results below retain the original Day 17 capture context. See [Day 18 validation](../tests/day-18.md).

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D17-01 | SDK installed | Graph cmdlets available in PowerShell 7 | PowerShell 7.6.6, Authentication 2.40.0, `Connect-MgGraph` available | Pass |
| D17-02 | Delegated connection | Lab tenant and operator context established | `adm-lab`, delegated auth; Read mode displayed | Pass (not read-only scope exclusivity) |
| D17-03 | Read objects | Users, groups and apps returned | Existing Baltic Finance users, groups and apps queried | Pass |
| D17-04 | User properties | Test user exists with intended properties | `graph.operator`: IT, test job title, enabled | Pass (properties; not creation output) |
| D17-05 | User idempotency | Rerun does not create duplicate | `User already exists` | Pass |
| D17-06 | Create group | Dedicated Security group is created | Creation message; SecurityEnabled True, MailEnabled False | Pass |
| D17-07 | Initial group state | Cloud Assigned group starts empty | Portal shows zero direct members | Pass (before add) |
| D17-08 | Add group member | Test user added and lookup verifies membership | Added; verified; rerun reports existing member | Pass |
| D17-09 | Portal membership | Direct member visible in Entra | Graph Automation Operator listed | Pass |
| D17-10 | Query role definition | CA Administrator role resolved | Role name and description returned | Pass (read operation) |
| D17-11 | Dry run | No role assignment is created | Script reports read-only validation | Pass |
| D17-12 | RBAC negative test | Unauthorized operator cannot assign role | `adm-lab`: 403 / Authorization_RequestDenied | Pass |
| D17-13 | Authorized assignment | Authorized operator creates direct role assignment | `roleops-lab`: assignment created at tenant scope | Pass (direct assignment, not PIM) |
| D17-14 | Tenant export | Selected CSV inventories written locally | Six categories reported exported; CA skipped for missing scope | Partial (CA CSV not shown) |
| D17-15 | Application inventory | App Registrations distinguished from Service Principals | Three selected apps returned by separate commands | Pass |
| D17-16 | Conditional Access inventory | CA policy names and states readable | Eight policies/states returned by a separate Graph query | Pass (not CSV-export proof) |
| D17-17 | Audit correlation | Created user has audit trail | Successful Add user, `adm-lab`, Microsoft Graph Command Line Tools, test user target | Pass |
| D17-18 | Privileged role cleanup | Remove test assignment after capture | No removal confirmation in published evidence | Not evidenced |
| D17-19 | Safe publication | Secrets and raw exports not published | `.gitignore` excludes `local-output/`; screenshots are redacted; no credentials/tokens apparent in checked-in scripts | Pass (repository review; no runtime secret scan) |

## D17-01–D17-05 — Graph connection and user

**Acting identity:** `adm-lab`.  
**Expected:** an installed Graph SDK, delegated tenant connection, successful queries and repeat-safe lab provisioning.  
**Observed:** SDK and queries are visible; existing-user properties were read, a subsequent rerun avoided duplication, and Day 17 Audit Logs corroborate the original Add-user operation.  
**Evidence:** [01](../evidence/day-17/01-graph-powershell-installed.png), [02](../evidence/day-17/02-graph-delegated-connection.png), [03](../evidence/day-17/03-graph-read-users-groups-apps.png), [04](../evidence/day-17/04-graph-user-created.png), [05](../evidence/day-17/05-graph-user-idempotency.png), [17](../evidence/day-17/17-graph-automation-audit-logs.png).  
**Boundary:** screen 04 says `User already exists`; it must not be called a successful `New-MgUser` console result. Read mode does not guarantee only read permissions in the granted context.

## D17-06–D17-09 — Group and membership

**Acting identity:** `adm-lab`.  
**Expected:** create the test Security group, add `graph.operator` exactly once and verify it in Graph and portal.  
**Observed:** group created; portal initially showed zero direct members; script added and verified member; rerun did not duplicate; portal subsequently showed one member.  
**Result:** Pass for shown actions.  
**Evidence:** [06](../evidence/day-17/06-graph-security-group-created.png), [07](../evidence/day-17/07-graph-group-validation.png), [08](../evidence/day-17/08-graph-group-membership.png), [09](../evidence/day-17/09-graph-group-membership-portal.png).

## D17-10–D17-13 — Privileged-role boundary

**Acting identities:** `adm-lab` (dry run and denied write), `roleops-lab` (authorized write).  
**Expected:** resolve the role; avoid implicit writes; deny insufficient RBAC; allow an explicitly confirmed write under the authorized operator.  
**Observed:** role definition returned; dry run created no role; Graph denied `adm-lab` with 403; `roleops-lab` successfully created a direct tenant-wide assignment.  
**Result:** Pass for these distinct observations.  
**Evidence:** [10](../evidence/day-17/10-graph-role-definition.png), [11](../evidence/day-17/11-graph-role-assignment-dry-run.png), [12](../evidence/day-17/12-graph-role-assignment-denied.png), [13](../evidence/day-17/13-graph-role-assignment-authorized.png).  
**Boundary:** not an Eligible PIM role, auto-expiring activation or proof that cleanup occurred.

## D17-14–D17-17 — Inventory and auditing

**Acting identity:** `adm-lab`.  
**Expected:** export selected tenant data; distinguish app object types; query CA policy state; locate an audited Graph change.  
**Observed:** six export categories completed, CA export skipped due to absent scope in the captured session; separate Application, Service Principal and CA queries succeeded; Add-user event records Graph Command Line Tools and `adm-lab`.  
**Result:** D17-14 Partial; D17-15–17 Pass.  
**Evidence:** [14](../evidence/day-17/14-graph-tenant-export.png), [15](../evidence/day-17/15-graph-applications-query.png), [16](../evidence/day-17/16-graph-conditional-access-query.png), [17](../evidence/day-17/17-graph-automation-audit-logs.png).  
**Boundary:** the checked-in connection script now requests `Policy.Read.All`; the Day 17 set has no **successful post-fix `conditional-access.csv` export**. Day 18 screenshot 02 separately reports that export; neither capture publishes its contents.

## Day 17-only evidence boundaries

| Area | Status | Explanation |
| --- | --- | --- |
| Direct role-assignment removal | Not in Day 17 captures; closed in Day 18 | Day 18 screenshot 05 records removal and screenshot 04 shows no Active assignment |
| CA CSV after connection-scope correction | Not in Day 17 captures; reported successful in Day 18 | Day 18 screenshot 02 reports CA export; raw CSV contents remain unpublished |
| PIM Eligible / time-bound role activation | Not tested in Day 17 | Script creates a direct tenant-wide assignment; Day 09 covers PIM |
| Full tenant backup / effective permissions | Not in scope | CSV contains selected properties, direct assignments and possible unresolved principals |
| Re-execution of all scripts after code edits | Not evidenced | Published screenshots capture the observed lab runs; source review is separate |

## Final state

The published evidence establishes delegated Graph automation, the creation and verification of test identities/groups, repeat-safe membership, an actual 403 privilege boundary, a successful separate authorized assignment, selected local inventory and an audit event. CA CSV completion and direct-role cleanup were open points at the Day 17 checkpoint. The separate Day 18 captures report the CA export and confirm role cleanup; the historical Day 17 outcomes above are unchanged. Revised repository scripts have local checks only, with no new tenant execution.

See [Day 17 implementation notes](../docs/day-17.md) and [Day 17 evidence](../evidence/day-17/README.md).
