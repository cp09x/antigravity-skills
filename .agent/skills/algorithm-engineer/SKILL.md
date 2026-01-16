---
name: algorithm-engineer
description: Complex algorithm and physics problems including AI agents, simulations, prediction systems, and mathematical optimization. Research-first approach to algorithm design.
---

# Algorithm Engineer Skill

Expert-level algorithm design for complex logic, physics simulations, and autonomous agents.

## When to Use This Skill

- Autonomous agents (game AI, bots, automation)
- Physics simulations (gravity, collision, trajectory, fluid dynamics)
- Prediction algorithms (trajectory, state forecasting)
- State machine design
- Mathematical optimization (search, pathfinding, scheduling)
- Signal processing and pattern recognition

## CRITICAL: Research-First Approach

**NEVER start implementing a complex algorithm without research.**

### Research Strategy

```markdown
1. Search: "[problem domain] algorithm"
2. Search: "[problem type] implementation [language]"
3. Read: Academic papers or tutorials on the approach
4. Find: Working open-source implementations
5. Understand: The mathematical/theoretical foundation
```

### Why Research First?

- Prevents reinventing solved problems
- Reveals edge cases others have discovered
- Provides proven patterns to adapt
- Saves debugging time on fundamentally flawed approaches

## Physics Simulation Fundamentals

Understanding the physics model is ESSENTIAL for any simulation:

```markdown
1. Identify all forces: gravity, friction, thrust, drag
2. Understand integration method: Euler, Verlet, RK4
3. Know the time step: per-frame, fixed dt, variable
4. Account for all state variables: position, velocity, acceleration
```

**Key insight**: Simulation accuracy depends on correct physics modeling. Verify your model before optimizing behavior.

## Trajectory Prediction Pattern

Core technique for predictive decision-making:

```javascript
function predictState(framesAhead, action = null) {
    let state = cloneCurrentState();
    if (action) applyAction(state, action);
    
    for (let i = 0; i < framesAhead; i++) {
        applyPhysics(state);
    }
    
    return state;
}
```

**Use this to answer**: "If I take action X now, what will the state be at time T?"

## Common Algorithm Patterns

### Pattern 1: Threshold-Based (Simple)

```markdown
If condition exceeds threshold → take action
Otherwise → do nothing

Good for: Quick prototypes, simple control problems
Weakness: No prediction, purely reactive
```

### Pattern 2: Look-Ahead Prediction (Better)

```markdown
1. Predict future state without action
2. Predict future state with action
3. Compare: which leads to better outcome?
4. Take action only if it improves outcome

Good for: Avoiding obstacles, timing-sensitive decisions
Weakness: Single-action horizon
```

### Pattern 3: Multi-Step Planning (Best)

```markdown
1. Evaluate all possible action sequences
2. Simulate each sequence forward
3. Score final states by objective function
4. Execute first action of best sequence

Good for: Complex navigation, optimization
Weakness: Computational cost grows exponentially
```

## Common Algorithm Bugs

### Over-Actuation
**Symptom**: System oscillates or overshoots
**Cause**: No cooldown or hysteresis
**Fix**: Add minimum time between actions, commit to decisions

### Under-Reaction
**Symptom**: Misses targets, reacts too late
**Cause**: Prediction horizon too short
**Fix**: Increase look-ahead distance/time

### Drift/Instability
**Symptom**: Gradual error accumulation
**Cause**: Floating point errors or incorrect physics
**Fix**: Verify physics model matches reality, add reset conditions

### Local Optima
**Symptom**: Gets stuck in suboptimal behavior
**Cause**: Greedy decisions without exploration
**Fix**: Add randomness, longer planning horizon

## Implementation Checklist

```markdown
- [ ] Research existing solutions and approaches
- [ ] Understand the physics/mechanics model
- [ ] Implement state prediction function
- [ ] Add safety rails (bounds checking, emergency behaviors)
- [ ] Define objective/fitness function
- [ ] Add stabilization (cooldowns, hysteresis)
- [ ] Test with measurable metrics
- [ ] Iterate based on observed failures
```

## Testing Autonomous Agents

```markdown
1. Define quantitative success metrics
2. Run multiple trials for statistical significance
3. Record failures for analysis
4. Identify patterns in failure modes
5. Target worst failure mode first
6. Retest after each iteration
```

## Model Selection

**Use Claude Opus 4.5** for algorithm implementation:
- Best at complex multi-step reasoning
- Excellent at mathematical calculations
- Good at iterating on subtle bugs
