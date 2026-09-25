# Day 07 — Hybrid Identity

## Objectives

The goal of Day 07 was to integrate an on-premises Active Directory environment with Microsoft Entra ID and validate a complete hybrid identity flow using Microsoft Entra Connect Sync and Password Hash Synchronization.

The lab focused on:

- Active Directory Domain Services,
- hybrid identity synchronization,
- Organizational Unit filtering,
- Password Hash Synchronization,
- synchronized user authentication,
- Conditional Access for a hybrid identity,
- cloud application access,
- Microsoft Entra Connect Health.

## Implemented

### On-premises Active Directory

`BFL-DC01` was configured as the Windows Server host for the hybrid identity lab.

For this cost-optimized lab, the server hosts:

- Active Directory Domain Services,
- DNS,
- Microsoft Entra Connect Sync.

The Active Directory domain used for the lab is:

`bfl.local`

A dedicated Organizational Unit structure was created for synchronized lab objects:

`HybridLab`

with separate containers for:

- Users,
- Groups.

A dedicated hybrid user, `Hybrid Finance`, was created in the on-premises directory.

The user was also added to the on-premises security group:

`SG-Hybrid-Finance`

### Microsoft Entra Connect Sync

Microsoft Entra Connect Sync was installed and configured on `BFL-DC01`.

The synchronization model used in the lab is:

`AD DS → Microsoft Entra Connect Sync → Microsoft Entra ID`

Password Hash Synchronization was selected as the authentication method.

The synchronization scope was intentionally restricted using Organizational Unit filtering.

Only the `HybridLab` scope required for the exercise was selected instead of synchronizing the entire Active Directory domain.

This created a controlled synchronization boundary for the lab environment.

### Password Hash Synchronization

Password Hash Synchronization was enabled so that the synchronized identity could authenticate directly against Microsoft Entra ID using credentials originating from the on-premises Active Directory environment.

The resulting authentication flow is:

`AD DS credentials → Password Hash Synchronization → Microsoft Entra ID → cloud authentication`

After synchronization completed, the `Hybrid Finance` user appeared in Microsoft Entra ID with:

`On-premises sync enabled: Yes`

The lab notes report an on-premises password change followed by successful cloud sign-in. Screenshot 07 shows an authenticated My Account session, but does not independently establish the password change, propagation time or a fresh sign-in using the new password. Screenshot 09 separately confirms successful Password Hash Sync authentication.

Microsoft Entra sign-in logs confirmed:

- `Password Hash Sync` as the authentication method,
- successful password authentication,
- successful MFA,
- successful Conditional Access evaluation.

### Expense Portal integration

The synchronized `Hybrid Finance` identity was integrated with the existing Expense Portal access model from earlier project days.

The user received access through the existing Microsoft Entra authorization model and successfully authenticated to the application.

The Expense Portal confirmed the expected application role:

`Expense.Submitter`

This validated the complete path:

`On-premises AD identity → Entra Connect Sync → Microsoft Entra ID → Conditional Access → Expense Portal`

### Conditional Access

The synchronized user was tested against the existing Expense Portal Conditional Access policy.

The sign-in required MFA and the policy completed successfully.

This confirmed that a user synchronized from on-premises Active Directory can be protected by the same Microsoft Entra Conditional Access controls used for cloud-native identities.

### Microsoft Entra Connect Health

Microsoft Entra Connect Health was used to verify the operational status of the hybrid synchronization environment.

`BFL-DC01` reported a healthy synchronization state with no active alerts or synchronization errors during validation.

## Design Decisions

### Single-server lab architecture

A separate synchronization server was not introduced for this lab.

To reduce Azure trial resource consumption, `BFL-DC01` hosts both Active Directory Domain Services and Microsoft Entra Connect Sync.

This is a deliberate lab simplification.

In a production environment, infrastructure roles and Microsoft Entra Connect deployment design would be evaluated separately based on availability, security, scale and operational requirements.

### Dedicated synchronization scope

The entire `bfl.local` directory was not synchronized.

OU filtering was used to limit synchronization to the dedicated `HybridLab` structure.

This reduces unnecessary object synchronization and provides a clear boundary between lab objects and other Active Directory objects.

### Dedicated hybrid identity

A new `Hybrid Finance` account was created specifically for hybrid identity testing instead of attempting to match an existing cloud-only project account.

This avoids unnecessary account matching complexity and provides a clear source of authority for the synchronized identity.

### Password Hash Synchronization

Password Hash Synchronization was selected as the primary authentication model for the practical lab.

Authentication therefore occurs in Microsoft Entra ID rather than requiring the on-premises Domain Controller to validate each cloud sign-in.

Pass-through Authentication and federation were not deployed because the objective was to build a minimal working hybrid environment while retaining those models as architecture decision scenarios for SC-300 study.

### Cloud authorization remains separate

Synchronization establishes the identity in Microsoft Entra ID, but it does not automatically grant access to cloud applications.

Expense Portal authorization continued to use the existing Microsoft Entra group and application-role model.

This keeps identity synchronization separate from application authorization.

## Verification

The following hybrid identity scenarios were successfully validated:

- `Hybrid Finance` exists in the on-premises Active Directory environment.
- The user and required group are within the controlled `HybridLab` synchronization scope.
- Microsoft Entra Connect configuration succeeded and synchronization was initiated; the later synchronized-user view confirms the user reached Entra ID. The wizard completion screen alone does not prove a completed export cycle.
- The synchronized user appeared in Microsoft Entra ID with on-premises synchronization enabled.
- Credentials originating from Active Directory successfully authenticated the user to Microsoft Entra ID through Password Hash Synchronization.
- Microsoft Entra sign-in logs identified `Password Hash Sync` as the authentication method.
- MFA and the existing Expense Portal Conditional Access policy completed successfully.
- The synchronized user successfully accessed Expense Portal with the `Expense.Submitter` application role.
- Microsoft Entra Connect Health reported `BFL-DC01` as healthy with no active synchronization errors.

These tests confirm a complete hybrid identity path from the on-premises Active Directory environment to Microsoft Entra ID and a protected cloud application.

## Evidence and Tests

- [Day 07 test results](../tests/day-07.md)
- [Day 07 evidence](../evidence/day-07/README.md)

Sensitive credentials, identifiers and tenant-specific values were redacted from published screenshots.
