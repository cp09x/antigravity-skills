---
name: oracle
description: Architecture review, code review, and strategic technical decisions. Use for design validation, quality assessment, and high-level technical guidance. Best with Gemini 3 Deep Think or Claude Opus 4.5 for maximum reasoning depth.
---

# Oracle Skill

Expert-level architecture and code review for strategic technical decisions.

## Model Selection

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| **Deep architecture review** | **Gemini 3 Deep Think** | Maximum reasoning depth |
| **Trade-off analysis** | **Claude Opus 4.5** | Complex decision making |
| **Quick code review** | **Gemini 3 Pro** | Balance of speed and depth |

## When to Use This Skill

- Reviewing system architecture before implementation
- Evaluating design patterns and their trade-offs
- Conducting thorough code reviews
- Making strategic technical decisions
- Identifying potential issues before they become problems

## Architecture Review Process

### 1. Understand the Context

Before proposing changes:
- What problem is being solved?
- What are the constraints (performance, scalability, team expertise)?
- What are the non-functional requirements?
- What's the expected growth trajectory?

### 2. Evaluate Design Patterns

Consider appropriateness of:
- **Layered Architecture**: Separation of concerns
- **Event-Driven**: Loose coupling, async processing
- **Microservices vs Monolith**: Team size, deployment complexity
- **CQRS/Event Sourcing**: Audit requirements, complex domain

### 3. Identify Risks

Look for:
- Single points of failure
- Scalability bottlenecks
- Security vulnerabilities
- Technical debt accumulation
- Testing difficulties

## Code Review Guidelines

### Quality Dimensions

1. **Correctness**: Does it work as intended?
2. **Clarity**: Is it easy to understand?
3. **Maintainability**: Can it be modified safely?
4. **Performance**: Are there obvious inefficiencies?
5. **Security**: Are there vulnerabilities?

### Review Checklist

```markdown
- [ ] Error handling is comprehensive
- [ ] Edge cases are considered
- [ ] No hardcoded secrets or credentials
- [ ] Logging is appropriate for debugging
- [ ] Tests cover critical paths
- [ ] Documentation matches implementation
- [ ] No obvious performance issues
- [ ] Dependencies are justified
```

### Providing Feedback

Structure reviews as:
1. **Summary**: Overall assessment (1-2 sentences)
2. **Critical Issues**: Must-fix before merge
3. **Suggestions**: Improvements to consider
4. **Praise**: What was done well

## Decision Framework

When recommending solutions:

### Trade-off Analysis

| Option | Pros | Cons | Risk Level |
|--------|------|------|------------|
| Option A | ... | ... | Low/Med/High |
| Option B | ... | ... | Low/Med/High |

### Recommendation Format

```
**Recommendation**: [Clear choice]

**Rationale**: [Why this option]

**Implementation Notes**: [Key considerations]

**Risks & Mitigations**: [What could go wrong and how to prevent it]
```

## Best Practices

- Always explain the "why" behind recommendations
- Consider team expertise and project timeline
- Prefer simple solutions over clever ones
- Think about testing and debugging experience
- Consider future maintainers who will read this code
