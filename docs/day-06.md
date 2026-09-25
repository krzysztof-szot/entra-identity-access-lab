# Day 06 — Identity Lifecycle and Administrative Units

## Objectives

The goal of Day 06 was to implement and validate identity lifecycle scenarios for Joiner, Mover, and Leaver users and to introduce scoped administration with Microsoft Entra Administrative Units.

The lab focused on:

- group-based application access,
- Joiner provisioning,
- Mover access changes,
- Leaver deprovisioning,
- Administrative Units,
- scoped Microsoft Entra role assignments,
- positive and negative authorization testing.

## Implemented

### Group-based application access

`SG-Finance-Users` was assigned to the Expense Portal with the `Expense.Submitter` application role.

This created the following access model:

`Finance user → SG-Finance-Users → Expense Portal → Expense.Submitter`

Application access is therefore controlled through group membership instead of direct user assignment.

### Joiner

A new employee account, `Marc Joiner`, was provisioned for the Finance department.

The user was:

- created as an internal Member account,
- assigned to Finance,
- added to `SG-Finance-Users`,
- reported as included in the Finance administrative scope (direct user membership is not shown in the published AU capture),
- granted Expense Portal access through group membership.

The captured authenticated portal session shows the Joiner's `Expense.Submitter` application role. No sign-in timestamp is published to independently confirm session freshness.

### Mover

`Jan Mover` was used to simulate an internal department transfer:

`Finance → IT`

The old Finance access was removed and the user was assigned to `SG-IT-Users`.

After the change:

- Department was set to IT,
- Finance group membership was removed,
- IT group membership was added,
- Finance application access was removed.

A new Expense Portal sign-in attempt was denied with `AADSTS50105`, confirming that the previous Finance entitlement was no longer effective.

### Leaver

`Alexandra Leaver` was used to simulate employee offboarding.

The final deprovisioned state included:

- account disabled,
- Finance group membership removed,
- application assignments removed,
- administrative role assignments removed.

A fresh authentication attempt was blocked after the account was disabled.

The account overview still shows one assigned license. Session revocation and termination of existing application sessions are not demonstrated; this lab verifies disabled state and a blocked sign-in attempt, not complete production offboarding. The sign-in capture says the account is locked and lacks an error code/log to establish disablement as the precise cause.

### Administrative Unit

`AU-Finance` was created to provide a limited administrative scope for Finance identities.

`SG-Finance-Users` was added to the Administrative Unit. Finance users were reported as placed within the scope, but the published membership screenshot shows only the group.

Adding a group to an AU scopes management of that group; it does not scope management of the group's individual users. Those users must be AU members separately. See [Microsoft's Administrative Unit scope rules](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/administrative-units) (checked 2026-09-25). A direct user-membership capture is therefore still required for Marc.

A dedicated administrator account, `adm-finance`, received:

`User Administrator`

with the assignment scoped to:

`AU-Finance`

The shown assignment is scoped to `AU-Finance`. A complete inventory of the administrator's other active/eligible roles is not published, so the capture does not establish that this is the account's only source of administrative permission.

## Design Decisions

### Group-based application assignment

Expense Portal access is granted through `SG-Finance-Users` instead of assigning individual users directly to the application.

This makes access removal during lifecycle changes easier to manage and keeps authorization tied to business group membership.

### Lifecycle events must change access

Changing a user attribute such as `Department` does not by itself remove existing group memberships or application access.

For the Mover scenario, the old Finance entitlement was explicitly removed and replaced with the appropriate IT membership.

For the Leaver scenario, disabling the account was combined with removal of existing access assignments.

### Administrative scope is separate from application access

Administrative Units were used to limit administrative permissions, while Security groups were used to control application access.

These mechanisms have different purposes:

- Security group membership controls entitlement to the Expense Portal.
- Administrative Unit membership defines the scope in which a delegated administrator can operate.

### Scoped administration instead of tenant-wide administration

The documented Finance administrator assignment grants `User Administrator` at `AU-Finance` scope.

This follows the least-privilege principle and avoids granting unnecessary tenant-wide administrative permissions.

## Verification

The following scenarios were validated:

- `Marc Joiner` received Expense Portal access through `SG-Finance-Users`.
- `Jan Mover` lost Expense Portal access after moving from Finance to IT.
- `Alexandra Leaver` could no longer authenticate after offboarding.
- The `adm-finance` session showed enabled edit controls and Marc's Job title; a successful update by that administrator is reported but no update audit event is published.
- The `adm-finance` session showed disabled Edit properties/Delete controls for the HR control user. Other operations, including the visible Reset password control, were not tested in the published evidence.

The evidence supports application access/denial, disabled-account state and the visible portal control boundary. To complete AU runtime verification, capture Marc's direct AU membership and the administrator's effective roles, then make and restore a harmless Job title change as `adm-finance` with successful Audit Logs. Attempt the same harmless edit on the out-of-scope HR control user and retain the denial. Do not use deletion as the negative test.

## Evidence and Tests

- [Day 06 test results](../tests/day-06.md)
- [Day 06 evidence](../evidence/day-06/README.md)

Environment-specific identifiers and other unnecessary tenant information were redacted from published screenshots.
