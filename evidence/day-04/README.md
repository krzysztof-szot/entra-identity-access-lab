# Day 04 — Evidence

This folder contains evidence for the Day 04 authentication hardening and phishing-resistant MFA implementation and validation.

## 01 — Authentication Methods Policy

![Enabled Authenticator, SMS, Temporary Access Pass and Passkey methods](01-authentication-methods-policy.png)

**Shows:** Authenticator and SMS enabled for all users, Passkey (FIDO2) for two groups and Temporary Access Pass for one group.

**Why it matters:** Documents method availability for the hardening lab. The TAP and Passkey target group names are not expanded in this view.

## 02 — Passkey registration campaign

![Enabled Passkey registration campaign targeting SG-Passwordless-Pilot](02-passkey-registration-campaign.png)

**Shows:** An enabled Passkey (FIDO2) registration campaign with `SG-Passwordless-Pilot` selected.

**Why it matters:** Documents a controlled registration rollout. Campaign configuration alone does not show a user completing the registration prompt.

## 03 — Temporary Access Pass issuance

![One-hour Temporary Access Pass created for Anna Finance with the value redacted](03-temporary-access-pass-bootstrap.png)

**Shows:** A Temporary Access Pass created for Anna Finance with a one-hour validity window and its credential value redacted.

**Why it matters:** Documents issuance of the intended bootstrap credential. The capture does not show TAP consumption or the authentication flow used to register the passkey.

## 04 — Registered device-bound passkey

![Anna Finance Security info listing a device-bound passkey and Authenticator](04-anna-passkey-registered.png)

**Shows:** Anna's Security info listing a device-bound passkey named `ANNA.FEITIAN-KEY03`, alongside Microsoft Authenticator and password.

**Why it matters:** Establishes that the passkey is registered to Anna's account; successful use is evidenced separately in the sign-in logs.

## 05 — Phishing-resistant MFA policy

![CA003 targeting the authentication hardening pilot with Phishing-resistant MFA strength](05-ca003-phishing-resistant-mfa.png)

**Shows:** CA003 On for `SG-Auth-Hardening-Pilot` and Expense Portal, excluding `SG-Emergency-Access`, with `Phishing-resistant MFA` authentication strength.

**Why it matters:** Documents the stronger authentication requirement for the pilot and its emergency-access exclusion.

## 06 — Additional authentication methods required

![Peter Finance blocked with an additional-sign-in-methods-required message](06-peter-weak-authentication-denied.png)

**Shows:** Peter Finance receiving a block message stating that additional sign-in methods are required.

**Why it matters:** Captures the negative authentication experience in the documented scenario. The image does not identify Expense Portal, CA003 or the exact failed method.

## 07 — Anna's authenticated portal session

![Anna Finance accessing Expense Portal with the Submitter role in the passkey scenario](07-anna-passkey-expense-portal-success.png)

**Shows:** Anna authenticated to Expense Portal with `Expense.Submitter` displayed.

**Why it matters:** Shows application access in the passkey test sequence while preserving the existing business role. The page itself does not identify the authentication method.

## 08 — Passkey and Conditional Access results

![Anna's device-bound passkey authentication and successful CA001 and CA003 evaluations](08-anna-fido2-signin-log.png)

**Shows:** Successful device-bound passkey authentication for Anna, CA001 and CA003 returning Success, and an Expense Portal event list with Interrupted followed by Success.

**Why it matters:** Corroborates use of the strong method and successful policy evaluation with Entra sign-in evidence.

## 09 — Self-Service Password Reset pilot

![SSPR enabled for SG-Auth-Hardening-Pilot with two reset methods required](09-sspr-pilot-configuration.png)

**Shows:** SSPR enabled for `SG-Auth-Hardening-Pilot`, with two authentication methods required for password reset.

**Why it matters:** Documents recovery configuration. A completed reset, sign-in with the new password and hybrid password writeback are not shown.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
