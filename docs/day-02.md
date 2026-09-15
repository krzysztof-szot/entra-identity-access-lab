# Day 02 — Expense Portal Identity Integration

## Objectives

The goal of Day 02 was to integrate the Expense Portal with
Microsoft Entra ID and implement role-based application access.

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

## Access Model

SG-App-Expense-Users
→ Expense.Submitter

SG-App-Expense-Approvers
→ Expense.Approver

## Design Decisions

### Group-based access

Application access is assigned to security groups instead of directly
to individual users.

This simplifies access management and prepares the environment for
future Joiner-Mover-Leaver automation.

### Application roles

Business permissions are represented by App Roles instead of
hard-coded user identities.

This separates identity management from application authorization.

### Assignment required

`Assignment required` is enabled on the Enterprise Application.

Successful Microsoft Entra authentication alone is therefore not
sufficient to access the application.

## Verification

Successful sign-ins for both Anna Finance and Peter Finance were
verified using Microsoft Entra sign-in logs.
