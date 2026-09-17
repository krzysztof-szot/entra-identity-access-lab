# Day 05 — External Identities and Cross-Tenant Access

## Objectives

- Configure secure B2B collaboration with an external organization.
- Provide an external auditor with least-privilege access to Expense Portal.
- Separate external contractor access from internal employee access.
- Configure organization-specific cross-tenant inbound and outbound access.
- Validate both application assignment controls and cross-tenant access controls.
- Review B2B activity in Audit Logs and Sign-in Logs.

## Implemented

A second Microsoft Entra tenant, **Amber Audit Partners**, was used as the external partner organization.

An `External Auditor` account from Amber Audit Partners was invited to **Baltic Finance Lab** using Microsoft Entra B2B collaboration. The invitation was successfully redeemed and the account is represented in Baltic Finance as a `Guest` user.

Guest collaboration settings in Baltic Finance were hardened by:

- restricting Guest users to properties and memberships of their own directory objects;
- allowing Guest invitations only from users assigned to appropriate administrative roles;
- disabling Guest self-service sign-up.

A dedicated security group was used for external application access:

`SG-External-Contractors`

The group was assigned to **Expense Portal** with the application role:

`Expense.Submitter`

The External Auditor was then added to `SG-External-Contractors`.

This keeps external access separate from the groups used for internal employees while allowing both populations to use the same application authorization model.

Cross-tenant access settings were also configured between:

- **Baltic Finance Lab** — resource tenant;
- **Amber Audit Partners** — home tenant.

Baltic Finance inbound B2B access was restricted to the selected Amber Audit Partners user and the Expense Portal application.

Inbound trust was configured to trust MFA claims from Amber Audit Partners. Trust for compliant devices and Microsoft Entra hybrid joined devices remained disabled.

On the Amber Audit Partners side, outbound B2B access was configured for the External Auditor and the selected Baltic Finance application.

## Design Decisions

External users are managed through a dedicated `SG-External-Contractors` group instead of being added to internal employee groups.

The External Auditor receives only the `Expense.Submitter` application role. No approval permissions are granted.

Application access requires both:

1. an allowed cross-tenant B2B relationship;
2. application authorization through the assigned security group.

Cross-tenant access was scoped to the required user and application instead of allowing unrestricted partner access.

Only MFA claims from the partner tenant are trusted. Device trust was intentionally left disabled because device compliance and hybrid join state are not managed or validated as part of this scenario.

**B2B Direct Connect** was not implemented because the scenario uses a custom enterprise application rather than a Teams shared channel.

**Cross-tenant synchronization** was not implemented because the scenario contains a single external auditor and manual B2B onboarding is sufficient. It remains an architecture option for larger external user populations.

Environment-specific identifiers such as Tenant IDs, Object IDs, Application IDs, session identifiers and IP addresses are redacted from published evidence.

## Verification

Audit Logs confirmed:

- partner organization configuration;
- external user invitation;
- successful invitation redemption.

Before the External Auditor was added to `SG-External-Contractors`, access to Expense Portal was denied with `AADSTS50105`, confirming that Guest status alone does not grant application access.

After group membership was added, the External Auditor successfully authenticated to Expense Portal and received the `Expense.Submitter` application role.

Sign-in Logs confirmed:

- successful authentication;
- `Guest` user type;
- `B2B collaboration` cross-tenant access type;
- access to Expense Portal.

A separate negative test temporarily changed Baltic Finance inbound B2B access to `Block access`.

The External Auditor was then denied access with `AADSTS500213`, confirming that the resource tenant cross-tenant access policy was enforced.

The intended `Allow access` configuration was restored after the test and a successful cross-tenant sign-in was verified again.

## Evidence and Tests

- [Test procedures and results](../tests/day-05.md)
- [Evidence](../evidence/day-05/README.md)
