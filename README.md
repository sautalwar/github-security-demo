# 🛡️ GitHub Actions Security Suite — Competitive Demo

**A production-grade reference implementation proving that GitHub Actions can match — and exceed — GitLab's native security features, with full transparency, customizability, and ecosystem depth.**

This repository contains a deliberately vulnerable Node.js API backed by **9 security-focused GitHub Actions workflows**, policy-as-code configurations, and an automated security dashboard. Every capability maps to a GitLab Ultimate feature, implemented entirely with open-source Actions and SARIF integration.

---

## 📊 Security Capability Matrix

| # | Capability | GitLab Equivalent | GitHub Actions Implementation | Workflow File |
|---|---|---|---|---|
| 1 | **SAST / Dependency Scanning** | GitLab SAST + Dependency Scanning | `npm audit` + SARIF upload | `sbom.yml` |
| 2 | **Container Scanning** | GitLab Container Scanning | Trivy container scanner | `container-scan.yml` |
| 3 | **DAST** | GitLab DAST | OWASP ZAP full scan | `dast.yml` |
| 4 | **API Security Testing** | GitLab API Fuzzing | OWASP ZAP API scan + Spectral linting | `api-security.yml` |
| 5 | **IaC Scanning** | GitLab SAST (IaC) | Checkov by Bridgecrew | `iac-scan.yml` |
| 6 | **License Compliance** | GitLab License Compliance | Custom license scanner + policy engine | `license-compliance.yml` |
| 7 | **SBOM Generation** | GitLab Dependency List | Syft + CycloneDX + SPDX | `sbom.yml` |
| 8 | **Compliance as Code** | GitLab Compliance Framework | Open Policy Agent (OPA / Rego) | `compliance.yml` |
| 9 | **Security Dashboard** | GitLab Security Dashboard | GitHub Pages + aggregated metrics | `security-dashboard.yml` |

**Bonus:** A **Security Policy Gate** (`security-policy-gate.yml`) enforces organizational policies on every PR — zero-tolerance for critical vulnerabilities, auto-assigned security reviewers, and time-boxed exemptions.

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/<org>/github-security-demo.git
cd github-security-demo

# 2. Install dependencies
npm install

# 3. Run locally (optional)
cp .env.example .env
npm run dev

# 4. Push to GitHub — all 9 workflows trigger automatically
git push origin main
```

> **Prerequisites:** Node.js ≥ 18, Docker (for container scanning), a GitHub repository with Actions enabled.

---

## 🔍 Workflow Details

### 1. SBOM & Dependency Scanning — `sbom.yml`
Generates a Software Bill of Materials in CycloneDX and SPDX formats using Syft. Runs `npm audit` and uploads results as SARIF to the GitHub **Security** tab. Produces downloadable SBOM artifacts for supply-chain compliance.

### 2. Container Scanning — `container-scan.yml`
Builds the Docker image and scans it with **Trivy** for OS-level and application-level CVEs. Results appear as SARIF findings in the Security tab. Fails the build on CRITICAL or HIGH severity vulnerabilities.

### 3. DAST — `dast.yml`
Deploys the application in a workflow container, then runs an **OWASP ZAP** full scan against it. Uses the ZAP rules in `.github/zap-rules.tsv` to control which findings are WARN, FAIL, or IGNORE. Uploads the HTML report as an artifact.

### 4. API Security Testing — `api-security.yml`
Lints the OpenAPI spec (`docs/api-spec.yaml`) with **Spectral** using security-focused rules (`.github/spectral.yaml`). Then runs OWASP ZAP in API scan mode against the live spec to fuzz endpoints for injection, auth bypass, and broken access control.

### 5. IaC Scanning — `iac-scan.yml`
Scans Terraform configurations in `terraform/` with **Checkov** for CIS, SOC 2, and cloud-provider benchmarks. Outputs SARIF for the Security tab and generates a JUnit report for the PR checks summary.

### 6. License Compliance — `license-compliance.yml`
Audits every dependency against the organization's license policy (`.github/license-policy.json`). Allowed licenses (MIT, Apache-2.0, BSD) pass automatically; denied licenses (GPL, AGPL, SSPL) fail the build; edge cases (LGPL, MPL) are flagged for legal review.

### 7. Compliance as Code — `compliance.yml`
Evaluates repository configuration, Dockerfile, Terraform, and CI/CD settings against **OPA / Rego** policies in `policies/`. Maps to frameworks like SOC 2, HIPAA, PCI-DSS, and CIS Benchmarks — all codified as machine-readable rules.

### 8. Security Dashboard — `security-dashboard.yml`
Aggregates findings from all other workflows and publishes a **GitHub Pages** dashboard with trend charts, severity breakdowns, and pass/fail history. Acts as a single pane of glass for security posture.

### 9. Security Policy Gate — `security-policy-gate.yml`
Runs on every PR. Enforces the rules in `.github/security-policies.json`:
- **Zero critical vulnerabilities** allowed to merge.
- **Auto-assigns** `security-lead` and `devsecops-engineer` when sensitive files change (`Dockerfile`, `terraform/`, `*.env*`).
- **Time-boxed exemptions** with mandatory justification (max 30 days).
- **Slack & email alerts** for critical findings.

---

## ⚙️ Customizing Security Policies

All policies live in version-controlled configuration files — no UI settings to drift or forget.

| File | Purpose |
|---|---|
| `.github/security-policies.json` | Vulnerability thresholds, required checks, reviewer auto-assignment, exemptions |
| `.github/license-policy.json` | Allowed / denied / needs-review license lists |
| `.github/zap-rules.tsv` | OWASP ZAP rule severity overrides (WARN / FAIL / IGNORE) |
| `.github/spectral.yaml` | OpenAPI linting rules for API security and design standards |
| `policies/*.rego` | OPA / Rego policies for compliance-as-code |

### Example: Tightening Vulnerability Thresholds

```jsonc
// .github/security-policies.json
{
  "vulnerability_thresholds": {
    "critical": 0,   // Zero tolerance
    "high": 5,       // Up to 5 high-severity findings
    "medium": 20,    // Up to 20 medium
    "low": -1        // Unlimited (informational)
  }
}
```

### Example: Blocking a License

```jsonc
// .github/license-policy.json
{
  "denied": ["GPL-2.0", "GPL-3.0", "AGPL-3.0", "SSPL-1.0"]
}
```

---

## 📈 Security Dashboard (GitHub Pages)

The `security-dashboard.yml` workflow publishes an HTML dashboard to GitHub Pages on every push to `main`. It provides:

- **Trend charts** — vulnerability counts over time by severity
- **Pass / fail history** — per-workflow success rates
- **SBOM inventory** — full dependency list with license metadata
- **Compliance scorecard** — OPA policy pass rates by framework

> **Setup:** Enable GitHub Pages in **Settings → Pages** and set the source to the `gh-pages` branch.

---

## 🏆 Key Differentiators vs. GitLab

| Differentiator | Details |
|---|---|
| **Full Customizability** | Every rule, threshold, and behavior is defined in YAML or JSON files you own. No black-box scanning — fork and modify any Action to fit your needs. |
| **17,000+ Actions Marketplace** | Plug in any scanner, notifier, or integration from the world's largest CI/CD ecosystem. Swap Trivy for Grype, ZAP for Nuclei, Checkov for tfsec — in one line. |
| **SARIF → Security Tab** | All scanners upload SARIF, giving you a **unified vulnerability view** in the GitHub Security tab with alert management, dismissal workflows, and Dependabot integration. |
| **Transparency** | All security logic lives in `.github/workflows/*.yml` — fully auditable, diff-able, and reviewable in pull requests. No hidden platform magic. |
| **Composability** | Mix and match workflows. Run IaC scanning on Terraform changes only. Trigger DAST only on deployments. Gate merges on exactly the checks your org requires. |
| **Policy as Code** | OPA/Rego policies, license rules, and vulnerability thresholds are all code — versioned, tested, and reviewed like any other source file. |
| **Cost Efficiency** | GitHub Actions minutes are included in every GitHub plan. No need for GitLab Ultimate ($99/user/month) to access security scanning. |

---

## 🔐 Relationship to GitHub Advanced Security (GHAS)

This demo is **independent of GHAS** and uses only open-source Actions available on any GitHub plan. However, organizations using GHAS gain additional native capabilities that complement this suite:

| GHAS Feature | What It Adds |
|---|---|
| **CodeQL** | Semantic SAST — deep dataflow analysis across languages (goes beyond pattern matching) |
| **Dependabot** | Automated dependency update PRs with vulnerability patching |
| **Secret Scanning** | Detects leaked credentials, API keys, and tokens in code and history |
| **Push Protection** | Blocks pushes containing secrets before they reach the repository |

> **Recommendation:** Use this Actions-based suite for DAST, container scanning, IaC, license compliance, SBOM, and policy enforcement. Layer GHAS on top for SAST, secrets, and dependency updates — achieving defense in depth.

---

## 📁 Repository Structure

```
├── .github/
│   ├── workflows/          # 9 security workflows
│   ├── security-policies.json
│   ├── license-policy.json
│   ├── zap-rules.tsv       # OWASP ZAP rule overrides
│   └── spectral.yaml       # OpenAPI linting rules
├── docs/
│   └── api-spec.yaml       # OpenAPI 3.0 specification
├── policies/               # OPA / Rego compliance policies
├── src/
│   └── app.js              # Express API (intentionally vulnerable)
├── terraform/
│   └── main.tf             # AWS infrastructure (for IaC scanning)
├── tests/
│   └── app.test.js         # Jest + Supertest integration tests
├── Dockerfile              # Multi-stage, non-root, Alpine-based
└── package.json
```

---

## 📜 License

This project is provided as a demonstration and reference architecture. See individual dependency licenses for terms.

---

<p align="center">
  <em>Built with ❤️ by the Solutions Engineering team — proving that GitHub is the platform for secure software delivery.</em>
</p>
