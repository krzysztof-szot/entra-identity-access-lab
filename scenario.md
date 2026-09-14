# Business scenario

**Project:** Microsoft Entra ID — Secure Employee & Contractor Access  
**Company:** Baltic Finance Lab (fictional)  
**Status:** Design specification; deployment evidence is recorded separately.

## Business context

Baltic Finance Lab has Finance, HR, and IT departments. The planned Expense Portal will allow employees to submit reimbursement requests and a designated Finance approver to approve them. External contractors will receive access appropriate to their engagement.

The project will manage access as people join, move between departments, and leave. Administrative access and changes will be documented so that the resulting permissions can be explained and tested.

## Requirements

| ID | Requirement | Planned validation |
|---|---|---|
| BR-01 | Give employees access appropriate to their role. | Compare configured membership and application assignments with the access matrix. |
| BR-02 | Restrict request approval to the designated approver. | Test an employee and an approver against the approval operation. |
| BR-03 | Update access when an employee changes departments. | Remove outdated departmental membership and verify new membership. |
| BR-04 | Remove access during offboarding. | Check blocked new access and document existing session behavior. |
| BR-05 | Limit contractor access to the engagement. | Verify intended assignments and their removal at the end. |
| BR-06 | Control privileged administration. | Test the selected task before, during, and after a PIM activation. |
| BR-07 | Maintain evidence of changes. | Correlate test actions with identity activity logs. |

## Day 1 scope

The planned baseline contains six employees, one delegated administrator, two emergency access accounts, and seven security groups. The pre-existing account used to establish the lab is separate from these nine new accounts.

Day 1 prepares identities, membership, administrative access, and documentation. Application roles, custom Conditional Access policies, lifecycle automation, B2B access, and governance are later implementation phases.

## Design decisions

| Decision | Reason |
|---|---|
| Use a dedicated personal workforce lab tenant. | Keep the experiment and its identities within a controlled environment. |
| Start with cloud-only identities. | Focus the first phase on Entra administration. |
| Start with Assigned security groups. | Make membership changes explicit and easy to validate before automation. |
| Use a separate delegated administrator. | Demonstrate the permissions required for ordinary identity operations. |
| Prepare two emergency accounts. | Establish a recovery design and record any authentication dependencies. |
| Record expected and observed behavior separately. | Show which controls have actually been tested. |

## Related documents

- [Access matrix](access-matrix.md)
- [Day 1 execution record](day-01.md)
- [Day 1 tests](../tests/day-01.md)
