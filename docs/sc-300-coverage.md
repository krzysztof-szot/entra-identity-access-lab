# SC-300 Lab Coverage

Selected mapping of the published Baltic Finance labs to the [Microsoft SC-300 study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300), reviewed on 2026-09-25 against the objectives effective April 27, 2026. This is a portfolio evidence map, not a claim that every exam objective has been completed.

**Status:** Tested = published runtime evidence; Configuration = settings shown, runtime operation not demonstrated; Concept review = discussed without a deployed lab; Deferred = intentionally postponed; No published lab = no implementation evidence in this repository.

| Area | Evidence | Coverage and boundary |
| --- | --- | --- |
| Users, groups and delegated administration | [Days 01](day-01.md), [06](day-06.md), [17](day-17.md) | Tested: attribute/group changes and lifecycle assignment removal; AU assignment/UI boundary shown, actor-attributed scoped write/deny remains partial |
| B2B and cross-tenant access | [Day 05](day-05.md) | Tested: invitation, application assignment, inbound deny/allow; cross-tenant synchronization has no published lab |
| Hybrid identity | [Day 07](day-07.md) | Tested: Connect Sync/PHS and cloud access; PTA/federation are concept-review topics; Cloud Sync has no published lab |
| Device identities | [Day 08](day-08.md) | Tested: registered/joined/hybrid states and CA; Intune compliance is outside the implemented scope |
| Authentication methods | [Day 04](day-04.md) | Tested: passkey sign-in and authentication strength; TAP and registration settings documented |
| Password recovery | [Day 04](day-04.md) | Configuration: SSPR pilot; actual reset and hybrid writeback not demonstrated |
| Conditional Access | [Days 03](day-03.md), [08](day-08.md), [18](day-18.md) | Tested: staged deployment, device filtering, MFA and actual policy outcomes |
| Identity risk | [Day 03](day-03.md) | Configuration/simulation: high sign-in risk What If; no published risky-user remediation workflow |
| Network access and session control | [Day 15](day-15.md) | Tested: GSA traffic and MDCA download block; post-edit Internet retest remains open |
| App integration and API access | [Days 02](day-02.md), [12](day-12.md), [14](day-14.md) | Tested: app assignment, Graph, SSO, Proxy and provisioning; Easy Auth renewal needs follow-up |
| Managed identities | [Days 13](day-13.md), [18](day-18.md) | Tested: both identity types, Storage read and pre-RBAC 403; write denial is a handled Runbook report without raw error/catch-source verification; scoped RBAC shown |
| Entitlements and access recertification | [Days 10](day-10.md), [11](day-11.md) | Tested: approval, delivery, manual revocation and applied review; natural package expiry not evidenced |
| Privileged access | [Days 09](day-09.md), [18](day-18.md) | Tested: Entra-role activation/approval/expiry; Groups and Azure-resource PIM are concept-review topics |
| Monitoring | [Days 16](day-16.md), [18](day-18.md) | Tested: ingestion, KQL and Workbooks; Secure Score baseline reviewed; automated alerts not demonstrated |
| Defender discovery and OAuth governance | [Day 15](day-15.md) | Cloud Discovery deferred; catalog/permission review completed; OAuth policy and connector scan not demonstrated |

Additional study gaps with no published practical lab include custom directory roles and security attributes, license administration, external identity-provider federation, Windows Hello for Business, certificate-based authentication, password protection, Entra Kerberos, CA authentication context/protected actions and application collections. Review the full linked syllabus for objectives beyond this selected map.

Practical follow-ups and missing source exports are tracked in [remaining work](remaining-work.md).

## Current licensing and historical lab evidence

Microsoft Learn was checked again on **2026-09-25**. The study guide still specifies objectives effective **April 27, 2026**. The lab's P2 tenant label and successful historical screenshots do not establish that every user, add-on, trial or billing prerequisite is satisfied today.

| Feature used in the lab | Current prerequisite boundary |
| --- | --- |
| Conditional Access / risk policies | CA requires Entra ID P1; sign-in/user-risk policies need the P2 Identity Protection capability. [Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview#license-requirements) |
| PIM, access reviews and entitlement management | P2 includes PIM and specified existing governance capabilities; advanced governance features have separate requirements. Check the feature-specific matrix and in-scope users, not only the tenant label. [Governance licensing](https://learn.microsoft.com/en-us/entra/id-governance/licensing-fundamentals) |
| Guest governance | Current guidance requires the guest-governance subscription linkage/add-on and appropriate administrator licensing. Day 10 screenshot 03 shows a subscription-link warning; completed linkage and current billing state are not evidenced. [Guest licensing](https://learn.microsoft.com/en-us/entra/id-governance/microsoft-entra-id-governance-licensing-for-guest-users) |
| Global Secure Access | Microsoft traffic capabilities are included in P1/P2. Internet Access and Private Access use their respective standalone or Entra Suite licenses in addition to the P1/P2 prerequisite. [GSA licensing](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access#licensing-overview) |
| Defender for Cloud Apps session control | Verify the Defender for Cloud Apps license and Entra P1 entitlement for the CA integration; P2 alone does not establish Defender entitlement. [Microsoft Learn](https://learn.microsoft.com/en-us/defender-cloud-apps/troubleshooting-proxy) |

These are reproduction prerequisites, not a retrospective finding that the captured lab operations failed. Current license assignments, trial expiry and guest billing were not inspected in the live tenant.
