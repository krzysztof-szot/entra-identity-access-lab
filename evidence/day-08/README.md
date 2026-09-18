# Day 08 — Evidence

This folder contains evidence of Microsoft Entra device identities and device-based Conditional Access for the Expense Portal.

## Evidence

- `01-entra-registered-dsregcmd.png` — confirms BFL-REG01 as Microsoft Entra registered with `AzureAdJoined: NO`, `DomainJoined: NO`, and `WorkplaceJoined: YES`.
- `02-entra-registered-device.png` — shows the BFL-REG01 device object in Microsoft Entra ID with the Microsoft Entra registered join type.
- `03-ca008-device-filter-report-only.png` — shows CA008 targeting Hybrid Finance and Expense Portal, blocking access while excluding Microsoft Entra hybrid joined devices through the device filter.
- `04-registered-ca-report-only.png` — confirms the registered device sign-in and the expected CA008 `Report-only: Failure` result.

- `05-entra-joined-dsregcmd.png` — confirms BFL-EJ01 as Microsoft Entra joined with `AzureAdJoined: YES` and `DomainJoined: NO`.
- `06-entra-joined-device-properties.png` — shows the BFL-EJ01 device object in Microsoft Entra ID with the Microsoft Entra joined join type.
- `07-entra-joined-expense-portal-blocked.png` — shows the user-facing access denial to Expense Portal with Conditional Access error 53003.
- `08-entra-joined-ca-block-result.png` — confirms BFL-EJ01 as Azure AD joined and shows CA008 blocking the Expense Portal sign-in.

- `09-hybrid-device-active-directory.png` — shows the BFL-HJ01 computer object in the `HybridLab\Devices` organizational unit in on-premises Active Directory.
- `10-hybrid-joined-dsregcmd.png` — confirms BFL-HJ01 as Microsoft Entra hybrid joined with both `AzureAdJoined: YES` and `DomainJoined: YES`.
- `11-hybrid-device-expense-portal-success.png` — shows successful Expense Portal access for Hybrid Finance from the hybrid joined device.
- `12-hybrid-device-ca-success.png` — confirms the successful sign-in from a hybrid joined device and shows CA008 as not applied because the device matched the configured exclusion.
- `13-three-device-identity-types.png` — shows the three tested device identity states in Microsoft Entra ID: registered, joined, and hybrid joined.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
