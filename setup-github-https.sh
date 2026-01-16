#!/bin/bash
# =============================================================================
# Setup GitHub HTTPS credentials using macOS Keychain
# This stores your PAT securely so you don't have to enter it every time
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  GitHub HTTPS Credential Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Configure git to use macOS Keychain for credentials
echo -e "${BLUE}==>${NC} Configuring git to use macOS Keychain..."
git config --global credential.helper osxkeychain

echo -e "${GREEN}✓${NC} Git configured to use macOS Keychain"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "1. The first time you push, git will ask for your username and password"
echo "2. Enter your GitHub username"
echo "3. For password, paste your Personal Access Token (NOT your GitHub password)"
echo "4. macOS Keychain will save it securely for future use"
echo ""
echo -e "${BLUE}To generate a Personal Access Token:${NC}"
echo "   1. Go to: https://github.com/settings/tokens"
echo "   2. Click 'Generate new token (classic)'"
echo "   3. Name it (e.g., 'antigravity-skills')"
echo "   4. Select scope: 'repo' (full control of private repos)"
echo "   5. Generate and COPY the token immediately"
echo ""
echo -e "${GREEN}Done! Run ./sync-to-github.sh to push your changes.${NC}"
