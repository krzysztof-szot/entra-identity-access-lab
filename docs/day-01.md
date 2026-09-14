# Day 1 execution record — worked example

> **EXAMPLE — NOT VERIFIED LAB EVIDENCE.** This document demonstrates how to write a completed Day 1 record. The configuration, dates, license quantities, test outcomes, and checked items below are illustrative assumptions, not observations from the lab owner's tenant. Replace them with verified observations before presenting this file as your execution record. The example does not establish that a P2 trial is available to your account.

**Status:** Example: Day 1 directory baseline and functional tests completed; independent emergency recovery remains a follow-up task.  
**Execution date:** 2026-09-14 — illustrative date.  
**Lab tenant alias:** Baltic Finance Lab — illustrative alias.  
**Administrative account alias used:** `adm-lab` for delegated user and group administration; `bootstrap-admin` for initial privileged configuration and audit-log inspection.

## Environment and licensing

The values in this table describe the example environment.

| Item | Example observed value |
|---|---|
| Correct personal lab tenant confirmed | The selected directory was checked against the personal lab tenant, Baltic Finance Lab. No employer tenant was used. |
| Entra license or trial available | Microsoft Entra ID P2 trial assumed active for this example. This is separate from the Azure credit. |
| Number of available license seats | Illustrative allocation: 100 total seats, 7 assigned, 93 unassigned. Assigned users: the six employees and `adm-lab`. |
| Trial expiration and renewal checked | Illustrative trial expiration: 2026-10-14. Recurring billing assumed disabled and the expiration recorded for follow-up. |
| Azure credit expiration checked | USD 200 initial Azure credit; illustrative expiration: 2026-10-14. The expiration was checked separately from the Entra trial. |
| Security Defaults state | Enabled. No change was made during Day 1. |
| Existing Conditional Access configuration, if any | No custom or Microsoft-managed policies were found in the example tenant. Conditional Access deployment is a later project phase. |
| Budget or cost tracking status | Cost Analysis reviewed; no Azure compute, storage, or Log Analytics resources deployed during Day 1. Manual daily cost review selected. No Azure budget configured yet. |

Security Defaults remains the baseline while the Conditional Access rollout is prepared. It does not provide per-account exclusions; both emergency accounts remain subject to it. [Microsoft guidance on Security Defaults](https://learn.microsoft.com/en-us/entra/fundamentals/security-defaults).

## Implementation progress

`Completed` below refers to the stated Day 1 outcome in this example. It does not certify production readiness or independent emergency recovery.

| Task | Planned outcome | Example actual outcome | Status |
|---|---|---|---|
| Delegated administrator | `adm-lab` with User Administrator | One dedicated administrator created. User Administrator assigned as Active. No additional directory role assigned to this account. Privileged role assignments were performed using `bootstrap-admin`. | Completed |
| Emergency accounts | `bg01` and `bg02` prepared and sign-in checked | Two cloud-only accounts created in the tenant's default `.onmicrosoft.com` domain. Both have permanent Active Global Administrator assignments and passed fresh sign-in checks. Shared-phone dependency recorded below. | Completed |
| Employee identities | Six employee accounts | Created `anna.finance`, `piotr.finance`, `ewa.hr`, `tomasz.it`, `jan.mover`, and `ola.leaver`. No administrative directory roles assigned to these employee accounts. | Completed |
| Attributes | Department, Usage location, and planned Manager relationships | All six employees have User type Member and Usage location Poland. Finance has four employees, HR one, and IT one. Piotr is Manager for Anna, Jan, and Ola. Manager is intentionally unset for Piotr, Ewa, and Tomasz. | Completed |
| Groups | Seven Assigned security groups | Seven Security groups created with Assigned membership. All are non-role-assignable; `adm-lab` is an owner of each. | Completed |
| Membership | Counts match the access matrix | Direct memberships checked: Finance 4, HR 1, IT 1, Expense Users 6, Expense Approvers 1, CA Pilot 2, External Contractors 0. | Completed |
| Licensing | Available licenses assigned for the intended premium scope | Seven illustrative P2 licenses assigned directly: six employees plus `adm-lab`. Usage location Poland also set for `adm-lab`. Future premium policy scope must match the licensed users. | Completed |
| Delegated administration tests | Positive operations and role-assignment boundary checked | User attribute and group membership updates succeeded. Administrative role assignment was unavailable to `adm-lab`, as expected. Temporary changes were restored. | Completed |
| Log inspection | Relevant events identified | `bootstrap-admin` located the user update and group membership changes. Initiator, target, activity time, and result were compared with the test actions. | Completed |

**Example object count:** 9 new user accounts: 6 employees, 1 delegated administrator, and 2 emergency accounts. Including the existing `bootstrap-admin`, this example has 10 user accounts. Seven security groups were created.

### Group membership verification

| Group | Example verified members | Count |
|---|---|---|
| `SG-Dept-Finance` | `anna.finance`, `piotr.finance`, `jan.mover`, `ola.leaver` | 4 |
| `SG-Dept-HR` | `ewa.hr` | 1 |
| `SG-Dept-IT` | `tomasz.it` | 1 |
| `SG-App-Expense-Users` | `anna.finance`, `piotr.finance`, `ewa.hr`, `tomasz.it`, `jan.mover`, `ola.leaver` | 6 |
| `SG-App-Expense-Approvers` | `piotr.finance` | 1 |
| `SG-CA-Pilot` | `anna.finance`, `tomasz.it` | 2 |
| `SG-External-Contractors` | No members; reserved for a later B2B phase | 0 |

These are overlapping group memberships, not additional user accounts. Expense groups are prepared for later application integration; their creation alone does not establish application access.

## Authentication and recovery observations

| Account alias | Example registered method type | Example new sign-in checked | Remaining dependency or limitation |
|---|---|---|---|
| `adm-lab` | Microsoft Authenticator push notification with number matching | Successful fresh sign-in to the Entra admin center; MFA completed | Depends on the registered phone. Account is used for routine delegated administration. |
| `bg01` | Microsoft Authenticator push notification with number matching; temporary lab method | Successful fresh administrative sign-in in a separate browser session | Uses the same physical phone as `adm-lab`; no independent or phishing-resistant emergency authentication has been validated. |
| `bg02` | Microsoft Authenticator push notification with number matching; separate registration on the same lab phone | Successful fresh administrative sign-in in a separate browser session | Shares the phone dependency with `adm-lab` and `bg01`; a phone failure could prevent all three accounts from authenticating. |

**Recovery assessment:** The example demonstrates two working backup administrative sign-ins. It does not demonstrate recovery after loss of the shared phone. Register independent phishing-resistant credentials, such as FIDO2 security keys, and validate recovery before considering emergency access complete. [Microsoft emergency access guidance](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access).

Only authentication method types belong in this record. Passwords, enrollment QR codes, recovery codes, and other credentials must remain outside the repository.

## Issues and resolutions

| Issue | Example observed symptom | Action taken | Result or next step |
|---|---|---|---|
| Administrative role assignment unavailable to `adm-lab` | The account could not add an administrative role assignment. | Confirmed that the session used `adm-lab` and that its only directory role was User Administrator. No role was added. | Expected permission boundary demonstrated; D1-03 marked Pass. This is not an implementation failure. |
| Shared MFA device for administrative accounts | All three administrative accounts used registrations on one physical phone. | Recorded the shared dependency and limited the recovery claim to successful sign-in under current conditions. | Open follow-up: configure independent phishing-resistant emergency authentication and test recovery. |
| Temporary state introduced during validation | `tomasz.it` Job title changed and the user was temporarily removed from `SG-CA-Pilot`. | Restored the original empty Job title, re-added Tomasz, and checked the final group members. | Resolved. CA Pilot again contains Anna and Tomasz; no extra administrator role assignments were introduced. |

## Evidence and results

- [Test procedures and results](../tests/day-01.md)
- [Evidence index](../evidence/day-01/README.md)

**Evidence status:** This worked example includes no screenshots or log exports. The links identify the intended repository locations; they do not confirm uploaded evidence. A real execution record must agree with the individual test results and supporting observations stored there.

### Illustrative test results

| Test ID | Example result | Outcome |
|---|---|---|
| D1-01 | `adm-lab` changed the ordinary user's Job title to a temporary value, verified the change, and restored the original empty value. | Pass |
| D1-02 | `adm-lab` removed and re-added `tomasz.it` in `SG-CA-Pilot`; final membership is Anna and Tomasz, two members. | Pass |
| D1-03 | Administrative role assignment was unavailable to `adm-lab`. No privilege escalation or unintended role assignment occurred. | Pass |
| D1-04 | `anna.finance` signed in to My Account in a fresh session and completed the required first-sign-in steps. | Pass |
| D1-05 | `bg01` and `bg02` each completed a fresh sign-in to the Entra admin center. The shared MFA-device limitation was recorded separately. | Pass |
| D1-06 | An authorized administrator located the tested user and group changes in Audit logs and matched their initiator, target, time, and successful result. | Pass |

| Result category | Example count |
|---|---|
| Completed tests, meaning Pass plus Fail | 6 |
| Passed | 6 |
| Failed | 0 |
| Blocked | 0 |
| Not run | 0 |

D1-05 is one test covering two accounts. A passing sign-in result does not close the independent recovery follow-up.

## End-of-day checks

The checked items below describe the hypothetical execution. They must be validated separately for the actual lab.

- [x] Objects have been compared with the access matrix: 9 new accounts, 7 groups, and the expected direct memberships.
- [x] Changes made during tests have been restored: original Job title and two original CA Pilot members.
- [x] Emergency access limitations have been recorded: all three administrative accounts depend on one phone.
- [x] License availability has been recorded: illustrative P2 allocation of 100 total, 7 assigned, and 93 unassigned seats.
- [x] The example test summary agrees with the six illustrative outcomes above.
- [ ] Published evidence has been checked for private information — not applicable to this worked example, which supplies no evidence files.
- [x] The next implementation task has been selected.

**Next task:** Complete independent emergency authentication and recovery validation, then begin Expense Portal integration with Entra ID using OpenID Connect. Prepare the application registration, corresponding enterprise application, redirect URI, and application roles; validate application access in the next phase.
