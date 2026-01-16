---
name: explore
description: Fast codebase exploration and pattern matching. Use for quick file discovery, function lookups, dependency mapping, and understanding code structure.
---

# Explore Skill

Fast, efficient codebase exploration for understanding structure and finding relevant code.

## When to Use This Skill

- Understanding a new codebase quickly
- Finding files related to a feature
- Locating function/class definitions
- Mapping dependencies between modules
- Identifying entry points and key components

## Exploration Strategy

### 1. Start Broad, Then Focus

```
1. List top-level directories to understand project structure
2. Identify key configuration files (package.json, Cargo.toml, go.mod, etc.)
3. Find main entry points
4. Map the dependency tree for the area of interest
```

### 2. Use the Right Tool for Each Task

| Task | Preferred Tool |
|------|----------------|
| Find files by name | `find_by_name` |
| Search for patterns | `grep_search` |
| Understand file structure | `view_file_outline` |
| View specific code | `view_code_item` |
| List directory contents | `list_dir` |

### 3. Pattern Matching Tips

- Use `grep_search` with `IsRegex: false` for literal strings
- Use `grep_search` with `IsRegex: true` for patterns
- Filter by file type with `Includes: ["*.ts", "*.tsx"]`
- Search specific paths to narrow results

## Quick Exploration Commands

### Find All Files of a Type
```
find_by_name with Extensions: ["ts", "tsx"]
```

### Find Function Definitions
```
grep_search with Query: "function handleSubmit" or "def handle_submit"
```

### Map Imports
```
grep_search with Query: "from './module'" or "import { X } from"
```

## Output Format

When exploring, provide:
1. **Summary**: Brief overview of what was found
2. **Key Files**: Most important files discovered
3. **Recommendations**: What to look at next

## Best Practices

- Don't read entire files when outline is sufficient
- Use parallel tool calls when searching multiple patterns
- Start with small MaxDepth values, increase if needed
- Always provide context about why something is relevant
