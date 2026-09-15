# Day 01 — Identity Foundation and Administrative Separation

## Objective

Build the identity foundation for the Baltic Finance Lab and validate delegated administration, least-privilege boundaries, emergency access and auditability in Microsoft Entra ID.

## Implemented

### Workforce identities

Six Microsoft Entra `Member` users were created to represent the core workforce:

- `anna.finance`
- `peter.finance`
- `eva.hr`
- `thomas.it`
- `jan.mover`
- `alexandra.leaver`

Department, manager and usage-location attributes were configured to support future group-based access and Joiner / Mover / Leaver scenarios.

### Administrative separation

Dedicated administrative identities are used instead of normal workforce accounts:

- `adm-lab` — `User Administrator`
- `appops-lab` — `Cloud Application Administrator`
- `roleops-lab` — `Privileged Role Administrator`
- `bg01` — permanent active `Global Administrator`
- `bg02` — permanent active `Global Administrator`
- Tenant bootstrap account — `Global Administrator`

This separates day-to-day identity administration, application administration, privileged role management and emergency access.

### Security groups

Eight assigned security groups define department membership, application access, Conditional Access pilot scope and emergency-access grouping:

- `SG-Dept-Finance`
- `SG-Dept-HR`
- `SG-Dept-IT`
- `SG-App-Expense-Users`
- `SG-App-Expense-Approvers`
- `SG-CA-Pilot`
- `SG-Emergency-Access`
- `SG-External-Contractors`

The complete identity and group model is documented in the [Access Matrix](access-matrix.md).

## Design Decisions

### Least-privilege administration

`adm-lab` uses the `User Administrator` role rather than `Global Administrator` for routine identity management.

A permission-boundary test confirmed that this account can manage users and group membership but cannot assign privileged Microsoft Entra directory roles.

### Dedicated emergency access

Two separate emergency access accounts, `bg01` and `bg02`, have permanent active `Global Administrator` assignments.

These accounts are reserved for recovery scenarios and are separated from standard workforce and delegated administrator identities.

### Group-based access model

Users are placed into security groups according to department, application access or policy scope instead of relying on direct per-user assignments wherever possible.

This prepares the environment for later Conditional Access, application authorization, B2B and Joiner / Mover / Leaver automation.

### Auditability

Administrative changes were verified in Microsoft Entra Audit Logs.

The lab confirmed that group-membership changes and user-attribute changes can be traced back to the initiating administrator, target identity and successful result.

## Validation

The following controls were tested successfully:

- `adm-lab` has an active `User Administrator` assignment.
- `adm-lab` can modify and restore an employee `JobTitle`.
- `adm-lab` can remove and re-add `thomas.it` in `SG-CA-Pilot`.
- `adm-lab` cannot assign privileged directory roles.
- `anna.finance` can complete a fresh sign-in.
- `bg01` and `bg02` can each complete an administrative sign-in.
- User and group administrative changes are recorded in Microsoft Entra Audit Logs.

Detailed test results are available in [Day 01 Tests](../tests/day-01.md).

Supporting screenshots are available in [Day 01 Evidence](../evidence/day-01/).

## Result

Day 01 established a documented Microsoft Entra identity foundation with workforce identities, separated administrative accounts, security groups, emergency access accounts, least-privilege validation and auditable administrative activity.

This foundation is used by the later application access, Conditional Access, governance and automation phases of the project.
