# Microsoft Entra Identity & Access Lab

I'm building this lab while preparing for SC-300, after passing AZ-500.
The aim is to configure identity controls and check how they behave
with different user accounts.

The scenario is a small company with Finance, HR and IT teams.
An Expense Portal will be used to test employee and approver access.

## Current focus

Users, security groups, delegated administration and emergency accounts.

- [Day 1 notes and checks](docs/day-01.md)
- [Users and groups](docs/access-matrix.md)

## Architecture

```mermaid
flowchart TB

    %% =========================
    %% USERS
    %% =========================

    EMP["Employees"]
    CON["Contractors"]
    ADM["Administrators"]

    %% =========================
    %% MICROSOFT ENTRA ID
    %% =========================

    ENTRA["Microsoft Entra ID"]

    %% =========================
    %% ADMINISTRATION
    %% =========================

    PIM["Directory Roles / PIM"]
    PS["Microsoft Graph PowerShell"]
    GRAPH["Microsoft Graph API"]
    JML["Joiner / Mover / Leaver Automation"]

    %% =========================
    %% APPLICATION ACCESS
    %% =========================

    AUTH["Authentication / MFA / SSO / Conditional Access"]
    APPREG["App Registration"]
    SP["Enterprise Application / Service Principal"]
    PORTAL["Expense Portal"]

    %% =========================
    %% WORKLOAD IDENTITY
    %% =========================

    MI["Workload Identity / Managed Identity"]
    KV["Azure Key Vault"]
    SECRETS["Secrets / Certificates"]

    %% =========================
    %% MONITORING
    %% =========================

    LOGS["Sign-in and Audit Logs"]

    %% =========================
    %% USER FLOWS
    %% =========================

    EMP -->|"Sign-in"| ENTRA
    CON -->|"B2B Collaboration"| ENTRA

    %% =========================
    %% ADMIN FLOWS
    %% =========================

    ADM --> PIM
    PIM -->|"Privileged administration"| ENTRA

    ADM --> PS
    PS --> GRAPH
    GRAPH -->|"Administration"| ENTRA
    PS -.->|"Automation"| JML
    JML -.-> ENTRA

    %% =========================
    %% APPLICATION FLOW
    %% =========================

    ENTRA --> AUTH
    AUTH -->|"Protected access"| PORTAL

    ENTRA --> APPREG
    APPREG --> SP

    APPREG -.->|"Application definition"| PORTAL
    SP -.->|"Assignments / App Roles"| PORTAL

    %% =========================
    %% WORKLOAD IDENTITY FLOW
    %% =========================

    PORTAL --> MI
    MI -.->|"Identity managed by Entra"| ENTRA
    MI -->|"Access token"| KV
    KV --> SECRETS

    %% =========================
    %% LOGGING
    %% =========================

    ENTRA -->|"Sign-in and administrative events"| LOGS

    %% =========================
    %% STYLES
    %% =========================

    classDef entra fill:#e8f1ff,stroke:#2563eb,stroke-width:2px,color:#111827;
    classDef person fill:#f8fafc,stroke:#64748b,stroke-width:1.5px,color:#111827;
    classDef admin fill:#fff7ed,stroke:#ea580c,stroke-width:1.5px,color:#111827;
    classDef security fill:#fef2f2,stroke:#dc2626,stroke-width:1.5px,color:#111827;
    classDef app fill:#f0fdf4,stroke:#16a34a,stroke-width:1.5px,color:#111827;
    classDef workload fill:#faf5ff,stroke:#9333ea,stroke-width:1.5px,color:#111827;
    classDef monitor fill:#fefce8,stroke:#ca8a04,stroke-width:1.5px,color:#111827;
    classDef automation fill:#ecfeff,stroke:#0891b2,stroke-width:1.5px,color:#111827;

    class ENTRA entra;
    class EMP,CON person;
    class ADM,PIM admin;
    class AUTH security;
    class APPREG,SP,PORTAL app;
    class MI,KV,SECRETS workload;
    class LOGS monitor;
    class PS,GRAPH,JML automation;
```

## Implementation Progress

### Day 01 — Identity Foundation

- [x] Workforce users
- [x] Security groups
- [x] Administrative separation
- [x] Emergency access accounts
- [x] Permission boundary testing
- [x] Audit log verification

### Day 02 — Application Identity and Access

- [x] Azure App Service
- [x] Microsoft Entra authentication
- [x] Single-tenant App Registration
- [x] Enterprise Application / Service Principal
- [x] Application roles
- [x] Group-based application assignment
- [x] Assignment required
- [x] Admin consent
- [x] Positive authentication tests
- [x] Sign-in log verification

### Planned

- [ ] Dynamic groups
- [ ] Joiner-Mover-Leaver lifecycle
- [ ] Conditional Access
- [ ] Identity Protection
- [ ] Privileged Identity Management
- [ ] B2B collaboration
- [ ] Entitlement Management
- [ ] Access Reviews
