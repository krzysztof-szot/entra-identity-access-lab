# Day 03 — Evidence

This folder contains evidence for the Day 03 Conditional Access and MFA implementation and validation.

## 01 — Conditional Access administrative roles

![Active User Administrator, Conditional Access Administrator and Reports Reader roles for adm-lab](01-adm-lab-ca-admin-role.png)

**Shows:** `adm-lab` with active, permanent assignments for User Administrator, Conditional Access Administrator and Reports Reader.

**Why it matters:** Documents the administrative permissions used to configure policies and inspect logs at this stage of the lab.

## 02 — CA001 report-only configuration

![CA001 pilot scope, emergency exclusion and MFA strength in Report-only mode](02-ca001-report-only.png)

**Shows:** `CA001-ExpensePortal-Pilot-Require-MFA` targeting `SG-CA-Pilot` and Expense Portal, excluding `SG-Emergency-Access`, with an MFA authentication-strength grant and Report-only state.

**Why it matters:** Documents the pilot configuration before enforcement. This initial policy name includes `-Pilot-`; later captures use the shorter CA001 name.

## 03 — CA001 What If evaluation

![What If evaluation matching Anna Finance and Expense Portal to CA001](03-whatif-anna-ca001-applies.png)

**Shows:** Anna Finance, Expense Portal and Windows/Browser selected in What If, with CA001 matching in Report-only mode and requiring Multifactor authentication strength.

**Why it matters:** Checks policy applicability for the specified scenario. A What If result is a simulation rather than a completed sign-in.

## 04 — Report-only sign-in evaluation

![Anna's sign-in records with CA001 Report-only User action required](04-ca001-report-only-signin-log.png)

**Shows:** Anna's Expense Portal sign-in sequence and CA001 returning `Report-only: User action required`; a subsequent event with the same correlation ID shows Success.

**Why it matters:** Demonstrates evaluation against a real sign-in while the policy remains non-enforcing. The overall Conditional Access column remains `Not applied`.

## 05 — Authenticator challenge

![Microsoft Authenticator number-matching prompt for Anna Finance](05-anna-mfa-challenge.png)

**Shows:** Anna Finance receiving a Microsoft Authenticator sign-in approval prompt with a number-matching challenge.

**Why it matters:** Captures the interactive MFA step in the documented scenario. The prompt alone does not identify the application, policy or final sign-in result.

## 06 — Expense Portal access after authentication

![Anna Finance authenticated to Expense Portal with Expense.Submitter displayed](06-anna-expense-portal-after-mfa.png)

**Shows:** Anna's authenticated Expense Portal session displaying the `Expense.Submitter` role.

**Why it matters:** Shows application access in the MFA test sequence. The authentication method and policy evaluation are established by the separate sign-in evidence.

## 07 — Successful MFA and CA001 evaluation

![Successful authentication steps and CA001 evaluation within an Interrupted sign-in event](07-ca001-enforced-success.png)

**Shows:** Successful password and mobile-app-notification steps for Anna and `CA001-ExpensePortal-Require-MFA: Success`; Basic info marks the overall event `Interrupted` for the keep-me-signed-in prompt.

**Why it matters:** Demonstrates successful MFA and policy evaluation while distinguishing those results from the overall sign-in event status.

## 08 — High-risk What If scenario

![High sign-in risk simulation matching CA001 and report-only CA002 Block access](08-whatif-high-signin-risk.png)

**Shows:** A High sign-in risk simulation for Anna and Expense Portal matching CA001 On and CA002 `Block access` in Report-only mode.

**Why it matters:** Validates the simulated policy combination. It does not demonstrate a real risky sign-in or an enforced CA002 block.

Sensitive environment-specific values were redacted before publication.
