# Day 02 — Evidence

This folder contains evidence from the Day 02 Expense Portal identity integration lab.

## Evidence

- `01-app-registration.png` — shows the single-tenant App Registration created for the Expense Portal.
- `02-app-roles.png` — shows the configured `Expense.Submitter` and `Expense.Approver` application roles.
- `03-enterprise-application.png` — shows the corresponding Enterprise Application / Service Principal.
- `04-group-assignments.png` — shows group-based application access assignments.
- `05-assignment-required.png` — confirms that `Assignment required` is enabled for the Enterprise Application.
- `05a-app-service-authentication.png` — shows Microsoft Entra authentication configured for the Azure App Service.
- `06-anna-portal-access.png` — confirms successful access for `anna.finance` with the expected application permissions.
- `07-peter-portal-access.png` — confirms successful access for `peter.finance` with the expected application permissions.
- `08-admin-consent.png` — confirms tenant-wide admin consent for Microsoft Graph delegated `User.Read` (the permission's default `Admin consent required` column is `No`).
- `09-anna-and-peter-signin-logs.png` — shows successful sign-in events for both test users in Microsoft Entra sign-in logs.
- `10-unassigned-user-access-denied.png` — confirms that an account without an explicit application assignment is denied access to the Expense Portal with `AADSTS50105`.

Sensitive identifiers and tenant-specific values were redacted before publication.

The portal pages show role values and their permission labels, not executed expense operations. The successful sign-in rows name Expense Portal as the application and Microsoft Graph as the resource.
