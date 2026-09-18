# Day 08 — Device Identities and Conditional Access Tests

Tests validate Microsoft Entra registered, Microsoft Entra joined and Microsoft Entra hybrid joined device states and confirm that device trust can be used as a Conditional Access signal for Expense Portal.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D8-01 | Microsoft Entra registered device state | `BFL-REG01` is registered but not Microsoft Entra joined or domain joined | `dsregcmd` showed `AzureAdJoined: NO`, `DomainJoined: NO` and `WorkplaceJoined: YES`; Entra ID showed `Microsoft Entra registered` | Pass |
| D8-02 | Microsoft Entra joined device state | `BFL-EJ01` is joined directly to Microsoft Entra ID and is not domain joined | `dsregcmd` showed `AzureAdJoined: YES` and `DomainJoined: NO`; Entra ID showed `Microsoft Entra joined` | Pass |
| D8-03 | Microsoft Entra hybrid joined device state | `BFL-HJ01` is joined to both `bfl.local` and Microsoft Entra ID | AD contained the computer object and `dsregcmd` showed `AzureAdJoined: YES` and `DomainJoined: YES` | Pass |
| D8-04 | Conditional Access device filter | CA008 blocks non-hybrid devices while excluding Microsoft Entra hybrid joined devices | CA008 targeted Hybrid Finance and Expense Portal with a `ServerAD` device-filter exclusion and `Block access` grant control | Pass |
| D8-05 | Registered device — Report-only evaluation | Registered device would be blocked by CA008 if enforcement were enabled | Sign-in succeeded while CA008 was Report-only and the policy returned `Report-only: Failure` | Pass |
| D8-06 | Microsoft Entra joined device — enforced block | Entra joined device does not satisfy the hybrid exclusion and is denied access | Expense Portal access was denied with error `53003`; CA008 returned `Failure` | Pass |
| D8-07 | Hybrid joined device — allowed access | Hybrid joined device matches the CA008 exclusion and can access Expense Portal | Sign-in succeeded; Sign-in Logs showed `Hybrid Azure AD joined` and CA008 returned `Not applied` | Pass |
| D8-08 | Device identity comparison | Microsoft Entra ID shows the three tested device identity states as distinct join types | Device inventory showed `BFL-REG01` as registered, `BFL-EJ01` as joined and `BFL-HJ01` as hybrid joined | Pass |

## D8-01 — Microsoft Entra registered device

**Acting identity:** `Hybrid Finance` on `BFL-REG01`  
**Expected:** the Windows device is registered with Microsoft Entra ID without being Microsoft Entra joined or Active Directory domain joined.  
**Observed:** `dsregcmd /status` returned:

```
AzureAdJoined   : NO
DomainJoined    : NO
WorkplaceJoined : YES
```

The corresponding device object in Microsoft Entra ID showed:

`Join type: Microsoft Entra registered`

**Result:** Pass  
**Evidence:**

- `../evidence/day-08/01-entra-registered-dsregcmd.png`
- `../evidence/day-08/02-entra-registered-device.png`

## D8-02 — Microsoft Entra joined device

**Acting identity:** `Hybrid Finance` on `BFL-EJ01`  
**Expected:** the device is joined directly to Microsoft Entra ID and is not joined to the on-premises Active Directory domain.  
**Observed:** `dsregcmd /status` returned:

```
AzureAdJoined : YES
DomainJoined  : NO
```

The Microsoft Entra device object showed:

`Join type: Microsoft Entra joined`

**Result:** Pass  
**Evidence:**

- `../evidence/day-08/05-entra-joined-dsregcmd.png`
- `../evidence/day-08/06-entra-joined-device-properties.png`

## D8-03 — Microsoft Entra hybrid joined device

**Acting identity:** Active Directory administrator and `Hybrid Finance` on `BFL-HJ01`  
**Precondition:** `BFL-HJ01` is joined to `bfl.local` and included in the intended hybrid device scope.  
**Expected:** the device is both Active Directory domain joined and Microsoft Entra joined.  
**Observed:** the `BFL-HJ01` computer object was present in `HybridLab\Devices`.

`dsregcmd /status` returned:

```
AzureAdJoined : YES
DomainJoined  : YES
DomainName    : BFL
```

**Result:** Pass  
**Evidence:**

- `../evidence/day-08/09-hybrid-device-active-directory.png`
- `../evidence/day-08/10-hybrid-joined-dsregcmd.png`

## D8-04 — CA008 device-filter configuration

**Acting identity:** Microsoft Entra administrator  
**Expected:** CA008 targets the intended user and Expense Portal, blocks access, and excludes Microsoft Entra hybrid joined devices from the block condition.  
**Observed:** the policy was configured as:

`CA008 - Expense Portal - Block Non-Hybrid Devices`

with:

- user: `Hybrid Finance`;
- target resource: `Expense Portal`;
- grant control: `Block access`;
- device filter mode: exclude matching devices;
- filter rule: `device.trustType -eq "ServerAD"`.

The policy was initially validated in Report-only mode before enforcement.

**Result:** Pass  
**Evidence:** `../evidence/day-08/03-ca008-device-filter-report-only.png`

## D8-05 — Registered device Report-only test

**Acting identity:** `Hybrid Finance`  
**Device:** `BFL-REG01`  
**Expected:** the registered device does not match the hybrid-device exclusion. While CA008 is in Report-only mode, access should succeed but the policy should report that it would block the sign-in.  
**Observed:** Expense Portal sign-in succeeded.

Sign-in Logs showed:

- Join Type: `Azure AD registered`;
- CA008 grant control: `Block`;
- CA008 result: `Report-only: Failure`.

**Result:** Pass  
**Evidence:** `../evidence/day-08/04-registered-ca-report-only.png`

## D8-06 — Microsoft Entra joined device block

**Acting identity:** `Hybrid Finance`  
**Device:** `BFL-EJ01`  
**Precondition:** CA008 is enabled.  
**Expected:** a Microsoft Entra joined device does not satisfy the `ServerAD` hybrid exclusion and is blocked from Expense Portal.  
**Observed:** the user-facing sign-in was denied with:

`Error Code: 53003`

Sign-in Logs showed:

- Join Type: `Azure AD joined`;
- CA008 grant control: `Block`;
- CA008 result: `Failure`.

**Result:** Pass  
**Evidence:**

- `../evidence/day-08/07-entra-joined-expense-portal-blocked.png`
- `../evidence/day-08/08-entra-joined-ca-block-result.png`

## D8-07 — Hybrid joined device access

**Acting identity:** `Hybrid Finance`  
**Device:** `BFL-HJ01`  
**Precondition:** CA008 is enabled and excludes devices with the hybrid join trust type.  
**Expected:** the hybrid joined device matches the exclusion, CA008 does not block the request, and Expense Portal access succeeds.  
**Observed:** Expense Portal authentication completed successfully and the application exposed:

`Expense.Submitter`

Sign-in Logs showed:

- Join Type: `Hybrid Azure AD joined`;
- CA008 result: `Not applied`;
- overall sign-in status: `Success`.

**Result:** Pass  
**Evidence:**

- `../evidence/day-08/11-hybrid-device-expense-portal-success.png`
- `../evidence/day-08/12-hybrid-device-ca-success.png`

## D8-08 — Device identity comparison

**Acting identity:** Microsoft Entra administrator  
**Expected:** the Microsoft Entra device inventory clearly distinguishes the three tested device identity states.  
**Observed:** the device inventory showed:

- `BFL-REG01` — Microsoft Entra registered;
- `BFL-EJ01` — Microsoft Entra joined;
- `BFL-HJ01` — Microsoft Entra hybrid joined.

The comparison also confirmed that join state is separate from device management and compliance state.

**Result:** Pass  
**Evidence:** `../evidence/day-08/13-three-device-identity-types.png`

## Final state

- `BFL-HJ01` remains joined to `bfl.local` and Microsoft Entra ID as a Microsoft Entra hybrid joined device.
- `BFL-REG01` and `BFL-EJ01` Azure test VMs were removed after validation because of Azure trial resource limits.
- Their Microsoft Entra device objects were retained for the final join-type comparison.
- CA008 remains configured to block non-hybrid devices from Expense Portal while excluding Microsoft Entra hybrid joined devices through the device filter.
- The existing Expense Portal MFA Conditional Access protection remains in place.
- Device join state and device compliance remain separate controls; the lab did not use Intune to establish compliance.

## Evidence

See [Day 08 evidence](../evidence/day-08/README.md).
