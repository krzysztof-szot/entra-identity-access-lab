# Day 14 — SSO, Application Proxy and Provisioning Tests

Tests cover the existing Expense Portal's sign-in experience, separate SAML and Linked SSO applications, a single-server Application Proxy deployment, assignment-based positive/negative access, Conditional Access and SCIM update/deprovisioning. Password-based SSO was omitted rather than presented as a completed test.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D14-01 | Existing Expense Portal authentication | Web registration and single-tenant sign-in remain functional | Web redirect URI and single-tenant registration visible | Pass |
| D14-02 | Expense Portal positive sign-in | Anna signs in and receives existing app role | Anna displayed with Expense.Submitter and Graph User.Read profile | Pass |
| D14-03 | Expense Portal sign-in monitoring | Relevant Entra sign-in is successful | Expense Portal Success; MFA requirement and CA details visible | Pass |
| D14-04 | SAML configuration | IdP/SP URLs and NameID configured for Toolkit | Entity ID, ACS URL, Sign-on URL and claims shown | Pass |
| D14-05 | SAML positive sign-in | Anna reaches Toolkit and Entra records the app sign-in | Signed-in Toolkit session; BFL SAML Lab Success | Pass |
| D14-06 | Linked SSO | My Apps link opens intended destination | BFL Linked Portal redirects to Expense Portal | Pass |
| D14-07 | Internal IIS app | Private test site works on application server | BFL Internal Portal visible at localhost | Pass |
| D14-08 | Connector and group | Connector active and app assigned to group | BFL-APP01 Active; BFL-Internal-Apps has one app | Pass |
| D14-09 | Application Proxy configuration | External HTTPS URL uses Entra pre-auth and local backend | http://localhost/, HTTPS external URL, Entra ID and connector group shown | Pass |
| D14-10 | Proxy application assignment | Pilot group is assigned | SG-APP-InternalPortal assigned as User | Pass |
| D14-11 | App-specific MFA policy | Pilot group and proxy are scoped to Require MFA | Configuration captured in Report-only; later log shows named policy Success | Pass (mode chronology limited) |
| D14-12 | Proxy positive access | Assigned Anna reaches the private portal externally | Internal IIS page visible at msappproxy.net URL | Pass |
| D14-13 | Proxy negative access | Unassigned Peter is refused | AADSTS50105 assignment-related denial | Pass |
| D14-14 | Proxy sign-in monitoring | Anna/Peter outcomes and CA evaluation are recorded | Anna Success, Peter Failure; named MFA policy Success for Anna | Pass |
| D14-15 | SCIM scope and mapping | Pilot assignment scope and user mappings are configured | SG-APP-Provisioning-Pilot, userPrincipalName → userName and jobTitle → title visible | Pass |
| D14-16 | SCIM on-demand update | In-scope Anna is matched and target title updated | All five stages Success; title updated to Senior Finance Analyst in customappsso | Pass |
| D14-17 | SCIM deprovisioning | Losing assignment leads to successful target disable | Separate Provisioning Log: Disable → Success for Anna / customappsso | Pass |
| D14-18 | Redundant soft-delete handling | Repeating an already processed soft-delete is not misreported as new disable | RedundantSoftDelete / Skipped; assignment False, source identity active | Pass (expected skip) |
| D14-19 | Password-based SSO | Real legacy app and credential forwarding would be required | LAB 5 intentionally omitted; no screenshot | Not tested |

## D14-01–D14-03 — Expense Portal authentication

**Acting identities:** adm-lab (configuration/log review), anna.finance (sign-in).  
**Expected:** existing single-tenant web application remains accessible, with the previously configured role and Graph integration.  
**Observed:** web callback URI and supported accounts visible; Anna signed in with Expense.Submitter and retrieved her Graph profile using delegated User.Read. Entra log showed Expense Portal Success and MFA/CA details.  
**Result:** Pass.  
**Evidence:**

- [01 — Registration](../evidence/day-14/01-oidc-app-registration.png)
- [02 — Signed-in Expense Portal](../evidence/day-14/02-oidc-successful-signin.png)
- [03 — Expense Portal sign-in log](../evidence/day-14/03-oidc-signin-log.png)

**Evidence boundary:** the screenshots demonstrate the app's Entra sign-in experience, not a raw ID-token-validation trace. The Microsoft Graph resource in the sign-in record is consistent with the app's Graph call.

## D14-04–D14-05 — SAML configuration and sign-in

**Acting identities:** adm-lab (Enterprise Application), anna.finance (test user).  
**Expected:** the Toolkit's Entity ID, ACS URL and Sign-on URL match the Enterprise Application; assigned Anna can sign in.  
**Observed:** SAML configuration and NameID mapping displayed; Toolkit showed Anna signed in and BFL SAML Lab recorded Success.  
**Result:** Pass.  
**Evidence:**

- [04 — SAML configuration](../evidence/day-14/04-saml-configuration.png)
- [05 — Toolkit and successful app sign-in](../evidence/day-14/05-saml-successful-sso.png)

## D14-06 — Linked SSO

**Acting identities:** adm-lab (link), anna.finance (My Apps).  
**Expected:** selecting BFL Linked Portal navigates to Expense Portal.  
**Observed:** configured Sign-on URL, tile and destination page shown.  
**Result:** Pass.  
**Evidence:** [06 — Linked SSO redirect](../evidence/day-14/06-linked-sso-redirect.png)

**Boundary:** Linked SSO does not itself sign Anna into Expense Portal; that app performs its own authentication.

## D14-07–D14-09 — Internal app, connector and publication

**Acting identities:** Windows administrator on BFL-APP01 and authorized Baltic Finance Enterprise Application administrator.  
**Expected:** IIS site is available locally, connector is active and the published app uses Entra pre-authentication with the intended connector group.  
**Observed:** local BFL Internal Portal opened; BFL-APP01 Active; BFL-Internal-Apps showed one assigned app; proxy used http://localhost/ and an external HTTPS address.  
**Result:** Pass.  
**Evidence:**

- [07 — IIS application](../evidence/day-14/07-internal-web-application.png)
- [08 — Active connector](../evidence/day-14/08-private-network-connector.png)
- [09 — Connector group and assignment count](../evidence/day-14/09-connector-group.png)
- [10 — Application Proxy settings](../evidence/day-14/10-application-proxy-configuration.png)

**Lab constraint:** connector and IIS share BFL-APP01. No BFL-APC01 or high-availability failover was deployed. The static IIS page does not prove backend-user SSO.

## D14-10–D14-11 — Group assignment and MFA policy

**Acting identity:** authorized Baltic Finance Enterprise Application / Conditional Access administrator.  
**Expected:** only the intended app group is assigned, and an MFA policy targets the proxy app.  
**Observed:** SG-APP-InternalPortal assigned; CA-BFL-InternalPortal-Require-MFA selected the group/app and Require MFA. The captured configuration was Report-only; the later Anna sign-in shows the named policy's Success.  
**Result:** Pass (exact transition between policy modes not separately timestamped).  
**Evidence:**

- [11 — App assignment](../evidence/day-14/11-proxy-app-assignment.png)
- [12 — Conditional Access setup](../evidence/day-14/12-proxy-conditional-access.png)
- [15 — Sign-in and CA evaluation](../evidence/day-14/15-proxy-signin-logs.png)

## D14-12–D14-14 — Positive and negative external access

**Acting identities:** anna.finance (assigned), peter.finance (unassigned), adm-lab (log reader).  
**Expected:** Anna reaches the internal page at the external URL; Peter is denied due to missing app assignment; logs record both outcomes.  
**Observed:** Anna saw BFL Internal Portal at the Application Proxy URL. Peter received AADSTS50105. Proxy sign-in logs showed Anna Success, Peter Failure and the named MFA policy Success for Anna.  
**Result:** Pass.  
**Evidence:**

- [13 — External access success](../evidence/day-14/13-proxy-successful-access.png)
- [14 — Expected denial](../evidence/day-14/14-proxy-access-denied.png)
- [15 — Proxy sign-in logs](../evidence/day-14/15-proxy-signin-logs.png)

**Interpretation:** Peter's failure is an application-assignment denial; it is not evidence that his tenant identity was disabled.

## D14-15–D14-16 — SCIM scope, mappings and update

**Acting identity:** authorized Baltic Finance provisioning administrator; **target identity:** anna.finance.  
**Expected:** pilot scope restricts the provisioning population; on-demand provisioning matches Anna and updates her target record.  
**Observed:** SG-APP-Provisioning-Pilot selected, matching userPrincipalName → userName and jobTitle → title visible. On demand, import/scope/match/evaluate/perform stages all succeeded and customappsso received the updated title Senior Finance Analyst.  
**Result:** Pass.  
**Evidence:**

- [16 — Pilot scope and mappings](../evidence/day-14/16-provisioning-attribute-mappings.png)
- [17 — Successful on-demand update](../evidence/day-14/17-provisioning-on-demand.png)

**Boundary:** this captured operation is an **update** to a matched target record, not proof of the initial account creation.

## D14-17–D14-18 — Disable and redundant soft-delete

**Acting identity:** authorized Baltic Finance provisioning administrator; **target identity:** anna.finance.  
**Expected:** loss of the application assignment causes target deprovisioning; repeating an already processed soft-delete does not create a second disable event.  
**Observed:** a Provisioning Log recorded Disable → Success for Anna, source Microsoft Entra ID and target customappsso. The later on-demand scope check showed Assigned to the application: False, IsActive: True and SkipReason: RedundantSoftDelete; the repeated operation was skipped.  
**Result:** Pass for the logged disable; Pass (expected skip) for the redundant check.  
**Evidence:** [18 — Scope diagnostic and successful disable log](../evidence/day-14/18-provisioning-deprovisioning.png)

**Interpretation:** Anna remained active in Microsoft Entra; the disable concerned her record in the target application. No independent screenshot of the target application's final account detail is included.

## D14-19 — Password-based SSO

**Expected:** a separate, real test app with a credential form and configured password-based SSO.  
**Observed:** LAB 5 was intentionally omitted due to the chosen lab scope; no credentials or artificial demonstration were created.  
**Result:** Not tested.  
**Evidence:** None.

## Final state

The existing Expense Portal, separate SAML and Linked applications, the single-host IIS/Application Proxy lab, and the SCIM test application were exercised as described above. Evidence includes both positive and negative proxy access, SCIM update and a logged successful disable. No second connector VM, backend Kerberos SSO, high availability or Password-based SSO is claimed.

See [Day 14 evidence](../evidence/day-14/README.md) and [Day 14 implementation notes](../docs/day-14.md).
