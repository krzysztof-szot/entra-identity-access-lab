# Day 07 — Hybrid Identity Tests

Tests validate the hybrid identity integration between on-premises Active Directory Domain Services and Microsoft Entra ID using Microsoft Entra Connect Sync and Password Hash Synchronization.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D7-01 | On-premises hybrid identity source | `Hybrid Finance` exists in the `HybridLab` Active Directory scope and is associated with the intended on-premises security group | User and group configuration were confirmed in Active Directory on `BFL-DC01` | Pass |
| D7-02 | Active Directory domain configuration | `BFL-DC01` operates within the `bfl.local` Active Directory domain used by the hybrid lab | Domain configuration was confirmed on the Windows Server host | Pass |
| D7-03 | Microsoft Entra Connect synchronization scope | Synchronization is limited to the intended `HybridLab` Organizational Unit structure | OU filtering was configured for the selected `HybridLab` user and group scope | Pass |
| D7-04 | Microsoft Entra Connect initialization | Connect configuration succeeds and starts synchronization | Configuration completed and synchronization was initiated; user export is corroborated separately by D7-05 | Pass |
| D7-05 | Synchronized user state | `Hybrid Finance` appears in Microsoft Entra ID as an on-premises synchronized identity | User appeared in Entra ID with `On-premises sync enabled: Yes` | Pass |
| D7-06 | Password Hash Synchronization | Credentials originating from on-premises Active Directory can be used for Microsoft Entra cloud authentication | Cloud sign-in succeeded and Sign-in Logs identified `Password Hash Sync` | Pass |
| D7-07 | Expense Portal access and Conditional Access | Synchronized user can access Expense Portal after satisfying the existing MFA Conditional Access policy | `Hybrid Finance` completed MFA, CA evaluation succeeded, and `Expense.Submitter` was available | Pass |
| D7-08 | Microsoft Entra Connect Health | Hybrid synchronization infrastructure reports a healthy operational state | `BFL-DC01` reported `Healthy` with no active alerts or synchronization errors | Pass |

## D7-01 — On-premises hybrid identity source

**Acting identity:** Active Directory administrator  
**Target:** `Hybrid Finance`  
**Expected:** the hybrid user exists in the dedicated `HybridLab` Active Directory scope and is associated with the intended on-premises security group.  
**Observed:** `Hybrid Finance` was present in the on-premises Active Directory environment on `BFL-DC01` with the expected lab group configuration.  
**Result:** Pass  
**Evidence:** [01 — AD user](../evidence/day-07/01-hybrid-ad-ds-users-group.png), [02 — AD group membership](../evidence/day-07/02-domain-configuration.png).

## D7-02 — Active Directory domain configuration

**Acting identity:** Active Directory administrator  
**Expected:** `BFL-DC01` operates within the `bfl.local` domain used as the on-premises identity source for the hybrid lab.  
**Observed:** the Windows Server domain configuration confirmed the intended `bfl.local` Active Directory environment.  
**Result:** Pass  
**Evidence:**

- [03 — Server and domain](../evidence/day-07/03-bfl-dc01-domain-joined.png)

## D7-03 — Microsoft Entra Connect synchronization scope

**Acting identity:** hybrid identity administrator  
**Expected:** Microsoft Entra Connect synchronizes only the dedicated lab Organizational Unit structure instead of the entire Active Directory domain.  
**Observed:** Domain and OU filtering was configured for the selected `HybridLab` scope containing the required users and groups.  
**Result:** Pass  
**Evidence:** `../evidence/day-07/04-entra-connect-phs-ou-scope.png`

## D7-04 — Microsoft Entra Connect synchronization

**Acting identity:** hybrid identity administrator  
**Expected:** Microsoft Entra Connect completes configuration and starts synchronization successfully.  
**Observed:** the configuration completed successfully and the synchronization process was initialized.  
**Result:** Pass  
**Evidence:** `../evidence/day-07/05-entra-connect-sync-success.png`

## D7-05 — Synchronized user state

**Acting identity:** Microsoft Entra administrator reviewing the synchronized identity  
**Target:** `Hybrid Finance`  
**Expected:** the on-premises user appears in Microsoft Entra ID as a synchronized identity.  
**Observed:** `Hybrid Finance` appeared in Microsoft Entra ID with `On-premises sync enabled` set to `Yes`.  
**Result:** Pass  
**Evidence:** `../evidence/day-07/06-synchronized-user-entra.png`

## D7-06 — Password Hash Synchronization

**Acting identity:** `Hybrid Finance`  
**Precondition:** the account password is managed in the on-premises Active Directory environment and synchronized through Microsoft Entra Connect.  
**Expected:** the synchronized credentials can be used to authenticate directly to Microsoft Entra ID.  
**Observed:** cloud sign-in succeeded and Microsoft Entra Sign-in Logs identified `Password Hash Sync` as the password authentication method.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-07/07-password-hash-sync-test.png`
- `../evidence/day-07/09-hybrid-user-signin-log-ca.png`

**Evidence boundary:** screenshot 07 shows an existing My Account session; screenshot 09 proves PHS authentication. Neither independently records the reported on-premises password change followed by a fresh sign-in with the new password. To validate propagation separately, record the password-change time without exposing the password, then correlate a fresh PHS sign-in after synchronization.

## D7-07 — Expense Portal and Conditional Access

**Acting identity:** `Hybrid Finance`  
**Expected:** the synchronized user can access Expense Portal after satisfying the existing MFA Conditional Access requirement and receives the intended application role.  
**Observed:** authentication succeeded, MFA completed successfully, the Expense Portal Conditional Access policy returned `Success`, and the application exposed the `Expense.Submitter` role.  
**Result:** Pass  
**Evidence:**

- `../evidence/day-07/08-hybrid-user-expense-portal.png`
- `../evidence/day-07/09-hybrid-user-signin-log-ca.png`

## D7-08 — Microsoft Entra Connect Health

**Acting identity:** Microsoft Entra administrator  
**Expected:** the hybrid synchronization service reports a healthy operational state without active synchronization errors.  
**Observed:** Microsoft Entra Connect Health reported `BFL-DC01` as `Healthy` with no active alerts or synchronization errors.  
**Result:** Pass  
**Evidence:** `../evidence/day-07/10-entra-connect-health.png`

## Final state

- `BFL-DC01` hosts the Active Directory Domain Services and Microsoft Entra Connect Sync components used by the lab.
- `Hybrid Finance` remains an on-premises synchronized identity in Microsoft Entra ID.
- Synchronization remains scoped to the dedicated `HybridLab` Organizational Unit structure.
- Password Hash Synchronization remains enabled for the hybrid authentication model.
- `Hybrid Finance` can authenticate to Microsoft Entra ID and access Expense Portal after satisfying MFA.
- The existing Conditional Access protection for Expense Portal remains enforced.
- Microsoft Entra Connect Health reports the hybrid synchronization environment as healthy.

## Evidence

See [Day 07 evidence](../evidence/day-07/README.md).
