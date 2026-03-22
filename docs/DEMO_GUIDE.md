# 🛡️ GitHub Actions Security Suite — Interactive Demo Guide

> **Audience:** GitHub Sales Engineers conducting competitive demos against GitLab  
> **Duration:** ~47 minutes (adjustable per section)  
> **Goal:** Demonstrate that GitHub Actions can match or exceed every GitLab native security feature — with full customizability, transparency, and no vendor lock-in  

---

## 📋 Pre-Demo Setup

Complete these steps **before** the customer call. Allow 15–20 minutes.

### Prerequisites

| Requirement | Details |
|---|---|
| GitHub account | With access to create repositories and enable GitHub Pages |
| Node.js | v18.0.0 or higher (`node --version`) |
| npm | Bundled with Node.js (`npm --version`) |
| Docker | For container scanning demo (`docker --version`) |
| Git | For pushing repo to GitHub (`git --version`) |

### Step 1 — Push the Repository to GitHub

```bash
# 1. Create a new repo on GitHub (public or internal)
gh repo create <org>/github-security-demo --public --source=. --push

# OR if the repo already exists:
git remote add origin https://github.com/<org>/github-security-demo.git
git push -u origin main
```

### Step 2 — Enable GitHub Pages

1. 🖱️ Navigate to **Settings** → **Pages** (left sidebar)
2. Under **Build and deployment**:
   - **Source:** Deploy from a branch
   - **Branch:** `gh-pages` / `/ (root)`
3. Click **Save**
4. ⏳ Wait ~60 seconds for the initial deployment

> 💡 The security dashboard workflow will auto-deploy to Pages on every scan completion.

### Step 3 — Run All Workflows Once

Trigger each workflow manually so results are populated before the demo:

1. 🖱️ Go to **Actions** tab
2. For each workflow, click the workflow name → **Run workflow** → **Run workflow**
3. Recommended order (some depend on others):
   - `DAST` → `Container Security` → `IaC Scan` → `License Compliance` → `SBOM` → `API Security` → `Compliance` → `Security Policy Gate` → `Security Dashboard`

> ⚠️ Wait for all runs to complete (green ✅) before the demo.

### Step 4 — (Optional) Configure Branch Protection

1. 🖱️ **Settings** → **Branches** → **Add branch protection rule**
2. Branch name pattern: `main`
3. ✅ Require a pull request before merging
4. ✅ Require status checks to pass (add: `Checkov IaC Scan`, `Trivy`, `License Compliance`, `OPA Compliance`)
5. ✅ Require review from code owners
6. Click **Create**

### Step 5 — Verify Demo Readiness

- [ ] All 9 workflows show green ✅ in the Actions tab
- [ ] Security tab shows SARIF findings (from DAST, Container, IaC scans)
- [ ] GitHub Pages dashboard is live at `https://<org>.github.io/github-security-demo/security-dashboard/`
- [ ] Sample PR exists (optional — create one for gate demo)

---

## 🗺️ Demo Flow Overview

| # | Section | Time | Key Message |
|---|---------|------|-------------|
| 1 | [Repository Overview](#demo-section-1-repository-overview) | 3 min | Everything is code you own and control |
| 2 | [DAST — Dynamic Application Security Testing](#demo-section-2-dast--dynamic-application-security-testing) | 5 min | Full-featured DAST with ZAP, not a black box |
| 3 | [Container Security Scanning](#demo-section-3-container-security-scanning) | 5 min | CVEs + misconfigs + secrets in one pass |
| 4 | [IaC Security Scanning](#demo-section-4-iac-security-scanning) | 5 min | Dual-scanner coverage maps to CIS benchmarks |
| 5 | [License Compliance](#demo-section-5-license-compliance) | 4 min | Policy-driven license gates you define |
| 6 | [SBOM Generation](#demo-section-6-sbom-generation) | 4 min | Dual-format SBOMs attached to releases |
| 7 | [Security Policy Gates](#demo-section-7-security-policy-gates) | 5 min | Policy as code — enforceable, auditable, reviewable |
| 8 | [API Security Testing](#demo-section-8-api-security-testing) | 5 min | Spec-driven fuzzing + custom security checks |
| 9 | [Compliance as Code](#demo-section-9-compliance-as-code) | 5 min | SOC2, HIPAA, CIS — automated, not manual |
| 10 | [Security Dashboard](#demo-section-10-security-dashboard) | 3 min | Unified posture view, auto-updated |
| | [Closing: The GitHub Advantage](#closing-the-github-advantage) | 3 min | Key differentiators and next steps |

> **Total: ~47 minutes** — Trim to 30 min by skipping Sections 6, 8, and 9.

---

## Demo Section 1: Repository Overview

⏱️ **Time:** 3 minutes

### 🎯 Goal

Set the stage. Show the customer that everything — every scan, every policy, every threshold — lives as code they own and can inspect.

### 🖱️ Click Path

1. **Navigate to repo root** → `https://github.com/<org>/github-security-demo`
2. Point out the top-level structure:
   ```
   📁 .github/workflows/    ← 9 security workflows
   📁 .github/               ← Security policies + license policy (JSON)
   📁 docs/                  ← OpenAPI spec (api-spec.yaml)
   📁 policies/opa/          ← Compliance rules (Rego)
   📁 src/                   ← Sample Express.js app
   📁 terraform/             ← Sample AWS infrastructure (with intentional misconfigs)
   📁 tests/                 ← Jest test suite
   📄 Dockerfile             ← Multi-stage, hardened container
   📄 package.json           ← Node.js project config
   ```
3. Click into **`.github/workflows/`** → Show the 9 workflow files listed
4. Open **one workflow** (e.g., `dast.yml`) → Scroll through to show YAML structure

### 💬 Talking Points

> "Everything you see here is **transparent**. Every security policy is code you own and control. There are no hidden configurations, no black-box scanners, no settings buried in a vendor UI. If you want to change a threshold, you edit a JSON file. If you want to swap a scanner, you change one line in a YAML file."

> "This repo has **9 security workflows** covering DAST, container scanning, IaC scanning, license compliance, SBOM generation, policy gates, API security testing, compliance automation, and a security dashboard. Every single one runs as a GitHub Action."

### 🏆 Value Statement

> "With GitHub, your security configuration is **version controlled, peer reviewed, and auditable** — just like your application code. When an auditor asks 'how do you enforce security?', you point them to a Git commit."

---

## Demo Section 2: DAST — Dynamic Application Security Testing

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's built-in DAST analyzer** — GitLab bundles a ZAP-based DAST scanner, but it's configured through CI variables with limited customization. Here, you get **full control**.

### 🖱️ Click Path

1. 🖱️ **Actions** tab → Click **"DAST"** workflow in the left sidebar
2. Click **"Run workflow"** dropdown (top right)
3. Select scan type from the dropdown:
   - `baseline` — Quick passive scan (~2 min)
   - `full` — Active + passive scan (~10 min)
   - `api` — API-focused scan using OpenAPI spec
4. Click **"Run workflow"** (green button)
5. Click into the running workflow → Watch the **"dast-scan"** job execute
6. While it runs, click **"Code"** tab → Open **`.github/workflows/dast.yml`**

### 👀 What to Show

| What | Where | Why It Matters |
|------|-------|----------------|
| Workflow YAML | `.github/workflows/dast.yml` | Full scan config is visible — no hidden settings |
| Scan type selector | `workflow_dispatch` inputs | Customer chooses baseline/full/API per run |
| ZAP scan running | Actions job log | Live OWASP ZAP output streaming |
| SARIF upload step | Workflow YAML → `upload-sarif` action | Results flow natively to GitHub Security tab |
| Security tab findings | **Security** → **Code scanning alerts** | Findings appear as actionable alerts with severity |
| PR comment | Any PR triggered by the workflow | Auto-posted scan summary directly on the PR |

### 💬 Talking Points

> "This runs **OWASP ZAP** — the same scanner GitLab uses under the hood — but here you have **full control**. You choose the scan type, configure rule exclusions, and define your own alert thresholds."

> "Notice the `workflow_dispatch` input — a developer or security engineer can manually trigger a full scan anytime. On PRs, it runs automatically as a baseline scan. That's the kind of flexibility a built-in scanner can't give you."

> "Results upload as **SARIF** — that's the industry standard format for static analysis results. They show up natively in the **Security tab**, alongside CodeQL findings, Dependabot alerts, and secret scanning. One unified view."

### 🏆 Customer Value

> "You're not locked into a black-box scanner. You choose the tool, configure the rules, and own the output. Want to switch from ZAP to Burp Suite or Nuclei tomorrow? Change one line in the YAML."

---

## Demo Section 3: Container Security Scanning

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's Container Scanning analyzer** — GitLab uses Trivy or Grype behind a CI template. Here, you use Trivy directly with **four scan modes** in a single workflow.

### 🖱️ Click Path

1. 🖱️ **Actions** tab → Click **"Container Security Scan"** workflow
2. Click into the **most recent run** (or trigger manually via **Run workflow**)
3. Click the **"container-scan"** job → Expand each step
4. Switch tabs: **Code** → Open **`.github/workflows/container-scan.yml`**
5. 🖱️ **Security** tab → **Code scanning alerts** → Filter by tool: "Trivy"

### 👀 What to Show

| What | Where | Why It Matters |
|------|-------|----------------|
| Docker build | Job log → "Build Docker image" step | Image built from the repo's Dockerfile |
| 4-part scan | Job log → 4 Trivy steps | Vulnerabilities + config + secrets in one pass |
| Image vuln scan (SARIF) | Job step: "Run Trivy vulnerability scanner" | OS & library CVEs with severity ratings |
| Config scan | Job step: "Run Trivy config scanner" | Dockerfile best practices (CIS benchmarks) |
| Secret scan | Job step: "Run Trivy secret scanner" | Detects leaked credentials in image layers |
| SARIF in Security tab | Security → Code scanning alerts | All findings in one place |
| PR comment | PR → Comments | Table summary auto-posted |
| Artifacts | Job summary → Artifacts section | SARIF, table, config, and secret reports downloadable |

### 💬 Talking Points

> "One workflow, **four scans**: image vulnerabilities, Dockerfile misconfigurations, and embedded secrets. GitLab's container scanner only does vulnerability scanning — you'd need separate tools for config and secrets."

> "We're using **Trivy by Aqua Security** — it's open source, actively maintained, and trusted by the cloud-native ecosystem. The `--ignore-unfixed` flag means we only alert on vulnerabilities that actually have patches available."

> "The Dockerfile itself follows security best practices — multi-stage build, non-root user, healthcheck — and Trivy's config scanner validates all of that automatically."

### 🏆 Customer Value

> "One scanner, four dimensions of security. CVEs, misconfigurations, and leaked secrets — caught before they reach production. And every finding flows to the same Security tab."

---

## Demo Section 4: IaC Security Scanning

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's IaC Scanning analyzer (KICS)** — GitLab uses a single scanner. Here, you get **dual-scanner coverage** with Checkov and tfsec for maximum detection.

### 🖱️ Click Path

1. 🖱️ **Code** tab → Open **`terraform/main.tf`** → Scroll through to show the infrastructure
2. Point out **intentional misconfigurations** (see list below)
3. 🖱️ **Actions** tab → Click **"IaC Security Scan"** workflow
4. Click into a completed run → Show **both jobs**: `checkov-scan` and `tfsec-scan`
5. Expand Checkov job → Show the parsed findings with file:line references
6. 🖱️ **Security** tab → Filter by tool to show Checkov and tfsec findings separately

### 👀 What to Show — Intentional Misconfigurations

Walk the customer through `terraform/main.tf` and highlight these **planted findings**:

| Resource | Misconfiguration | Checkov ID | What It Means |
|----------|-----------------|------------|---------------|
| `aws_s3_bucket.app_data` | No versioning enabled | CKV_AWS_21 | Data loss risk — no object recovery |
| `aws_s3_bucket.app_data` | No encryption | CKV_AWS_19 | Data at rest is unencrypted |
| `aws_s3_bucket.app_data` | No access logging | CKV_AWS_18 | No audit trail for bucket access |
| `aws_s3_bucket_public_access_block` | All flags set to `false` | CKV_AWS_53–56 | Bucket is publicly accessible |
| `aws_security_group.app` | SSH open to 0.0.0.0/0 | CKV_AWS_24 | Entire internet can SSH in |
| `aws_db_instance.app_db` | Publicly accessible | CKV_AWS_17 | Database exposed to the internet |
| `aws_db_instance.app_db` | Storage not encrypted | CKV_AWS_16 | Data at rest is unencrypted |
| `aws_db_instance.app_db` | Hardcoded password | — | Credential in source code |
| `aws_ecs_cluster.app` | Container insights disabled | CKV_AWS_65 | No runtime monitoring |
| `aws_cloudwatch_log_group` | No KMS encryption | CKV_AWS_158 | Logs are unencrypted |

### 💬 Talking Points

> "We intentionally seeded this Terraform with real-world misconfigurations — the kinds of things that slip through code review. An S3 bucket with no encryption, an RDS database exposed to the internet, SSH open to the world."

> "Notice we run **two scanners** — Checkov and tfsec. They have overlapping but also unique detections. Checkov maps findings to **CIS benchmarks and AWS best practices**. tfsec adds its own detection rules. Running both gives you maximum coverage."

> "Checkov findings include the **exact file and line number**, plus a link to the remediation docs. The PR comment shows the top 10 failed checks so developers see issues before they merge."

### 🏆 Customer Value

> "Dual-scanner coverage means fewer blind spots. Every finding maps to an industry benchmark — CIS, AWS Well-Architected, NIST. Your auditors will love this."

---

## Demo Section 5: License Compliance

⏱️ **Time:** 4 minutes

### 🔄 What It Replaces

**GitLab's License Compliance analyzer** — GitLab scans dependencies and reports licenses. Here, you define a **customizable policy** that decides which licenses are allowed, denied, or require review.

### 🖱️ Click Path

1. 🖱️ **Code** tab → Open **`.github/license-policy.json`**
2. Walk through the three tiers: `allowed`, `denied`, `requires_review`
3. 🖱️ **Actions** tab → Click **"License Compliance"** workflow
4. Click into a completed run → Expand the job steps
5. Show the **license distribution table** in the PR comment or job summary
6. Show the **violation detection** — what happens when a GPL dependency is found

### 👀 What to Show — The Policy File

```
📄 .github/license-policy.json
```

| Tier | Licenses | Action |
|------|----------|--------|
| ✅ **Allowed** | MIT, Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, 0BSD, CC0-1.0, Unlicense, CC-BY-3.0, CC-BY-4.0, Python-2.0, PSF-2.0, BlueOak-1.0.0 | Pass — no action needed |
| 🚫 **Denied** | GPL-2.0, GPL-3.0, AGPL-1.0, AGPL-3.0, SSPL-1.0, EUPL-1.1, OSL-3.0, CPAL-1.0, CPL-1.0, Sleepycat | **Fail** — workflow blocks the PR |
| 🔍 **Requires Review** | LGPL-2.0, LGPL-2.1, LGPL-3.0, MPL-2.0, EPL-1.0, EPL-2.0, CDDL-1.0, Artistic-2.0 | **Flag** — needs legal/security team review |

### 💬 Talking Points

> "This is **your policy, defined in JSON**. Your legal team decides what goes in each tier. When a developer adds a dependency with a GPL license, the workflow **blocks the PR** and posts a comment explaining why."

> "The `requires_review` tier is the nuanced middle ground. LGPL and MPL have conditional copyleft — they might be fine depending on how you use them. This tier flags them for human review without blocking."

> "The notes section explains **why** each license category is restricted. This educates developers, not just blocks them."

### 🏆 Customer Value

> "Your license policy becomes an **automated gate** — not a manual checklist. Developers get instant feedback, legal gets peace of mind, and you have an auditable trail of every license decision."

---

## Demo Section 6: SBOM Generation

⏱️ **Time:** 4 minutes

### 🔄 What It Replaces

**GitLab's Dependency List / SBOM** — GitLab generates a dependency list. Here, you get **dual-format SBOMs** (CycloneDX + SPDX) for both the application and the container image, plus vulnerability scanning against the SBOM.

### 🖱️ Click Path

1. 🖱️ **Actions** tab → Click **"SBOM Generation"** workflow
2. Click into a completed run → Expand the job steps
3. Show the **4 SBOM files** generated (app + container × CycloneDX + SPDX)
4. Show the **Grype vulnerability scan** against the SBOM
5. Show the **artifacts** section — download an SBOM to show the format
6. (If a release exists) Go to **Releases** → Show SBOM files attached as release assets

### 👀 What to Show

| Output | Format | What It Contains |
|--------|--------|-----------------|
| `app-sbom-cyclonedx.json` | CycloneDX JSON | Application dependencies with versions, licenses, hashes |
| `app-sbom-spdx.json` | SPDX JSON | Same data in SPDX format (NTIA/EO 14028 preferred) |
| `container-sbom-cyclonedx.json` | CycloneDX JSON | Full container image inventory (OS packages + app deps) |
| `container-sbom-spdx.json` | SPDX JSON | Container inventory in SPDX format |
| `sbom-vulnerability-report` | Table + JSON | Grype scan of SBOM for known CVEs |

### 💬 Talking Points

> "We generate **four SBOMs** every run — application and container, in both CycloneDX and SPDX formats. CycloneDX is the OWASP standard; SPDX is the Linux Foundation standard preferred by **Executive Order 14028** for federal supply chain compliance."

> "The SBOM doesn't just list dependencies — we immediately **scan it with Grype** to find known vulnerabilities. So you get the inventory AND the risk assessment in one workflow."

> "When you publish a release, all four SBOM files are **automatically attached as release assets**. Your customers can download the SBOM for any version and verify the software supply chain."

### 🏆 Customer Value

> "If your customers are in government, healthcare, or financial services, they need SBOMs. This gives you **EO 14028 compliance out of the box** — dual-format, vulnerability-scanned, attached to every release."

---

## Demo Section 7: Security Policy Gates

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's built-in Security Policies / Approval Rules** — GitLab lets you require approvals for certain findings. Here, you define **comprehensive policy as code** — required checks, vulnerability thresholds, auto-reviewer assignment, and file-based security review triggers.

### 🖱️ Click Path

1. 🖱️ **Code** tab → Open **`.github/security-policies.json`**
2. Walk through each section of the policy file (see below)
3. 🖱️ **Actions** tab → Click **"Security Policy Gate"** workflow
4. Click into a run triggered by a PR → Show the enforcement table
5. Show the **PR comment** with the pass/fail status for each required check
6. (If branch protection is configured) Show how the PR is **blocked** until all checks pass

### 👀 What to Show — The Policy File

Walk through **`.github/security-policies.json`** section by section:

**① Required Checks**
```json
"required_checks": [
  "Checkov IaC Scan",
  "Trivy",
  "License Compliance",
  "OPA Compliance"
]
```
> "These checks MUST pass before any PR can merge. No exceptions without an explicit exemption."

**② Vulnerability Thresholds**
```json
"vulnerability_thresholds": {
  "critical": 0,     ← Zero tolerance for critical
  "high": 5,         ← Max 5 high-severity findings
  "medium": 20,      ← Max 20 medium-severity findings
  "low": -1          ← Unlimited (informational only)
}
```
> "Your security team sets these numbers. Zero tolerance for critical vulns, a reasonable cap on high and medium, and low-severity findings are tracked but don't block."

**③ Security Review Triggers**
```json
"security_review_required_for": [
  "Dockerfile",
  "terraform/",
  ".github/workflows/",
  "src/auth",
  "*.env*"
]
```
> "Any PR that touches these files automatically triggers a security review. Infrastructure, workflows, auth code, and environment files — the high-risk areas."

**④ Auto-Assign Reviewers**
```json
"auto_assign_reviewers": {
  "security_team": ["security-lead", "devsecops-engineer"],
  "infra_team": ["platform-engineer"]
}
```
> "The right reviewers are automatically assigned based on what changed. No manual triage."

**⑤ Exemptions**
```json
"exemptions": {
  "allow_skip_for": ["documentation-only", "test-only"],
  "max_exemption_days": 30,
  "require_justification": true
}
```
> "Exemptions exist for docs-only and test-only changes, but they expire after 30 days and require written justification. Auditable."

### 💬 Talking Points

> "This is **policy as code**. Every rule — what checks must pass, what thresholds are acceptable, who reviews what — is defined in a JSON file that's version controlled, peer reviewed, and auditable."

> "When someone changes this policy, it goes through the same PR review process as any code change. Your CISO can approve policy changes. Your auditors can see the full history in Git."

> "The workflow posts a **status table** as a PR comment showing pass/fail for every required check. Developers see exactly what's blocking them and why."

### 🏆 Customer Value

> "Your security policies aren't buried in a vendor UI — they're code. Reviewable, auditable, version-controlled code. When an auditor asks 'how do you enforce security controls?', you point to a Git commit."

---

## Demo Section 8: API Security Testing

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's API Fuzzing / DAST API** — GitLab offers API fuzzing through CI templates. Here, you get **spec-driven fuzzing** plus **custom security checks** that test for real-world API vulnerabilities.

### 🖱️ Click Path

1. 🖱️ **Code** tab → Open **`docs/api-spec.yaml`** → Show the OpenAPI 3.0.3 spec
2. 🖱️ **Actions** tab → Click **"API Security Testing"** workflow
3. Click into a completed run → Show the three jobs/stages:
   - **Spectral validation** (OpenAPI linting)
   - **Schemathesis fuzzing** (automated API fuzzing)
   - **Custom security tests** (targeted vulnerability checks)
4. Show the **markdown report** posted as a PR comment

### 👀 What to Show

**The OpenAPI Spec** (`docs/api-spec.yaml`):
| Endpoint | Method | Auth Required | Purpose |
|----------|--------|--------------|---------|
| `/health` | GET | No | Health check |
| `/api/auth/register` | POST | No | User registration |
| `/api/auth/login` | POST | No | Authentication |
| `/api/data` | GET | Bearer JWT | Protected data |
| `/api/search` | GET | Bearer JWT | Search (⚠️ has SQL injection pattern) |
| `/api/upload` | POST | Bearer JWT | File upload (⚠️ no type validation) |
| `/api/admin/users` | GET | Bearer JWT | Admin endpoint (⚠️ no RBAC) |

**Three-Layer Testing:**

| Layer | Tool | What It Checks |
|-------|------|---------------|
| 1️⃣ Spec Validation | Spectral | OpenAPI spec quality, security scheme definitions |
| 2️⃣ API Fuzzing | Schemathesis | Schema-driven fuzzing with stateful link detection, 50 max examples |
| 3️⃣ Custom Checks | curl + bash | Auth bypass, SQL injection, XSS, rate limiting, headers, CORS |

**Custom Security Checks Detail:**

| Check | Test | Expected Result |
|-------|------|----------------|
| 🔐 Auth bypass | `GET /api/data` without token | `401 Unauthorized` |
| 💉 SQL injection | `GET /api/search?query='; DROP TABLE users;--` | No 500 error |
| 🕸️ XSS injection | `GET /api/search?query=<script>alert('xss')</script>` | No reflection |
| 🚦 Rate limiting | Send 110 requests to `/api/` | `429 Too Many Requests` |
| 🛡️ Security headers | Check response headers | `x-content-type-options`, `x-frame-options`, `strict-transport-security`, `x-xss-protection` |
| 🌐 CORS policy | Check `Access-Control-Allow-Origin` | No wildcard `*` origin |

### 💬 Talking Points

> "API security testing starts from the **OpenAPI spec** — `docs/api-spec.yaml`. Schemathesis reads the spec and automatically generates fuzz tests for every endpoint, every parameter, every schema."

> "But fuzzing alone isn't enough. We also run **six custom security checks** — authentication bypass, SQL injection, XSS, rate limiting, security headers, and CORS. These are the OWASP API Top 10 risks that matter most."

> "Everything is defined in the workflow YAML. Want to add a check for JWT algorithm confusion? Add five lines of bash. Want to test for IDOR? Add a curl command. **Fully customizable**."

### 🏆 Customer Value

> "Your API security tests are defined in code, driven by your OpenAPI spec, and completely customizable. Add checks for your specific threat model — not just what a vendor decided to test for."

---

## Demo Section 9: Compliance as Code

⏱️ **Time:** 5 minutes

### 🔄 What It Replaces

**GitLab's Compliance Frameworks** — GitLab offers compliance labels and pipeline enforcement. Here, you write **actual compliance rules in Rego** (Open Policy Agent) that automatically validate your infrastructure against SOC2, HIPAA, and CIS benchmarks.

### 🖱️ Click Path

1. 🖱️ **Code** tab → Navigate to **`policies/opa/`** → Show the three policy files
2. Open **`policies/opa/soc2.rego`** → Walk through a few rules
3. Open **`policies/opa/hipaa.rego`** → Show healthcare-specific checks
4. Open **`policies/opa/cis_benchmark.rego`** → Show infrastructure benchmarks
5. 🖱️ **Actions** tab → Click **"Compliance as Code"** workflow
6. Click into a completed run → Show the compliance report
7. Show the **PR comment** with pass/fail results per framework

### 👀 What to Show

**Three Compliance Frameworks:**

| Framework | File | What It Validates |
|-----------|------|------------------|
| 🏢 SOC2 Type II | `policies/opa/soc2.rego` | Logical access controls, change management, availability, monitoring, encryption |
| 🏥 HIPAA | `policies/opa/hipaa.rego` | Access controls, audit controls, transmission security, integrity, risk management |
| 🔒 CIS Benchmark | `policies/opa/cis_benchmark.rego` | Identity/access management, logging, monitoring, networking, data protection |

**How It Works:**

```
┌─────────────────────┐      ┌──────────────────────┐      ┌─────────────────────┐
│ compliance.yml      │──▶   │ compliance-input.json │──▶   │ OPA evaluates       │
│ (GitHub Actions)    │      │ (repo metadata)       │      │ policies/*.rego     │
│                     │      │                       │      │                     │
│ • Docker config     │      │ • Base image          │      │ • SOC2 checks       │
│ • CI/CD flags       │      │ • Non-root user       │      │ • HIPAA checks      │
│ • Access control    │      │ • Branch protection   │      │ • CIS checks        │
│ • Encryption        │      │ • Review requirements │      │                     │
│ • Logging           │      │ • Encryption status   │      │ → Pass/Fail per     │
└─────────────────────┘      └──────────────────────┘      │   control           │
                                                            └─────────────────────┘
```

### 💬 Talking Points

> "This is where compliance goes from 'check a box once a year' to '**verify on every commit**'. Each Rego policy file encodes the actual controls from SOC2, HIPAA, or CIS — and OPA evaluates them automatically."

> "The input file captures your repository's security posture — is there a non-root user in Docker? Is branch protection enabled? Is encryption configured? OPA checks each control and reports pass or fail."

> "The beauty of Rego is that **your compliance team can write their own rules**. If you have internal policies beyond SOC2 and HIPAA — add a new `.rego` file and it runs automatically. No vendor involvement, no professional services engagement."

### 🏆 Customer Value

> "Your compliance requirements become **automated checks**, not manual audits. Every commit is validated against SOC2, HIPAA, and CIS benchmarks. Your compliance team writes the rules; the pipeline enforces them."

---

## Demo Section 10: Security Dashboard

⏱️ **Time:** 3 minutes

### 🖱️ Click Path

1. 🖱️ Navigate to GitHub Pages URL: `https://<org>.github.io/github-security-demo/security-dashboard/`
2. Walk through the **capability cards** — 9 cards showing each security scan
3. Scroll to the **metrics summary** — 9 scans, 4 compliance frameworks, unlimited custom policies
4. Scroll to the **comparison table** — GitHub Actions vs GitLab, feature by feature
5. 🖱️ Back to repo → **Actions** tab → Click **"Security Dashboard"** workflow → Show it triggers on completion of any scan

### 👀 What to Show

**Dashboard Elements:**

| Element | What It Shows |
|---------|--------------|
| 🃏 Capability Cards | 9 cards — one per security scan, showing tools used and GitLab equivalent |
| 📊 Metrics Summary | `9 Security Scans` · `4 Compliance Frameworks` · `∞ Custom Policies` · `100% Customizable` |
| 📋 Comparison Table | Side-by-side: GitHub Actions vs GitLab for each capability |
| 🔄 Auto-Update | Triggered by any scan workflow completion + weekly schedule |

### 💬 Talking Points

> "This is your **unified security posture view** — auto-updated on every scan, deployed to GitHub Pages. Every scan result, every compliance check, every tool — visible in one dashboard."

> "The comparison table shows feature-for-feature how GitHub Actions matches GitLab's native security. And remember — this is built with **standard GitHub Actions and open-source tools**. No proprietary add-ons."

> "The dashboard updates automatically. When any security workflow completes, it triggers a rebuild. Your security posture is always current."

### 🏆 Customer Value

> "One dashboard, automatically maintained, showing your complete security posture. No manual aggregation, no spreadsheets, no quarterly reports — it's always live."

---

## 🏁 Closing: The GitHub Advantage

⏱️ **Time:** 3 minutes

### Key Differentiators to Emphasize

| # | Differentiator | What to Say |
|---|---------------|-------------|
| 1️⃣ | **Full Customizability** | "Every policy, every scan, every threshold is code you control. Want to change the vulnerability threshold from 5 to 3? Edit a JSON file. Want to add a new compliance framework? Write a Rego file." |
| 2️⃣ | **Transparency** | "No black boxes. Every security decision is visible in YAML, JSON, and Rego files. Your security team can read, review, and approve every change." |
| 3️⃣ | **Ecosystem** | "17,000+ Actions in the GitHub Marketplace. Use best-of-breed tools — Trivy, Checkov, ZAP, OPA, Syft — or swap them for alternatives. No vendor lock-in." |
| 4️⃣ | **SARIF Integration** | "All findings — from any scanner — flow to GitHub's Security tab via SARIF. One unified view across DAST, container scanning, IaC, and more." |
| 5️⃣ | **Composability** | "Mix and match. Add a scan, remove a scan, swap a tool — without affecting anything else. Each workflow is independent and self-contained." |
| 6️⃣ | **Copilot Integration** | "GitHub Copilot can help write and customize these workflows. Ask Copilot to add a new security check or modify a threshold — it understands the YAML natively." |
| 7️⃣ | **And this is BEFORE GHAS** | "Everything you've seen today uses **standard GitHub Actions and open-source tools**. GitHub Advanced Security adds **CodeQL** for deep SAST, **Dependabot** for supply chain security, and **secret scanning** for credential detection — on top of all this." |

### Closing Statement

> "What you've seen today is a **fully automated security suite** built entirely on GitHub Actions and open-source tools. Nine workflows covering DAST, container scanning, infrastructure security, license compliance, SBOM generation, policy gates, API security, compliance automation, and a live dashboard."
>
> "Every single component is **code you own, customize, and control**. No vendor lock-in, no black boxes, no hidden configurations. And when you add GitHub Advanced Security on top — CodeQL, Dependabot, secret scanning — you have the most comprehensive application security platform available."
>
> "GitLab gives you built-in scanners you can't customize. **GitHub gives you a platform to build exactly the security program your organization needs.**"

---

## 🤺 Objection Handling

### "GitLab has this built-in — why should I configure it?"

> ✅ "Built-in means **built their way**. You're locked into their scanner versions, their configuration options, their update schedule. With GitHub Actions, you choose the best tool for each job — and you can swap it anytime. Your security team controls the scanners, not the vendor."

### "This looks like more setup work."

> ✅ "It's a **one-time setup** — these 9 workflows took a few hours to create, and now they run fully automated on every push, every PR, every release. Plus, **GitHub Copilot can generate these workflows for you**. Ask Copilot 'create a container scanning workflow with Trivy' and it writes the YAML."

### "How do we maintain these workflows?"

> ✅ "They're **code** — version controlled, peer reviewed, Copilot-assisted. When GitHub releases a new Actions runner or Trivy releases a new version, you update one line in the YAML. Compare that to waiting for GitLab to update their bundled scanner version."

### "What about GitHub Advanced Security (GHAS)?"

> ✅ "GHAS adds even **more** on top of everything you've seen:
> - **CodeQL** — deep semantic SAST analysis that understands data flow across your entire codebase
> - **Dependabot** — automated supply chain security with version updates and vulnerability alerts
> - **Secret Scanning** — real-time detection of 200+ credential types with push protection
>
> These workflows **complement** GHAS. Together, they give you the most comprehensive security coverage available on any platform."

### "Can we see this with our own codebase?"

> ✅ "Absolutely. We can do a **proof of value** — take these workflows, adapt them to your stack, and run them against your code. You'll see real findings, real value, in your environment. Let's schedule that as a next step."

### "How does this compare on cost?"

> ✅ "GitHub Actions minutes are included in your GitHub plan. The security tools — Trivy, Checkov, ZAP, OPA — are all **open source and free**. GitLab Ultimate (required for their security features) is a significant premium. And GHAS licensing is per-committer, not per-repo — so it scales efficiently."

---

## 📎 Appendix: Quick Reference

### Workflow Summary Table

| # | Workflow | File | Trigger | Tools | GitLab Equivalent |
|---|----------|------|---------|-------|-------------------|
| 1 | DAST | `.github/workflows/dast.yml` | Push, PR, Manual (scan type selector) | OWASP ZAP v0.12.0 | DAST Analyzer |
| 2 | Container Security | `.github/workflows/container-scan.yml` | Push (Dockerfile/package.json), PR, Manual | Trivy (vuln + config + secrets) | Container Scanning |
| 3 | IaC Scanning | `.github/workflows/iac-scan.yml` | Push (terraform/), PR, Manual | Checkov v12 + tfsec v1.0.3 | IaC Scanning (KICS) |
| 4 | License Compliance | `.github/workflows/license-compliance.yml` | Push (package.json/policy), PR, Manual | license-checker (npm) | License Compliance |
| 5 | SBOM Generation | `.github/workflows/sbom.yml` | Push, Release, Manual | Syft + Grype (Anchore) | Dependency List / SBOM |
| 6 | Security Policy Gate | `.github/workflows/security-policy-gate.yml` | PR opened/sync/reopen, Manual | Custom scripts + policies JSON | Security Policies / Approval Rules |
| 7 | API Security | `.github/workflows/api-security.yml` | Push (src/ or api-spec), PR, Manual | Schemathesis + Spectral + custom checks | API Fuzzing / DAST API |
| 8 | Compliance | `.github/workflows/compliance.yml` | Push, PR, Manual | Open Policy Agent (OPA/Rego) | Compliance Frameworks |
| 9 | Security Dashboard | `.github/workflows/security-dashboard.yml` | Workflow completion, Manual, Weekly schedule | GitHub Pages + custom HTML | Security Dashboard |

### Policy Files Reference

| File | Purpose | Key Contents |
|------|---------|-------------|
| `.github/security-policies.json` | PR gate enforcement | Required checks, vuln thresholds (C:0 H:5 M:20), security review triggers, auto-assign reviewers, exemptions |
| `.github/license-policy.json` | License compliance | Allowed (MIT, Apache, BSD...), Denied (GPL, AGPL, SSPL...), Requires Review (LGPL, MPL, EPL...) |
| `policies/opa/soc2.rego` | SOC2 Type II compliance | Logical access controls, change management, availability, monitoring, encryption |
| `policies/opa/hipaa.rego` | HIPAA compliance | Access controls, audit controls, transmission security, integrity controls |
| `policies/opa/cis_benchmark.rego` | CIS Benchmark | IAM, logging, monitoring, networking, data protection |

### Key Repository Files

| File | Purpose |
|------|---------|
| `src/app.js` | Express.js sample app with intentional vulnerabilities |
| `terraform/main.tf` | AWS infrastructure with intentional misconfigurations |
| `Dockerfile` | Multi-stage, hardened container (non-root, healthcheck) |
| `docs/api-spec.yaml` | OpenAPI 3.0.3 spec for API security testing |
| `tests/app.test.js` | Jest + Supertest test suite (7 tests) |
| `package.json` | Node.js project (Express, Helmet, JWT, bcrypt, Winston) |

### Demo Environment Quick Start

```bash
# Install dependencies
npm ci

# Run the app locally
npm start                  # http://localhost:3000

# Run tests
npm test                   # Jest + coverage

# Build Docker image
docker build -t github-security-demo .

# View Swagger docs
open http://localhost:3000/api-docs
```

---

> 📝 **Last updated:** This guide covers the `github-security-demo` repository with 9 GitHub Actions security workflows. For questions or updates, contact your GitHub Solutions Engineering team.
