# Day 04 — Evidence

This folder contains evidence for the Day 04 authentication hardening and phishing-resistant MFA implementation and validation.

## Evidence

- `01-authentication-methods-policy.png` — shows the enabled authentication methods used in the lab, including Microsoft Authenticator, SMS, Temporary Access Pass, and Passkey (FIDO2).

- `02-passkey-registration-campaign.png` — shows the enabled Passkey (FIDO2) registration campaign scoped to `SG-Passwordless-Pilot`.

- `03-temporary-access-pass-bootstrap.png` — shows a one-hour Temporary Access Pass created for Anna Finance for intended bootstrap use; no TAP sign-in or consumption is shown.

- `04-anna-passkey-registered.png` — confirms that Anna Finance successfully registered a device-bound passkey in addition to Microsoft Authenticator.

- `05-ca003-phishing-resistant-mfa.png` — shows `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot` enabled for `SG-Auth-Hardening-Pilot`, excluding `SG-Emergency-Access`, targeting the Expense Portal, and requiring the `Phishing-resistant MFA` authentication strength.

- `06-peter-weak-authentication-denied.png` — shows Peter Finance blocked with an additional-sign-in-methods-required message. The application, CA003 policy and exact failed method are not visible, so the scenario attribution is only partially supported.

- `07-anna-passkey-expense-portal-success.png` — confirms successful Expense Portal access for Anna Finance after authentication with a passkey while retaining the `Expense.Submitter` application role.

- `08-anna-fido2-signin-log.png` — confirms in Microsoft Entra sign-in logs that Anna authenticated using a device-bound passkey and that both CA001 and CA003 returned `Success`.

- `09-sspr-pilot-configuration.png` — shows Self-Service Password Reset enabled for `SG-Auth-Hardening-Pilot` with two authentication methods required for password reset.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
