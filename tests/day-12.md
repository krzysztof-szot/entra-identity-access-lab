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
| D12-10 | Client Credentials Graph request | App-only token permits `GET /users` | PowerShell returned multiple user profiles | Pass |
| D12-11 | Negative app-only `/me` | `GET /me` cannot return a user profile without a signed-in user | `Expected failure: BadRequest` | Pass |
| D12-12 | App-only token claims | Graph audience; `User.Read.All` in `roles`; no `scp` | Locally decoded payload showed these claims | Pass |
| D12-13 | Least-privilege cleanup | Temporary Application permission/consent and credential are removed | Only delegated `User.Read` appears in final permissions; user confirmed secret deletion and consent revocation | Pass (cleanup partly user-confirmed) |
| D12-14 | Post-cleanup regression | Expense Portal delegated Graph access remains functional | Anna, `Expense.Submitter` and Graph HTTP 200 after cleanup | Pass |

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

## D12-08–D12-09 — Temporary Application permission and consent

**Acting identity:** Baltic Finance administrator authorized to grant Microsoft Graph Application permissions.  
**Expected:** the same App Registration temporarily requests `User.Read.All` as Application and receives admin consent before app-only requests.  
**Observed:** the initial state showed `User.Read` Delegated/Granted and `User.Read.All` Application/Not granted. The following screenshot showed successful admin consent and both permissions Granted.  
**Result:** Pass.  
**Evidence:**

- [10 — Delegated versus Application permissions](../evidence/day-12/10-delegated-vs-application-permissions.png)
- [11 — Application admin consent](../evidence/day-12/11-application-admin-consent.png)

## D12-10 — Client Credentials Flow and `GET /users`

**Acting identity:** Expense Portal application identity; PowerShell initiated the request without an interactive user context in the Graph token.  
**Expected:** a token obtained for `https://graph.microsoft.com/.default` with the temporary Application permission can be used for `GET /users`.  
**Observed:** the PowerShell Graph request returned multiple Baltic Finance user profiles. The companion decoded token evidence showed `roles: User.Read.All`.  
**Result:** Pass.  
**Evidence:**

- [12 — App-only GET /users](../evidence/day-12/12-client-credentials-graph-users.png)
- [14 — App-only token claims](../evidence/day-12/14-app-only-token-claims.png)

## D12-11 — Negative app-only `GET /me`

**Acting identity:** Expense Portal application identity using the app-only bearer token.  
**Expected:** `GET /me` does not return a user profile because the token has no signed-in user context.  
**Observed:** PowerShell displayed `Expected failure: BadRequest`. The test does not claim a specific HTTP 403 result.  
**Result:** Pass.  
**Evidence:** [13 — App-only /me denied](../evidence/day-12/13-app-only-me-denied.png)

## D12-12 — Token claim inspection

**Acting identity:** lab operator decoding the app-only token payload locally.  
**Expected:** the token targets Microsoft Graph, carries `User.Read.All` in `roles` and has no delegated `scp` claim.  
**Observed:** `aud` was `https://graph.microsoft.com`; `roles` contained `User.Read.All`; `scp` was absent.  
**Result:** Pass.  
**Evidence:** [14 — App-only token claims](../evidence/day-12/14-app-only-token-claims.png)

**Evidence boundary:** JWT payload decoding displays claims; it is not cryptographic signature validation. A separate delegated JWT payload screenshot was not captured.

## D12-13–D12-14 — Cleanup and regression

**Acting identities:** authorized Baltic Finance administrator (cleanup); `anna.finance` (fresh portal test).  
**Expected:** delete the temporary test credential, revoke app-only consent, remove declared `User.Read.All`, retain delegated `User.Read` and verify that the application still retrieves Anna's profile.  
**Observed:** the user confirmed deletion of the temporary client secret and revocation of the Application permission grant. The final App Registration screenshot showed only delegated `User.Read` Granted. The final Expense Portal screenshot showed Anna authenticated, `Expense.Submitter`, her Graph profile and HTTP 200.  
**Result:** Pass (secret deletion and consent revocation confirmed by the operator, not independently pictured).  
**Evidence:**

- [15 — Least-privilege final state](../evidence/day-12/15-least-privilege-final-state.png)
- [16 — Final Expense Portal Graph test](../evidence/day-12/16-final-expense-portal-graph.png)

## Final state

- The existing Expense Portal, authentication and business App Roles remain in use.
- Delegated Microsoft Graph `User.Read` remains granted.
- Temporary Application `User.Read.All` and its consent were removed; the temporary test secret was deleted (operator-confirmed cleanup).
- Delegated `/graph/profile` still returned Anna's profile after cleanup.
- No full access tokens or client secrets were published.

See [Day 12 evidence](../evidence/day-12/README.md) and [Day 12 implementation notes](../docs/day-12.md).
