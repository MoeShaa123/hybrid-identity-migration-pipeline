# Multi-Cloud Identity Governance & Automation Pipeline (Mono-Repo)

A production-grade, multi-cloud Identity-as-Code (IaC) repository. This portfolio demonstrates how to architect enterprise-level lifecycle management, cross-cloud trust federation, and real-time directory synchronization across **Microsoft Azure (Entra ID)** and **Amazon Web Services (AWS)** using **Terraform**, **PowerShell**, and **GitHub Actions**.

---

## 🏗️ Repository Architecture

```text
hybrid-identity-migration-pipeline/
├── .gitignore                   # Safe credentials masking filter
├── README.md                    # Core project presentation layout
│
├── 01-ad-to-entra-migration/    # 🏆 Project 1: Automated Directory Migration
│   ├── data/
│   │   ├── legacy_users.csv     # Raw legacy on-premises datastore
│   │   └── identities.json      # Sanitised pipeline interchange payload
│   ├── scripts/
│   │   └── parse_data.ps1       # .NET file stream conversion utility
│   └── terraform/
│       ├── main.tf              # Engine requirements & client configuration
│       └── groups.tf            # Dynamic identity resource schema loops
│
├── 02-azure-aws-sso-federation/ # 🚀 Project 2: Cross-Cloud SAML 2.0 & SCIM Pipeline
│   └── terraform/
│       ├── main.tf              # Multi-cloud provider definitions & AWS anchors
│       ├── entra_sso.tf         # Automated programmatic application user mappings
│       └── entra_metadata.xml   # Cryptographic identity handshake certificate
│
└── 03-zero-trust-threat-audit/  # 🛡️ Project 3: Automated Threat Auditing Pipeline
    ├── .github/workflows/
    │   └── scheduled_audit.yml  # GitHub Actions automated cron orchestrator
    └── scripts/
        └── run_access_review.ps1# Graph API OAuth 2.0 governance scanner
```

---

## 🏆 Project 1: Automated Hybrid Directory Migration Pipeline

**Core Focus:** _Identity-as-Code (IaC), Data Sanitisation, Structural Resource Provisioning_

### The Engineering Problem

Enterprise environments migrating from legacy on-premises Active Directory networks face text anomalies, unhygienic data schemas, and high operational friction when lifting bulk user populations to pure cloud structures.

### What Was Engineered

- **Advanced Data ETL Pipeline:** Wrote a highly robust PowerShell extraction script (`parse_data.ps1`) that imports raw CSV data, programmatically strips string formatting anomalies (such as Windows Byte Order Mark markers), and serializes the identities into standard JSON formats.
- **Dynamic Identity Loops:** Configured native Terraform loops to process the JSON profiles, programmatically provisioning cloud objects with correct target properties (`given_name`, `surname`, `department`, `job_title`) via direct provider hooks into the **Microsoft Graph API**.
- **Zero-Trust Baseline Enforcement:** Programmatically appended immediate `force_password_change = true` mandates on all migrated accounts, neutralizing the risk of stagnant, default admin credentials.

---

## 🚀 Project 2: Multi-Cloud SAML 2.0 Federation & Real-Time SCIM Sync

**Core Focus:** _SAML 2.0 Handshakes, SCIM API Operations, Cross-Cloud Access Delegation_

### The Engineering Problem

Siloed login environments cause password fatigue, expand corporate threat attack surfaces, and create administrative gaps during critical offboarding events (Leavers).

### What Was Engineered

- **Cryptographic Trust Foundation:** Established an immutable SAML 2.0 identity federation trust link between Microsoft Entra ID and **AWS IAM Identity Center** over secure London (`eu-west-2`) endpoints by importing portal metadata into Terraform.
- **Automated Identity Access Mappings:** Engineered programmatic User-to-Application role maps inside Terraform (`azuread_app_role_assignment`), completely bypassing free-tier Azure group-assignment limitations via clean code loops.
- **Real-Time SCIM Synchronization Engine:** Enabled a System for Cross-domain Identity Management (SCIM) pipe over a dedicated **IPv4 network endpoint**, utilizing OAuth 2.0 Secret Bearer tokens to seamlessly synchronize account lifecycles and states from Azure to AWS.
- **Cross-Cloud Permissions Bridge:** Configured short-lived, ephemeral AWS assume-role bindings (`AzureFederatedAdminRole`), enabling enterprise users to authenticate securely using their Azure workspace passwords to instantly inherit scoped permissions inside AWS.

---

## 🛡️ Project 3: Automated Zero-Trust Threat Auditing Pipeline

**Core Focus:** _SecOps Automation, API Security, Token Authentication, Governance & Compliance_

### The Engineering Problem

Unmonitored environments suffer from "Identity Drift" and "Privilege Creep," where stale, inactive employee accounts remain open indefinitely, presenting massive targets for external threat actors.

### What Was Engineered

- **OAuth 2.0 Compliance Integration:** Configured an identity audit engine that authenticates securely using App Registrations and scoped OAuth 2.0 client credentials (`User.ReadWrite.All`) to interface with the Microsoft Graph core engine.
- **Automated Threat Assessment Scripting:** Coded a programmatic compliance utility (`run_access_review.ps1`) that performs a deep scan of the cloud directory to flag any accounts that have remained inactive or have not logged in for **over 90 days**.
- **Privilege Demotion Remediation:** Programmed the engine to instantly execute automated cleanup steps, systematically stripping high-level group privileges and revoking active entitlements from stale accounts to enforce absolute **Least-Privilege Compliance**.
- **GitHub Actions CI/CD Scheduler:** Embedded the security engine inside a managed GitHub Actions runner file (`scheduled_audit.yml`), executing the compliance scans on a weekly automated schedule.

---

## 💻 Tech Stack & Protocols Managed

- **Infrastructure as Code:** Terraform (HashiCorp AWS and AzureAD engine providers)
- **Identity Management Providers:** Microsoft Entra ID (Azure Active Directory), AWS IAM Identity Center (SSO)
- **Automation & Core Scripting:** PowerShell Core (Advanced Graph API modules, native .NET file IO)
- **Security & Authentication Protocols:** SAML 2.0, SCIM, OAuth 2.0, OpenID Connect (OIDC), Cryptographic Certificates
- **CI/CD & Process Orchestration:** GitHub Actions Workflow Engines, Git Version Control
