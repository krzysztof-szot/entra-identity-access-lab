# Day 15 — Evidence

This folder documents the Baltic Finance Global Secure Access and Microsoft Defender for Cloud Apps lab: a scoped pilot group, enabled traffic forwarding profiles, a connected client, observed Microsoft 365/Entra traffic, per-app Private Access to an internal finance site, Internet Access web filtering, Cloud App Catalog and OAuth permission review, and a tested Conditional Access App Control download block.

The images are arranged by **implementation and verification flow**, not by exact capture time. Screenshot 02 is the final profile state.

## Evidence

- `01-gsa-pilot-group.png` — shows `SG-GSA-Pilot` with Anna Finance as its single direct member.
- `02-gsa-traffic-forwarding-final-state.png` — shows Microsoft traffic, Private Access and Internet Access profiles enabled, with group assignments and related policy/application counts.
- `03-microsoft-traffic-pilot-assignment.png` — shows `SG-GSA-Pilot` assigned with Default Access in the traffic-forwarding-related Enterprise Application; this screen alone is not proof of traffic delivery.
- `04-gsa-client-connected.png` — shows Anna's Global Secure Access Client connected to Baltic Finance Lab, with Entra, M365, Private and Internet channels connected and device join type Entra Joined.
- `05-gsa-microsoft-traffic-verification.png` — shows central GSA Traffic logs with Microsoft 365 and Entra connections for Anna and action Allow.
- `06-private-access-app-configuration.png` — shows `BFL-Internal-Finance`, connector group `CG-BFL-PrivateAccess - Europe`, GSA client access enabled and a successful TCP application segment for `10.20.0.4:80`.
- `07-private-app-access-by-ip.png` — shows the Internal Finance Application hosted on `BFL-CON01` opening at `http://10.20.0.4/`; the browser page alone does not establish the network path.
- `08-private-access-client-traffic.png` — shows the GSA Client's advanced diagnostics tunneling Edge TCP traffic to `10.20.0.4` on port 80 through the Private Access channel.
- `09-private-access-central-traffic-logs.png` — shows central Private traffic transactions for Anna with action Allow, corroborating the client-side tunnel evidence.
- `10-internet-access-block-policy.png` — combines the `GSA-Block-Risky-Web` domain rule (`example.org`, `www.example.org`), the enabled `SP-GSA-Web` security profile with Block action, and the `CA-GSA-Web-Filtering` policy scoped to `SG-GSA-Pilot` and GSA Internet resources.
- `11-internet-access-blocked-traffic.png` — shows Internet Access transactions for Anna blocking `example.org` while permitting other destinations. These records predate the last-modified time visible on the security profile in screenshot 10, so they do not independently re-verify any later policy edits.
- `12-cloud-app-catalog-risk-analysis.png` — shows the Defender for Cloud Apps catalog's Dropbox security factors and displayed risk score; no sanction/unsanction decision is demonstrated.
- `13-oauth-app-permissions-review.png` — shows Expense Portal's Microsoft Graph delegated `User.Read` permission granted through admin consent in Entra Enterprise Applications; this is a permission review, not an OAuth App Policy in Defender.
- `14-ca-mdca-session-control.png` — shows `CA-MDCA-Session-Control` enabled for `SG-GSA-Pilot` and Office 365 SharePoint Online, with Use Conditional Access App Control → Use custom policy.
- `15-mdca-block-download-policy.png` — shows `MDCA-Block-Download`, Control file download (with inspection), file-name filter `BFL-Test-Download.docx`, Inspection method None, and action Block.
- `16-mdca-download-blocked.png` — shows SharePoint Online refusing the matching document download with the Microsoft Defender for Cloud Apps “Download blocked” message.

Cloud Discovery was deferred and is **not** represented by a sample/demo screenshot. Sensitive account and device identifiers, network addresses where appropriate, and user-specific details were redacted. No credentials or tokens are published.
