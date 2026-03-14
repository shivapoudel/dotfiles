#!/usr/bin/env bash
# setup-herd-shims.sh
#
# Creates POSIX shim scripts for Laravel Herd .bat commands so they work
# correctly in Git Bash — enabling `which php`, scripts calling `php`, and
# composer global binaries to all resolve without relying on shell aliases.
#
# Usage:
#   ./setup-herd-shims.sh
#
# What it does:
#   1. Creates ~/bin if it doesn't already exist
#   2. Verifies Herd bin directory exists and is in PATH
#   3. Discovers all .bat files in ~/.config/herd/bin
#   4. Writes a shim for each command and makes it executable
#
# Note: ~/bin is added to PATH by Git for Windows via /etc/profile.d/env.sh.

set -euo pipefail

RED=$(tput setaf 1 2>/dev/null || true)
CYAN=$(tput setaf 6 2>/dev/null || true)
RESET=$(tput sgr0 2>/dev/null || true)

# Home bin directory for shims.
BIN_DIR="$HOME/bin"

# Herd bin directory containing .bat command files.
HERD_BIN="$HOME/.config/herd/bin"

# Create ~/bin if it doesn't exist.
[[ -d "$BIN_DIR" ]] || mkdir "$BIN_DIR"

# Exit if Herd bin directory is missing or not in PATH.
[[ -d "$HERD_BIN" && ":$PATH:" == *":$HERD_BIN:"* ]] || {
  echo "${RED}✗ Herd bin not found or not in PATH. Is Laravel Herd installed?${RESET}"
  exit 1
}

# Collect all command names from .bat files in the Herd bin directory.
mapfile -t COMMANDS < <(find "$HERD_BIN" -maxdepth 1 -name "*.bat" -exec basename {} .bat \;)

# Write a shim for each command that forwards all arguments to its .bat file.
for cmd in "${COMMANDS[@]}"; do
  shim="$BIN_DIR/$cmd"
  printf '#!/usr/bin/env sh\nexec %s.bat "$@"\n' "$cmd" > "$shim"
  chmod +x "$shim"
done

echo "${CYAN}✓ Herd Shims — ${#COMMANDS[@]} shim(s) ready.${RESET}"
