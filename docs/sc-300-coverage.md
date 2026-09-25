# SC-300 Lab Coverage

Selected mapping of the published Baltic Finance labs to the [Microsoft SC-300 study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300), reviewed on 2026-09-25 against the objectives effective April 27, 2026. This is a portfolio evidence map, not a claim that every exam objective has been completed.

**Status:** Tested = published runtime evidence; Configuration = settings shown, runtime operation not demonstrated; Concept review = discussed without a deployed lab; Deferred = intentionally postponed; No published lab = no implementation evidence in this repository.

| Area | Evidence | Coverage and boundary |
| --- | --- | --- |
| Users, groups and delegated administration | [Days 01](day-01.md), [06](day-06.md), [17](day-17.md) | Tested: attribute/group changes, lifecycle access removal and scoped administration |
| B2B and cross-tenant access | [Day 05](day-05.md) | Tested: invitation, application assignment, inbound deny/allow; cross-tenant synchronization has no published lab |
| Hybrid identity | [Day 07](day-07.md) | Tested: Connect Sync/PHS and cloud access; PTA/federation are concept-review topics; Cloud Sync has no published lab |
| Device identities | [Day 08](day-08.md) | Tested: registered/joined/hybrid states and CA; Intune compliance is outside the implemented scope |
| Authentication methods | [Day 04](day-04.md) | Tested: passkey sign-in and authentication strength; TAP and registration settings documented |
| Password recovery | [Day 04](day-04.md) | Configuration: SSPR pilot; actual reset and hybrid writeback not demonstrated |
| Conditional Access | [Days 03](day-03.md), [08](day-08.md), [18](day-18.md) | Tested: staged deployment, device filtering, MFA and actual policy outcomes |
| Identity risk | [Day 03](day-03.md) | Configuration/simulation: high sign-in risk What If; no published risky-user remediation workflow |
| Network access and session control | [Day 15](day-15.md) | Tested: GSA traffic and MDCA download block; post-edit Internet retest remains open |
| App integration and API access | [Days 02](day-02.md), [12](day-12.md), [14](day-14.md) | Tested: app assignment, Graph, SSO, Proxy and provisioning; Easy Auth renewal needs follow-up |
| Managed identities | [Days 13](day-13.md), [18](day-18.md) | Tested: both identity types, Storage read/deny and scoped RBAC |
| Entitlements and access recertification | [Days 10](day-10.md), [11](day-11.md) | Tested: approval, delivery, manual revocation and applied review; natural package expiry not evidenced |
| Privileged access | [Days 09](day-09.md), [18](day-18.md) | Tested: Entra-role activation/approval/expiry; Groups and Azure-resource PIM are concept-review topics |
| Monitoring | [Days 16](day-16.md), [18](day-18.md) | Tested: ingestion, KQL and Workbooks; Secure Score baseline reviewed; automated alerts not demonstrated |
| Defender discovery and OAuth governance | [Day 15](day-15.md) | Cloud Discovery deferred; catalog/permission review completed; OAuth policy and connector scan not demonstrated |

Additional study gaps with no published practical lab include custom directory roles and security attributes, license administration, external identity-provider federation, Windows Hello for Business, certificate-based authentication, password protection, Entra Kerberos, CA authentication context/protected actions and application collections. Review the full linked syllabus for objectives beyond this selected map.

Practical follow-ups and missing source exports are tracked in [remaining work](remaining-work.md).
