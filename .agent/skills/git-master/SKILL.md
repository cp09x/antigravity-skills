---
name: git-master
description: Professional Git workflows including atomic commits, semantic messages, rebase/squash operations, and history search. Use for any git operations requiring expertise.
---

# Git Master Skill

Professional Git workflows for clean history and effective collaboration.

## Model Selection

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| **Complex merges/rebases** | **Gemini 3 Pro** | Context understanding |
| **History analysis** | **Gemini 3 Flash** | Speed for searches |
| **Conflict resolution** | **Claude Opus 4.5** | Careful code understanding |

## When to Use This Skill

- Creating atomic, meaningful commits
- Interactive rebase and squash operations
- History search (blame, bisect, log -S)
- Branch management and merging strategies
- Resolving complex conflicts
- Recovering from git mistakes

## Commit Best Practices

### Atomic Commits

Each commit should:
- Represent ONE logical change
- Be independently revertable
- Pass all tests (if applicable)
- Include all related changes (code, tests, docs)

### Commit Message Format

Use conventional commits:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code change that neither fixes nor adds
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

#### Examples

```
feat(auth): add OAuth2 login support

Implement Google and GitHub OAuth providers.
Users can now authenticate using their existing accounts.

Closes #123
```

```
fix(api): handle null response from external service

The payment gateway occasionally returns null during
maintenance windows. Added defensive check.
```

## History Operations

### Finding When Something Changed

```bash
# Find commits that changed a specific string
git log -S "function_name" --oneline

# Find who last modified each line
git blame path/to/file.ts

# Find the commit that introduced a bug
git bisect start
git bisect bad HEAD
git bisect good v1.0.0
# Then test each commit git provides
```

### Cleaning Up History

```bash
# Interactive rebase last N commits
git rebase -i HEAD~N

# Common operations in interactive rebase:
# - pick: keep commit as-is
# - squash: combine with previous commit
# - reword: change commit message
# - edit: pause to amend commit
# - drop: remove commit
```

## Branch Strategies

### Feature Branches

```bash
# Create feature branch
git checkout -b feature/descriptive-name

# Keep up to date with main
git fetch origin
git rebase origin/main

# Before merging, squash if needed
git rebase -i origin/main
```

### Handling Conflicts

1. Don't panic
2. Understand both sides of the conflict
3. Make a conscious decision about resolution
4. Test after resolution
5. Continue the operation

## Recovery Operations

### Undo Last Commit (Keep Changes)
```bash
git reset --soft HEAD~1
```

### Discard Uncommitted Changes
```bash
git checkout -- path/to/file
# or discard all
git checkout -- .
```

### Recover Deleted Branch
```bash
git reflog
git checkout -b recovered-branch <commit-hash>
```

## Git Commands Reference

### Safe Commands (read-only)
```bash
git status
git log --oneline -n 20
git diff
git blame
git show <commit>
```

### Modifying Commands (use with care)
```bash
git add
git commit
git rebase
git reset
git push
```

## Best Practices

- Write commit messages for future readers
- Never rebase public/shared branches
- Test before committing
- Keep commits small and focused
- Use branches liberally
- Pull before push
