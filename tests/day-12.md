# Day 12 — OAuth 2.0 and Microsoft Graph Tests

Tests validate delegated Microsoft Graph access from the existing Expense Portal, differences between App Roles and API permissions, temporary app-only access with Client Credentials Flow, an expected negative request, and least-privilege cleanup.

## Results

**Evidence note:** screenshots 01 and 02 are the same capture. Delegated permission configuration and existing admin consent are both visible in that view; no separate consent action is inferred.

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D12-01 | Delegated permission | Expense Portal requests Graph `User.Read` as Delegated | `User.Read` shown as Delegated and granted | Pass |
| D12-02 | Tenant-wide and service-principal consent | Delegated permission is consented for the tenant | Granted status in App Registration and Admin consent in Enterprise Application | Pass |
| D12-03 | Graph Explorer `/me` | Anna's profile is returned by the separate Graph Explorer client | Selected fields returned; HTTP 200 | Pass |
| D12-04 | Easy Auth and token configuration | Existing Web App authenticates users and requests Graph scope | Authentication and Token store enabled; `User.Read` in login parameters | Pass |
| D12-05 | Anna's Graph profile in Expense Portal | Anna retains Submitter role and sees her own Graph profile | Anna, `Expense.Submitter` and Graph HTTP 200 displayed | Pass |
| D12-06 | Anna's Graph endpoint | App backend returns Anna's Graph profile | `/graph/profile` returned Anna's selected fields and `Delegated` | Pass |
| D12-07 | Peter's Graph profile | Peter retains both App Roles and sees his own Graph profile | Peter, Submitter + Approver and Graph HTTP 200 displayed | Pass |
| D12-08 | Application permission before consent | New `User.Read.All` is Application and not yet granted | Permission appeared as Application, `Not granted` | Pass |
| D12-09 | Application admin consent | Temporary `User.Read.All` is granted | Admin consent success; Application permission marked Granted | Pass |
| D12-10 | Client Credentials Graph request | Expense Portal obtains an app-only token and calls `GET /users` | User profiles returned and app-only claim values displayed; token acquisition and client ID not captured | Partial evidence |
| D12-11 | Negative app-only `/me` | `GET /me` cannot return a user profile without a signed-in user | `Expected failure: BadRequest` | Pass |
| D12-12 | App-only token claim display | Graph audience; `User.Read.All` in `roles`; no delegated scope value | Selected claim output shows Graph, `User.Read.All` and blank `scp` | Pass (displayed values only) |
| D12-13 | Least-privilege cleanup | Temporary Application permission/consent and credential are removed | Only delegated `User.Read` appears; separate cleanup actions are historical operator reports | Partial evidence |
| D12-14 | Post-cleanup regression | Fresh delegated sign-in and token retrieval remain functional after cleanup | Anna, `Expense.Submitter` and Graph HTTP 200 in a captured session; fresh redemption/renewal not shown | Partial evidence |

## D12-01–D12-03 — Delegated permission and consent

**Acting identities:** Baltic Finance application administrator (configuration); `anna.finance` (Graph Explorer).  
**Expected:** `User.Read` is Delegated and consented; a signed-in client can request Anna's profile through `GET /me`.  
**Observed:** the App Registration listed `User.Read` as Delegated and Granted; the Enterprise Application showed Admin consent. Graph Explorer returned Anna's selected profile fields with HTTP 200.  
**Result:** Pass.  
**Evidence:**

- [01 — Delegated User.Read](../evidence/day-12/01-delegated-user-read.png)
- [02 — Delegated consent status](../evidence/day-12/02-delegated-admin-consent.png)
- [03 — Enterprise Application permission](../evidence/day-12/03-enterprise-app-permissions.png)
- [04 — Graph Explorer Anna profile](../evidence/day-12/04-graph-explorer-anna-profile.png)

**Evidence boundary:** Graph Explorer has its own client identity. Tenant-wide admin consent is shown; an interactive user-consent prompt was not tested.

## D12-04 — Existing App Service authentication and Graph scope

**Acting identity:** Baltic Finance administrator.  
**Expected:** the existing Expense Portal Web App remains protected by Easy Auth, token storage is enabled, and OAuth login parameters request the Graph `User.Read` scope.  
**Observed:** Authentication showed Enabled, Require authentication, redirect to Microsoft and Token store Enabled. API Playground showed `https://graph.microsoft.com/User.Read` in the login parameters.  
**Result:** Pass.  
**Evidence:**

- [05 — App Service Token store](../evidence/day-12/05-app-service-token-store.png)
- [06 — Graph scope configuration](../evidence/day-12/06-graph-scope-configuration.png)

## D12-05–D12-07 — Delegated Graph profiles in Expense Portal

**Acting identities:** `anna.finance` and `peter.finance`, in separate portal sessions.  
**Expected:** the same application retains each user's original App Roles while Microsoft Graph returns that signed-in user's own profile.  
**Observed:** Anna's portal displayed `Expense.Submitter` and her Graph profile with HTTP 200. Her `/graph/profile` JSON response identified `source: Microsoft Graph` and `permissionModel: Delegated`. Peter's portal displayed `Expense.Submitter`, `Expense.Approver` and Peter's own Graph profile with HTTP 200.  
**Result:** Pass.  
**Evidence:**

- [07 — Anna's Expense Portal profile](../evidence/day-12/07-anna-graph-profile.png)
- [08 — Anna's Graph API response](../evidence/day-12/08-anna-graph-api-response.png)
- [09 — Peter's Expense Portal profile](../evidence/day-12/09-peter-graph-profile.png)

**Interpretation:** an Expense Portal App Role controls business functionality; it is not itself a Microsoft Graph API permission. Optional profile fields returned as null are not request failures.

**Evidence boundary:** these screenshots confirm application-displayed profile responses and role labels. The backend source and a delegated token-claim capture are not published, so the audit does not independently verify token handling or server-side authorization implementation.

## D12-08–D12-09 — Temporary Application permission and consent

**Acting identity:** Baltic Finance administrator authorized to grant Microsoft Graph Application permissions.  
**Expected:** the same App Registration temporarily requests `User.Read.All` as Application and receives admin consent before app-only requests.  
**Observed:** the initial state showed `User.Read` Delegated/Granted and `User.Read.All` Application/Not granted. The following screenshot showed successful admin consent and both permissions Granted.  
**Result:** Pass.  
**Evidence:**

- [10 — Delegated versus Application permissions](../evidence/day-12/10-delegated-vs-application-permissions.png)
- [11 — Application admin consent](../evidence/day-12/11-application-admin-consent.png)

## D12-10 — Client Credentials Flow and `GET /users`

**Acting identity:** reported as the Expense Portal application identity; the screenshots show the request and selected app-only claim values, without the client identifier.  
**Expected:** a token obtained for `https://graph.microsoft.com/.default` with the temporary Application permission can be used for `GET /users`.  
**Observed:** the PowerShell Graph request returned multiple Baltic Finance user profiles. The companion decoded token evidence showed `roles: User.Read.All`.  
**Result:** Partial evidence: request result and claim display observed; token acquisition and client attribution not independently captured.  
**Evidence:**

- [12 — App-only GET /users](../evidence/day-12/12-client-credentials-graph-users.png)
- [14 — App-only token claims](../evidence/day-12/14-app-only-token-claims.png)

**Evidence boundary:** screenshot 12 starts with an existing `$tokenResponse`; it does not show the token endpoint request, `grant_type` or client identifier. Screenshot 14 omits `appid`/`azp`. Preserve a sanitized token-acquisition script and diagnostic client/tenant correlation without exposing any token or credential to complete this evidence chain.

## D12-11 — Negative app-only `GET /me`

**Acting identity:** reported as the Expense Portal application identity using the app-only bearer token.  
**Expected:** `GET /me` does not return a user profile because the token has no signed-in user context.  
**Observed:** PowerShell displayed `Expected failure: BadRequest`. The test does not claim a specific HTTP 403 result.  
**Result:** Pass.  
**Evidence:** [13 — App-only /me denied](../evidence/day-12/13-app-only-me-denied.png)

**Evidence boundary:** the broad catch prints an HTTP status, not the Graph error body. `BadRequest` is consistent with the [documented delegated-only `/me` endpoint](https://learn.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0), but the exact server error reason is unverified. A repeat should check the expected status and sanitized Graph error code/message rather than label every caught exception an expected failure.

## D12-12 — Token claim inspection

**Acting identity:** lab operator decoding the app-only token payload locally.  
**Expected:** displayed claims identify Microsoft Graph, `User.Read.All` in `roles` and no delegated scope value.  
**Observed:** `aud` was `https://graph.microsoft.com`; `roles` contained `User.Read.All`; the selected `scp` column was blank.  
**Result:** Pass (displayed claim values).  
**Evidence:** [14 — App-only token claims](../evidence/day-12/14-app-only-token-claims.png)

**Evidence boundary:** the screenshot shows selected properties of `$claims`; the decoding implementation is absent. Blank output does not distinguish an absent property from an empty value. Claim display is not cryptographic signature validation. A separate delegated JWT payload screenshot was not captured.

## D12-13–D12-14 — Cleanup and regression

**Acting identities:** authorized Baltic Finance administrator (reported cleanup); `anna.finance` (captured portal session).  
**Expected:** delete the temporary test credential, revoke app-only consent, remove declared `User.Read.All`, retain delegated `User.Read` and verify that the application still retrieves Anna's profile.  
**Observed:** prior lab notes report operator-confirmed temporary-secret deletion and consent revocation. The final permission list shows only delegated `User.Read` Granted. Anna's captured session shows `Expense.Submitter`, her Graph profile and HTTP 200, without fresh-sign-in or token-lifetime evidence.  
**Result:** Partial evidence for complete cleanup and fresh post-cleanup regression.  
**Evidence:**

- [15 — Least-privilege final state](../evidence/day-12/15-least-privilege-final-state.png)
- [16 — Final Expense Portal Graph test](../evidence/day-12/16-final-expense-portal-graph.png)

**Follow-up:** independently verify the service-principal grant and credential state, then perform a new browser sign-in and token-renewal test with sanitized timestamps. Distinguish the temporary app-only credential from the provider credential used by Easy Auth. See [remaining work](../docs/remaining-work.md).

## Final state

- The existing Expense Portal, authentication and business App Roles remain in use.
- Delegated Microsoft Graph `User.Read` remains granted.
- Configured Application `User.Read.All` is absent; consent revocation and temporary-secret deletion were reported by the operator and are not independently pictured in Day 12.
- The captured portal session still displayed Anna's Graph profile; fresh code redemption and token renewal after cleanup remain unverified here.
- No full access tokens or client secrets were published.

See [Day 12 evidence](../evidence/day-12/README.md) and [Day 12 implementation notes](../docs/day-12.md).
