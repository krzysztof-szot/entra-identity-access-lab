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
