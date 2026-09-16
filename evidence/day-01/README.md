# Day 01 — Evidence

This folder contains evidence from the Day 01 identity foundation lab.

## Evidence

- `01-users.png` — shows the created workforce, administrator and emergency access accounts.
- `02-groups.png` — shows the security groups used for department, application and Conditional Access assignments.
- `03-adm-lab-user-administrator.png` — confirms that `adm-lab` has the active `User Administrator` role.
- `04-permission-denied-role-assignment.png` — demonstrates the least-privilege boundary: `adm-lab` cannot assign privileged directory roles.
- `05-break-glass-accounts.png` — confirms that both emergency access accounts have permanent active `Global Administrator` assignments.
- `06-audit-log-group-membership.png` — shows an `SG-CA-Pilot` membership change performed by `adm-lab` and recorded in Microsoft Entra Audit Logs.
- `07-audit-log-user-update.png` — shows a user attribute change performed by `adm-lab`, including the modified `JobTitle` value in Audit Logs.
- `08-break-glass-signin-logs.png` — confirms successful interactive Azure Portal sign-ins for both emergency access accounts.

Sensitive identifiers, IP addresses and tenant-specific values were redacted before publication.
