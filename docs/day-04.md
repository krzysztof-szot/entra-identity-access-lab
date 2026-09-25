# Day 04 — Authentication Hardening

## Objectives

The goal of Day 04 was to strengthen authentication for the Expense Portal by introducing passwordless and phishing-resistant authentication, while preserving the Conditional Access controls implemented on Day 03.

## Implemented

- Reviewed and configured the Microsoft Entra Authentication Methods Policy.
- Enabled Microsoft Authenticator and SMS as available authentication methods.
- Enabled Temporary Access Pass for controlled passwordless onboarding.
- Enabled Passkey (FIDO2) for the passwordless pilot group.
- Created `SG-Auth-Hardening-Pilot` for authentication hardening tests.
- Created `SG-Passwordless-Pilot` for controlled passkey deployment.
- Enabled a Passkey (FIDO2) registration campaign for `SG-Passwordless-Pilot`.
- Generated a Temporary Access Pass for Anna Finance to bootstrap strong credential registration.
- Registered a device-bound passkey for Anna Finance.
- Created `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot`.
- Scoped CA003 to `SG-Auth-Hardening-Pilot`.
- Excluded `SG-Emergency-Access` from CA003.
- Targeted the Expense Portal as the protected resource.
- Configured CA003 to require the built-in `Phishing-resistant MFA` authentication strength.
- Captured Peter Finance's additional-sign-in-methods-required block during the reported Expense Portal test; the capture does not identify the app or CA003.
- Confirmed that Anna Finance could access the Expense Portal using a device-bound passkey.
- Verified the passkey authentication method and successful Conditional Access evaluation in Microsoft Entra sign-in logs.
- Enabled Self-Service Password Reset for `SG-Auth-Hardening-Pilot`.
- Configured SSPR to require two authentication methods for password reset.

## Design Decisions

### Authentication strength

Day 03 established MFA as the baseline requirement for access to the Expense Portal.

Day 04 introduced a stronger control for selected users by requiring the built-in `Phishing-resistant MFA` authentication strength.

This separates the requirement to perform MFA from the requirement to use an authentication method that is resistant to phishing.

### Passwordless onboarding

A one-hour Temporary Access Pass was issued for Anna as the intended bootstrap credential. The evidence confirms TAP creation and a registered device-bound passkey, but does not show TAP consumption or the registration authentication flow.

[Microsoft supports both existing MFA and TAP for passwordless bootstrap](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass). Anna already had Microsoft Authenticator, so the actual bootstrap method cannot be inferred from the final credential list (guidance checked 2026-09-25).

### Pilot-based deployment

Passkey registration and authentication hardening were introduced through dedicated pilot groups rather than being enabled as a mandatory requirement for all users.

`SG-Passwordless-Pilot` controls the initial passkey rollout, while `SG-Auth-Hardening-Pilot` controls the Conditional Access authentication strength requirement.

This allows stronger authentication controls to be validated before broader deployment.

### Conditional Access separation

The existing CA001 policy from Day 03 remains the general MFA baseline for the Expense Portal.

CA003 adds a stronger authentication requirement for the authentication hardening pilot without duplicating the existing MFA policy.

`SG-Emergency-Access` remains excluded from restrictive Conditional Access policies to preserve emergency tenant access.

### Authentication and authorization

Successful strong authentication does not replace application authorization.

After satisfying CA003 with a passkey, Anna Finance retained access through the existing `Expense.Submitter` application role configured on Day 02.

### Account recovery

Self-Service Password Reset was enabled for the authentication hardening pilot with two authentication methods required for password reset.

This establishes the pilot recovery configuration. The evidence does not include an executed password reset, a sign-in with a newly reset password, or hybrid password writeback.

## Verification

Peter Finance's capture shows an additional-sign-in-methods-required block. The lab record attributes it to Expense Portal/CA003, but no application name, policy result or sign-in detail is visible; that attribution remains partially verified.

Anna Finance successfully accessed the same application using a device-bound passkey.

Microsoft Entra sign-in logs confirmed that the passkey authentication succeeded and that both `CA001-ExpensePortal-Require-MFA` and `CA003-ExpensePortal-Phishing-resistant-MFA-Pilot` returned `Success`.

The Expense Portal also confirmed that Anna retained the existing `Expense.Submitter` application role after completing phishing-resistant authentication.

To complete the missing evidence, capture a TAP sign-in followed by passkey-registration audit events, and Peter's failed sign-in details showing Expense Portal, the CA003 evaluation and authentication methods. Do not publish the TAP value.

Detailed validation results are available in [Day 04 Tests](../tests/day-04.md).

Supporting screenshots are available in [Day 04 Evidence](../evidence/day-04/).
