# Expense Portal — Application Architecture

```mermaid
flowchart LR
    A[Microsoft Entra ID]

    A --> B[App Registration<br/>Expense Portal]
    A --> C[Enterprise Application<br/>Expense Portal]

    B --> D[Single tenant]
    B --> E[App Roles]

    E --> F[Expense.Submitter]
    E --> G[Expense.Approver]

    C --> H[Assignment required: Yes]

    H --> I[SG-App-Expense-Users]
    H --> J[SG-App-Expense-Approvers]

    I --> K[Expense.Submitter]
    J --> L[Expense.Approver]
```

The Expense Portal uses Microsoft Entra ID for authentication and role-based access control.

Application permissions are assigned through security groups rather than directly to individual users.

* `SG-App-Expense-Users` is assigned the `Expense.Submitter` app role.
* `SG-App-Expense-Approvers` is assigned the `Expense.Approver` app role.

This design keeps user access management separate from the application configuration and makes role assignments easier to maintain.
