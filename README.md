# Multi-Cloud Identity Automation & Security Pipeline (Mono-Repo)

This repository contains a working setup that manages user accounts, connects different cloud environments, and scans for security risks automatically. It uses **Terraform**, **PowerShell**, and **GitHub Actions** to automate user management across **Microsoft Entra ID (Azure)** and **Amazon Web Services (AWS)**.

---

## 📂 Inside the Repository

```text
hybrid-identity-migration-pipeline/
├── .github/                         # The automation folder
│   └── workflows/
│       └── identity-pipeline-ci-cd.yml # The script that runs the weekly security check
├── .gitignore                       # Hides passwords/keys so they aren't uploaded
├── README.md                        # This project guide
│
├── 01-ad-to-entra-migration/        # 🏆 Stage 1: Moving users to the cloud
│   ├── data/
│   │   ├── legacy_users.csv         # The old list of company employees
│   │   └── identities.json          # The cleaned up, machine-readable user list
│   ├── scripts/
│   │   └── parse_data.ps1           # The script that fixes and converts the text list
│   └── terraform/
│       └── groups.tf                # The code that actually creates the cloud accounts
│
├── 02-entra-to-aws-sso-federation/  # 🚀 Stage 2: Connecting Azure to AWS
│   └── terraform/
│       ├── main.tf                  # The code that links the two clouds together
│       ├── entra_sso.tf             # Automatically gives users access to the AWS login app
│       └── entra_metadata.xml       # The security certificate shared between clouds
│
└── 03-zero-trust-compliance-auditor/# 🛡️ Stage 3: Checking for inactive accounts
    └── scripts/
        └── run_access_review.ps1    # The script that logs in and looks for old users
```

---

## 🏆 Stage 1: Automated Hybrid Directory Migration Pipeline

### 🏢 Real-World Company Scenario

Imagine a company has 5,000 employees saved on an old, dusty on-premises corporate server. The business decides to move entirely to the cloud (Microsoft Entra ID). Doing this by hand means typing 5,000 names manually, which takes weeks and leads to human error, typos, and broken data formats.

### What I Built

- **The Cleaner Script:** I wrote a PowerShell script (`parse_data.ps1`) that takes the raw user spreadsheet, strips out invisible text errors, fixes punctuation marks, and changes the data into a clean JSON file that automation engines can read.
- **The Account Creator:** I wrote Terraform code that reads that clean text file and programmatically creates every user account, populates their first name, last name, and department, and drops them into the correct company security groups.
- **First-Day Security:** The code automatically flags every new user with a setting that forces them to pick a brand-new, private password the very first second they log in. This prevents default passwords from leaking.

---

## 🚀 Stage 2: Multi-Cloud SAML 2.0 Federation & Real-Time SCIM Bridge

### 🏢 Real-World Company Scenario

Your company uses Microsoft Azure for daily employee operations (emails, Excel, laptops), but the engineering teams use AWS to build customer web applications. Employees are frustrated because they have to remember two different usernames and two separate passwords. Worse, when an employee leaves the company, HR deletes them from Azure, but the IT team forgets to delete them from AWS—leaving a massive security backdoor open.

### What I Built

- **The Login Bridge (SSO):** I used Terraform to exchange secure digital certificates between Azure and AWS. Now, employees browse to an AWS page, click login, and are redirected to type their standard Azure password. One password, two clouds.
- **The Automated Guest List (SCIM):** I set up an automated background sync engine. The moment a new user is added or updated in Azure, Azure calls an API in AWS in the background and instantly duplicates that user account into AWS. If an account is disabled in Azure, their access to AWS is cut off automatically.
- **Free-Tier License Fix:** Since the free version of Azure blocks groups from being assigned to applications, I wrote a code loop in Terraform (`azuread_app_role_assignment`) that assigns every single user to the login portal individually, getting the exact same result for free.

---

## 🛡️ Stage 3: Automated Zero-Trust Threat Auditing Pipeline

### 🏢 Real-World Company Scenario

Employees join and leave companies constantly. Over time, contractor accounts are forgotten, old employee accounts are left active, and stale profiles sit abandoned. These inactive accounts are prime targets for hackers because nobody is watching them.

### What I Built

- **The Autonomous Auditor:** I wrote a security script (`run_access_review.ps1`) that doesn't need a human to type a password to log in. Instead, it logs in as a secure background automation service using an OAuth 2.0 security token.
- **The 90-Day Tracker:** Every time it runs, the script scans the login history of every account in the entire company directory. It isolates any user who hasn't logged in for over 90 days (or has never logged in at all) and flags them in bold red as a security risk.
- **The Weekly Clockwork Scheduler:** I embedded this script inside a GitHub Actions file (`identity-pipeline-ci-cd.yml`). It is set up on a timer to wake up automatically every Sunday at midnight, run the audit, and log the compliance report cleanly on the screen.

---

## 💻 Systems & Tools Used

- **Infrastructure Management:** Terraform
- **Cloud Security Platforms:** Microsoft Entra ID (Azure AD), AWS IAM Identity Center
- **Scripting Languages:** PowerShell Core, .NET Web Extensions
- **Security Protocols:** SAML 2.0 Certificates, SCIM User Syncing, OAuth 2.0 API Tokens
- **Automation Servers:** GitHub Actions
