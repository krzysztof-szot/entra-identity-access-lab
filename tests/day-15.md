# Day 15 — Global Secure Access and Defender for Cloud Apps Tests

Tests cover pilot scope, Microsoft traffic forwarding, Private Access to a TCP web resource, Internet Access web filtering, cloud app and OAuth permission analysis, and Conditional Access App Control session enforcement. Cloud Discovery was deferred and is **not** counted as a passed test.

## Results

| Test ID | Test | Expected result | Actual result | Outcome |
| --- | --- | --- | --- | --- |
| D15-01 | GSA pilot scope | Anna belongs to the dedicated pilot group | `SG-GSA-Pilot` shows Anna as its only direct member | Pass |
| D15-02 | Forwarding profiles | Microsoft, Private and Internet profiles are enabled | All three enabled in final Traffic forwarding view | Pass |
| D15-03 | Microsoft traffic assignment | Pilot group is assigned to the relevant traffic-forwarding app | `SG-GSA-Pilot` assigned with Default Access | Pass |
| D15-04 | GSA Client | Anna's Entra-joined device connects to required channels | Entra, M365, Private and Internet Connected | Pass |
| D15-05 | Microsoft traffic verification | Allowed Microsoft/Entra traffic is recorded centrally | Anna's Microsoft 365 and Entra Allow connections visible | Pass |
| D15-06 | Private Access configuration | A specific internal resource and connector group are configured | `BFL-Internal-Finance`, `10.20.0.4:80/TCP`, segment Success | Pass |
| D15-07 | Private app reachability | Finance test app opens by its internal IP | Internal Finance Application displayed at `10.20.0.4` | Pass |
| D15-08 | Private tunnel verification | Client identifies resource connections as Private Access tunnels | Edge to `10.20.0.4:80`; Channel Private Access; Tunnel | Pass |
| D15-09 | Private central monitoring | Central logs record Anna's permitted Private traffic | Private transactions with Allow visible | Pass |
| D15-10 | Web filtering configuration | Domain rule, security profile and scoped CA are present | `GSA-Block-Risky-Web` → `SP-GSA-Web` → `CA-GSA-Web-Filtering` shown | Pass (captured configuration) |
| D15-11 | Internet traffic blocking | `example.org` is blocked while unrelated destinations can be allowed | `example.org` Block; other destinations Allow | Pass (earlier observed block; post-edit retest not shown) |
| D15-12 | Cloud App Catalog review | Security information for a SaaS app is available for analysis | Dropbox security factors and score displayed | Pass (analysis) |
| D15-13 | Existing OAuth grant review | The existing app's granted Graph scope and consent type are identifiable | Expense Portal: delegated `User.Read` through admin consent | Pass (review; no Defender OAuth policy) |
| D15-14 | CA App Control scope | Pilot group and SharePoint are subject to custom app control | `CA-MDCA-Session-Control` On, correct group/app/session control | Pass |
| D15-15 | MDCA Session Policy | Matching test file downloads are set to Block | `MDCA-Block-Download`; matching filename; Inspection None; Block | Pass |
| D15-16 | SharePoint download negative test | Matching document cannot be downloaded | Defender “Download blocked” for `BFL-Test-Download.docx` | Pass |

## D15-01–D15-05 — Pilot, client and Microsoft traffic

**Acting identities:** `adm-lab` (configuration/monitoring), `anna.finance` (client and traffic).  
**Expected:** the pilot is scoped; forwarding is enabled; the client connects; real Microsoft-related traffic is logged.  
**Observed:** Anna is the only direct member of `SG-GSA-Pilot`; the final view shows three enabled profiles; the group has Default Access assignment; the Entra-joined client reports four Connected channels; central logs show Microsoft 365 and Entra Allow records for Anna.  
**Result:** Pass.  
**Evidence:**

- [01 — Pilot group](../evidence/day-15/01-gsa-pilot-group.png)
- [02 — Final forwarding state](../evidence/day-15/02-gsa-traffic-forwarding-final-state.png)
- [03 — Pilot assignment](../evidence/day-15/03-microsoft-traffic-pilot-assignment.png)
- [04 — Connected client](../evidence/day-15/04-gsa-client-connected.png)
- [05 — Microsoft traffic logs](../evidence/day-15/05-gsa-microsoft-traffic-verification.png)

**Evidence boundary:** final profile state is presented in logical order. Assignment and client status alone are not proof of forwarded traffic; screenshot 05 shows actual log records.

## D15-06–D15-09 — Private Access

**Acting identities:** `adm-lab` (configuration/logs), `anna.finance` (resource access and client diagnostics).  
**Expected:** only the intended internal application segment is configured; Anna accesses it through Private Access; matching client and central traffic is recorded.  
**Observed:** `BFL-Internal-Finance` uses `CG-BFL-PrivateAccess - Europe` with a successful TCP segment to `10.20.0.4:80`. The `BFL-CON01` test page opened at that address. GSA diagnostics showed Edge traffic to the same IP/port with Private Access / Tunnel; central transactions recorded Private / Allow for Anna.  
**Result:** Pass.  
**Evidence:**

- [06 — Private Access configuration](../evidence/day-15/06-private-access-app-configuration.png)
- [07 — Internal application by IP](../evidence/day-15/07-private-app-access-by-ip.png)
- [08 — Client tunnel diagnostics](../evidence/day-15/08-private-access-client-traffic.png)
- [09 — Central Private traffic logs](../evidence/day-15/09-private-access-central-traffic-logs.png)

**Evidence boundary:** the web page alone does not prove the route; client and central logs corroborate it. No connector redundancy, production-grade HA or backend user SSO is tested.

## D15-10–D15-11 — Internet Access Web Content Filtering

**Acting identities:** `adm-lab` (policy/configuration and logs), `anna.finance` (web test).  
**Expected:** a domain-matched Block policy is scoped to the pilot through GSA security profile and Conditional Access; test-domain requests are blocked without blocking all internet traffic.  
**Observed:** `Block-Test-Domain` matches `example.org` and `www.example.org` in `GSA-Block-Risky-Web`; enabled `SP-GSA-Web` has Block action and is selected in `CA-GSA-Web-Filtering` for the pilot and GSA Internet resources. Traffic logs show `example.org` Block and other sites Allow.  
**Result:** D15-10 Pass; D15-11 Pass for the observed block, with chronology limitation.  
**Evidence:**

- [10 — Web filtering policy, profile and CA](../evidence/day-15/10-internet-access-block-policy.png)
- [11 — Blocked and allowed Internet transactions](../evidence/day-15/11-internet-access-blocked-traffic.png)

**Evidence boundary:** the Block transactions shown precede the security profile's last-modified time in screenshot 10. The captured final configuration is not independently re-tested in the provided log screenshot.

## D15-12–D15-13 — Cloud app and OAuth review

**Acting identity:** `adm-lab`.  
**Expected:** inspect a catalog app's security information and identify existing Microsoft Graph consent without increasing app privileges.  
**Observed:** Defender Cloud App Catalog showed Dropbox security factors and score; Expense Portal's Entra Permissions view showed Microsoft Graph delegated `User.Read` through admin consent.  
**Result:** Pass (analysis and review, not new enforcement).  
**Evidence:**

- [12 — Cloud App Catalog](../evidence/day-15/12-cloud-app-catalog-risk-analysis.png)
- [13 — OAuth permissions](../evidence/day-15/13-oauth-app-permissions-review.png)

**Evidence boundary:** the catalog result is not Cloud Discovery telemetry; the Entra permission page is not an OAuth App Policy or App governance result.

## D15-14–D15-16 — Conditional Access App Control

**Acting identities:** `adm-lab` (Conditional Access/MDCA configuration), `anna.finance` (SharePoint test).  
**Expected:** a scoped CA session control sends SharePoint access to Defender; the matching file name triggers a blocked download.  
**Observed:** `CA-MDCA-Session-Control` is On for `SG-GSA-Pilot` and Office 365 SharePoint Online with custom Conditional Access App Control. `MDCA-Block-Download` filters `BFL-Test-Download.docx`, uses Inspection method None and action Block. SharePoint displayed Defender's Download blocked message for the test file.  
**Result:** Pass.  
**Evidence:**

- [14 — CA App Control](../evidence/day-15/14-ca-mdca-session-control.png)
- [15 — Session Policy](../evidence/day-15/15-mdca-block-download-policy.png)
- [16 — Blocked SharePoint download](../evidence/day-15/16-mdca-download-blocked.png)

**Evidence boundary:** the test proves the matching document download was denied; it does not demonstrate content inspection, all-file blocking, or that SharePoint sign-in itself was denied.

## Deferred / not tested

| Area | Status | Reason |
| --- | --- | --- |
| Cloud Discovery report | Not tested / deferred | Excluded from Day 15 for now; no actual discovery report is published |
| Connected Apps scanning | Not verified | No successfully completed scan is established by this evidence set |
| OAuth App Policy / App governance | Not implemented | Only existing Entra delegated permissions were reviewed |
| Internet policy after final modification | Not re-tested in supplied evidence | Block transactions precede the later configuration timestamp |

## Final state

The screenshot set documents a scoped and connected GSA pilot, observed Microsoft/Entra traffic, Private Access tunneling to a defined internal web resource, selective Internet blocking, cloud-app and OAuth analysis, and an actual Defender Session Policy download denial. Cloud Discovery remains outside this day's implemented and tested scope.

See [Day 15 implementation notes](../docs/day-15.md) and [Day 15 evidence](../evidence/day-15/README.md).
