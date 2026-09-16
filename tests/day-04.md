# Day 04 — Authentication Hardening Tests

## Objective

Validate authentication method configuration, passwordless onboarding, phishing-resistant authentication strength enforcement, Conditional Access behavior, sign-in logging and Self-Service Password Reset for the Expense Portal.

| Check | Expected Result | Actual Result | Evidence |
|---|---|---|---|
| Required authentication methods are enabled | Microsoft Authenticator, SMS, Temporary Access Pass and Passkey (FIDO2) are available for the intended users or groups | Pass | [01-authentication-methods-policy.png](../evidence/day-04/01-authentication-methods-policy.png) |
| Passkey registration campaign targets the passwordless pilot | Passkey (FIDO2) registration campaign is enabled for `SG-Passwordless-Pilot` | Pass | [02-passkey-registration-campaign.png](../evidence/day-04/02-passkey-registration-campaign.png) |
| Temporary Access Pass can be used to bootstrap strong authentication | A time-limited TAP is generated for `anna.finance` without exposing the credential in published evidence | Pass | [03-temporary-access-pass-bootstrap.png](../evidence/day-04/03-temporary-access-pass-bootstrap.png) |
| `anna.finance` can register a device-bound passkey | Passkey appears as a usable authentication method for the user | Pass | [04-anna-passkey-registered.png](../evidence/day-04/04-anna-passkey-registered.png) |
| CA003 enforces phishing-resistant MFA for the authentication hardening pilot | Policy targets `SG-Auth-Hardening-Pilot`, excludes `SG-Emergency-Access`, targets Expense Portal and requires `Phishing-resistant MFA` | Pass | [05-ca003-phishing-resistant-mfa.png](../evidence/day-04/05-ca003-phishing-resistant-mfa.png) |
| `peter.finance` cannot access Expense Portal with authentication methods that do not satisfy CA003 | Access is denied or additional stronger authentication is required | Pass | [06-peter-weak-authentication-denied.png](../evidence/day-04/06-peter-weak-authentication-denied.png) |
| `anna.finance` can access Expense Portal using a passkey | Authentication succeeds and the existing `Expense.Submitter` application role remains available | Pass | [07-anna-passkey-expense-portal-success.png](../evidence/day-04/07-anna-passkey-expense-portal-success.png) |
| Passkey authentication and CA003 enforcement are recorded in Sign-in logs | Authentication details show a device-bound passkey and both CA001 and CA003 return `Success` | Pass | [08-anna-fido2-signin-log.png](../evidence/day-04/08-anna-fido2-signin-log.png) |
| SSPR is enabled for the authentication hardening pilot | `SG-Auth-Hardening-Pilot` is selected and two authentication methods are required for password reset | Pass | [09-sspr-pilot-configuration.png](../evidence/day-04/09-sspr-pilot-configuration.png) |

## Result

All planned Day 04 authentication hardening tests completed successfully.

The tests confirmed that passwordless onboarding, phishing-resistant MFA enforcement, negative and positive access scenarios, Conditional Access logging and SSPR recovery controls behave as designed.
