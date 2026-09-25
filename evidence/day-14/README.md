# Day 14 — Evidence

This folder documents SSO and application integration in Baltic Finance: OIDC authentication with the existing Expense Portal, SAML federation, linked sign-on, a single-server Microsoft Entra Application Proxy deployment, Conditional Access, SCIM-based provisioning and deprovisioning, and a subsequently completed Password-based SSO test.

## Evidence

- `01-oidc-app-registration.png` — shows the Expense Portal web redirect URI and single-tenant authentication configuration.
- `02-oidc-successful-signin.png` — shows Anna signed in to Expense Portal with the `Expense.Submitter` app role and her profile retrieved through delegated Microsoft Graph `User.Read`.
- `03-oidc-signin-log.png` — shows Anna's successful Expense Portal sign-in, MFA requirement, and Conditional Access results; the displayed Microsoft Graph resource relates to the app's Graph access.
- `04-saml-configuration.png` — shows the `BFL SAML Lab` Entity ID, ACS/Reply URL, Sign-on URL, and SAML attributes and claims.
- `05-saml-successful-sso.png` — shows Anna signed in to SAML Toolkit alongside a successful `BFL SAML Lab` sign-in log.
- `06-linked-sso-redirect.png` — shows `BFL Linked Portal` configured in My Apps to redirect to Expense Portal. Linked SSO provides a link; Expense Portal performs its own authentication.
- `07-internal-web-application.png` — shows `BFL Internal Portal` served locally by IIS on `BFL-APP01` at `http://localhost/`.
- `08-private-network-connector.png` — shows the registered `BFL-APP01` Private Network Connector in Active status.
- `09-connector-group.png` — shows `BFL-Internal-Apps` with the Active `BFL-APP01` connector and one assigned application.
- `10-application-proxy-configuration.png` — shows `BFL Internal Portal - Proxy` with internal URL `http://localhost/`, an external HTTPS URL, Microsoft Entra ID pre-authentication, and the `BFL-Internal-Apps` connector group.
- `11-proxy-app-assignment.png` — shows `SG-APP-InternalPortal` assigned to the proxy Enterprise Application.
- `12-proxy-conditional-access.png` — shows `CA-BFL-InternalPortal-Require-MFA` scoped to the pilot group and proxy application, with MFA required; the captured policy configuration is in Report-only mode.
- `13-proxy-successful-access.png` — shows the internal IIS application reached through the external Application Proxy URL after Entra pre-authentication. The static IIS page does not itself establish backend user SSO.
- `14-proxy-access-denied.png` — shows Peter denied access with `AADSTS50105` because he was not assigned to the proxy application.
- `15-proxy-signin-logs.png` — shows the proxy sign-in results for Anna and Peter and a successful evaluation of `CA-BFL-InternalPortal-Require-MFA` for Anna.
- `16-provisioning-attribute-mappings.png` — shows the `SG-APP-Provisioning-Pilot` assignment scope and Entra-to-`customappsso` SCIM attribute mappings, including `userPrincipalName → userName` and `jobTitle → title`.
- `17-provisioning-on-demand.png` — shows successful on-demand provisioning for Anna: user import, scoping, matching, evaluation, and update of `title` in `customappsso`.
- `18-provisioning-deprovisioning.png` — shows Anna no longer assigned to the application, the subsequent on-demand soft-delete skipped as `RedundantSoftDelete` because it had already been processed, and a separate provisioning log recording `Disable → Success` in `customappsso`.
- `19-password-based-sso-configuration.png` — shows `BFL Legacy HR - Password SSO` configured with the test login form URL and Entra's `A sign-in form was detected` confirmation.
- `20-password-sso-myapps-assignment.png` — shows the assigned `BFL Legacy HR - Password SSO` tile in Anna's My Apps dashboard.
- `21-password-based-sso.png` — shows the target site's `/secure` page after the My Apps launch. The existing lab notes report automatic stored-credential replay without manual entry; this image only confirms the destination session. Independent replay verification is Partial.

Sensitive identifiers and user-specific details were redacted where appropriate; no credentials or tokens are published.
