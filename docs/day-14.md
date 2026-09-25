# Day 14 — SSO, Application Proxy and Provisioning

## Objectives

Day 14 extended the existing Baltic Finance identity lab with enterprise application integration. The goals were to compare OIDC, SAML, Linked SSO and Password-based SSO; publish a private IIS application through Microsoft Entra Application Proxy; enforce application assignment and Conditional Access; and exercise SCIM-based account updates and deprovisioning.

Day 12 focused on OAuth 2.0 authorization and Microsoft Graph. This day separates **authentication/SSO**, **remote application access**, and **identity lifecycle provisioning** instead of treating them as interchangeable.

## Implemented

### Existing Expense Portal: OIDC and sign-in verification

The existing single-tenant Expense Portal App Registration and Azure App Service were reused, preserving the web redirect URI ending in /.auth/login/aad/callback, app roles and Microsoft Graph integration.

Anna Finance signed in successfully. Expense Portal displayed the existing Expense.Submitter role and her profile retrieved using delegated Microsoft Graph User.Read. The associated Entra sign-in evidence recorded a successful Expense Portal sign-in, an MFA requirement and Conditional Access results. The Microsoft Graph resource visible in that log reflects the app's Graph access; it is not a separate Application Proxy sign-in.

The evidence verifies a working Entra-authenticated application experience and its registration settings. The screenshots do not independently show cryptographic ID-token validation or a raw OIDC protocol trace.

### SAML federated sign-on

A separate BFL SAML Lab Enterprise Application was configured against SAML Toolkit, without changing Expense Portal's authentication method. The recorded configuration includes:

| SAML setting | Recorded value |
| --- | --- |
| Entity ID | https://samltoolkit.azurewebsites.net |
| Reply URL / ACS | https://samltoolkit.azurewebsites.net/SAML/Consume |
| Sign-on URL | https://samltoolkit.azurewebsites.net/ |
| Unique User Identifier | user.userprincipalname |

Anna's SAML Toolkit session and a successful BFL SAML Lab sign-in log were captured together. The service-provider session and Entra event corroborate the functional SSO test; no raw SAML assertion is published.

### Linked SSO

BFL Linked Portal was configured with the existing Expense Portal URL as the linked destination. The My Apps tile and resulting Expense Portal page were captured for Anna.

**Linked SSO is navigation, not federated authentication by itself.** Expense Portal continues to authenticate the user through its own Microsoft Entra integration.

### Password-based SSO for a legacy application

A separate Enterprise Application, `BFL Legacy HR - Password SSO`, was configured for **Password-based single sign-on** using the test application's form at `https://the-internet.herokuapp.com/login`. Entra's configuration page reported `A sign-in form was detected`.

Anna was assigned the application, and the `BFL Legacy HR - Password SSO` tile appeared in My Apps. The existing lab notes report that selecting the tile automatically signed her in to the test site's `/secure` page using stored application credentials **without manually entering the username or password**. The resulting page displayed `You logged into a secure area!`.

This is credential replay to a separate form-based application's sign-in, **not SAML/OIDC federation** and not evidence that the application itself validates an Entra token. The configuration, My Apps assignment and successful destination page are visible in screenshots 19–21. Those screenshots do not independently expose the credential-replay step; the no-manual-entry observation is the recorded test execution. No credentials were published.

### Single-server Application Proxy architecture

Due to lab VM/resource constraints, a separate BFL-APC01 was **not** created. The internal IIS application and the Private Network Connector were intentionally co-located on BFL-APP01.

```text
External user
    ↓
Microsoft Entra ID pre-authentication / Conditional Access
    ↓
Microsoft Entra Application Proxy (external HTTPS URL)
    ↓
Private Network Connector on BFL-APP01
    ↓
IIS on BFL-APP01 (http://localhost/)
```

| Component | Configuration |
| --- | --- |
| Internal site | BFL Internal Portal on IIS |
| Application server / connector host | BFL-APP01 |
| Enterprise Application | BFL Internal Portal - Proxy |
| Internal URL | http://localhost/ |
| External URL | Microsoft Application Proxy HTTPS / msappproxy.net |
| Pre-authentication | Microsoft Entra ID |
| Connector group | BFL-Internal-Apps |
| Application access group | SG-APP-InternalPortal |
| Conditional Access policy | CA-BFL-InternalPortal-Require-MFA |

The internal page was opened locally on BFL-APP01. The connector appeared as **Active**, its group showed **one assigned application**, and the Enterprise Application showed the expected internal/external URLs, pre-authentication and connector group.

Screenshots 08 and 10 also contain a `Private Network is currently disabled for your tenant` banner; screenshot 09 shows the enabled-state `Disable private network connectors` control. These configuration captures have no timestamps establishing their transition order. The successful external access and sign-in in 13–15 establish the working test outcome separately.

The single-server arrangement is a deliberate learning constraint, **not** a highly available or separated production deployment. The public HTTPS URL reaches the IIS test page through Application Proxy; the static IIS page does **not** demonstrate backend Kerberos/header-based SSO or independently display a validated user identity.

### Assignment, Conditional Access and access tests

SG-APP-InternalPortal was assigned to BFL Internal Portal - Proxy. Anna was the positive test identity; Peter was the unassigned negative test identity.

CA-BFL-InternalPortal-Require-MFA targeted the pilot group and proxy app, requiring MFA. Its configuration screenshot shows **Report-only** at capture time. A later proxy sign-in record shows the named policy with **Success** for Anna. The log, not the configuration screenshot alone, is the evidence of policy evaluation during that sign-in; the exact time when the policy mode changed is not independently documented.

Anna successfully reached the internal portal at its Application Proxy external URL. Peter's fresh access attempt failed with AADSTS50105 because he had neither a qualifying group assignment nor a direct application assignment. The corresponding application sign-in entries show Anna's Success and Peter's Failure.

### SCIM provisioning and deprovisioning

A separate BFL Provisioning Lab Enterprise Application targeted customappsso. SG-APP-Provisioning-Pilot defined the selected-user assignment scope. The recorded mapping view included userPrincipalName → userName (matching precedence 1), jobTitle → title, givenName → name.givenName and other profile attributes.

Provision on demand for Anna completed import, scope evaluation, matching, action evaluation and action execution with **Success**. The target's title attribute was updated to Senior Finance Analyst.

After Anna lost the application assignment, a later on-demand attempt reported RedundantSoftDelete: Entra considered the soft-delete already processed and skipped doing it again. The final evidence screenshot combines that diagnostic with a **separate Provisioning Logs entry** recording Disable → Success for Anna in customappsso. This is evidence of a successful target disable and of a subsequent redundant-operation skip; it is **not** a claim that the skipped attempt disabled the account a second time.

The source identity remained active (IsActive = True); deprovisioning concerned access to the target app, not disabling Anna throughout Baltic Finance. The evidence does not expose a target-side account-management screen or the full original-to-final SCIM payload.

## Design Decisions

- Reuse Expense Portal for OIDC and Linked SSO while keeping the SAML experiment isolated in BFL SAML Lab.
- Test Password-based SSO separately with a disposable form-based test site, avoiding production credentials.
- Keep OAuth/Microsoft Graph authorization distinct from OIDC/SAML authentication and SCIM lifecycle management.
- Use BFL-APP01 for both IIS and the connector rather than creating an additional VM; document the resulting single point of failure.
- Use Microsoft Entra ID pre-authentication, a narrowly assigned group and app-specific MFA policy rather than an unprotected public application.
- Show positive **and** negative external access, plus application sign-in logs, instead of relying only on configuration screenshots.
- Scope SCIM provisioning to the pilot group and demonstrate update and disable outcomes without changing Anna's tenant-wide account status.

## Verification and Limitations

The evidence supports: working Expense Portal authentication; SAML Toolkit sign-in with a matching Entra application log; Linked SSO redirection; Password-based SSO configuration, a My Apps tile and a successful target session (the automatic replay step remains independently unverified); a healthy connector and working external Application Proxy route; Anna's allowed access and Peter's expected assignment denial; MFA policy evaluation; and SCIM user update plus successful disable recorded by Provisioning Logs.

**Not implemented / not claimed:** Kerberos Constrained Delegation, header-based backend SSO, a second connector, high availability, a separate connector VM, or independent inspection of raw OIDC/SAML/SCIM messages. The provisioning evidence is numbered **16–18** and was completed before the previously deferred Password-based SSO lab was added as **19–21**. The last three images were not renumbered to imply a different execution order.

## Evidence and Tests

- [Day 14 test results](../tests/day-14.md)
- [Day 14 evidence](../evidence/day-14/README.md)

Sensitive identifiers and user-specific information were redacted where appropriate. No passwords, secrets or bearer tokens are published.
