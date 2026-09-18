# Day 07 — Evidence

This folder contains evidence of hybrid identity integration between on-premises Active Directory Domain Services and Microsoft Entra ID using Microsoft Entra Connect Sync and Password Hash Synchronization.

## Evidence

- `01-hybrid-ad-ds-users-group.png` — shows the `Hybrid Finance` user created in the `HybridLab\Users` Organizational Unit in Active Directory Domain Services on `BFL-DC01`.

- `01a-hybrid-ad-ds-users-group.png` — confirms that `Hybrid Finance` is a member of the `SG-Hybrid-Finance` security group in the on-premises Active Directory environment.

- `02-hybrid-sync-server-domain-joined.png` — shows `BFL-DC01` running Windows Server 2022 and joined to the `bfl.local` Active Directory domain.

- `03-entra-connect-phs-ou-scope.png` — shows Microsoft Entra Connect Sync scoped to the selected `HybridLab` Organizational Unit, including the `Users` and `Groups` containers.

- `04-entra-connect-sync-success.png` — confirms successful Microsoft Entra Connect Sync configuration and initialization of the synchronization process.

- `05-synchronized-user-entra.png` — confirms that `Hybrid Finance` was successfully synchronized from on-premises Active Directory to Microsoft Entra ID with `On-premises sync enabled` set to `Yes`.

- `06-password-hash-sync-test.png` — confirms successful cloud sign-in for the synchronized `Hybrid Finance` account after Password Hash Synchronization.

- `07-hybrid-user-expense-portal.png` — confirms successful Expense Portal access for the synchronized `Hybrid Finance` identity with the `Expense.Submitter` application role.

- `08-hybrid-user-signin-log-ca.png` — confirms in Microsoft Entra sign-in logs that the user authenticated with `Password Hash Sync`, completed MFA, and successfully satisfied the Expense Portal Conditional Access policy.

- `09-entra-connect-health.png` — shows `BFL-DC01` reporting a `Healthy` Microsoft Entra Connect status with no active alerts or synchronization errors.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
