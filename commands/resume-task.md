---
description: "Resume interrupted task execution with full context restoration from session history"
argument-hint: "[task-identifier] [session-id]"
allowed-tools:
  - "Task(subagent_type:context-fetcher,project-manager)"
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
---

# Resume Task

Resume interrupted task execution with complete context restoration from session logs, ensuring seamless continuation of development work.

## Usage

```
/resume-task [task-identifier] [session-id]
```

**Arguments:**
- `task-identifier` (optional): Specific task to resume (e.g., "oauth-integration-2.1", "spec-name")
- `session-id` (optional): Specific session to resume from (defaults to most recent interrupted session)

## What This Command Does

1. **Context Restoration**: Fully reconstructs the development context from session logs:
   - Loads previous session state and progress tracking
   - Restores understanding of completed vs remaining work
   - Retrieves relevant specification and technical context
   - Identifies any discoveries or blockers from previous session

2. **Progress Assessment**: Analyzes current state against original plans:
   - Compares file system state with session expectations
   - Identifies any external changes that occurred during interruption
   - Validates that assumptions from previous session still hold
   - Updates task status based on actual current state

3. **Seamless Continuation**: Resumes work exactly where it left off:
   - Continues from the last incomplete step
   - Maintains the same technical approach and patterns
   - Preserves any in-progress architectural decisions
   - Applies lessons learned from previous session discoveries

## When to Use

**Perfect for:**
- Resuming work after interruptions (meetings, breaks, other priorities)
- Continuing complex multi-day implementations
- Picking up tasks after context switching to other projects
- Restarting after system crashes or unexpected terminations

**Not needed for:**
- Starting completely new tasks (use `/execute-tasks`)
- Simple one-step operations without context dependencies
- Tasks that were fully completed in previous sessions

## Examples

```bash
# Resume most recent interrupted task
/resume-task

# Resume specific task by name
/resume-task oauth-integration

# Resume from specific session
/resume-task payment-system session-2025-01-29-14-30

# Resume with full task identifier
/resume-task 2025-01-29-user-auth-2.1
```

## Context Restoration Process

The command reconstructs:

1. **Task Status**: Which specific steps were completed vs incomplete
2. **Technical Context**: Code patterns, architecture decisions, dependency choices  
3. **Discovery Context**: Any unexpected behaviors or constraints discovered
4. **Environment State**: File changes, git status, test results from previous session
5. **Next Actions**: Specific next steps that were identified but not yet executed

## Benefits

- **Zero Context Loss**: Resume exactly where you left off without re-analysis
- **Maintains Consistency**: Preserves technical patterns and architectural decisions
- **Leverages Discoveries**: Benefits from any debugging or learning from previous session
- **Efficient Restart**: No time wasted reconstructing context or re-reading documentation

## Session Management

Sessions are automatically managed in `.agentic-workflow/sessions/`:
- Current active session state is preserved
- Historical sessions provide context restoration points
- Progress tracking ensures accurate continuation
- Discovery logs inform resumed implementation approach

## Related Commands

- `/execute-tasks` - Start new task execution
- `/refine-context` - Extract learnings before session interruption
- `/create-spec` - Create new specifications for future task execution

## Implementation Details

Detailed context restoration process and session management are defined in:
@.agentic-workflow/instructions/core/resume-task.md
