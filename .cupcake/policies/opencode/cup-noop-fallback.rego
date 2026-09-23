# METADATA
# scope: package
# title: Fallback Skeleton Placeholder (input-gated, never fires)
# authors: ["Cupcake Global Policies"]
# custom:
#   severity: INFO
#   id: FALLBACK-NOOP-PLACEHOLDER
#   routing:
#     required_events: ["PreToolUse"]
package cupcake.policies.noop

import rego.v1

# The fallback skeleton carries global policies only. This placeholder exists
# so the project-local WASM bundle always contains at least two real modules:
# OPA's wasm compiler (v1.19.1, -O 2) panics when the aggregator is the only
# module in the bundle. The body references input, so the optimizer cannot
# prune it, and it is gated on a session id that no real session can ever
# carry - so the rule never fires anywhere, ever.
deny contains decision if {
	input.session_id == "cupcake-fallback-placeholder-session"
	decision := {
		"rule_id": "FALLBACK-NOOP-PLACEHOLDER",
		"reason": "Placeholder rule - input gate can never match a real session id.",
		"severity": "INFO",
	}
}
