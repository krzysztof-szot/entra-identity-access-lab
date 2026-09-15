# Expense Portal — Identity Architecture

```text
Microsoft Entra ID
│
├── App Registration
│   └── Expense Portal
│       ├── Single tenant
│       └── App Roles
│           ├── Expense.Submitter
│           └── Expense.Approver
│
└── Enterprise Application
    └── Expense Portal
        ├── Assignment required: Yes
        │
        ├── SG-App-Expense-Users
        │   └── Expense.Submitter
        │
        └── SG-App-Expense-Approvers
            └── Expense.Approver

```markdown
## Authentication vs Authorization

Microsoft Entra ID provides authentication.

Application assignment and App Roles provide authorization.

A successful sign-in does not automatically grant business access
to the Expense Portal.
