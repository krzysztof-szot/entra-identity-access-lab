# Day 07 — Evidence

This folder documents hybrid identity integration between Active Directory Domain Services on `BFL-DC01` and Microsoft Entra ID, using Microsoft Entra Connect Sync and Password Hash Synchronization.

## Evidence

- [01 — Hybrid identity source](01-hybrid-ad-ds-users-group.png) — `Hybrid Finance` exists in `HybridLab\Users` on `BFL-DC01`.
- [02 — On-premises group membership](02-domain-configuration.png) — the Members tab of `SG-Hybrid-Finance` shows `Hybrid Finance`; the AD tree places the group in `HybridLab\Groups`. The retained filename says “domain configuration”, but the screenshot specifically proves group membership.
- [03 — Server and domain](03-bfl-dc01-domain-joined.png) — Server Manager identifies `BFL-DC01`, the `bfl.local` domain and Windows Server 2022 Datacenter.
- [04 — Synchronization scope](04-entra-connect-phs-ou-scope.png) — Entra Connect Domain and OU filtering selects the `HybridLab` Users and Groups scope.
- [05 — Synchronization initialization](05-entra-connect-sync-success.png) — Entra Connect configuration succeeded and synchronization was initiated; a completed export cycle is not shown on this page.
- [06 — Synchronized Entra user](06-synchronized-user-entra.png) — `Hybrid Finance` appears in Entra ID with `On-premises sync enabled: Yes`.
- [07 — Authenticated cloud session](07-password-hash-sync-test.png) — My Account displays Hybrid Finance. The screenshot does not establish a password change or a fresh sign-in with the new password; screenshot 09 separately supports PHS authentication.
- [08 — Expense Portal access](08-hybrid-user-expense-portal.png) — the synchronized user accesses Expense Portal with `Expense.Submitter`.
- [09 — Authentication and CA log](09-hybrid-user-signin-log-ca.png) — Sign-in logs identify Password Hash Sync, successful MFA and the Expense Portal Conditional Access result.
- [10 — Connect Health](10-entra-connect-health.png) — `BFL-DC01` reports Healthy with no active alerts or synchronization errors at capture time.

Sensitive credentials and environment-specific identifiers were redacted before publication.
