# Remaining Validation and Reproduction Work

This register separates work that can be verified from repository evidence from checks requiring the running lab. No new tenant tests were executed during the repository documentation review on 2026-09-25.

## Tenant Validation

| Priority | Item | Existing evidence | Evidence needed to close it |
| --- | --- | --- | --- |
| High | Easy Auth credential path and token renewal | Day 12 Token Store and `code id_token` login parameters; Day 18 zero app credentials and a portal Graph HTTP 200 | Confirm the App Service provider points to the reviewed registration; document the actual credential mechanism; complete a fresh sign-in and successful token refresh with a subsequent Graph call |
| High | Emergency exclusion-group protection | Day 18 effective exclusions for both emergency accounts | Inspect current group properties, owners and management permissions; demonstrate that an unauthorized membership change is rejected |
| Medium | Emergency-account operational readiness | Day 01 sign-ins; Day 18 GA assignments and CA exclusions | Record current phishing-resistant authentication and a controlled sign-in/administrative test, including receipt of the emergency-use alert |
| Medium | Workload sign-in centralization | Day 18 Diagnostic Settings omit both workload sign-in categories | Configure the intended Service Principal / Managed Identity export coverage and verify actual ingestion if extending the monitoring scope |
| Medium | Additional Access Package policy | Day 18 shows an `Initial Policy` that was not assessed | Review request scope, approvals and lifecycle; record whether it provides any unintended access path |
| Medium | SSPR runtime behavior | Day 04 pilot settings | Complete a password reset and new-password sign-in; test hybrid writeback separately if added |
| Low | Internet filtering after the final policy edit | Day 15 block events precede the captured profile modification time | Repeat allowed and denied traffic tests against the final configuration |

### Easy Auth verification

Compare the App Service Microsoft provider's client ID with the App Registration privately; publishing unredacted IDs is unnecessary. Record whether the provider uses a client-secret setting or the supported managed-identity/federated-credential configuration. A zero-secret count is not a universal success criterion: authentication still needs a mechanism appropriate to the configured flow.

Sign out of the application using `/.auth/logout`, start a new private browser session and test both authentication and the Graph profile. Then test `/.auth/refresh` and repeat the Graph request. Record outcomes and relevant errors without publishing token values. The existing successful portal screenshot remains valid for the captured session; these additional tests close the code-redemption and renewal gap.

References: [App Service Microsoft Entra authentication](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad), [OAuth token handling](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-oauth-tokens).

### Emergency access verification

CA exclusions and Global Administrator assignments establish only part of emergency readiness. Check the current exclusion group's management boundary rather than relying on the original Access Matrix's group settings. Keep the emergency role assignments permanent Active. Document strong authentication, controlled use and alert delivery separately.

References: [Emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access), [Role-assignable group protections](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/groups-concept).

## Source Artifacts to Publish

| Artifact | Repository state | Required next step |
| --- | --- | --- |
| Day 17 Graph scripts | Six original scripts plus [usage instructions](../scripts/README.md) | Reuse with documented roles and lab-specific identity checks |
| Days 16/18 KQL | Six [query files](../queries/README.md), transcribed from published screenshots | Run against the intended workspace/time window; results depend on retained events |
| Expense Portal | Authentication and behavior documented; application source absent | Export the actual deployed source, dependencies and deployment instructions; redact secrets and local configuration |
| Day 13 Runbooks | Runtime screenshots and selected commands documented | Export the actual System-assigned, User-assigned and write-denial `.ps1` sources plus runtime/module dependencies |
| Custom Workbook | Saved dashboard shown in Day 16 | Export its actual JSON and parameterize environment-specific identifiers |
| Day 18 exclusion assessment | Results shown in screenshot 06 | Add the original Graph assessment script with its membership-resolution rules and required scopes |

Application source, Runbooks, Workbook JSON and the exclusion-check script must come from the actual implementation before being described as the code used in the evidence. A newly written replacement would need its own validation.

## Deferred Learning Scope

[SC-300 coverage](sc-300-coverage.md) identifies lab-tested, configuration-only, conceptual and deferred topics. Cloud Discovery, broader lifecycle automation and Azure Key Vault integration remain extensions. The completed Day 17 role cleanup and CA export are recorded in [Day 18](day-18.md), not open remediation items.
