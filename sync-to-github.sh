#!/bin/bash
# =============================================================================
# Antigravity Skills Manager
# Sync, install, and manage skills across machines and projects
# Uses HTTPS with Personal Access Token (not SSH)
# =============================================================================

set -e

# Configuration
GITHUB_USERNAME="cp09x"
REPO_NAME="antigravity-skills"
GLOBAL_SKILLS_DIR="$HOME/.antigravity/skills"

# Auto-detect the repository directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
SKILLS_SOURCE="$REPO_DIR/.agent/skills"
GEMINI_SOURCE="$REPO_DIR/GEMINI.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

show_help() {
    echo ""
    echo -e "${CYAN}Antigravity Skills Manager${NC}"
    echo ""
    echo "Usage: ./sync-to-github.sh [COMMAND] [OPTIONS]"
    echo ""
    echo -e "${YELLOW}Git Commands:${NC}"
    echo "  push [message]     Push local changes to GitHub"
    echo "  pull               Pull latest changes from GitHub"
    echo "  sync               Pull then push (full sync)"
    echo "  status             Show git status"
    echo ""
    echo -e "${YELLOW}Install Commands:${NC}"
    echo "  install global     Copy skills to ~/.antigravity/skills (available everywhere)"
    echo "  install <path>     Copy skills to a specific project"
    echo "  link global        Symlink global skills (auto-updates)"
    echo "  link <path>        Symlink skills to a project (auto-updates)"
    echo "  uninstall global   Remove global skills installation"
    echo "  uninstall <path>   Remove skills from a project"
    echo "  list               Show where skills are installed"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./sync-to-github.sh push \"Added new skill\""
    echo "  ./sync-to-github.sh install global"
    echo "  ./sync-to-github.sh install ~/projects/my-app"
    echo "  ./sync-to-github.sh link ~/projects/my-app"
    echo ""
}

REMOTE_URL="https://${GITHUB_USERNAME}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

cd "$REPO_DIR" || { print_error "Could not find repo: $REPO_DIR"; exit 1; }

# ============================================================================
# Git Functions
# ============================================================================

init_git() {
    if [ ! -d ".git" ]; then
        print_step "Initializing git repository..."
        git init
        git remote add origin "$REMOTE_URL"
        print_success "Git initialized"
    fi
}

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

do_pull() {
    print_step "Pulling latest changes from GitHub..."
    fix_remote
    if git pull origin master --rebase 2>/dev/null || git pull origin main --rebase 2>/dev/null; then
        print_success "Pull complete!"
    else
        print_warning "No remote branch found or already up to date"
    fi
}

do_push() {
    local msg="${1:-Update skills - $(date '+%Y-%m-%d %H:%M:%S')}"
    
    init_git
    fix_remote
    
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

do_status() {
    print_step "Git Status:"
    git status
    echo ""
    print_step "Remote:"
    git remote -v
}

# ============================================================================
# Install Functions
# ============================================================================

resolve_path() {
    local path="$1"
    if [[ "$path" == "global" ]]; then
        echo "$GLOBAL_SKILLS_DIR"
    elif [[ "$path" == /* ]]; then
        echo "$path"
    else
        echo "$(cd "$path" 2>/dev/null && pwd)" || echo "$PWD/$path"
    fi
}

do_install_copy() {
    local target="$1"
    local target_path
    
    if [[ "$target" == "global" ]]; then
        target_path="$GLOBAL_SKILLS_DIR"
        print_step "Installing skills globally to: $target_path"
    else
        target_path="$(resolve_path "$target")/.agent/skills"
        print_step "Installing skills to project: $target_path"
    fi
    
    # Create target directory
    mkdir -p "$target_path"
    
    # Copy skills
    if [ -d "$SKILLS_SOURCE" ]; then
        cp -R "$SKILLS_SOURCE"/* "$target_path/"
        print_success "Skills copied to: $target_path"
    else
        print_error "Skills source not found: $SKILLS_SOURCE"
        exit 1
    fi
    
    # Copy GEMINI.md for projects (not global)
    if [[ "$target" != "global" ]]; then
        local project_root="$(resolve_path "$target")"
        if [ -f "$GEMINI_SOURCE" ]; then
            cp "$GEMINI_SOURCE" "$project_root/"
            print_success "GEMINI.md copied to: $project_root"
        fi
    fi
    
    echo ""
    print_success "Installation complete!"
    print_info "Skills are now available at: $target_path"
}

do_install_link() {
    local target="$1"
    local target_path
    local link_source="$SKILLS_SOURCE"
    
    if [[ "$target" == "global" ]]; then
        target_path="$GLOBAL_SKILLS_DIR"
        print_step "Linking skills globally to: $target_path"
        
        # For global, link the entire skills folder
        if [ -L "$target_path" ]; then
            rm "$target_path"
        elif [ -d "$target_path" ]; then
            print_warning "Removing existing directory: $target_path"
            rm -rf "$target_path"
        fi
        mkdir -p "$(dirname "$target_path")"
        ln -s "$link_source" "$target_path"
        print_success "Symlink created: $target_path -> $link_source"
    else
        local project_root="$(resolve_path "$target")"
        target_path="$project_root/.agent/skills"
        
        print_step "Linking skills to project: $target_path"
        
        # Create .agent directory
        mkdir -p "$project_root/.agent"
        
        # Remove existing and create symlink
        if [ -L "$target_path" ]; then
            rm "$target_path"
        elif [ -d "$target_path" ]; then
            print_warning "Removing existing directory: $target_path"
            rm -rf "$target_path"
        fi
        
        ln -s "$link_source" "$target_path"
        print_success "Symlink created: $target_path -> $link_source"
        
        # Also link GEMINI.md
        local gemini_link="$project_root/GEMINI.md"
        if [ -f "$GEMINI_SOURCE" ]; then
            if [ -L "$gemini_link" ]; then
                rm "$gemini_link"
            elif [ -f "$gemini_link" ]; then
                print_warning "GEMINI.md already exists, skipping"
            else
                ln -s "$GEMINI_SOURCE" "$gemini_link"
                print_success "Symlink created: $gemini_link -> $GEMINI_SOURCE"
            fi
        fi
    fi
    
    echo ""
    print_success "Linking complete!"
    print_info "Changes to source skills will automatically propagate."
}

do_uninstall() {
    local target="$1"
    local target_path
    
    if [[ "$target" == "global" ]]; then
        target_path="$GLOBAL_SKILLS_DIR"
        print_step "Uninstalling global skills from: $target_path"
    else
        target_path="$(resolve_path "$target")/.agent/skills"
        print_step "Uninstalling skills from: $target_path"
    fi
    
    if [ -L "$target_path" ]; then
        rm "$target_path"
        print_success "Symlink removed: $target_path"
    elif [ -d "$target_path" ]; then
        rm -rf "$target_path"
        print_success "Directory removed: $target_path"
    else
        print_warning "Nothing to uninstall at: $target_path"
    fi
    
    # Also remove GEMINI.md if it's a symlink
    if [[ "$target" != "global" ]]; then
        local gemini_link="$(resolve_path "$target")/GEMINI.md"
        if [ -L "$gemini_link" ]; then
            rm "$gemini_link"
            print_success "Removed symlink: $gemini_link"
        fi
    fi
}

do_list() {
    echo ""
    echo -e "${CYAN}Antigravity Skills Installations${NC}"
    echo ""
    
    # Check global
    if [ -L "$GLOBAL_SKILLS_DIR" ]; then
        local link_target=$(readlink "$GLOBAL_SKILLS_DIR")
        echo -e "${GREEN}●${NC} Global (symlink): $GLOBAL_SKILLS_DIR -> $link_target"
    elif [ -d "$GLOBAL_SKILLS_DIR" ]; then
        local skill_count=$(ls -1 "$GLOBAL_SKILLS_DIR" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}●${NC} Global (copy): $GLOBAL_SKILLS_DIR ($skill_count skills)"
    else
        echo -e "${YELLOW}○${NC} Global: Not installed"
    fi
    
    # Check current project
    if [ -L "$SKILLS_SOURCE" ]; then
        local link_target=$(readlink "$SKILLS_SOURCE")
        echo -e "${GREEN}●${NC} Source repo (symlink): $SKILLS_SOURCE -> $link_target"
    elif [ -d "$SKILLS_SOURCE" ]; then
        local skill_count=$(ls -1 "$SKILLS_SOURCE" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}●${NC} Source repo: $SKILLS_SOURCE ($skill_count skills)"
    fi
    
    echo ""
    echo -e "${CYAN}Available Skills:${NC}"
    if [ -d "$SKILLS_SOURCE" ]; then
        for skill in "$SKILLS_SOURCE"/*/; do
            if [ -d "$skill" ]; then
                local name=$(basename "$skill")
                echo "  - $name"
            fi
        done
    fi
    echo ""
}

do_clone_info() {
    echo ""
    echo -e "${CYAN}To clone on a new machine:${NC}"
    echo ""
    echo "  git clone https://${GITHUB_USERNAME}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
    echo ""
    echo "Then enter your Personal Access Token when prompted."
    echo ""
}

# ============================================================================
# Main
# ============================================================================

case "${1:-}" in
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
    install)
        if [ -z "$2" ]; then
            print_error "Usage: ./sync-to-github.sh install <global|path>"
            exit 1
        fi
        do_install_copy "$2"
        ;;
    link)
        if [ -z "$2" ]; then
            print_error "Usage: ./sync-to-github.sh link <global|path>"
            exit 1
        fi
        do_install_link "$2"
        ;;
    uninstall)
        if [ -z "$2" ]; then
            print_error "Usage: ./sync-to-github.sh uninstall <global|path>"
            exit 1
        fi
        do_uninstall "$2"
        ;;
    list)
        do_list
        ;;
    clone)
        do_clone_info
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
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
