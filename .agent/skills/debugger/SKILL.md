---
name: debugger
description: Iterative problem-solving with scientific method, hypothesis tracking, and verification testing. Use for complex bugs requiring multiple test-fix cycles.
---

# Debugger Skill

Expert-level iterative debugging using scientific method.

## When to Use This Skill

- Problems without obvious solutions
- Bugs requiring multiple fix attempts
- Issues needing verification testing (browser, unit tests, etc.)
- Complex logic or algorithm problems
- "It doesn't work and I don't know why"
- Performance issues requiring profiling

## Core Philosophy: Scientific Method

Debugging is hypothesis testing. Every fix attempt is an experiment.

```markdown
1. OBSERVE: What is the actual behavior vs expected?
2. HYPOTHESIZE: What could cause this discrepancy?
3. PREDICT: If my hypothesis is correct, what should happen when I fix it?
4. TEST: Make the fix, run verification
5. ANALYZE: Did reality match prediction?
6. ITERATE: Refine hypothesis based on results
```

## CRITICAL: Research Before Coding

**For algorithm/logic problems, ALWAYS research first:**

```markdown
1. Search web for established solutions
   - "[problem type] bug"
   - "[error message]"
   - "[symptom] cause"

2. Read official docs/tutorials

3. Find working examples in open source

4. Check issue trackers for similar problems

5. ONLY THEN start implementing fixes
```

This prevents wasting iterations on approaches that are fundamentally flawed.

## Iteration Tracking Template

Keep explicit track of each debugging attempt:

```markdown
## Iteration N
- **Hypothesis**: [What we think is wrong]
- **Change**: [Specific modification]
- **Test Result**: [What actually happened]
- **Learning**: [What this tells us]
```

**Why track failures?** Each failed attempt narrows the solution space. Knowing what DOESN'T work is as valuable as knowing what does.

## Verification Testing Patterns

### Browser-Based Testing
```markdown
1. Make ONE specific change
2. Launch browser test with clear observation criteria  
3. Watch for specific behaviors to confirm/deny hypothesis
4. Document actual vs expected
5. Screenshot or record key moments
```

### Unit/Integration Testing
```markdown
1. Write failing test that reproduces bug
2. Make minimal fix
3. Verify test passes
4. Check no regression in other tests
```

### Performance Testing
```markdown
1. Establish baseline metrics
2. Profile to identify bottleneck
3. Apply targeted optimization
4. Measure improvement
5. Verify no functionality regression
```

## Tool Selection by Phase

| Phase | Tools |
|-------|-------|
| Research | `search_web`, `read_url_content` |
| Analyze | `view_file`, `grep_search`, `view_code_item` |
| Fix | `replace_file_content`, `multi_replace_file_content` |
| Test | `browser_subagent`, `run_command` |
| Verify | Screenshots, console logs, test output |

## Common Debugging Patterns

### Algorithm Not Working
```markdown
1. Research: How is this algorithm supposed to work?
2. Trace: Log key values at each decision point
3. Compare: What does working implementation look like?
4. Isolate: Which specific calculation is wrong?
```

### Timing/Race Condition
```markdown
1. Add timestamps to key events
2. Increase delays to exaggerate the issue
3. Make the sequence explicit
4. Test with controlled timing
```

### State Management Bug
```markdown
1. Log state before and after operations
2. Identify unexpected state transitions
3. Find where state is incorrectly modified
4. Add guards or make state immutable
```

### UI/Visual Bug
```markdown
1. Screenshot the problem
2. Inspect element state in browser
3. Compare expected vs actual CSS/properties
4. Test fix visually
```

## Best Practices

- **Never give up after one failed attempt** - complex bugs need iteration
- **Track what doesn't work** - this is valuable data
- **Research existing solutions** - someone has likely solved this before
- **Test one thing at a time** - makes results interpretable
- **Keep iterations focused** - each attempt should test ONE hypothesis
- **Document learnings** - build knowledge for future debugging
