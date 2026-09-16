# Day 03 — Conditional Access and MFA

## Objectives

The goal of Day 03 was to protect the Expense Portal with Microsoft Entra Conditional Access, enforce multifactor authentication and validate risk-based access controls.

## Implemented

- Assigned `Conditional Access Administrator` and `Reports Reader` to `adm-lab`.
- Used `SG-CA-Pilot` for the initial Conditional Access deployment.
- Excluded `SG-Emergency-Access` from restrictive Conditional Access policies.
- Created `CA001-ExpensePortal-Require-MFA`.
- Targeted the Expense Portal as the protected resource.
- Configured the built-in `Multifactor authentication` authentication strength.
- Initially deployed CA001 in `Report-only` mode.
- Validated policy scope with the Conditional Access What If tool.
- Verified the Report-only result in Microsoft Entra sign-in logs.
- Enabled CA001 and successfully completed an MFA-protected Expense Portal sign-in.
- Verified successful Conditional Access and authentication strength enforcement in sign-in logs.
- Created `CA002-ExpensePortal-HighSignInRisk`.
- Configured CA002 to evaluate `Block access` for high-risk sign-ins.
- Validated the high sign-in risk scenario with the What If tool while keeping CA002 in `Report-only` mode.

## Design Decisions

### Staged Conditional Access deployment

CA001 was first deployed to `SG-CA-Pilot` in `Report-only` mode.

The policy was validated with the What If tool and real sign-in events before enforcement was enabled.

### Emergency access exclusion

`SG-Emergency-Access` is excluded from the Conditional Access policies.

This helps preserve emergency administrative access if a Conditional Access configuration causes an unexpected lockout.

### Least privilege

`adm-lab` uses `Conditional Access Administrator` to manage Conditional Access and `Reports Reader` to review sign-in logs.

`Global Administrator` was not assigned for these tasks.

### Risk-based access

A separate policy was created for high sign-in risk.

CA001 requires MFA for normal protected access, while CA002 evaluates blocking access when the sign-in risk is high.

## Verification

CA001 was successfully evaluated in `Report-only` mode with a `User action required` result when the MFA requirement was not yet satisfied.

After enforcement was enabled, Microsoft Authenticator MFA completed successfully and CA001 returned `Success` in the sign-in logs. The Expense Portal remained accessible with the existing `Expense.Submitter` application role.

The What If tool also confirmed that a simulated high-risk sign-in would match both CA001 and the blocking CA002 policy.

Detailed validation results are available in [Day 03 Tests](../tests/day-03.md).

Supporting screenshots are available in [Day 03 Evidence](../evidence/day-03/).
