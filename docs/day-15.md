# Day 15 — Global Secure Access and Defender for Cloud Apps

## Objectives

Day 15 extended Baltic Finance's identity lab beyond application sign-in into **identity-aware network access and in-session controls**. The goals were to scope a Global Secure Access (GSA) pilot, inspect forwarded Microsoft traffic, publish a specific private TCP resource, enforce an Internet Access domain block, review cloud app and OAuth permission risk, and use Defender for Cloud Apps to block a specific SharePoint document download.

This day reuses the Conditional Access, Enterprise Application and OAuth knowledge from earlier labs. **Cloud Discovery was intentionally deferred**; no discovered-app report or successful App connector scan is claimed.

## Implemented

### Pilot, traffic forwarding and client

`SG-GSA-Pilot` contained Anna Finance as its only direct member. The final GSA Traffic forwarding view showed all three profiles enabled: Microsoft traffic, Private Access and Internet Access. The Microsoft-traffic-related Enterprise Application showed the pilot group with Default Access.

On Anna's Entra-joined device, the GSA Client connected to Baltic Finance Lab. Its Entra, M365, Private and Internet channels showed Connected. Central Traffic logs separately showed allowed Microsoft 365 and Entra traffic for Anna.

These artifacts establish a connected client and observed traffic; Enterprise Application assignment alone is not proof of traffic forwarding.

### Private Access to BFL-Internal-Finance

The lab configured the GSA Enterprise Application `BFL-Internal-Finance` with connector group `CG-BFL-PrivateAccess - Europe`, enabled GSA Client access and defined this application segment:

| Property | Value |
| --- | --- |
| Destination | `10.20.0.4` |
| Port | `80` |
| Protocol | TCP |
| Segment status | Success |
| Internal resource | Internal Finance Application on `BFL-CON01` |

The finance test page opened at `http://10.20.0.4/`. GSA Client advanced diagnostics showed Edge TCP connections to `10.20.0.4:80` with channel **Private Access** and action **Tunnel**. Central GSA Traffic logs also showed Anna's Private transactions with action Allow.

The browser page demonstrates resource accessibility; the client diagnostics and central transactions provide the separate evidence that the tested path used Private Access. The evidence does not establish high availability, a second active connector, or backend user-level SSO within the simple web page. The application uses HTTP on port 80 in this private lab, not end-to-end HTTPS.

### Internet Access: domain filtering

An Internet Access web filtering rule `Block-Test-Domain` was configured under `GSA-Block-Risky-Web` for `example.org` and `www.example.org`. The configuration screenshot also shows:

| Component | Recorded setting |
| --- | --- |
| Security profile | `SP-GSA-Web`, Enabled |
| Web content filtering policy | `GSA-Block-Risky-Web` |
| Policy action | Block |
| Conditional Access | `CA-GSA-Web-Filtering`, On |
| CA users | `SG-GSA-Pilot` |
| CA target | All internet resources with Global Secure Access |
| CA session control | Use Global Secure Access security profile → `SP-GSA-Web` |

Internet Access transaction logs showed Anna's requests to `example.org` blocked and other destinations allowed.

**Time-order limitation:** the blocked events visible in screenshot 11 occurred before the last-modified time shown for the security profile in screenshot 10. They confirm that an Internet Access block occurred during the lab, but do not independently re-test every setting of the later captured policy version. No post-edit re-test is claimed.

### Cloud App Catalog and OAuth permissions

In Defender for Cloud Apps, the Cloud App Catalog was used to inspect Dropbox security factors and its displayed score. This was a **catalog analysis**, not an assertion that Dropbox was discovered in Baltic Finance traffic or marked Sanctioned/Unsanctioned.

The existing Expense Portal Enterprise Application was reviewed in Entra ID. Its Permissions view showed Microsoft Graph delegated `User.Read`, granted by admin consent. This is an **OAuth permission review**, not proof of an OAuth App Policy or App governance deployment in Defender.

### Conditional Access App Control and SharePoint download block

The enabled Conditional Access policy `CA-MDCA-Session-Control` targeted `SG-GSA-Pilot` and **Office 365 SharePoint Online**, with Session → **Use Conditional Access App Control** → **Use custom policy**.

Defender for Cloud Apps contained the corresponding `MDCA-Block-Download` Session Policy:

| Setting | Value |
| --- | --- |
| Session control type | Control file download (with inspection) |
| File filter | File name contains `BFL-Test-Download.docx` |
| Inspection method | None |
| Action | Block |

During the SharePoint test, downloading `BFL-Test-Download.docx` produced the Defender for Cloud Apps **Download blocked** message. This is evidence of a targeted session download restriction, **not** content-based DLP inspection or a general denial of SharePoint access.

## Design Decisions

- Restrict tests to `SG-GSA-Pilot` rather than a tenant-wide user population; Anna is the positive pilot identity.
- Keep the three GSA traffic types conceptually distinct and verify connection and traffic separately from administrative configuration.
- Expose only the `BFL-Internal-Finance` TCP application segment required for the private-resource test, instead of claiming unrestricted network-level VPN replacement.
- Correlate the private application's target IP/port with the client's Tunnel records and central Private transaction logs.
- Apply the Internet domain block through a Web Content Filtering policy, a security profile and a scoped Conditional Access policy; retain allowed traffic as a comparison.
- Reuse Expense Portal for read-only OAuth permission analysis instead of granting extra Graph scopes merely to create an alert.
- Use a disposable, filename-matched SharePoint document to demonstrate Session Policy enforcement without inspecting sensitive file contents.

## Verification and Limitations

**Observed:** pilot membership; three enabled forwarding profiles; connected GSA Client and channels; allowed Microsoft/Entra traffic; configured Private Access app and successfully tunneled TCP traffic to `10.20.0.4:80`; central Private Allow transactions; Internet Access Block events for `example.org`; catalog and OAuth permission review; and an actual SharePoint download denial under the configured MDCA session control.

**Not implemented or not claimed:** Cloud Discovery reporting, a verified successful Connected Apps scan, OAuth App Policy/App governance, general Shadow IT discovery, content-based file inspection, a second Private Network Connector/high availability, or a post-edit Internet policy re-test. The final-state Traffic forwarding screenshot is placed early for **logical documentation order**, not to imply it was captured before all the later tests.

## Evidence and Tests

- [Day 15 test results](../tests/day-15.md)
- [Day 15 evidence](../evidence/day-15/README.md)

Sensitive user, device and network identifiers were redacted where appropriate; private test destination `10.20.0.4:80` remains visible to correlate the access configuration and traffic. No credentials or tokens are published.
