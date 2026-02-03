#!/usr/bin/env bash
set -euo pipefail

info() { echo -e "\033[1;36m[INFO]  $*\033[0m"; }
warn() { echo -e "\033[1;33m[WARN]  $*\033[0m"; }
error() { echo -e "\033[1;31m[ERROR] $*\033[0m"; }

# Get directory of this wrapper script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info "
=============================================================
Executing post container create setup.
=============================================================
"

# Running semantic-release setup
bash "$SCRIPT_DIR/semantic-release-setup.sh"

# Running pre-commit hooks installation
bash "$SCRIPT_DIR/precommit-hooks-install.sh"

info "
=============================================================
All post-create setup scripts completed successfully!
=============================================================
"
