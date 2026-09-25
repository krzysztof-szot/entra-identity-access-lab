# Day 01 — Evidence

This folder contains evidence from the Day 01 identity foundation lab.

## Evidence

- `01-users.png` — shows the created workforce, administrator and emergency access accounts.
- `02-groups.png` — shows seven Security/Assigned groups used for department, application, Conditional Access and contractor access. The emergency group, group owners and role-assignable status are not shown.
- `03-adm-lab-user-administrator.png` — confirms that `adm-lab` has the active `User Administrator` role.
- `04-permission-denied-role-assignment.png` — shows the Privileged Role Administrator `Add assignments` control disabled while signed in as `adm-lab`; no API denial is captured.
- `05-break-glass-accounts.png` — confirms that both emergency access accounts have permanent active `Global Administrator` assignments.
- `06-audit-log-group-membership.png` — shows a successful re-add of `thomas.it` to `SG-CA-Pilot` by `adm-lab` and an earlier removal row; the removal event's result detail is not expanded.
- `07-audit-log-user-update.png` — shows a user attribute change performed by `adm-lab`, including the modified `JobTitle` value in Audit Logs.
- `08-break-glass-signin-logs.png` — confirms successful interactive Azure Portal sign-ins for both emergency access accounts.

Sensitive identifiers, IP addresses and tenant-specific values were redacted before publication.
