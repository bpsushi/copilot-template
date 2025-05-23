---
applyTo: "**"
---
# VS Code Copilot Memory Bank Instructions

## Core Principle
As a VS Code Copilot agent using Memory MCP, I must treat memory as my primary source of project knowledge. Each conversation starts fresh, so I MUST read and understand the entire memory bank before proceeding with any task. Memory is not optional - it's essential for effective assistance.

## Memory Bank Structure

The memory bank uses a hierarchical structure with these core memory keys:

### Essential Memory Keys (Always Required)
1. **`project_brief`** - Foundation document
2. **`active_context`** - Current work state and focus
3. **`system_patterns`** - Architecture and design patterns
4. **`tech_stack`** - Technologies and setup
5. **`progress_tracker`** - Status and next steps

### Optional Memory Keys (Create as needed)
- **`feature_specs`** - Detailed feature documentation
- **`api_docs`** - API specifications
- **`testing_strategy`** - Testing approaches
- **`deployment_notes`** - Deployment procedures
- **`user_preferences`** - User-specific preferences and decisions

## Core Workflows

### Session Start Protocol (MANDATORY)
```
1. Read ALL memory keys starting with essential ones
2. Verify project understanding
3. Identify current focus from active_context
4. Proceed with informed assistance
```

### Memory Read Sequence
```
project_brief → tech_stack → system_patterns → active_context → progress_tracker → [other keys as relevant]
```

### Memory Update Process
When updating memory (especially when user requests "update memory"):
1. Review ALL memory keys systematically
2. Update active_context with current state
3. Document any new patterns in system_patterns
4. Update progress_tracker with completed work
5. Record any new preferences or decisions

### Memory Update Triggers
Update memory when:
- User explicitly requests "update memory"
- Significant architectural decisions are made
- New patterns or preferences are established
- Features are completed or modified
- Technical setup changes
- Project scope or requirements evolve

## Operational Instructions

### Before Every Response
1. **Read Memory**: Always check relevant memory keys before responding
2. **Understand Context**: Ensure understanding of current project state
3. **Apply Patterns**: Use established patterns and preferences from memory

### After Significant Actions
1. **Update Memory**: Record new information, decisions, or patterns
2. **Maintain Context**: Keep active_context current with latest state
3. **Track Progress**: Update progress_tracker with completed work
