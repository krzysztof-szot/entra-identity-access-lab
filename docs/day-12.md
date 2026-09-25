# Day 12 — OAuth 2.0 and Microsoft Graph

## Objectives

The goal of Day 12 was to extend the existing Day 02 Expense Portal from Microsoft Entra authentication and application-role authorization to Microsoft Graph API access, without creating a second, unrelated application.

The lab compared **Delegated permissions** (application plus signed-in user) with **Application permissions** (application without a signed-in user), and tested consent, Graph requests, access-token claims, a negative authorization scenario and least-privilege cleanup.

## Implemented

### Existing Expense Portal reused

The existing single-tenant Expense Portal App Registration, Enterprise Application, Azure App Service, explicit application assignment and App Roles were retained:

- `Expense.Submitter` — displayed for Anna Finance;
- `Expense.Submitter` and `Expense.Approver` — displayed for Peter Finance.

These application business roles are separate from Microsoft Graph API permissions.

### Delegated Microsoft Graph access and consent

The Expense Portal App Registration had Microsoft Graph `User.Read` configured as **Delegated**, with tenant-wide admin consent granted for Baltic Finance Lab. The corresponding grant was verified under the Enterprise Application's Permissions page.

A separate Microsoft Graph Explorer test returned Anna Finance's profile from `GET /me` with HTTP 200. Graph Explorer is its own OAuth client; this test is not presented as an Expense Portal access-token capture. No separate user-consent prompt was demonstrated because admin consent was already present.

### Easy Auth and Expense Portal integration

App Service Authentication continued to require authentication and redirect unauthenticated requests to Microsoft Entra ID. Token store was enabled. The recorded `authsettingsV2` login parameters included:

```text
response_type=code id_token
scope=openid offline_access profile https://graph.microsoft.com/User.Read
```

The existing Expense Portal was extended to retrieve the signed-in user's profile from Microsoft Graph, while keeping its existing App Roles visible. The application exposed a `/graph/profile` endpoint returning selected profile fields and identifying the permission model as `Delegated`.

- Anna's portal session displayed `Expense.Submitter`, her own Graph profile and HTTP 200; the `/graph/profile` JSON response separately confirmed her details.
- Peter's portal session displayed `Expense.Submitter` and `Expense.Approver`, his **own** Graph profile and HTTP 200.

The profile responses included display name, user principal name, department and job title. Null or empty optional attributes such as mail and office location were not treated as failures.

### Temporary Application permission and Client Credentials Flow

To compare the non-user context, `User.Read.All` was temporarily added to the **same** Expense Portal App Registration as a Microsoft Graph **Application** permission. The screenshots show its transition from `Not granted` to tenant-wide admin consent granted.

The lab notes report using a temporary client secret for a PowerShell Client Credentials Flow token request with:

```text
grant_type=client_credentials
scope=https://graph.microsoft.com/.default
```

The token-acquisition request is not included in the published screenshots or source files. Screenshot 12 begins with an existing `$tokenResponse`; screenshot 14 shows selected claims but no client identifier. Together they support the reported app-only scenario, but do not independently establish the token-acquisition implementation or bind the token to the Expense Portal client.

Using the reported app-only bearer token, a Microsoft Graph `GET /users` request returned user profiles. The controlled negative test sent the same type of token to `GET /me` and displayed `BadRequest`. This is consistent with the [Microsoft Graph requirement for delegated user context at `/me`](https://learn.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0); the capture omits the response body, so it does not independently establish the server's exact error reason.

A local projection of token claims showed Microsoft Graph as `aud`, `User.Read.All` in `roles`, and a blank `scp` value. The screenshot does not include the decoding code or distinguish an absent claim from an empty value. It was inspected for learning purposes, not treated as independent cryptographic token validation. Full tokens and secrets were not published.

### Least-privilege cleanup

The existing lab notes record operator-confirmed deletion of the temporary client secret and revocation of `User.Read.All` Application consent, plus removal of the configured permission. That historical report is retained; the Day 12 screenshots do not independently verify all cleanup actions.

The final App Registration screenshot shows only `User.Read` (Delegated) remaining. Anna's captured portal session displayed `Expense.Submitter`, her Graph profile and HTTP 200. Its capture has no timestamp, token lifetime or fresh-sign-in details, so it supports the observed session result but does not prove new code redemption or token renewal after cleanup.

The final permission-list screenshot alone does not independently show the secret deletion or the separate consent-revocation action.

For the documented Easy Auth token-store approach, [Microsoft Learn](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-oauth-tokens) describes a configured provider client secret for provider access tokens, and `offline_access` for refresh tokens. A valid existing session cannot establish that this credential path still works after cleanup. The [remaining-work follow-up](remaining-work.md) calls for sanitized credential-configuration evidence, a fresh sign-in and token renewal without publishing secrets or tokens.

## Design Decisions

- Reuse the original Expense Portal so Day 12 adds API authorization to Day 02's authentication and App Roles.
- Keep user-facing Graph profile retrieval delegated under `User.Read` rather than granting broad application-wide read access for an interactive feature.
- Keep application business roles (`Expense.Submitter`, `Expense.Approver`) distinct from Microsoft Graph permissions.
- Use a temporary `User.Read.All` Application permission only to demonstrate Client Credentials Flow and `GET /users`.
- Include a negative `GET /me` test to demonstrate the absence of a user context in an app-only token.
- Revoke the elevated consent and delete the temporary credential after testing, then run a final delegated-access regression test.

## Verification

The recorded evidence supports:

- delegated `User.Read` configuration and admin consent;
- Graph Explorer `GET /me` returning Anna's profile;
- Easy Auth, Token store and Graph scope configuration;
- successful in-app Graph profiles for Anna and Peter with their distinct App Roles;
- temporary `User.Read.All` Application permission and admin consent;
- `GET /users` success and `GET /me` failure (`BadRequest`) in the reported app-only workflow, with token-acquisition and error-body limits noted above;
- displayed Graph audience and app-role claim values in the reported app-only token;
- the final minimal configured permission list and a successful captured Expense Portal Graph session.

No separate user-consent prompt or full delegated JWT-claim capture is claimed. Secret deletion and consent revocation remain historical operator reports for Day 12; fresh token acquisition and renewal after cleanup are not independently evidenced here.

## Evidence and Tests

- [Day 12 test results](../tests/day-12.md)
- [Day 12 evidence](../evidence/day-12/README.md)

Sensitive tenant identifiers and personal details were redacted where appropriate. No client secrets or access tokens are included in the published evidence.
