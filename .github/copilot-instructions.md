# Copilot Instructions

## Build & Test Commands

- `npm ci` — Install dependencies (use instead of `npm install` for reproducible builds)
- `npm start` — Start the Express app on the default port
- `npm test` — Run the full Jest + Supertest test suite
- `npm run test:single <pattern>` — Run a single test file matching `<pattern>`
- `npm run lint` — Lint the codebase
- `docker build -t copilot-security-demo .` — Build the multi-stage Alpine-based container image

## Architecture

This is a **demo/showcase repository**, not a production application. Its purpose is to demonstrate 9 GitHub Actions security capabilities that are competitive with GitLab's native security features.

- **`src/app.js`** — Node.js/Express sample app with **intentional vulnerabilities** for scanning demos.
- **`Dockerfile`** — Multi-stage, non-root, Alpine-based image.
- **`terraform/main.tf`** — Terraform config with **intentional misconfigurations** for IaC scanning demos.
- **`.github/workflows/`** — 9 security workflows (the main deliverable of this repo).
- **`policies/opa/*.rego`** — OPA/Rego policies that drive compliance checks.
- **`docs/api-spec.yaml`** — OpenAPI 3.0 spec used by the API security scan.
- **`tests/app.test.js`** — Jest + Supertest tests for the sample app.

The workflows are the primary deliverable. The app, Dockerfile, and Terraform exist to give the workflows something to scan.

## Workflow Conventions

Each of the 9 workflows in `.github/workflows/` follows these conventions:

- **Header comment block** at the top of every workflow file explaining which GitLab feature it replaces and the value proposition.
- **SARIF upload** — All workflows upload results to the GitHub Security tab via `github/codeql-action/upload-sarif`.
- **PR comments** — All workflows post scan results as comments on pull requests.
- **Artifact retention** — Scan artifacts are retained for 30–90 days.

The workflows:
| Workflow | Tool(s) | Purpose |
|---|---|---|
| `dast.yml` | OWASP ZAP | Dynamic application security testing |
| `container-scan.yml` | Trivy | Container image vulnerability scanning |
| `iac-scan.yml` | Checkov + tfsec | Infrastructure-as-code scanning |
| `license-compliance.yml` | Custom | License compliance checking |
| `sbom.yml` | Syft + Grype | Software bill of materials + vulnerability scan |
| `security-policy-gate.yml` | Custom | Enforce security policies as PR gates |
| `api-security.yml` | Schemathesis + custom | API security testing against OpenAPI spec |
| `compliance.yml` | OPA/Rego | Policy-as-code compliance checks |
| `security-dashboard.yml` | GitHub Pages | Aggregate security dashboard |

## Adding New Security Scans

Follow the established pattern:

1. Use a **descriptive workflow name with an emoji** (e.g., `🔍 DAST Security Scan`).
2. Include a **header comment block** explaining which GitLab feature it replaces and the value prop.
3. **Upload SARIF** results to the Security tab.
4. **Comment on PRs** with a summary of findings.
5. **Upload artifacts** with appropriate retention (30–90 days).

## Policy Files

- **`.github/security-policies.json`** — Controls PR security gates (severity thresholds, required checks).
- **`.github/license-policy.json`** — Controls allowed/denied software licenses.
- **`policies/opa/*.rego`** — OPA policies written in Rego. Used by the `compliance.yml` workflow to evaluate policy-as-code checks.

## Important: Intentional Vulnerabilities

The application code (`src/app.js`) and Terraform configuration (`terraform/main.tf`) contain **intentional security issues** placed there for demo purposes. These exist to trigger findings in the security scanning workflows.

**Do not fix these vulnerabilities** unless specifically asked to do so. "Fixing" them would break the demo by removing the scan findings the workflows are designed to detect.
