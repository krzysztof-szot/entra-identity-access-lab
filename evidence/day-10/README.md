# Day 10 — Evidence

This folder documents Microsoft Entra Entitlement Management for the existing External Auditor from Amber Audit Partners: access request, business approval, automated group and application provisioning, Terms of Use, and access revocation.

## 01 — Empty contractor group baseline

![Empty contractor group baseline](01-auditor-baseline-no-access.png)

**Shows:** `SG-External-Contractors` has zero direct members before the access-package workflow.

**Why it matters:** Establishes the group-membership baseline without asserting that every other possible application assignment is absent.

## 02 — Connected partner organization

![Connected partner organization](02-connected-organization-amber.png)

**Shows:** `Amber Audit Partners` appears as a configured connected organization with one internal sponsor.

**Why it matters:** Identifies the partner organization used to scope external package requests; this configuration does not itself grant application access.

## 03 — External-enabled catalog

![External-enabled catalog](03-external-audit-catalog.png)

**Shows:** `BFL-External-Audit` is enabled and available to external users; its initial resource and package counts are zero.

**Why it matters:** Records the catalog baseline before resources and access packages are added.

## 04 — Selected catalog resources

![Selected catalog resources](04-catalog-resources.png)

**Shows:** The Add resources view selects a security group and `Expense Portal` for the catalog.

**Why it matters:** Shows the group and application resource types being brought under package management; screenshot 05 displays their full resource-role mapping.

## 05 — Access-package resource roles

![Access-package resource roles](05-access-package-resource-roles..png)

**Shows:** The review page for `AP-External-Auditor-30D` lists `SG-External-Contractors` with role `Member` and Expense Portal with role `Expense Submitter`.

**Why it matters:** Makes the bundled entitlements explicit. The existing Submitter role is a lab demonstration role, not read-only auditor access.

## 06 — Scoped request and approval policy

![Scoped request and approval policy](06-assignment-policy-approval.png)

**Shows:** The policy selects Amber Audit Partners, self-service requests, required justification and one approval stage with Anna Finance and a three-day decision window.

**Why it matters:** Documents partner scope and independent business approval before access delivery.

## 07 — Thirty-day lifecycle settings

![Thirty-day lifecycle settings](07-access-package-lifecycle-30d.png)

**Shows:** Assignments expire after 30 days; user-selected timelines, extensions and access reviews are disabled.

**Why it matters:** Records the configured lifecycle. It does not show that a 30-day assignment expired naturally.

## 08 — Package available in My Access

![Package available in My Access](08-auditor-access-package-available.png)

**Shows:** External Auditor sees `AP-External-Auditor-30D` with a `Request` action.

**Why it matters:** Shows package discovery. The portal continued displaying Request after the documented submission; this capture does not show a Pending request.

## 09 — Business approval recorded

![Business approval recorded](09-auditor-request-approved.png)

**Shows:** Approval history identifies Anna Finance's `Approved` decision, External Auditor, the requested package, business justification, answers and resource roles.

**Why it matters:** Connects the delivered access to a recorded request and a separate business approver.

## 10 — Delivered package assignment

![Delivered package assignment](10-access-package-assignment.png)

**Shows:** External Auditor's assignment is `Delivered` under `POL-Amber-External-Auditors`, with a future end date and `Governed` lifecycle state.

**Why it matters:** Records successful package delivery and a time-limited assignment; `Governed` is not evidence of guest deletion.

## 11 — Provisioned contractor membership

![Provisioned contractor membership](11-auditor-group-membership.png)

**Shows:** External Auditor appears as a direct Guest member of `SG-External-Contractors`.

**Why it matters:** Shows the group resource role present after the documented package delivery.

## 12 — Provisioned application role

![Provisioned application role](12-auditor-expense-portal-assignment.png)

**Shows:** Expense Portal's Users and groups view lists External Auditor with `Expense Submitter`.

**Why it matters:** Shows the application resource role alongside the separate group entitlement.

## 13 — Auditor's successful portal session

![Auditor's successful portal session](13-auditor-expense-portal-access.png)

**Shows:** Expense Portal displays External Auditor, successful authentication and `Expense.Submitter`.

**Why it matters:** Demonstrates the application-access outcome after the group and application roles were delivered.

## 14 — Terms of Use policy scope

![Terms of Use policy scope](14-conditional-access-terms-of-use.png)

**Shows:** `CA-External-Auditor-ToU` targets `SG-External-Contractors` and Expense Portal, selects `BFL-External-Auditor-ToU` and is set to On.

**Why it matters:** Connects the Terms of Use grant control to the intended group and application.

## 15 — Terms of Use prompt

![Terms of Use prompt](15-auditor-terms-of-use.png)

**Shows:** External Auditor receives the Baltic Finance Terms of Use prompt with Accept and Decline controls.

**Why it matters:** Records presentation of the terms; the screenshot precedes acceptance and is not an acceptance-report entry.

## 16 — Terms of Use grant satisfied

![Terms of Use grant satisfied](16-terms-of-use-ca-success.png)

**Shows:** An Expense Portal sign-in succeeds and `CA-External-Auditor-ToU` returns `Success`.

**Why it matters:** Corroborates satisfaction of the grant control during sign-in, without replacing a separate Terms of Use acceptance report.

## 17 — Assignment state after manual removal

![Assignment state after manual removal](17-access-package-assignment-removed.png)

**Shows:** The auditor's assignment displays `Expired`, retaining its original future end date and `Governed` lifecycle state.

**Why it matters:** Records the state following the documented manual-removal test. It does not demonstrate natural expiration after 30 days.

## 18 — Contractor membership removed

![Contractor membership removed](18-auditor-group-membership-removed.png)

**Shows:** `SG-External-Contractors` returns to zero direct members.

**Why it matters:** Shows the group entitlement withdrawn after the package assignment was removed.

## 19 — Application access denied after revocation

![Application access denied after revocation](19-auditor-expense-portal-denied.png)

**Shows:** Expense Portal rejects External Auditor with `AADSTS50105`, citing no qualifying direct assignment or group membership.

**Why it matters:** Records an application-assignment denial after entitlement removal; it does not prove the guest account was deleted.

The evidence uses the lab's existing `Expense Submitter` role; this is a demonstration role, **not** read-only auditor access. Sensitive identifiers and tenant-specific details were redacted where appropriate.
