---
description: Execute implementation tasks for a specific feature specification
argument-hint: [spec-name] [task-number]
allowed-tools: Task(subagent_type:project-manager,context-fetcher,file-creator,git-workflow), Read, Write, Edit, Bash, Grep, Glob
---

# Execute Tasks

Execute implementation tasks for the specified feature specification following the structured 3-phase workflow.

## Usage

```
/execute-tasks [spec-name] [task-number]
```

**Arguments:**
- `spec-name` (optional): Name or path of the spec to execute tasks for
- `task-number` (optional): Specific task to execute (e.g., "2.1" for Task 2.1)

**Without arguments:** Execute the next uncompleted task from the most recent spec

## What This Command Does

1. **Phase 1: Pre-Execution Setup**
   - Identifies which tasks to execute from the specified spec
   - Gathers context using the context-fetcher agent
   - Prepares the implementation environment

2. **Phase 2: Task Execution Loop** 
   - Implements the identified tasks step by step
   - Uses specialized agents for file creation, git operations, etc.
   - Maintains progress tracking throughout implementation

3. **Phase 3: Post-Execution Tasks**
   - Validates implementation against acceptance criteria
   - Updates task tracking and documentation
   - Performs git workflow completion if ready

## Examples

```bash
# Execute next task from most recent spec
/execute-tasks

# Execute tasks for specific feature
/execute-tasks user-authentication

# Execute specific task number
/execute-tasks payment-system 2.1

# Execute from full spec path
/execute-tasks 2025-01-29-oauth-integration
```

## Related Commands

- `/create-tasks` - Create task list for a specification
- `/plan-product` - Set up product mission and roadmap
- `/resume-task` - Resume interrupted task execution

## Implementation Details

Detailed implementation rules and workflow steps are defined in:
@.agentic-workflow/instructions/core/execute-tasks.md
