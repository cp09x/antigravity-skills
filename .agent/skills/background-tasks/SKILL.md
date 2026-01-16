---
name: background-tasks
description: Parallel task delegation patterns using subagents. Use when work can be parallelized or when tasks should run in the background while you continue other work.
---

# Background Tasks Skill

Patterns for parallel task delegation and background execution.

## When to Use This Skill

- Tasks that can run independently in parallel
- Long-running operations that shouldn't block progress
- Multiple investigations that need to happen simultaneously
- Complex tasks that benefit from divide-and-conquer

## Core Concept: browser_subagent

Antigravity provides the `browser_subagent` tool for background task execution. Use it to:

- Perform browser automation in parallel
- Run long investigations without blocking
- Execute multiple independent tasks simultaneously

## Parallel Execution Patterns

### Pattern 1: Parallel Investigation

When you need to investigate multiple things:

```markdown
1. Start subagent A to investigate authentication flow
2. Start subagent B to analyze API patterns
3. Continue with your main task
4. Review results when subagents complete
```

### Pattern 2: Divide and Conquer

For large tasks that can be split:

```markdown
1. Break the task into independent chunks
2. Assign chunks to subagents
3. Coordinate results
4. Synthesize findings
```

### Pattern 3: Exploratory Parallelism

When multiple approaches might work:

```markdown
1. Start subagent exploring approach A
2. Start subagent exploring approach B
3. Compare results
4. Choose the better solution
```

## Task Decomposition

### Good Candidates for Parallelization

✅ Independent file searches
✅ Multiple API endpoint testing
✅ UI verification across different pages
✅ Research on different topics
✅ Testing different solutions

### Poor Candidates

❌ Tasks with dependencies on previous results
❌ Operations that modify shared state
❌ Sequential workflows
❌ Tasks requiring context from each other

## Subagent Task Definition

When delegating to a subagent, be specific:

```markdown
Task: [Clear, actionable description]
Context: [What the subagent needs to know]
Goal: [Specific outcome expected]
Return Condition: [When to consider task complete]
Output Format: [What information to return]
```

### Example Task Definition

```markdown
Task: Test the user registration flow in the browser
Context: The app is running at localhost:3000
Goal: Verify that new users can register successfully
Return Condition: When registration is confirmed or an error is found
Output Format: 
- Success/Failure status
- Steps taken
- Any errors encountered
- Screenshot of final state
```

## Coordination Strategies

### Fire and Forget

For tasks that don't need coordination:
- Launch subagent
- Continue with main work
- Check results later if needed

### Wait for Completion

For tasks that need results:
- Launch subagent(s)
- Wait for completion
- Use results for next steps

### Result Aggregation

For multiple parallel tasks:
- Launch multiple subagents
- Collect all results
- Synthesize findings
- Make decision based on aggregate

## Best Practices

### Task Sizing

- Tasks should be substantial enough to justify overhead
- But not so large they become hard to define
- Aim for 5-15 minute tasks typically

### Clear Boundaries

- Define exactly what the subagent should do
- Specify what files/areas they should focus on
- Set clear success criteria

### Error Handling

- Expect some tasks to fail
- Have fallback strategies
- Don't block on non-critical tasks

### Context Sharing

- Provide necessary context upfront
- Don't assume subagent knows project context
- Include relevant file paths, conventions

## Anti-Patterns to Avoid

### Over-Parallelization
❌ Starting too many subagents at once
✅ Start 2-3, add more if needed

### Vague Tasks
❌ "Look into the auth stuff"
✅ "Find where JWT tokens are validated and list the validation rules"

### Missing Return Conditions
❌ "Explore the codebase"
✅ "Explore the codebase and return when you've identified all API endpoints"

### Ignoring Dependencies
❌ Parallelizing tasks that depend on each other
✅ Sequence dependent tasks, parallelize independent ones

## Usage Example

```
I need to update the payment module. 

In parallel:
1. [Subagent 1] Explore how payments are currently implemented
2. [Subagent 2] Research best practices for payment integrations

While those run, I'll review the requirements document.

Once both complete, I'll synthesize findings and create the implementation plan.
```
