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
- included in the Finance administrative scope,
- granted Expense Portal access through group membership.

A fresh sign-in confirmed that the Joiner received the `Expense.Submitter` application role.

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

### Administrative Unit

`AU-Finance` was created to provide a limited administrative scope for Finance identities.

`SG-Finance-Users` was added to the Administrative Unit and Finance users required for delegated administration were placed within the Finance scope.

A dedicated administrator account, `adm-finance`, received:

`User Administrator`

with the assignment scoped to:

`AU-Finance`

The role was not assigned tenant-wide.

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

The Finance administrator received `User Administrator` only for `AU-Finance`.

This follows the least-privilege principle and avoids granting unnecessary tenant-wide administrative permissions.

## Verification

The following scenarios were validated:

- `Marc Joiner` received Expense Portal access through `SG-Finance-Users`.
- `Jan Mover` lost Expense Portal access after moving from Finance to IT.
- `Alexandra Leaver` could no longer authenticate after offboarding.
- `adm-finance` could manage a Finance user within `AU-Finance`.
- `adm-finance` could not manage the HR control user outside `AU-Finance`.

The positive and negative tests confirmed both the intended lifecycle behavior and the Administrative Unit permission boundary.

## Evidence and Tests

- [Day 06 test results](../tests/day-06.md)
- [Day 06 evidence](../evidence/day-06/README.md)

Environment-specific identifiers and other unnecessary tenant information were redacted from published screenshots.
