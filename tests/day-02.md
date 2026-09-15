# Day 02 — Application Identity and Access Tests

## Objective

Validate Microsoft Entra authentication, group-based application access, App Roles, assignment requirements and sign-in logging for the Expense Portal.

| Check | Expected Result | Actual Result | Evidence |
|---|---|---|---|
| Expense Portal has a single-tenant App Registration | App Registration exists and is configured for the tenant | Pass | [01-app-registration.png](../evidence/day-02/01-app-registration.png) |
| Expense Portal defines `Expense.Submitter` and `Expense.Approver` App Roles | Both application roles are configured | Pass | [02-app-roles.png](../evidence/day-02/02-app-roles.png) |
| Enterprise Application / Service Principal exists | Corresponding Enterprise Application is present | Pass | [03-enterprise-application.png](../evidence/day-02/03-enterprise-application.png) |
| Application access is assigned through security groups | Required groups are assigned to the application | Pass | [04-group-assignments.png](../evidence/day-02/04-group-assignments.png) |
| `Assignment required` is enabled | Only explicitly assigned users or groups can access the application | Pass | [05-assignment-required.png](../evidence/day-02/05-assignment-required.png) |
| Microsoft Entra authentication protects the Azure App Service | Authentication is enabled and configured for Expense Portal | Pass | [05a-app-service-authentication.png](../evidence/day-02/05a-app-service-authentication.png) |
| `anna.finance` can authenticate to Expense Portal | Authentication succeeds | Pass | [06-anna-portal-access.png](../evidence/day-02/06-anna-portal-access.png) |
| `anna.finance` receives `Expense.Submitter` | Submitter permission is present and Approver permission is absent | Pass | [06-anna-portal-access.png](../evidence/day-02/06-anna-portal-access.png) |
| `peter.finance` can authenticate to Expense Portal | Authentication succeeds | Pass | [07-peter-portal-access.png](../evidence/day-02/07-peter-portal-access.png) |
| `peter.finance` receives `Expense.Submitter` and `Expense.Approver` | Both expected application permissions are present | Pass | [07-peter-portal-access.png](../evidence/day-02/07-peter-portal-access.png) |
| Tenant-wide admin consent is granted | Required API permissions have admin consent | Pass | [08-admin-consent.png](../evidence/day-02/08-admin-consent.png) |
| Sign-ins for Anna and Peter are recorded | Successful authentication events are visible in Microsoft Entra sign-in logs | Pass | [09-anna-and-peter-signin-logs.png](../evidence/day-02/09-anna-and-peter-signin-logs.png) |
| Unassigned standard user cannot access Expense Portal | Access is denied because explicit assignment is required | Pass | — |

## Result

All planned Day 02 application identity and access tests completed successfully.

The tests confirmed that authentication, application assignment, App Roles and access restrictions behave as designed.
