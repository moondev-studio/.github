#!/usr/bin/env bash
# vault-fetch.sh — Fetch a single credential value from MoonDeveloper Vault
# Usage: ./vault-fetch.sh <vault_base_url> <key> <token>
# Output: raw credential value (stdout), exit 1 on failure

set -euo pipefail

VAULT_URL="${1:?vault_base_url required}"
KEY="${2:?key required}"               # e.g., "global.ios.distribution.p12" or "splitly.android.keystore"
TOKEN="${3:?token required}"

RESPONSE=$(curl -sf \
  -H "Authorization: Bearer ${TOKEN}" \
  "${VAULT_URL}/api/vault/credential?key=${KEY}" 2>/dev/null) \
  || { echo "ERROR: vault fetch failed for key=${KEY}" >&2; exit 1; }

VALUE=$(echo "${RESPONSE}" | python3 -c "import sys,json; print(json.load(sys.stdin)['value'])" 2>/dev/null) \
  || { echo "ERROR: could not parse vault response for key=${KEY}" >&2; exit 1; }

printf '%s' "${VALUE}"
