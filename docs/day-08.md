# Day 08 — Device Identities and Conditional Access

## Objectives

The goal of Day 08 was to compare Microsoft Entra device identity states and use device trust as a Conditional Access signal for the Expense Portal.

The lab focused on:

- Microsoft Entra registered devices,
- Microsoft Entra joined devices,
- Microsoft Entra hybrid joined devices,
- device state verification with `dsregcmd`,
- device objects in Microsoft Entra ID,
- device ownership and compliance state,
- Conditional Access device filters,
- positive and negative application access testing.

## Implemented

### Microsoft Entra registered device

`BFL-REG01` was configured as a Microsoft Entra registered Windows device.

The device state was verified with:

`dsregcmd /status`

The resulting state was:

```
AzureAdJoined   : NO
DomainJoined    : NO
WorkplaceJoined : YES
```

The corresponding device object appeared in Microsoft Entra ID with the join type:

`Microsoft Entra registered`

This represented a registration scenario where the work identity was connected to the device without joining the Windows device directly to Microsoft Entra ID.

### Microsoft Entra joined device

`BFL-EJ01` was joined directly to Microsoft Entra ID.

The device state was verified as:

```
AzureAdJoined : YES
DomainJoined  : NO
```

The device object appeared in Microsoft Entra ID with the join type:

`Microsoft Entra joined`

This confirmed the difference between registering an organizational account on a device and joining the device itself to Microsoft Entra ID.

### Microsoft Entra hybrid joined device

`BFL-HJ01` was joined to the existing `bfl.local` Active Directory domain from Day 07.

The computer object was placed in:

`HybridLab\Devices`

and included in the Microsoft Entra Connect synchronization scope.

The resulting device state was:

```
AzureAdJoined : YES
DomainJoined  : YES
DomainName    : BFL
```

This confirmed that `BFL-HJ01` was both an on-premises Active Directory domain member and a Microsoft Entra device.

The final device object appeared in Microsoft Entra ID with the join type:

`Microsoft Entra hybrid joined`

### Device identity comparison

The three test devices demonstrated the following states:

| Device | Microsoft Entra state | Local verification |
| --- | --- | --- |
| `BFL-REG01` | Microsoft Entra registered | `WorkplaceJoined: YES` |
| `BFL-EJ01` | Microsoft Entra joined | `AzureAdJoined: YES`, `DomainJoined: NO` |
| `BFL-HJ01` | Microsoft Entra hybrid joined | `AzureAdJoined: YES`, `DomainJoined: YES` |

The lab also confirmed that join state and compliance are separate concepts.

A device can be registered, joined or hybrid joined without automatically being marked as compliant.

### Conditional Access device filter

A dedicated Conditional Access policy was created:

`CA008 - Expense Portal - Block Non-Hybrid Devices`

The policy targeted:

- user: `Hybrid Finance`,
- resource: `Expense Portal`.

The policy used a device filter that excluded Microsoft Entra hybrid joined devices from the block policy.

The rule was based on:

```
device.trustType -eq "ServerAD"
```

The resulting access model was:

`Hybrid Finance → Device trust → Conditional Access → Expense Portal`

Non-hybrid devices remained inside the scope of the block policy, while devices matching the hybrid join trust state were excluded from the block.

### Registered device test

The first test was performed from `BFL-REG01` while CA008 was configured in Report-only mode.

The sign-in to Expense Portal succeeded because the policy was not yet enforced.

Sign-in Logs identified the device as:

`Azure AD registered`

and CA008 returned:

`Report-only: Failure`

This confirmed that the registered device would be blocked if the policy were enabled.

### Microsoft Entra joined device test

CA008 was then enabled and the Expense Portal sign-in was repeated from `BFL-EJ01`.

The device was identified in Sign-in Logs as:

`Azure AD joined`

The sign-in was denied with Conditional Access error:

`53003`

and CA008 returned:

`Failure`

This confirmed that Microsoft Entra joined did not satisfy the hybrid device exclusion configured in CA008.

### Hybrid joined device test

The same Expense Portal access test was performed from `BFL-HJ01`.

Sign-in Logs identified the device as:

`Hybrid Azure AD joined`

and CA008 returned:

`Not applied`

because the device matched the configured hybrid join exclusion.

The Expense Portal sign-in completed successfully and the user received the existing application permission:

`Expense.Submitter`

This validated the complete access path:

`Hybrid Finance → BFL-HJ01 → Microsoft Entra ID → Conditional Access → Expense Portal`

## Design Decisions

### Join state and compliance are separate

The lab intentionally treated device identity and device compliance as separate concepts.

Microsoft Entra registration or join establishes a device identity relationship with the directory.

Compliance represents a separate management and policy state and was not automatically granted by any of the tested join types.

The key distinction validated in the lab was:

`registered ≠ joined ≠ hybrid joined ≠ compliant`

### Device trust was used instead of compliance

The Conditional Access scenario was designed around the Microsoft Entra hybrid join state rather than a compliance requirement.

The lab does not use Microsoft Intune to establish device compliance, so CA008 uses the device trust type as the access condition.

### Hybrid devices are excluded from the block policy

CA008 uses a block policy with an exclusion for devices matching:

`trustType = ServerAD`

This makes the policy behavior easy to verify:

- registered device — block condition applies,
- Microsoft Entra joined device — block condition applies,
- Microsoft Entra hybrid joined device — excluded from the block condition.

### Sequential client deployment

Azure trial resource limits did not allow all three Windows client virtual machines to run at the same time.

The devices were therefore deployed and tested sequentially:

`BFL-REG01 → BFL-EJ01 → BFL-HJ01`

After evidence was collected for a test device, the Azure virtual machine was removed while its Microsoft Entra device object was retained.

This allowed the final Microsoft Entra device inventory to show all three tested join types without requiring three active client virtual machines.

### Existing hybrid infrastructure was reused

The Day 07 hybrid identity infrastructure was reused instead of creating a separate Active Directory environment.

`BFL-DC01` continued to provide the existing AD DS, DNS and Microsoft Entra Connect Sync services for `bfl.local`.

`BFL-HJ01` was added to the dedicated `HybridLab\Devices` scope to keep the device scenario separated from other Active Directory objects.

## Verification

The following device identity and Conditional Access scenarios were successfully validated:

- `BFL-REG01` was confirmed as Microsoft Entra registered.
- `BFL-EJ01` was confirmed as Microsoft Entra joined.
- `BFL-HJ01` was confirmed as Microsoft Entra hybrid joined.
- Microsoft Entra ID displayed all three tested device identity types.
- The registered-device test produced the expected CA008 `Report-only: Failure` result.
- The Microsoft Entra joined device was blocked from Expense Portal by CA008.
- The hybrid joined device matched the device-filter exclusion.
- CA008 was not applied to the hybrid joined device.
- The hybrid joined device successfully accessed Expense Portal.
- The successful hybrid sign-in retained the existing `Expense.Submitter` application role.

These tests confirmed that device join state can be used as a Conditional Access signal independently from device compliance.

## Evidence and Tests

- [Day 08 test results](../tests/day-08.md)
- [Day 08 evidence](../evidence/day-08/README.md)

Sensitive credentials, identifiers and tenant-specific values were redacted from published screenshots.
