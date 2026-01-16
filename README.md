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

### Other Files

- **`GEMINI.md`** - Sisyphus orchestrator configuration
- **`flappy-bird.html`** - Demo game with advanced features
- **`sync-to-github.sh`** - Multi-machine sync script

---

## 🔧 Setup on a New Machine

### 1. Clone the Repository

```bash
git clone https://YOUR_USERNAME@github.com/YOUR_USERNAME/antigravity-skills.git
cd antigravity-skills
```

When prompted for password, enter your **Personal Access Token** (not your GitHub password).

### 2. Generate a Personal Access Token (if needed)

1. Go to [GitHub Settings → Tokens](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. Name: `antigravity-skills`
4. Scope: ✅ `repo`
5. Generate and **copy immediately**

### 3. Configure macOS Keychain (optional)

```bash
./setup-github-https.sh
```

This saves your token securely so you don't re-enter it.

---

## 🔄 Sync Commands

| Command | Description |
|---------|-------------|
| `./sync-to-github.sh push "message"` | Upload changes to GitHub |
| `./sync-to-github.sh pull` | Download latest from GitHub |
| `./sync-to-github.sh sync` | Pull then push (full sync) |
| `./sync-to-github.sh status` | Show git status |
| `./sync-to-github.sh clone` | Show clone command |

### Examples

```bash
# Push your changes
./sync-to-github.sh push "Added new skill"

# Get latest from another machine
./sync-to-github.sh pull

# Full sync (pull + push)
./sync-to-github.sh sync "Merged updates"
```

---

## 🎯 Multi-Machine Workflow

```
┌─────────────────┐         ┌─────────────────┐
│   Machine A     │         │   Machine B     │
│                 │         │                 │
│  Make changes   │         │                 │
│       ↓         │         │                 │
│  ./sync push    │ ──────► │  ./sync pull    │
│                 │  GitHub │       ↓         │
│                 │         │  Make changes   │
│                 │         │       ↓         │
│  ./sync pull    │ ◄────── │  ./sync push    │
└─────────────────┘         └─────────────────┘
```

---

## 📁 Directory Structure

```
antigravity-skills/
├── .agent/
│   └── skills/
│       ├── algorithm-engineer/SKILL.md
│       ├── background-tasks/SKILL.md
│       ├── cloud-architect/SKILL.md
│       ├── debugger/SKILL.md
│       ├── document-writer/SKILL.md
│       ├── explore/SKILL.md
│       ├── frontend-ui-ux/SKILL.md
│       ├── git-master/SKILL.md
│       ├── librarian/SKILL.md
│       ├── mobile-developer/SKILL.md
│       ├── oracle/SKILL.md
│       └── security-researcher/SKILL.md
├── GEMINI.md              # Sisyphus orchestrator config
├── flappy-bird.html       # Demo game
├── setup-github-https.sh  # Credential setup script
├── sync-to-github.sh      # Sync script
└── README.md              # This file
```

---

## 🧠 Using the Skills

Skills are automatically detected by Antigravity based on task type. You can also reference them explicitly:

```
"Use the debugger skill to fix this bug"
"Apply frontend-ui-ux patterns to improve this UI"
```

### Magic Words

| Trigger | Effect |
|---------|--------|
| `ultrawork` / `ulw` | Maximum parallelization |
| `deep` | Use Deep Think model |
| `quick` | Use Flash model for speed |
| `iterate` | Extended debugging loops |
| `research` | Prioritize external research |

---

## 📝 License

Private repository. All rights reserved.
