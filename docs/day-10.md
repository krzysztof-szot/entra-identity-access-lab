# Day 10 — Entitlement Management

## Objectives

The goal was to govern time-limited access for the existing External Auditor from Amber Audit Partners, extending the manual B2B access model introduced in Day 05.

The lab focused on connected organizations, catalogs, resource roles, access packages, scoped request policies, separate business approval, 30-day assignment lifecycle, automated provisioning, Conditional Access Terms of Use and access revocation.

## Implemented

### Existing external identity and baseline

The existing B2B `External Auditor` identity was reused. `SG-External-Contractors` initially had no members in the Day 10 baseline. This avoided treating a pre-existing manual group membership as package-provisioned access.

### Connected organization and catalog

`Amber Audit Partners` was configured as a connected organization with an internal sponsor.

The `BFL-External-Audit` catalog was enabled for internal and external use. Its resources were:

- `SG-External-Contractors` — security group;
- `Expense Portal` — enterprise application.

A connected organization defines an external request scope; it does not itself grant application access.

### Access package and policy

`AP-External-Auditor-30D` bundled:

| Resource | Assigned resource role |
| --- | --- |
| `SG-External-Contractors` | `Member` |
| `Expense Portal` | `Expense Submitter` |

The observed policy name was `POL-Amber-External-Auditors`. It allowed self-service requests by users from the specific connected organization, required requestor justification and used one approval stage with Anna Finance as the designated approver and a three-day decision window. Required business-context questions were included in the request.

Assignment expiration was configured for **30 days**. Users could not choose a different timeline or extend access under this policy. Access Reviews were not included in this day's practical configuration.

### Request, approval and delivery

External Auditor could discover the package in My Access. The portal's screenshot continued to display `Request` after submission, so a `Pending` screen was **not** captured. The separate approval-history evidence confirms that Anna Finance approved the auditor's request and shows the recorded business justification and responses.

The package assignment subsequently appeared as `Delivered`, with a future end date and `User lifecycle: Governed`.

After delivery, the auditor appeared in `SG-External-Contractors` and in Expense Portal's users-and-groups assignment with the `Expense Submitter` role. A successful portal sign-in displayed `Expense.Submitter`.

### Conditional Access and Terms of Use

`CA-External-Auditor-ToU` targeted `SG-External-Contractors` and Expense Portal with the `BFL-External-Auditor-ToU` grant control. The policy was shown as On.

External Auditor encountered the Terms of Use prompt. Expense Portal sign-in logs subsequently showed `CA-External-Auditor-ToU` with result `Success`. This confirms that the grant control was satisfied during sign-in; the screenshot is not a standalone Terms of Use acceptance-report entry.

### Manual revocation

The assignment was manually removed before its configured 30-day end date. The Assignments view then displayed `Expired`, while retaining the original future end date. This is **manual revocation**, not proof that the scheduled 30-day expiration ran.

After removal, `SG-External-Contractors` returned to zero members. A fresh Expense Portal sign-in failed with `AADSTS50105`, stating that the auditor had no direct application assignment or qualifying group membership. The failed sign-in is an application-assignment denial; it should not be conflated with a separate account-locked message seen during troubleshooting.

The external guest's `Governed` state was observed, but the screenshots do not establish deletion of the B2B identity.

## Design Decisions

- Reuse the Day 05 guest and existing Expense Portal rather than creating disconnected demonstration identities or applications.
- Scope self-service access to Amber Audit Partners and require approval by a Baltic Finance identity separate from the requester.
- Put group membership and an App Role into one Access Package to demonstrate governance across two resource types.
- Use a 30-day assignment policy and separately test manual revocation without misrepresenting it as automatic expiration.
- Treat Terms of Use, application authorization and access-package approval as separate controls.
- Reuse `Expense Submitter` from Day 02. It permits submitting expenses and is **not** a production read-only audit role; an actual audit design would require least-privilege authorization.

## Verification

The recorded evidence supports:

- a configured connected organization and external-enabled catalog;
- a package containing the intended group and application resource roles;
- a scoped request policy, required justification and Anna Finance's approval;
- a `Delivered` assignment with a configured 30-day end date;
- group membership, application assignment and successful Expense Portal access;
- presentation of Terms of Use and a successful Conditional Access grant-control evaluation;
- manual assignment removal, group-membership removal and fresh sign-in denial (`AADSTS50105`).

The evidence **does not** independently show a Pending request, a standalone Terms of Use acceptance report or natural expiration after 30 days.

## Evidence and Tests

- [Day 10 test results](../tests/day-10.md)
- [Day 10 evidence](../evidence/day-10/README.md)

Sensitive identifiers and tenant-specific details were redacted from the published screenshots where appropriate.
