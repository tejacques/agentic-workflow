---
description: "Create a detailed feature specification with technical requirements and task breakdown"
argument-hint: "[feature-name] [user-story]"
allowed-tools:
  - "Task(subagent_type:context-fetcher,file-creator)"
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
---

# Create Spec

Create a comprehensive feature specification with detailed requirements, technical approach, and actionable task breakdown.

## Usage

```
/create-spec [feature-name] [user-story]
```

**Arguments:**
- `feature-name` (required): Name of the feature to spec (e.g., "user-authentication", "payment-system")
- `user-story` (optional): Brief user story or requirement description

## What This Command Does

1. **Requirement Gathering**: Analyzes the feature request and gathers context from existing documentation
2. **Specification Creation**: Generates comprehensive spec documentation including:
   - Main specification (`spec.md`) with user stories and scope
   - Lite summary (`spec-lite.md`) for quick reference
   - Technical specification (`technical-spec.md`) with implementation details
   - Task breakdown (`tasks.md`) with actionable implementation steps
3. **Integration**: Links the spec to existing product mission and technical stack
4. **Organization**: Creates properly dated and structured spec folders

## Generated Files

The command creates a complete spec structure:

```
.agentic-workflow/specs/YYYY-MM-DD-[feature-name]/
├── spec.md              # Main specification document
├── spec-lite.md         # Executive summary
├── tasks.md             # Implementation tasks
└── sub-specs/
    ├── technical-spec.md    # Technical requirements
    ├── database-schema.md   # Database changes (if needed)
    ├── api-spec.md         # API endpoints (if needed)
    └── tests.md            # Testing requirements
```

## Examples

```bash
# Create OAuth integration spec
/create-spec oauth-integration "Users need secure login with Google/GitHub"

# Create payment processing spec
/create-spec payment-system "Accept credit card payments for subscriptions"

# Create basic feature spec
/create-spec user-profiles

# Create complex integration spec
/create-spec real-time-chat "Users can send messages instantly to each other"
```

## Best Practices

- **Be Specific**: Provide clear, actionable feature names
- **Include Context**: Add user stories when possible for better requirements gathering
- **Review Dependencies**: The command will analyze existing specs for related requirements
- **Iterate**: Specs can be refined after creation using standard edit tools

## Related Commands

- `/plan-product` - Set up overall product strategy before creating specs
- `/analyze-product` - Analyze existing codebase to inform spec creation
- `/execute-tasks` - Implement the tasks created by this command
- `/create-tasks` - Create additional tasks for existing specs

## Implementation Details

Detailed spec creation rules and templates are defined in:
@.agentic-workflow/instructions/core/create-spec.md
