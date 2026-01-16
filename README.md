# 🚀 Antigravity Skills

A collection of specialized skills for the **Antigravity AI coding assistant**, orchestrated by **Sisyphus** - an intelligent task delegator that automatically routes work to the right expert.

## 📦 What's Included

### Skills (`.agent/skills/`)

| Skill | Description |
|-------|-------------|
| **algorithm-engineer** | Complex algorithms, physics, AI agents, optimization |
| **background-tasks** | Parallel task delegation with subagents |
| **cloud-architect** | AWS, GCP, Azure architecture & IaC |
| **debugger** | Iterative debugging with scientific method |
| **document-writer** | Technical writing, READMEs, API docs |
| **explore** | Fast codebase exploration & pattern matching |
| **frontend-ui-ux** | Beautiful UI with modern design patterns |
| **git-master** | Professional Git workflows |
| **librarian** | Documentation research & examples |
| **mobile-developer** | iOS, Android, Swift, Kotlin, Flutter |
| **oracle** | Architecture review & strategic decisions |
| **security-researcher** | Reverse engineering, pentesting, exploits |

---

## 🔧 Quick Start

### Clone the Repository

```bash
git clone https://YOUR_USERNAME@github.com/YOUR_USERNAME/antigravity-skills.git
cd antigravity-skills
```

### Install Skills Globally

```bash
./sync-to-github.sh install global
```

This copies skills to `~/.antigravity/skills/` - available for all projects.

### Install to a Specific Project

```bash
# Copy skills (independent copy)
./sync-to-github.sh install ~/projects/my-app

# Or symlink (auto-updates when source changes)
./sync-to-github.sh link ~/projects/my-app
```

---

## 📋 All Commands

### Git Commands

| Command | Description |
|---------|-------------|
| `./sync-to-github.sh push "msg"` | Push changes to GitHub |
| `./sync-to-github.sh pull` | Pull latest from GitHub |
| `./sync-to-github.sh sync` | Pull then push |
| `./sync-to-github.sh status` | Show git status |

### Install Commands

| Command | Description |
|---------|-------------|
| `./sync-to-github.sh install global` | Copy skills to ~/.antigravity/skills |
| `./sync-to-github.sh install <path>` | Copy skills to a project |
| `./sync-to-github.sh link global` | Symlink global (auto-updates) |
| `./sync-to-github.sh link <path>` | Symlink to project (auto-updates) |
| `./sync-to-github.sh uninstall global` | Remove global installation |
| `./sync-to-github.sh uninstall <path>` | Remove from project |
| `./sync-to-github.sh list` | Show installed locations |

---

## 🔄 Multi-Machine Workflow

```
┌─────────────────┐         ┌─────────────────┐
│   Machine A     │         │   Machine B     │
│                 │         │                 │
│  Make changes   │         │                 │
│       ↓         │         │                 │
│  ./sync push    │ ──────► │  ./sync pull    │
│                 │  GitHub │       ↓         │
│                 │         │  install global │
│                 │         │                 │
└─────────────────┘         └─────────────────┘
```

---

## 📁 Directory Structure

```
antigravity-skills/
├── .agent/skills/           # Source skills
│   ├── algorithm-engineer/
│   ├── cloud-architect/
│   ├── debugger/
│   └── ... (12 skills)
├── GEMINI.md                # Sisyphus orchestrator config
├── sync-to-github.sh        # Main management script
├── setup-github-https.sh    # Credential setup
└── README.md
```

---

## 🧠 Using Skills

Skills are automatically detected by Antigravity. You can also reference them explicitly:

```
"Use the debugger skill to fix this bug"
"Apply frontend-ui-ux patterns here"
```

### Magic Words

| Trigger | Effect |
|---------|--------|
| `ultrawork` | Maximum parallelization |
| `deep` | Deep Think model |
| `quick` | Flash model for speed |
| `iterate` | Extended debugging |
| `research` | Prioritize research |

---

## 🔐 HTTPS Authentication

This repo uses HTTPS with Personal Access Token (not SSH).

### Generate a Token

1. Go to [GitHub Settings → Tokens](https://github.com/settings/tokens)
2. Generate new token (classic)
3. Scope: ✅ `repo`
4. Copy and save securely

### Setup macOS Keychain

```bash
./setup-github-https.sh
```

---

## 📝 License

Private repository. All rights reserved.
