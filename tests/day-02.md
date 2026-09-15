# Day 02 — Application Access Tests

## Objective

Validate Microsoft Entra authentication, application assignment,
group-based access and application roles for the Expense Portal.

| CheckResult | Expected Result | Actual Result |
|---|---|---|
| Anna can authenticate to Expense Portal | Pass | Pass |
| Anna receives access through SG-App-Expense-Users | Pass | Pass |
| Anna is assigned Expense.Submitter | Pass | Pass |
| Anna is not assigned Expense.Approver | Pass | Pass |
| Peter can authenticate to Expense Portal | Pass | Pass |
| Peter receives access through SG-App-Expense-Users | Pass | Pass |
| Peter is assigned Expense.Submitter | Pass | Pass |
| Peter is assigned Expense.Approver through SG-App-Expense-Approvers | Pass | Pass |
| Tenant-wide admin consent is granted for required API permissions | Pass | Pass |
| Sign-in events for Anna are visible in Microsoft Entra logs | Pass | Pass |
| Sign-in events for Peter are visible in Microsoft Entra logs | Pass | Pass |
| Unassigned standard user cannot access Expense Portal | Access denied — Pass | Pass |

## Result

All planned Day 02 identity and application access tests completed successfully.
