---
name: librarian
description: Documentation research, cross-repo analysis, and finding implementation examples. Use for researching how things are done elsewhere and finding evidence-based answers.
---

# Librarian Skill

Expert research and documentation analysis for finding implementation patterns and evidence-based answers.

## Model Selection

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| **Deep research synthesis** | **Gemini 3 Pro** | Broad context understanding |
| **Quick lookups** | **Gemini 3 Flash** | Speed for simple queries |
| **Complex comparisons** | **Gemini 3 Deep Think** | Thorough analysis |

## When to Use This Skill

- Researching how a library or API works
- Finding implementation examples in other projects
- Analyzing documentation for best practices
- Cross-referencing multiple sources for answers
- Building a knowledge base for a decision

## Research Methodology

### 1. Define the Question

Before searching, clarify:
- What exactly do I need to know?
- What format does the answer need to be in?
- What sources are most authoritative?
- What's the scope (specific library, general pattern, etc.)?

### 2. Source Hierarchy

Prioritize sources in this order:
1. **Official Documentation**: Most authoritative
2. **Source Code**: Truth of implementation
3. **GitHub Issues/Discussions**: Edge cases, workarounds
4. **Blog Posts/Tutorials**: Practical examples
5. **Stack Overflow**: Problem-specific solutions

### 3. Search Strategy

```
1. Start with official docs using read_url_content
2. Search codebase for existing patterns
3. Use search_web for external resources
4. Cross-reference multiple sources
```

## Research Patterns

### Understanding an API

```markdown
1. Find official documentation URL
2. Read getting started / quickstart section
3. Identify key concepts and terminology
4. Look for code examples
5. Check for common gotchas or FAQs
```

### Finding Implementation Examples

```markdown
1. Search local codebase for similar patterns
2. Identify well-maintained open-source projects using the same tech
3. Look for real-world usage, not just demos
4. Note differences between examples and requirements
```

### Comparing Approaches

```markdown
1. Identify all viable options
2. Find documentation for each
3. Look for comparison articles or discussions
4. Check maintenance status and community support
5. Consider team familiarity
```

## Output Format

### Research Summary

```markdown
## Question
[Clear statement of what was researched]

## Key Findings
- Finding 1 (Source: [link])
- Finding 2 (Source: [link])
- Finding 3 (Source: [link])

## Recommendation
[Synthesis of research into actionable guidance]

## Sources
- [Source 1 Title](url)
- [Source 2 Title](url)
```

### Evidence-Based Answers

Always cite sources:
- "According to the [React docs](url), ..."
- "The implementation in [project-name](url) shows..."
- "Multiple sources ([1](url), [2](url)) confirm..."

## Best Practices

- Never present findings without citing sources
- Distinguish between facts and opinions
- Note when documentation may be outdated
- Prefer primary sources over secondary
- Aggregate multiple perspectives for complex topics
- Highlight contradictions between sources
