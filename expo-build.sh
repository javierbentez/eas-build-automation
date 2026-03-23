#!/bin/bash

# ==============================================================================
# Script: Expo & EAS Build Automation
# Description: Streamlines cleaning, installing, and building for Expo projects.
# ==============================================================================

# Terminal Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Exit immediately if a command exits with a non-zero status
set -e

# Utility functions for feedback
info() { echo -e "${BLUE}${BOLD}i${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}✓${NC} $1"; }
warn() { echo -e "${YELLOW}${BOLD}⚠️  $1${NC}"; }
error() { echo -e "${RED}${BOLD}✖  $1${NC}"; exit 1; }

# 1. Dependency Validation
info "Checking required tools..."
command -v git >/dev/null 2>&1 || error "Git is not installed."
command -v npm >/dev/null 2>&1 || error "Node/NPM is not installed."
command -v eas >/dev/null 2>&1 || error "EAS CLI is not installed. Run: npm install -g eas-cli"

# 2. Interactive Configuration
echo -e "${BOLD}--- 🛠  BUILD CONFIGURATION ---${NC}"

# Platform Selection
PS3=$'\nSelect target platform (number): '
options_plat=("ios" "android" "all")
select opt_plat in "${options_plat[@]}"; do
    case $opt_plat in
        "ios"|"android"|"all") PLATFORM=$opt_plat; break;;
        *) warn "Invalid option.";;
    esac
done

# Profile Selection
PS3=$'\nSelect build profile (number): '
options_prof=("development" "preview" "production")
select opt_prof in "${options_prof[@]}"; do
    case $opt_prof in
        "development"|"preview"|"production") PROFILE=$opt_prof; break;;
        *) warn "Invalid option.";;
    esac
done

# Build Location Selection
PS3=$'\nWhere should the build run? (number): '
options_type=("Local (--local)" "Cloud (EAS Cloud)")
select opt_type in "${options_type[@]}"; do
    case $REPLY in
        1) BUILD_TYPE="local"; break;;
        2) BUILD_TYPE="cloud"; break;;
        *) warn "Invalid option.";;
    esac
done

echo -e "\n${BOLD}Summary:${NC} $PLATFORM | Profile: $PROFILE | Engine: $BUILD_TYPE\n"

# 3. Git Management
info "Syncing with remote repository..."
if ! git pull; then
    warn "Conflicts or uncommitted local changes detected."
    read -p "Do you want to DISCARD local changes (git checkout .) and continue? (y/n): " confirm
    if [[ "$confirm" == [yY] ]]; then
        git checkout .
        git pull
        success "Repository cleaned and updated."
    else
        error "Build aborted to protect your local work."
    fi
fi

# 4. Environment Preparation
info "Installing dependencies (npm install)..."
npm install > /dev/null
success "Dependencies installed."

info "Running expo prebuild..."
npx expo prebuild --platform "$PLATFORM" --clean
success "Prebuild finished."

# 5. Build Execution
info "Initializing EAS Build..."

FLAGS="--platform $PLATFORM --profile $PROFILE --non-interactive"

if [ "$BUILD_TYPE" == "local" ]; then
    FLAGS="$FLAGS --local"
fi

if [ "$PROFILE" == "production" ]; then
    FLAGS="$FLAGS --auto-submit"
    info "Production profile: --auto-submit enabled."
fi

# Final Execution
echo -e "${YELLOW}Running: eas build $FLAGS${NC}"
eas build $FLAGS

success "Process completed successfully!"
