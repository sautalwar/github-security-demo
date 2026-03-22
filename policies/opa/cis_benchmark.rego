# ============================================================
# CIS Benchmark Compliance Policy
# ============================================================
# Validates repository and container configuration against
# CIS (Center for Internet Security) Benchmarks for Docker,
# CI/CD pipelines, and supply chain security.
#
# Evaluated by the compliance.yml GitHub Actions workflow.
# Input: compliance-input.json with repository metadata.
# ============================================================

package cis

import future.keywords.in
import future.keywords.contains
import future.keywords.if

# ----------------------------------------------------------
# 4.1 / 4.6 – Container Security
# ----------------------------------------------------------

# CIS Docker Benchmark 4.1: Ensure a non-root user is used
default container_non_root := false
container_non_root if {
	input.docker.has_dockerfile == true
	input.docker.runs_as_root == false
}

# CIS Docker Benchmark 4.6: Ensure HEALTHCHECK is defined
default container_healthcheck := false
container_healthcheck if {
	input.docker.has_dockerfile == true
	input.docker.has_healthcheck == true
}

# Approved base images to reduce supply chain risk
approved_base_images := {
	"node:18-alpine",
	"node:20-alpine",
	"node:22-alpine",
	"python:3.11-slim",
	"python:3.12-slim",
	"golang:1.21-alpine",
	"golang:1.22-alpine",
	"ubuntu:22.04",
	"ubuntu:24.04",
	"alpine:3.18",
	"alpine:3.19",
	"alpine:3.20",
}

default container_approved_base_image := false
container_approved_base_image if {
	input.docker.base_image in approved_base_images
}

container_security_passed if {
	container_non_root
	container_healthcheck
	container_approved_base_image
}

default container_security_passed := false

# ----------------------------------------------------------
# 5.1 – CI/CD Pipeline Security
# ----------------------------------------------------------

default cicd_security_scanning := false
cicd_security_scanning if {
	input.ci_cd.has_security_scanning == true
}

default cicd_dast := false
cicd_dast if {
	input.ci_cd.has_dast == true
}

cicd_pipeline_passed if {
	cicd_security_scanning
	cicd_dast
}

default cicd_pipeline_passed := false

# ----------------------------------------------------------
# 5.3 – Infrastructure Security
# ----------------------------------------------------------

default infra_iac_scanning := false
infra_iac_scanning if {
	input.ci_cd.has_iac_scanning == true
}

infrastructure_security_passed if {
	infra_iac_scanning
}

default infrastructure_security_passed := false

# ----------------------------------------------------------
# 5.4 – Supply Chain Security
# ----------------------------------------------------------

default supply_chain_sbom := false
supply_chain_sbom if {
	input.ci_cd.has_sbom == true
}

default supply_chain_license_compliance := false
supply_chain_license_compliance if {
	input.ci_cd.has_license_compliance == true
}

supply_chain_passed if {
	supply_chain_sbom
	supply_chain_license_compliance
}

default supply_chain_passed := false

# ----------------------------------------------------------
# 6.1 – Access Management
# ----------------------------------------------------------

default access_branch_protection := false
access_branch_protection if {
	input.access_control.branch_protection == true
}

default access_min_reviewers := false
access_min_reviewers if {
	input.access_control.min_reviewers >= 2
}

access_management_passed if {
	access_branch_protection
	access_min_reviewers
}

default access_management_passed := false

# ----------------------------------------------------------
# Compliance Report – aggregated output
# ----------------------------------------------------------

checks := [
	{
		"name": "CIS 4.1 - Non-Root Container",
		"passed": container_non_root,
		"description": "Containers must not run as the root user",
	},
	{
		"name": "CIS 4.6 - Container Healthcheck",
		"passed": container_healthcheck,
		"description": "Dockerfile must include a HEALTHCHECK instruction",
	},
	{
		"name": "CIS 4.2 - Approved Base Image",
		"passed": container_approved_base_image,
		"description": "Container base image must be from the approved allowlist",
	},
	{
		"name": "CIS 5.1 - Security Scanning",
		"passed": cicd_security_scanning,
		"description": "CI/CD pipeline must include static security scanning",
	},
	{
		"name": "CIS 5.1 - DAST Enabled",
		"passed": cicd_dast,
		"description": "CI/CD pipeline must include Dynamic Application Security Testing",
	},
	{
		"name": "CIS 5.3 - IaC Scanning",
		"passed": infra_iac_scanning,
		"description": "Infrastructure as Code must be scanned for misconfigurations",
	},
	{
		"name": "CIS 5.4 - SBOM Generation",
		"passed": supply_chain_sbom,
		"description": "Software Bill of Materials must be generated for each build",
	},
	{
		"name": "CIS 5.4 - License Compliance",
		"passed": supply_chain_license_compliance,
		"description": "Dependency licenses must be checked for compliance",
	},
	{
		"name": "CIS 6.1 - Branch Protection",
		"passed": access_branch_protection,
		"description": "Default branch must have branch protection rules enabled",
	},
	{
		"name": "CIS 6.1 - Minimum Reviewers",
		"passed": access_min_reviewers,
		"description": "Pull requests must require at least 2 reviewers",
	},
]

passed_checks := [c | some c in checks; c.passed == true]
failed_checks := [c | some c in checks; c.passed == false]

overall_status := "PASS" if {
	count(failed_checks) == 0
}

default overall_status := "FAIL"

compliance_report := {
	"framework": "CIS Benchmarks",
	"status": overall_status,
	"checks": checks,
	"summary": {
		"total": count(checks),
		"passed": count(passed_checks),
		"failed": count(failed_checks),
	},
}
