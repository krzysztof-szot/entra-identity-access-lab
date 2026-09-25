# Day 05 — External Identities and Cross-Tenant Access Tests

Tests validate B2B collaboration between **Amber Audit Partners** and **Baltic Finance Lab**, including Guest onboarding, group-based application access and cross-tenant access controls.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
|---|---|---|---|---|
| D5-01 | B2B invitation and redemption | External user can be invited from Amber Audit Partners and successfully redeem the invitation. | Successful partner-add, invitation and redemption rows are visible; target and initiator details are absent. | Partial evidence |
| D5-02 | Expense Portal access without group membership | External Auditor must not access Expense Portal without an applicable application assignment. | Sign-in was denied with `AADSTS50105` because the user was not a member of an assigned group and had no direct assignment. | Pass |
| D5-03 | Group-based application authorization | Membership in `SG-External-Contractors` should provide the assigned `Expense.Submitter` role. | External Auditor was added as a Guest member of `SG-External-Contractors` and successfully accessed Expense Portal with `Expense.Submitter`. | Pass |
| D5-04 | B2B sign-in logging | Successful access should appear as a Guest B2B collaboration sign-in. | Sign-in Logs showed `External Auditor`, `User type: Guest`, `Cross tenant access type: B2B collaboration` and `Application: Expense Portal`. | Pass |
| D5-05 | Inbound B2B scoping | Baltic Finance should allow inbound B2B access only for the selected Amber user and selected application. | Custom Allow scope shows one masked user and Expense Portal; the user's identity cannot be checked. | Partial evidence |
| D5-06 | Cross-tenant trust and outbound access | MFA trust should be enabled without trusting partner device state, and Amber outbound access should be scoped to the intended user and application. | MFA trust enabled and both device trusts disabled; outbound scope shows External Auditor and one masked application. Runtime MFA-claim acceptance is not shown. | Partial evidence |
| D5-07 | Cross-tenant inbound block | Blocking inbound B2B access should prevent the External Auditor from reaching Expense Portal. | Access was denied with `AADSTS500213`, confirming enforcement of the resource tenant cross-tenant access policy. | Pass |
| D5-08 | Restore intended cross-tenant access | Restoring inbound access should allow the authorized Guest to use Expense Portal again. | After restoring `Allow access`, a new Expense Portal sign-in completed successfully. | Pass |

## D5-01 — B2B invitation and redemption

**Acting identities:** Baltic Finance administrator and `External Auditor`

**Expected**

The external account from Amber Audit Partners can be invited to Baltic Finance and successfully redeem the B2B invitation.

**Observed**

Audit Logs confirmed:

- partner organization configuration;
- `Invite external user` — Success;
- `Redeem external user invite` — Success.

The list does not display the event targets or initiators, so exact correlation to this partner/user is not independently established by the audit screenshot.

**Result:** Partial evidence; successful event types are confirmed.

**Evidence:** `02-b2b-cross-tenant-audit-logs.png`

---

## D5-02 — Access denied without group membership

**Acting identity:** `External Auditor`

**Precondition**

`SG-External-Contractors` was assigned to Expense Portal with the `Expense.Submitter` role, but the External Auditor was not yet a member of the group.

**Expected**

The External Auditor cannot access Expense Portal.

**Observed**

Microsoft Entra ID returned:

`AADSTS50105`

The user was blocked because no direct application assignment or membership in an assigned group was present.

**Result:** Pass

**Evidence:**

- `03-external-contractors-expense-assignment.png`
- `04-guest-denied-without-group.png`

---

## D5-03 — Group-based application access

**Acting identity:** `External Auditor`

**Action**

The Guest account was added to:

`SG-External-Contractors`

The group already had the following Expense Portal assignment:

`Expense.Submitter`

**Expected**

The External Auditor can access Expense Portal and receives only the intended application role.

**Observed**

Authentication completed successfully and Expense Portal showed:

- `External Auditor`;
- permission to submit expense requests;
- `Expense.Submitter` application role.

**Result:** Pass

**Evidence:**

- `05-external-contractors-membership.png`
- `06-guest-expense-portal-success.png`

---

## D5-04 — B2B sign-in verification

**Acting identity:** Baltic Finance administrator reviewing Sign-in Logs

**Expected**

The successful external sign-in is recorded as B2B collaboration.

**Observed**

Sign-in details showed:

- User: `External Auditor`;
- User type: `Guest`;
- Application: `Expense Portal`;
- Status: `Success`;
- Cross tenant access type: `B2B collaboration`.

**Result:** Pass

**Evidence:** `07-cross-tenant-signin.jpg`

---

## D5-05 — Inbound B2B access

**Configuration**

Baltic Finance configured organization-specific inbound access for:

`Amber Audit Partners`

Access was scoped to:

- the selected Amber external user;
- Expense Portal.

**Expected**

Only the intended external identity and application are included in the partner-specific inbound configuration.

**Observed**

Custom inbound B2B collaboration shows Allow access for one selected user and Expense Portal. The user value is masked, preventing exact identity verification. Screenshot 08 shows the earlier inherited-default state; screenshot 09 shows the custom settings.

**Result:** Partial evidence; scope shape and named application confirmed, selected user identity obscured.

**Evidence:**

- `08-cross-tenant-amber-organization.png`
- `09-baltic-inbound-b2b.png`

---

## D5-06 — Trust and outbound access

**Expected**

Baltic Finance should trust the partner's MFA claim without automatically trusting its device state.

Amber Audit Partners should explicitly permit the External Auditor to access the selected Baltic Finance application.

**Observed**

Baltic Finance inbound trust:

- MFA trust — enabled;
- compliant device trust — disabled;
- Microsoft Entra hybrid joined device trust — disabled.

Amber Audit Partners outbound B2B access shows External Auditor and one selected external application. The application value is masked. MFA trust is configuration evidence only; the successful sign-in screenshots show CA Not applied and no partner-MFA acceptance detail.

**Result:** Partial evidence; trust configuration and outbound user confirmed, exact outbound application obscured.

**Evidence:**

- `10-amber-inbound-trust.png`
- `11-amber-outbound-b2b.png`

---

## D5-07 — Cross-tenant inbound block

**Acting identity:** `External Auditor`

**Action**

Baltic Finance inbound B2B access for the selected Amber identity was temporarily changed from:

`Allow access`

to:

`Block access`

**Expected**

The External Auditor cannot access Expense Portal even though the Guest identity, group membership and application assignment still exist.

**Observed**

Access was blocked with:

`AADSTS500213`

The error confirmed that the resource tenant's cross-tenant access policy prevented access.

**Result:** Pass

**Evidence:** `12-cross-tenant-inbound-denied.png`

---

## D5-08 — Access restoration

**Action**

The temporary inbound block was removed and the intended `Allow access` configuration was restored.

**Expected**

The authorized External Auditor can access Expense Portal again.

**Observed**

A new interactive sign-in to Expense Portal completed successfully after restoring the intended cross-tenant access configuration.

**Result:** Pass

**Evidence:** `13-cross-tenant-signin-success.png`

---

## Day 05 final state

- External Auditor remains a `Guest` in Baltic Finance.
- External Auditor is a member of `SG-External-Contractors`.
- `SG-External-Contractors` remains assigned to Expense Portal with `Expense.Submitter`.
- Baltic Finance inbound B2B access is restored to `Allow access`.
- Partner MFA trust remains enabled.
- Partner device trust remains disabled.
- Amber Audit Partners outbound B2B access remains configured for the intended user and application.
- Temporary blocking configuration used during D5-07 was removed.

These statements record the historical lab outcome, subject to the masking limits above. Later governance labs remove the auditor's application access. To close the evidence gaps, retain stable non-sensitive aliases for the selected user/application, capture target/initiator details for the invitation events, verify the saved external-collaboration settings, and capture a guest sign-in with a required MFA policy and authentication details establishing partner MFA-claim acceptance.

## Evidence

[Day 05 evidence](../evidence/day-05/README.md)
