# Day 02 — Expense Portal Identity Integration

## Objectives

The goal of Day 02 was to integrate the Expense Portal with Microsoft Entra ID and implement role-based application access.

## Implemented

- Created Azure App Service for Expense Portal.
- Enabled Microsoft Entra authentication.
- Created a single-tenant App Registration.
- Created the corresponding Enterprise Application / Service Principal.
- Configured application access to require explicit assignment.
- Created two application roles:
  - `Expense.Submitter`
  - `Expense.Approver`
- Assigned `SG-App-Expense-Users` to `Expense.Submitter`.
- Assigned `SG-App-Expense-Approvers` to `Expense.Approver`.
- Granted required tenant-wide admin consent.
- Successfully tested authentication with Anna Finance and Peter Finance.
- Verified both sign-ins in Microsoft Entra sign-in logs.
- Confirmed that an unassigned account is denied access to the application.

The detailed application design is documented in the [Expense Portal Application Architecture](application-architecture.md).

## Access Model

`SG-App-Expense-Users` → `Expense.Submitter`

`SG-App-Expense-Approvers` → `Expense.Approver`

The group membership model is documented in the [Access Matrix](access-matrix.md).

## Design Decisions

### Group-based access

Application access is assigned to security groups instead of directly to individual users.

This simplifies access management and prepares the environment for future Joiner / Mover / Leaver automation.

### Application roles

Business permissions are represented by App Roles instead of hard-coded user identities.

This separates identity management from application authorization.

### Assignment required

`Assignment required` is enabled on the Enterprise Application.

Successful Microsoft Entra authentication alone is therefore not sufficient to access the application.

## Verification

Authentication, group-based access, App Roles, assignment requirements, denied access for an unassigned account and sign-in logging were validated successfully.

Detailed test results are available in [Day 02 Tests](../tests/day-02.md).

Supporting screenshots are available in [Day 02 Evidence](../evidence/day-02/).
