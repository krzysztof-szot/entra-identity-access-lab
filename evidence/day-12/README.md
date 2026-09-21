# Day 12 — Evidence

This folder documents OAuth 2.0 authorization and Microsoft Graph integration with the existing Expense Portal: delegated `User.Read`, consent, Graph profile retrieval for Anna and Peter, a temporary app-only `User.Read.All` test, and least-privilege cleanup.

## Evidence

- `01-delegated-user-read.png` — shows Microsoft Graph `User.Read` configured as a Delegated permission for Expense Portal.
- `02-delegated-admin-consent.png` — confirms tenant-wide admin consent for delegated `User.Read` (consent status, not the moment of approval).
- `03-enterprise-app-permissions.png` — shows the consented delegated `User.Read` permission on the Expense Portal Enterprise Application.
- `04-graph-explorer-anna-profile.png` — shows a successful `GET /me` request for Anna Finance in Graph Explorer; this is a separate client from Expense Portal.
- `05-app-service-token-store.png` — confirms App Service Authentication and Token store are enabled for the existing Expense Portal Web App.
- `06-graph-scope-configuration.png` — shows the Easy Auth login parameters requesting the Microsoft Graph `User.Read` scope.
- `07-anna-graph-profile.png` — shows Anna signed in to Expense Portal with `Expense.Submitter` and her Graph profile returned using delegated `User.Read` (HTTP 200).
- `08-anna-graph-api-response.png` — shows the Expense Portal `/graph/profile` JSON response containing Anna's profile and `Delegated` permission model.
- `09-peter-graph-profile.png` — shows Peter signed in with `Expense.Submitter` and `Expense.Approver`, plus his own Graph profile returned through delegated `User.Read` (HTTP 200).
- `10-delegated-vs-application-permissions.png` — contrasts delegated `User.Read` (granted) with newly configured application `User.Read.All` (not yet granted).
- `11-application-admin-consent.png` — confirms tenant-wide admin consent was granted to the temporary `User.Read.All` Application permission.
- `12-client-credentials-graph-users.png` — shows the app-only token used in PowerShell to retrieve user profiles through Microsoft Graph `GET /users`.
- `13-app-only-me-denied.png` — shows the expected `BadRequest` when an app-only token is used with `GET /me`, which requires a signed-in user.
- `14-app-only-token-claims.png` — shows Microsoft Graph as token audience, `roles: User.Read.All`, and no delegated `scp` claim.
- `15-least-privilege-final-state.png` — shows the final App Registration permission list with delegated `User.Read` retained and temporary application `User.Read.All` removed.
- `16-final-expense-portal-graph.png` — confirms Expense Portal still authenticates Anna, displays `Expense.Submitter`, and retrieves her Graph profile (HTTP 200) after cleanup.

Sensitive identifiers, user-specific details and credentials were redacted where appropriate. No access tokens or client secrets are published.
