#!/usr/bin/env bash
set -euo pipefail

info()  { echo -e "\033[1;36m[INFO]  $*\033[0m" >&2; }
warn()  { echo -e "\033[1;33m[WARN]  $*\033[0m" >&2; }
error() { echo -e "\033[1;31m[ERROR] $*\033[0m" >&2; }

SCRIPT_PATH="$(realpath "$0" 2>/dev/null || echo "$0")"

info "
=============================================================
Executing: $SCRIPT_PATH
Description: Setting up pre-commit hooks in this repository.
Prerequisite: pre-commit installation via dockerfile.
=============================================================
"

info "Checking if pre-commit command is available..."
if ! command -v pre-commit >/dev/null 2>&1; then
    error "pre-commit not found in PATH. Install it in Dockerfile first (pipx install pre-commit)."
    exit 1
fi

info "Checking if current directory is inside a git repository..."
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    warn "Not a git repository - skipping pre-commit hook installation."
    info "Setup complete (nothing to do)."
    exit 0
fi

info "Installing pre-commit hooks (this adds automated checks before git commits)..."
pre-commit install

info "pre-commit hooks installed successfully!"
info "Hooks will now run automatically on 'git commit'."
info "Setup complete."
