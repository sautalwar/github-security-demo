# ============================================================
# SOC2 Type II Compliance Policy
# ============================================================
# Validates repository configuration against SOC2 Trust Service
# Criteria: Security, Availability, Processing Integrity,
# Confidentiality, and Privacy.
#
# Evaluated by the compliance.yml GitHub Actions workflow.
# Input: compliance-input.json with repository metadata.
# ============================================================

package soc2

import future.keywords.in
import future.keywords.contains
import future.keywords.if

# ----------------------------------------------------------
# CC6.1 – Logical Access Controls
# ----------------------------------------------------------

default access_control_branch_protection := false
access_control_branch_protection if {
	input.access_control.branch_protection == true
}

default access_control_require_reviews := false
access_control_require_reviews if {
	input.access_control.require_reviews == true
}

default access_control_min_reviewers := false
access_control_min_reviewers if {
	input.access_control.min_reviewers >= 2
}

access_controls_passed if {
	access_control_branch_protection
	access_control_require_reviews
	access_control_min_reviewers
}

default access_controls_passed := false

# ----------------------------------------------------------
# CC8.1 – Change Management
# ----------------------------------------------------------

default change_mgmt_status_checks := false
change_mgmt_status_checks if {
	input.access_control.require_status_checks == true
}

default change_mgmt_ci_pipeline := false
change_mgmt_ci_pipeline if {
	input.ci_cd.has_security_scanning == true
}

change_management_passed if {
	change_mgmt_status_checks
	change_mgmt_ci_pipeline
}

default change_management_passed := false

# ----------------------------------------------------------
# CC7.1 / CC7.2 – System Monitoring
# ----------------------------------------------------------

default monitoring_audit_logging := false
monitoring_audit_logging if {
	input.logging.audit_logging == true
}

default monitoring_log_retention := false
monitoring_log_retention if {
	input.logging.log_retention_days >= 90
}

default monitoring_centralized_logging := false
monitoring_centralized_logging if {
	input.logging.centralized_logging == true
}

monitoring_passed if {
	monitoring_audit_logging
	monitoring_log_retention
	monitoring_centralized_logging
}

default monitoring_passed := false

# ----------------------------------------------------------
# CC6.7 – Encryption Controls
# ----------------------------------------------------------

default encryption_at_rest := false
encryption_at_rest if {
	input.encryption.data_at_rest == true
}

default encryption_in_transit := false
encryption_in_transit if {
	input.encryption.data_in_transit == true
}

# TLS 1.2 is the minimum acceptable version
tls_versions := {"1.2": 12, "1.3": 13}

default encryption_tls_version := false
encryption_tls_version if {
	version := tls_versions[input.encryption.tls_version]
	version >= 12
}

encryption_passed if {
	encryption_at_rest
	encryption_in_transit
	encryption_tls_version
}

default encryption_passed := false

# ----------------------------------------------------------
# CC7.1 – Security Scanning
# ----------------------------------------------------------

default scanning_dast := false
scanning_dast if {
	input.ci_cd.has_dast == true
}

default scanning_container := false
scanning_container if {
	input.ci_cd.has_container_scanning == true
}

default scanning_iac := false
scanning_iac if {
	input.ci_cd.has_iac_scanning == true
}

security_scanning_passed if {
	scanning_dast
	scanning_container
	scanning_iac
}

default security_scanning_passed := false

# ----------------------------------------------------------
# Compliance Report – aggregated output
# ----------------------------------------------------------

checks := [
	{
		"name": "CC6.1 - Branch Protection",
		"passed": access_control_branch_protection,
		"description": "Default branch must have branch protection enabled",
	},
	{
		"name": "CC6.1 - Code Reviews Required",
		"passed": access_control_require_reviews,
		"description": "Pull requests must require code review approval",
	},
	{
		"name": "CC6.1 - Minimum Reviewers",
		"passed": access_control_min_reviewers,
		"description": "At least 2 reviewers must be required for pull requests",
	},
	{
		"name": "CC8.1 - Status Checks",
		"passed": change_mgmt_status_checks,
		"description": "Status checks must pass before merging",
	},
	{
		"name": "CC8.1 - CI/CD Security Pipeline",
		"passed": change_mgmt_ci_pipeline,
		"description": "CI/CD pipeline must include security scanning",
	},
	{
		"name": "CC7.1 - Audit Logging",
		"passed": monitoring_audit_logging,
		"description": "Audit logging must be enabled for all system events",
	},
	{
		"name": "CC7.1 - Log Retention",
		"passed": monitoring_log_retention,
		"description": "Logs must be retained for at least 90 days",
	},
	{
		"name": "CC7.2 - Centralized Logging",
		"passed": monitoring_centralized_logging,
		"description": "Logs must be sent to a centralized logging system",
	},
	{
		"name": "CC6.7 - Encryption at Rest",
		"passed": encryption_at_rest,
		"description": "Data at rest must be encrypted",
	},
	{
		"name": "CC6.7 - Encryption in Transit",
		"passed": encryption_in_transit,
		"description": "Data in transit must be encrypted",
	},
	{
		"name": "CC6.7 - TLS Version",
		"passed": encryption_tls_version,
		"description": "TLS version must be 1.2 or higher",
	},
	{
		"name": "CC7.1 - DAST Scanning",
		"passed": scanning_dast,
		"description": "Dynamic Application Security Testing must be enabled",
	},
	{
		"name": "CC7.1 - Container Scanning",
		"passed": scanning_container,
		"description": "Container image vulnerability scanning must be enabled",
	},
	{
		"name": "CC7.1 - IaC Scanning",
		"passed": scanning_iac,
		"description": "Infrastructure as Code security scanning must be enabled",
	},
]

passed_checks := [c | some c in checks; c.passed == true]
failed_checks := [c | some c in checks; c.passed == false]

overall_status := "PASS" if {
	count(failed_checks) == 0
}

default overall_status := "FAIL"

compliance_report := {
	"framework": "SOC2 Type II",
	"status": overall_status,
	"checks": checks,
	"summary": {
		"total": count(checks),
		"passed": count(passed_checks),
		"failed": count(failed_checks),
	},
}
