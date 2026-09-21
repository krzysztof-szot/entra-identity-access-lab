# Day 10 — Entitlement Management Tests

Tests validate governed external access for Amber Audit Partners, from package discovery and approval through resource provisioning and manual revocation.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D10-01 | Baseline group membership | No auditor membership before package delivery | `SG-External-Contractors` showed zero members | Pass |
| D10-02 | Connected organization | Amber partner configured | Amber Audit Partners was `Configured` with an internal sponsor | Pass |
| D10-03 | Catalog | Catalog enabled for external users | `BFL-External-Audit`: Enabled Yes; external users Yes | Pass |
| D10-04 | Resource roles | Group Member and Expense Portal role bundled | `Member` and `Expense Submitter` selected | Pass |
| D10-05 | Request policy and approval settings | Specific partner, justification, separate approver | Amber scope, self-request, Anna Finance, three-day window and required justification | Pass |
| D10-06 | 30-day lifecycle configuration | Assignment set to expire after 30 days | Number of days = 30; no self-selected timeline or extension | Pass |
| D10-07 | Package discoverability | Auditor can find a requestable package | My Access showed package and `Request` action | Pass |
| D10-08 | Request submitted / Pending state | Request reaches approval workflow | Approved request history demonstrates submission; Pending screen not captured | Partial evidence |
| D10-09 | Business approval | Separate approver approves request | Anna Finance approved the request and business justification was recorded | Pass |
| D10-10 | Delivery and provisioning | Active assignment yields group and app role | `Delivered`; auditor added to group and assigned Expense Submitter | Pass |
| D10-11 | Application access | Granted auditor can access portal | Successful sign-in; portal displayed `Expense.Submitter` | Pass |
| D10-12 | Terms of Use | User is prompted and grant control succeeds | Terms shown; CA sign-in result `Success` | Pass |
| D10-13 | Manual assignment removal | Package-managed entitlement ends | Assignment status `Expired` after manual removal | Pass |
| D10-14 | Group revocation | Package-managed membership removed | Group again showed zero members | Pass |
| D10-15 | Fresh application access after removal | Expense Portal denies unassigned auditor | `AADSTS50105` reported neither direct nor group assignment | Pass |
| D10-16 | Automatic 30-day expiry | Assignment expires naturally after 30 days | Not observed; configured duration was tested separately from manual removal | Not tested |

## Test notes

### Request workflow

The screenshot `08-auditor-access-package-available.png` shows package discoverability, **not** the Pending state. Approval history (`09-auditor-request-approved.png`) confirms that a request was submitted and approved; it does not independently document its transient Pending state.

### Provisioning and positive sign-in

The delivered assignment (`10`) is corroborated by the actual group membership (`11`), app-role assignment (`12`) and successful Expense Portal sign-in (`13`). This is stronger evidence than relying on the approval decision alone.

### Terms of Use

The Terms of Use prompt (`15`) and successful CA grant-control evaluation (`16`) support the positive access test. The latter is **not** a direct acceptance-report export.

### Revocation and expiration boundary

Assignment removal was performed manually. The portal showed `Expired` (`17`) with its original future end date, followed by an empty contractors group (`18`) and application sign-in denial `AADSTS50105` (`19`). No claim is made that the 30-day automatic-expiration schedule executed.

The `Governed` guest lifecycle value was observed, but guest deletion and the precise cause of any separate account-lock message were not established by this test.

## Final state

- `AP-External-Auditor-30D` and `POL-Amber-External-Auditors` remain configured.
- The tested auditor's assignment was manually removed and appears as `Expired`.
- `SG-External-Contractors` has zero members after revocation.
- A fresh Expense Portal sign-in is denied with `AADSTS50105`.
- `CA-External-Auditor-ToU` remains configured in the recorded evidence.

## Evidence

See [Day 10 evidence](../evidence/day-10/README.md).
