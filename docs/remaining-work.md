# Remaining Validation and Reproduction Work

This register separates work that can be verified from repository evidence from checks requiring the running lab. No new tenant tests were executed during the [independent audit on 2026-09-25](audit-2026-09-25.md). Tasks below close specific evidence gaps; later retests should be dated as new observations, not substituted for the historical runs.

## Tenant Validation

| Priority | Item | Existing evidence | Evidence needed to close it |
| --- | --- | --- | --- |
| High | Easy Auth credential path and token renewal | Day 12 Token Store and `code id_token` login parameters; Day 18 zero app credentials and a portal Graph HTTP 200 | Confirm the App Service provider points to the reviewed registration; document the actual credential mechanism; complete a fresh sign-in and successful token refresh with a subsequent Graph call |
| High | Emergency exclusion calculation and group protection | Day 18 custom output reports exclusions for both accounts, but the source and resolution logic are absent | Export the actual script, policy assignments and resolved emergency membership; cross-check per-account What If exclusions; inspect group properties/owners and demonstrate unauthorized membership-change rejection |
| High | AU scope and actor-attributed administration | Day 06 shows the AU group, a scoped role and contrasting UI controls | Capture the AU Users list and administrator's effective roles; as `adm-finance`, perform and restore a Marc Job title change with actor/target Audit Logs, and record an out-of-scope edit denial |
| Medium | Emergency-account operational readiness | Day 01 sign-ins; Day 18 GA assignments and CA exclusions | Record current phishing-resistant authentication and a controlled sign-in/administrative test, including receipt of the emergency-use alert |
| Medium | Workload sign-in centralization | Day 18 Diagnostic Settings omit both workload sign-in categories | Configure the intended Service Principal / Managed Identity export coverage and verify actual ingestion if extending the monitoring scope |
| Medium | Additional Access Package policy | Day 18 shows an `Initial Policy` that was not assessed | Review request scope, approvals and lifecycle; record whether it provides any unintended access path |
| Medium | SSPR runtime behavior | Day 04 pilot settings | Complete a password reset and new-password sign-in; test hybrid writeback separately if added |
| Medium | Managed Identity write-denial cause | Day 13 prints a handled `PASS`; raw Storage error and catch logic are absent | Publish the actual write-test source, verify it accepts only the expected authorization failure, and capture identity, target, Storage error code and job timestamp on a new run |
| Medium | Leaver completion | Day 06 Disabled, zero assignment counts and a generic account-locked sign-in message; one license remains | Capture exact sign-in error/log and session revocation plus existing-session behavior; decide license retention/removal according to the lab scenario |
| Medium | Current licensing and guest governance billing | P2 tenant label; Day 10 screenshot 03 warns about subscription linkage | Verify applicable user/add-on licenses and trial expiry; inspect guest-governance subscription linkage using the [current licensing references](sc-300-coverage.md#current-licensing-and-historical-lab-evidence) |
| Medium | Revised Graph scripts | Offline regression checks pass for updated scripts 03/04/06 | In the lab, capture group reuse/membership rerun and export manifest/CSV results using the documented operator/scopes; keep exports private and record failures as failures |
| Medium | Application business authorization | Portal displays Submitter/Approver claims; deployed backend source and operation tests are absent | Publish the actual source; if business APIs exist, test submit-only user's approval denial and approver's success at the API, not only the displayed page |
| Low | TAP bootstrap and exact weak-auth policy | Day 04 TAP created and passkey succeeds; Peter's generic error does not name the app/policy | Capture a fresh TAP-based registration flow without publishing the TAP; retain a correlated Peter/Expense Portal sign-in log identifying the failing authentication-strength policy |
| Low | Cross-tenant MFA trust and masked scope | Day 05 settings enable trust; selected inbound user/outbound app IDs are masked | Verify the selected user/app privately; capture sign-in authentication detail showing whether the partner MFA claim satisfied MFA in the resource tenant |
| Low | Password-change propagation | Day 07 successful Hybrid Finance session; no new-password evidence | After a controlled AD DS password change, record PHS processing and a fresh new-password cloud sign-in without publishing the password |
| Low | Access before applying a review | Day 11 untimestamped portal session between Deny and Apply in the narrative | In a new controlled review, capture timestamped membership and a fresh sign-in after Deny but before Apply, then Apply and record a new denied sign-in |
| Low | PIM privileged-action attribution | Day 09 shows activation and a created CA009 policy, but no creator audit | Capture the `Add conditional access policy` Audit Log with `adm-lab` as actor, the target policy and a timestamp inside the activation window; use a new test if the historical event is no longer retained |
| Low | App-only token acquisition and negative-error cause | Day 12 starts with an existing token response and a broad catch prints `BadRequest` | Publish sanitized acquisition/catch source and client/tenant correlation; on a deliberate retest, check the expected Graph error code/message without exposing tokens or reintroducing a persistent app-only grant |
| Low | Password-based SSO replay | Day 14 shows configuration, My Apps tile and a target session | Capture a fresh My Apps launch through automatic credential replay to the test site, with credential fields masked and no password values published |
| Low | Workload IAM warning state | Day 18 screenshot 22 masks the banner area | Review current warning text and relevant elevated-access state; capture a sanitized view retaining nonsensitive warning text if claiming remediation |
| Low | Internet filtering after the final policy edit | Day 15 block events precede the captured profile modification time | Repeat allowed and denied traffic tests against the final configuration |

### Easy Auth verification

Compare the App Service Microsoft provider's client ID with the App Registration privately; publishing unredacted IDs is unnecessary. Record whether the provider uses a client-secret setting or the supported managed-identity/federated-credential configuration. A zero-secret count is not a universal success criterion: authentication still needs a mechanism appropriate to the configured flow.

Sign out of the application using `/.auth/logout`, start a new private browser session and test both authentication and the Graph profile. Then test `/.auth/refresh` and repeat the Graph request. Record outcomes and relevant errors without publishing token values. The existing successful portal screenshot remains valid for the captured session; these additional tests close the code-redemption and renewal gap.

References: [App Service Microsoft Entra authentication](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad), [OAuth token handling](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-oauth-tokens).

### Emergency access verification

Global Administrator assignments are shown, while the effective CA exclusions are reported by an unpublished custom calculation. Independently verify both policy assignments and membership resolution before treating that output as proven. Check the current exclusion group's management boundary rather than relying on the original Access Matrix's group settings. Keep the emergency role assignments permanent Active. Document strong authentication, controlled use and alert delivery separately.

References: [Emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access), [Role-assignable group protections](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/groups-concept).

## Source Artifacts to Publish

| Artifact | Repository state | Required next step |
| --- | --- | --- |
| Day 17 Graph scripts | Six scripts, with audited changes to 03/04/06 and [usage instructions](../scripts/README.md) | Retest revised versions with documented roles and lab-specific identity checks; original screenshot results do not validate the revised code |
| Days 16/18 KQL | Six [query files](../queries/README.md), transcribed from published screenshots | Run against the intended workspace/time window; results depend on retained events |
| Expense Portal | Authentication and behavior documented; application source absent | Export the actual deployed source, dependencies and deployment instructions; redact secrets and local configuration |
| Day 13 Runbooks | Runtime screenshots and selected commands documented | Export the actual System-assigned, User-assigned and write-denial `.ps1` sources plus runtime/module dependencies |
| Custom Workbook | Saved dashboard shown in Day 16 | Export its actual JSON and parameterize environment-specific identifiers |
| Day 18 exclusion assessment | Results shown in screenshot 06 | Add the original Graph assessment script with its membership-resolution rules and required scopes |

Application source, Runbooks, Workbook JSON and the exclusion-check script must come from the actual implementation before being described as the code used in the evidence. A newly written replacement would need its own validation.

## Deferred Learning Scope

[SC-300 coverage](sc-300-coverage.md) identifies lab-tested, configuration-only, conceptual and deferred topics. Cloud Discovery, broader lifecycle automation and Azure Key Vault integration remain extensions. The completed Day 17 role cleanup and CA export are recorded in [Day 18](day-18.md), not open remediation items.
