# Day 01 — Identity Foundation

## Objectives

The goal of Day 01 was to build the Microsoft Entra ID identity foundation for the Baltic Finance Lab and validate delegated administration, emergency access and auditability.

## Implemented

- Created workforce user accounts and configured basic identity attributes.
- Created department, application, Conditional Access pilot and contractor security groups. The emergency access group is part of the documented design, but is not shown in the Day 01 group inventory; its later CA exclusion is visible in Day 03.
- Separated administrative responsibilities across dedicated admin accounts.
- Assigned `User Administrator` to `adm-lab`.
- Configured two emergency access accounts with permanent active `Global Administrator` assignments.
- Verified that `adm-lab` can manage users and group membership.
- Confirmed that `adm-lab` cannot assign privileged directory roles.
- Verified user and group changes in Microsoft Entra Audit Logs.

The complete identity, role and group structure is documented in the [Access Matrix](access-matrix.md).

## Design Decisions

### Administrative separation

Dedicated administrative accounts are used instead of normal workforce identities.

This separates routine identity administration, application administration, privileged role management and emergency access.

### Least privilege

`adm-lab` uses the `User Administrator` role rather than `Global Administrator` for day-to-day identity administration.

A permission-boundary test confirmed that privileged directory role assignment remains unavailable to this account.

### Emergency access

Two dedicated break-glass accounts provide tenant recovery access and are kept separate from standard administrative identities.

## Verification

Audit Logs show a successful user attribute update and successful re-add of `thomas.it` to `SG-CA-Pilot`. The preceding removal row is visible, but its result detail is not expanded.

Both emergency access accounts also completed successful interactive Azure Portal sign-ins.

Anna's fresh-sign-in check was reported as successful, but no Day 01 evidence was published for that check. The role-assignment boundary is demonstrated by a disabled portal control, not an attempted Microsoft Graph operation.

Detailed validation results are available in [Day 01 Tests](../tests/day-01.md), with supporting screenshots in [Day 01 Evidence](../evidence/day-01/).
