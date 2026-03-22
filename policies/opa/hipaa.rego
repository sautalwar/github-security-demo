# ============================================================
# HIPAA Compliance Policy
# ============================================================
# Validates repository configuration against HIPAA Security Rule
# requirements covering Administrative, Physical, and Technical
# Safeguards for electronic Protected Health Information (ePHI).
#
# Evaluated by the compliance.yml GitHub Actions workflow.
# Input: compliance-input.json with repository metadata.
# ============================================================

package hipaa

import future.keywords.in
import future.keywords.contains
import future.keywords.if

# ----------------------------------------------------------
# §164.312(d) – Access Controls / Person or Entity Authentication
# ----------------------------------------------------------

default access_control_require_reviews := false
access_control_require_reviews if {
	input.access_control.require_reviews == true
}

default access_control_enforce_admins := false
access_control_enforce_admins if {
	input.access_control.enforce_admins == true
}

access_controls_passed if {
	access_control_require_reviews
	access_control_enforce_admins
}

default access_controls_passed := false

# ----------------------------------------------------------
# §164.312(a)(2)(iv) / §164.312(e)(2)(ii) – Encryption
# ----------------------------------------------------------

default encryption_at_rest := false
encryption_at_rest if {
	input.encryption.data_at_rest == true
}

default encryption_in_transit := false
encryption_in_transit if {
	input.encryption.data_in_transit == true
}

# HIPAA requires strong encryption; TLS 1.2 is the minimum
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
# §164.312(b) – Audit Controls
# ----------------------------------------------------------

default audit_logging_enabled := false
audit_logging_enabled if {
	input.logging.audit_logging == true
}

# HIPAA requires minimum 6-year retention for certain records,
# but 90-day operational retention is the CI/CD baseline check
default audit_log_retention := false
audit_log_retention if {
	input.logging.log_retention_days >= 90
}

audit_controls_passed if {
	audit_logging_enabled
	audit_log_retention
}

default audit_controls_passed := false

# ----------------------------------------------------------
# §164.312(c) – Data Integrity
# ----------------------------------------------------------

default integrity_security_scanning := false
integrity_security_scanning if {
	input.ci_cd.has_security_scanning == true
}

default integrity_sbom := false
integrity_sbom if {
	input.ci_cd.has_sbom == true
}

data_integrity_passed if {
	integrity_security_scanning
	integrity_sbom
}

default data_integrity_passed := false

# ----------------------------------------------------------
# §164.312(e)(1) – Transmission Security
# ----------------------------------------------------------

default transmission_tls_version := false
transmission_tls_version if {
	version := tls_versions[input.encryption.tls_version]
	version >= 12
}

transmission_security_passed if {
	transmission_tls_version
}

default transmission_security_passed := false

# ----------------------------------------------------------
# Compliance Report – aggregated output
# ----------------------------------------------------------

checks := [
	{
		"name": "§164.312(d) - Code Review Required",
		"passed": access_control_require_reviews,
		"description": "Changes to ePHI systems must require peer review approval",
	},
	{
		"name": "§164.312(d) - Admin Enforcement",
		"passed": access_control_enforce_admins,
		"description": "Branch protection rules must apply to administrators",
	},
	{
		"name": "§164.312(a)(2)(iv) - Encryption at Rest",
		"passed": encryption_at_rest,
		"description": "ePHI must be encrypted when stored at rest",
	},
	{
		"name": "§164.312(e)(2)(ii) - Encryption in Transit",
		"passed": encryption_in_transit,
		"description": "ePHI must be encrypted during transmission",
	},
	{
		"name": "§164.312(e)(2)(ii) - TLS Version",
		"passed": encryption_tls_version,
		"description": "TLS version must be 1.2 or higher for ePHI transmission",
	},
	{
		"name": "§164.312(b) - Audit Logging",
		"passed": audit_logging_enabled,
		"description": "Audit logging must be enabled to track access to ePHI",
	},
	{
		"name": "§164.312(b) - Log Retention",
		"passed": audit_log_retention,
		"description": "Audit logs must be retained for at least 90 days",
	},
	{
		"name": "§164.312(c) - Security Scanning",
		"passed": integrity_security_scanning,
		"description": "Security scanning must be enabled to protect ePHI integrity",
	},
	{
		"name": "§164.312(c) - SBOM Generation",
		"passed": integrity_sbom,
		"description": "Software Bill of Materials must be generated for supply chain integrity",
	},
	{
		"name": "§164.312(e)(1) - Transmission Security",
		"passed": transmission_tls_version,
		"description": "Transmission channels must use TLS 1.2 or higher",
	},
]

passed_checks := [c | some c in checks; c.passed == true]
failed_checks := [c | some c in checks; c.passed == false]

overall_status := "PASS" if {
	count(failed_checks) == 0
}

default overall_status := "FAIL"

compliance_report := {
	"framework": "HIPAA Security Rule",
	"status": overall_status,
	"checks": checks,
	"summary": {
		"total": count(checks),
		"passed": count(passed_checks),
		"failed": count(failed_checks),
	},
}
