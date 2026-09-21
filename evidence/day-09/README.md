# Day 09 — Evidence

This folder contains evidence of Just-in-Time privileged access for the Conditional Access Administrator role using Microsoft Entra Privileged Identity Management (PIM).

## Evidence

- `01-conditional-access-admin-pim-settings.png` — shows the role activation settings: one-hour maximum duration, Azure MFA, justification and approval by a designated approver.
- `02-adm-lab-eligible-conditional-access-admin.png` — confirms that `adm-lab` has a permanent Eligible assignment for Conditional Access Administrator.
- `03-adm-lab-my-roles-eligible.png` — shows the role available for activation in `adm-lab`'s My roles view.
- `04-before-pim-activation-no-admin-access.png` — shows the access-denied result when `adm-lab` opens Conditional Access Policies before activating the role.
- `05-pim-activation-request.png` — shows the one-hour activation request with a business justification.
- `06-pim-request-pending-approval.png` — confirms that the activation request is pending approval.
- `07-bg01-pim-approval.png` — shows the request in the separate `pim-approver` account's approval view (the filename is retained; `bg01` was not the approver).
- `08-conditional-access-admin-active.png` — confirms the temporary Activated state and scheduled end time.
- `09-privileged-action-ca-policy-created.png` — shows the `CA009-PIM-Validation` Conditional Access policy in the Off state after the PIM activation.
- `10-pim-resource-audit-activation.png` — records the request, approval request, approval and completed PIM activation.
- `11-pim-automatic-expiration.png` — shows the role back in Eligible assignments with Activate available after the activation window.
- `12-pim-audit-automatic-expiration.png` — records `Remove member from role (PIM activation expired)`, confirming automatic expiration.

Sensitive credentials, identifiers and tenant-specific values were redacted before publication.
