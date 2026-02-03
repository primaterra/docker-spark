#!/usr/bin/env bash
set -euo pipefail


info() { echo -e "\033[1;36m[INFO] $*\033[0m" >&2; }
warn() { echo -e "\033[1;33m[WARN] $*\033[0m" >&2; }
error() { echo -e "\033[1;31m[ERROR] $*\033[0m" >&2; }


generate_toml_config() {
    # Generates pyproject.toml for python-semantic-release
    # if it does not exist.

    info "Generating pyproject.toml config..."

    if [ ! -f pyproject.toml ]; then
        info "pyproject.toml not found. Generating default config..."
        if semantic-release generate-config --pyproject > pyproject.toml; then
            info "Default config generated successfully."
        else
            error "Failed to generate config with semantic-release."
            exit 1
        fi
    else
        info "pyproject.toml already exists - skipping default config generation."
    fi
}


set_version_variables() {
    # Docstring: Enforces "tag-only" mode for python-semantic-release.

    # Default semantic-release:
    # (1) analyzes commits
    # (2) bumps version in files
    # (3) commits the bump
    # (4) creates Git tag + changelog.

    # Tag-only mode (version_variables = []): skips python specific file edits (2 & 3)

    info "Enforcing tag-only mode using version_variables = []..."

    sed -i '/^version_variables *=.*/d' pyproject.toml
    sed -i '/\[tool\.semantic_release\]/a version_variables = []' pyproject.toml

    if grep -q '^version_variables = \[\]$' pyproject.toml; then
        info "'version_variables' Successfully set."
    else
        error "Failed to insert version_variables = []. Check pyproject.toml manually."
        exit 1
    fi
}


set_version_mode() {

    info "Configuring semantic-release version mode (stable/development)..."

    local env_val="${SEMANTIC_RELEASE_IS_DEV:-}"
    local is_dev=false


    if [[ -z "$env_val" ]]; then
        info "SEMANTIC_RELEASE_IS_DEV not set in devcontainer - tagging repo as stable (v1.0.0+)"
    elif [[ "${env_val,,}" == "true" ]]; then
        is_dev=true
        info "SEMANTIC_RELEASE_IS_DEV=true - tagging repo as development mode (v0.x.x+)."
    else
        info "SEMANTIC_RELEASE_IS_DEV='$env_val' -  tagging repo as stable (v1.0.0+)."
    fi

    local val_allow="false"
    local val_major="true"
    if $is_dev; then
        val_allow="true"
        val_major="false"
    fi

    # Remove any previous lines
    sed -i '/^allow_zero_version *=.*/d' pyproject.toml
    sed -i '/^major_on_zero *=.*/d' pyproject.toml

    # Insert in consistent order
    sed -i "/\[tool\.semantic_release\]/a allow_zero_version = $val_allow" pyproject.toml
    sed -i '/^allow_zero_version = /a major_on_zero = '"$val_major" pyproject.toml

    # Validate both lines
    if grep -q "^allow_zero_version = $val_allow\$" pyproject.toml && \
       grep -q "^major_on_zero = $val_major\$" pyproject.toml; then
        info "Version mode settings applied successfully."
    else
        error "Failed to apply version mode settings. Check pyproject.toml."
        exit 1
    fi
}


#======== MAIN ========

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_NAME="$(basename "$0")"

info "
=============================================================
Executing: $SCRIPT_PATH
Description: Generating config for python-semantic-release
Prequisites: python-semantic-release install via dockerfile.
=============================================================
"

generate_toml_config
# defaults to [] for non py repo
set_version_variables
# semanting tagging dev/prod
set_version_mode

info "Setup complete."
