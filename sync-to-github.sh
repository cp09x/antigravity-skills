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
GLOBAL_SKILLS_DIR="$HOME/.gemini/skills"
GLOBAL_GEMINI_FILE="$HOME/.gemini/GEMINI.md"

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
    echo "  install global     Copy skills to ~/.gemini/skills"
    echo "  install <path>     Copy skills to a specific project"
    echo "  link global        Symlink global skills (auto-updates)"
    echo "  link <path>        Symlink skills to a project"
    echo "  uninstall global   Remove global skills"
    echo "  uninstall <path>   Remove skills from a project"
    echo "  update             Pull latest + reinstall global (one step)"
    echo ""
    echo -e "${YELLOW}Info Commands:${NC}"
    echo "  list               Show installed locations and versions"
    echo "  info <skill>       Show skill description"
    echo "  info               List all skills with descriptions"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./sync-to-github.sh update              # Sync and reinstall"
    echo "  ./sync-to-github.sh info debugger       # Show debugger skill info"
    echo "  ./sync-to-github.sh install global      # Install all skills globally"
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
    
    # Copy GEMINI.md (orchestrator config)
    if [[ "$target" == "global" ]]; then
        # For global, copy to ~/.gemini/GEMINI.md
        if [ -f "$GEMINI_SOURCE" ]; then
            cp "$GEMINI_SOURCE" "$GLOBAL_GEMINI_FILE"
            print_success "GEMINI.md copied to: $GLOBAL_GEMINI_FILE"
        fi
    else
        # For projects, copy to project root
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
        mkdir -p "$(dirname "$GLOBAL_SKILLS_DIR")"
        ln -s "$link_source" "$target_path"
        print_success "Symlink created: $target_path -> $link_source"
        
        # Also link GEMINI.md for global
        if [ -f "$GEMINI_SOURCE" ]; then
            if [ -L "$GLOBAL_GEMINI_FILE" ]; then
                rm "$GLOBAL_GEMINI_FILE"
            fi
            ln -s "$GEMINI_SOURCE" "$GLOBAL_GEMINI_FILE"
            print_success "Symlink created: $GLOBAL_GEMINI_FILE -> $GEMINI_SOURCE"
        fi
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
    
    # Also remove GEMINI.md if it exists
    if [[ "$target" == "global" ]]; then
        if [ -L "$GLOBAL_GEMINI_FILE" ] || [ -f "$GLOBAL_GEMINI_FILE" ]; then
            rm "$GLOBAL_GEMINI_FILE"
            print_success "Removed: $GLOBAL_GEMINI_FILE"
        fi
    else
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
    
    # Show version info
    echo -e "${YELLOW}Source Version:${NC} $(get_version_info)"
    echo ""
    
    # Check global skills
    if [ -L "$GLOBAL_SKILLS_DIR" ]; then
        local link_target=$(readlink "$GLOBAL_SKILLS_DIR")
        echo -e "${GREEN}●${NC} Global Skills (symlink): $GLOBAL_SKILLS_DIR -> $link_target"
    elif [ -d "$GLOBAL_SKILLS_DIR" ]; then
        local skill_count=$(ls -1 "$GLOBAL_SKILLS_DIR" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}●${NC} Global Skills (copy): $GLOBAL_SKILLS_DIR ($skill_count skills)"
    else
        echo -e "${YELLOW}○${NC} Global Skills: Not installed"
    fi
    
    # Check global GEMINI.md
    if [ -L "$GLOBAL_GEMINI_FILE" ]; then
        echo -e "${GREEN}●${NC} Global GEMINI.md (symlink): $GLOBAL_GEMINI_FILE"
    elif [ -f "$GLOBAL_GEMINI_FILE" ]; then
        echo -e "${GREEN}●${NC} Global GEMINI.md (copy): $GLOBAL_GEMINI_FILE"
    else
        echo -e "${YELLOW}○${NC} Global GEMINI.md: Not installed"
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

# Get current git commit info
get_version_info() {
    if [ -d "$REPO_DIR/.git" ]; then
        local commit=$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
        local date=$(git -C "$REPO_DIR" log -1 --format=%cd --date=short 2>/dev/null || echo "unknown")
        echo "$commit ($date)"
    else
        echo "not a git repo"
    fi
}

# Update command: pull + install global
do_update() {
    print_step "Updating Antigravity Skills..."
    echo ""
    
    # Pull latest
    do_pull
    echo ""
    
    # Reinstall globally
    do_install_copy "global"
    
    echo ""
    print_success "Update complete!"
    print_info "Version: $(get_version_info)"
}

# Info command: show skill descriptions
do_info() {
    local skill_name="$1"
    
    if [ -z "$skill_name" ]; then
        # List all skills with descriptions
        echo ""
        echo -e "${CYAN}Available Skills${NC}"
        echo ""
        
        for skill_dir in "$SKILLS_SOURCE"/*/; do
            if [ -d "$skill_dir" ]; then
                local name=$(basename "$skill_dir")
                local skill_file="$skill_dir/SKILL.md"
                
                if [ -f "$skill_file" ]; then
                    # Extract description from YAML frontmatter
                    local desc=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^description:" | sed 's/^description: *//')
                    if [ -z "$desc" ]; then
                        desc="No description"
                    fi
                    printf "  ${GREEN}%-20s${NC} %s\n" "$name" "$desc"
                else
                    printf "  ${YELLOW}%-20s${NC} (no SKILL.md)\n" "$name"
                fi
            fi
        done
        echo ""
    else
        # Show specific skill info
        local skill_dir="$SKILLS_SOURCE/$skill_name"
        local skill_file="$skill_dir/SKILL.md"
        
        if [ ! -d "$skill_dir" ]; then
            print_error "Skill not found: $skill_name"
            echo ""
            echo "Available skills:"
            ls -1 "$SKILLS_SOURCE" 2>/dev/null | sed 's/^/  /'
            exit 1
        fi
        
        echo ""
        echo -e "${CYAN}$skill_name${NC}"
        echo "$(printf '%.0s─' {1..40})"
        
        if [ -f "$skill_file" ]; then
            # Extract frontmatter info
            local desc=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep "^description:" | sed 's/^description: *//')
            
            echo -e "${YELLOW}Description:${NC} ${desc:-No description}"
            echo -e "${YELLOW}Location:${NC}    $skill_file"
            
            # Count lines (rough size indicator)
            local lines=$(wc -l < "$skill_file" | tr -d ' ')
            echo -e "${YELLOW}Size:${NC}        $lines lines"
            
            echo ""
            echo -e "${YELLOW}Preview:${NC}"
            # Show first 10 non-frontmatter lines
            sed -n '/^---$/,/^---$/!p' "$skill_file" | head -10 | sed 's/^/  /'
            echo "  ..."
        else
            print_warning "No SKILL.md found in $skill_dir"
        fi
        echo ""
    fi
}

# ============================================================================
# Interactive Menu
# ============================================================================

do_menu() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     Antigravity Skills Manager         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Git Commands:${NC}"
    echo "  1) push        Push local changes to GitHub"
    echo "  2) pull        Pull latest changes from GitHub"
    echo "  3) sync        Pull then push (full sync)"
    echo "  4) status      Show git status"
    echo ""
    echo -e "${YELLOW}Install Commands:${NC}"
    echo "  5) install     Install skills globally"
    echo "  6) link        Symlink skills globally (auto-updates)"
    echo "  7) uninstall   Remove global skills"
    echo "  8) update      Pull latest + reinstall global"
    echo ""
    echo -e "${YELLOW}Info Commands:${NC}"
    echo "  9) list        Show installed locations"
    echo " 10) info        List all skills with descriptions"
    echo " 11) help        Show full help"
    echo ""
    echo "  0) exit"
    echo ""
    
    read -p "Select option [0-11]: " choice
    echo ""
    
    case "$choice" in
        1)
            read -p "Commit message (or press Enter for default): " msg
            do_push "${msg:-}"
            ;;
        2) do_pull ;;
        3)
            read -p "Commit message (or press Enter for default): " msg
            do_pull
            do_push "${msg:-}"
            ;;
        4) do_status ;;
        5) do_install_copy "global" ;;
        6) do_install_link "global" ;;
        7) do_uninstall "global" ;;
        8) do_update ;;
        9) do_list ;;
        10) do_info ;;
        11) show_help ;;
        0|q|Q|exit) 
            echo "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option: $choice"
            ;;
    esac
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
    update)
        do_update
        ;;
    list)
        do_list
        ;;
    info)
        do_info "$2"
        ;;
    clone)
        do_clone_info
        ;;
    help|--help|-h)
        show_help
        ;;
    menu)
        do_menu
        ;;
    "")
        do_menu
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
