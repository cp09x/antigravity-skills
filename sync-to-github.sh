#!/bin/bash
# =============================================================================
# GitHub Sync Script for Antigravity Skills
# Uses HTTPS with Personal Access Token (not SSH)
# =============================================================================

set -e

# Configuration - UPDATE THESE VALUES
GITHUB_USERNAME="cp09x"  # Your GitHub username
REPO_NAME="antigravity-skills"           # Replace with your repo name

# Auto-detect the repository directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Change to the repository directory
cd "$REPO_DIR" || {
    print_error "Could not find repository directory: $REPO_DIR"
    exit 1
}

print_step "Working in: $(pwd)"

# Check if git is initialized
if [ ! -d ".git" ]; then
    print_step "Initializing git repository..."
    git init
    print_success "Git initialized"
fi

# Check if remote exists
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

if ! git remote get-url origin &>/dev/null; then
    print_step "Adding remote origin (HTTPS)..."
    git remote add origin "$REMOTE_URL"
    print_success "Remote added: $REMOTE_URL"
else
    CURRENT_REMOTE=$(git remote get-url origin)
    if [[ "$CURRENT_REMOTE" == git@* ]]; then
        print_warning "Current remote uses SSH, switching to HTTPS..."
        git remote set-url origin "$REMOTE_URL"
        print_success "Remote updated to HTTPS: $REMOTE_URL"
    fi
fi

# Create/update .gitignore
if [ ! -f ".gitignore" ]; then
    print_step "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~
.idea/
.vscode/

# Node modules (if any)
node_modules/

# Logs
*.log

# Temporary files
*.tmp
*.temp

# Build artifacts
dist/
build/

# Environment files (keep secrets out!)
.env
.env.local
EOF
    print_success ".gitignore created"
fi

# Stage all changes
print_step "Staging changes..."
git add -A

# Check if there are changes to commit
if git diff --cached --quiet; then
    print_warning "No changes to commit"
else
    # Get commit message
    if [ -n "$1" ]; then
        COMMIT_MSG="$1"
    else
        COMMIT_MSG="Update skills - $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    print_step "Committing: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
    print_success "Changes committed"
fi

# Push to remote
print_step "Pushing to GitHub..."
echo ""
echo -e "${YELLOW}When prompted for password, use your Personal Access Token (NOT your GitHub password)${NC}"
echo ""

# Try to push
if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
    print_success "Successfully pushed to GitHub!"
else
    # If branch doesn't exist, create it
    BRANCH=$(git branch --show-current)
    print_step "Pushing branch: $BRANCH"
    git push -u origin "$BRANCH"
    print_success "Successfully pushed to GitHub!"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Sync complete!${NC}"
echo -e "${GREEN}  View at: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
echo -e "${GREEN}========================================${NC}"
