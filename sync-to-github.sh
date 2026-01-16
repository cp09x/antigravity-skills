#!/bin/bash
# =============================================================================
# GitHub Sync Script for Antigravity Skills
# Uses HTTPS with Personal Access Token (not SSH)
# Handles both PUSH (upload changes) and PULL (download changes)
# =============================================================================

set -e

# Configuration
GITHUB_USERNAME="cp09x"
REPO_NAME="antigravity-skills"

# Auto-detect the repository directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

show_help() {
    echo ""
    echo "Usage: ./sync-to-github.sh [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  push [message]   Push local changes to GitHub (default)"
    echo "  pull             Pull latest changes from GitHub"
    echo "  sync             Pull then push (full sync)"
    echo "  status           Show git status"
    echo "  clone            Clone repo to current directory (for new machines)"
    echo ""
    echo "Examples:"
    echo "  ./sync-to-github.sh push \"Added new skill\""
    echo "  ./sync-to-github.sh pull"
    echo "  ./sync-to-github.sh sync"
    echo ""
}

cd "$REPO_DIR" || { print_error "Could not find repo: $REPO_DIR"; exit 1; }

REMOTE_URL="https://${GITHUB_USERNAME}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Initialize git if needed
init_git() {
    if [ ! -d ".git" ]; then
        print_step "Initializing git repository..."
        git init
        git remote add origin "$REMOTE_URL"
        print_success "Git initialized"
    fi
}

# Ensure remote URL is correct (HTTPS with username)
fix_remote() {
    if git remote get-url origin &>/dev/null; then
        CURRENT=$(git remote get-url origin)
        if [[ "$CURRENT" != "$REMOTE_URL" ]]; then
            git remote set-url origin "$REMOTE_URL"
            print_success "Remote URL updated"
        fi
    else
        git remote add origin "$REMOTE_URL"
    fi
}

# Pull changes from GitHub
do_pull() {
    print_step "Pulling latest changes from GitHub..."
    fix_remote
    if git pull origin master --rebase 2>/dev/null || git pull origin main --rebase 2>/dev/null; then
        print_success "Pull complete!"
    else
        print_warning "No remote branch found or already up to date"
    fi
}

# Push changes to GitHub
do_push() {
    local msg="${1:-Update skills - $(date '+%Y-%m-%d %H:%M:%S')}"
    
    init_git
    fix_remote
    
    # Create .gitignore if missing
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
.DS_Store
Thumbs.db
*.swp
*.swo
*~
.idea/
.vscode/
node_modules/
*.log
*.tmp
*.temp
dist/
build/
.env
.env.local
EOF
        print_success ".gitignore created"
    fi
    
    print_step "Staging changes..."
    git add -A
    
    if git diff --cached --quiet; then
        print_warning "No changes to commit"
    else
        print_step "Committing: $msg"
        git commit -m "$msg"
        print_success "Changes committed"
    fi
    
    print_step "Pushing to GitHub..."
    BRANCH=$(git branch --show-current)
    git push -u origin "$BRANCH"
    print_success "Pushed to GitHub!"
    
    echo ""
    echo -e "${GREEN}✓ View at: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
}

# Show status
do_status() {
    print_step "Git Status:"
    git status
    echo ""
    print_step "Remote:"
    git remote -v
}

# Clone command (for new machines)
do_clone() {
    echo ""
    echo -e "${BLUE}To clone on a new machine, run:${NC}"
    echo ""
    echo "  git clone https://${GITHUB_USERNAME}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
    echo ""
    echo "Then enter your Personal Access Token when prompted for password."
    echo ""
}

# Main
case "${1:-push}" in
    push)
        do_push "$2"
        ;;
    pull)
        do_pull
        ;;
    sync)
        do_pull
        do_push "$2"
        ;;
    status)
        do_status
        ;;
    clone)
        do_clone
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        # If first arg looks like a message, treat as push
        if [[ "$1" != -* ]]; then
            do_push "$1"
        else
            show_help
        fi
        ;;
esac
