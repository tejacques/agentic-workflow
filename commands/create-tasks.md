---
description: "Generate detailed task breakdown for feature implementation based on specifications"
argument-hint: "[spec-name] [focus-area]"
allowed-tools:
  - "Task(subagent_type:context-fetcher)"
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
---

# Create Tasks

Generate a comprehensive, actionable task breakdown for implementing a feature based on its detailed specification.

## Usage

```
/create-tasks [spec-name] [focus-area]
```

**Arguments:**
- `spec-name` (required): Name or path of the specification to create tasks for
- `focus-area` (optional): Specific area to focus task creation on ("api", "frontend", "database", "testing")

## What This Command Does

1. **Specification Analysis**: Thoroughly analyzes the feature specification:
   - Extracts user stories and converts them to implementable tasks
   - Identifies all scope items and creates corresponding implementation steps
   - Reviews technical requirements and dependencies
   - Considers integration points and architectural constraints

2. **Task Decomposition**: Breaks down high-level requirements into actionable tasks:
   - Creates parent tasks for major feature areas
   - Generates detailed sub-tasks for specific implementation work
   - Establishes clear dependencies and sequencing between tasks
   - Includes validation and testing requirements for each component

3. **Documentation Generation**: Produces comprehensive task documentation:
   - Updates or creates `tasks.md` with complete task breakdown
   - Links tasks back to original spec requirements for traceability  
   - Includes acceptance criteria for each task
   - Provides implementation hints and architectural guidance

## Generated Task Structure

```
# Main Feature Tasks
- [ ] Task 1: [Major Component] (Parent)
  - [ ] 1.1: [Specific Implementation Detail]
  - [ ] 1.2: [Related Implementation Step] 
  - [ ] 1.3: [Testing/Validation Step]
  
- [ ] Task 2: [Integration Component] (Parent)
  - [ ] 2.1: [API Integration]
  - [ ] 2.2: [Database Changes]
  - [ ] 2.3: [Frontend Implementation]

- [ ] Task 3: [Testing & Validation] (Parent)
  - [ ] 3.1: [Unit Testing]
  - [ ] 3.2: [Integration Testing]
  - [ ] 3.3: [End-to-End Validation]
```

## Examples

```bash
# Create tasks for OAuth integration spec
/create-tasks oauth-integration

# Focus on API implementation tasks
/create-tasks payment-system api

# Create frontend-focused tasks
/create-tasks user-dashboard frontend

# Full task breakdown for complex feature
/create-tasks 2025-01-29-real-time-chat
```

## Task Categories

### Implementation Tasks
- **Core Features**: Primary functionality implementation
- **API Endpoints**: REST/GraphQL endpoint creation and testing
- **Database Changes**: Schema changes, migrations, data access layers
- **UI Components**: Frontend components, pages, and user interactions

### Integration Tasks  
- **External APIs**: Third-party service integrations
- **Authentication**: Login, permissions, security implementations
- **Data Flow**: Inter-component communication and data management
- **Performance**: Optimization, caching, and scaling considerations

### Validation Tasks
- **Unit Tests**: Component-level testing coverage
- **Integration Tests**: Cross-system functionality validation  
- **User Acceptance**: Manual testing against original requirements
- **Error Handling**: Edge case and failure scenario coverage

## Best Practices

- **Atomic Tasks**: Each task should be completable in a focused work session
- **Clear Acceptance**: Every task includes specific completion criteria
- **Dependency Awareness**: Tasks are sequenced to minimize blockers
- **Testable Outcomes**: Each task produces verifiable results

## When to Use

**Perfect for:**
- Converting completed specs into implementable work
- Breaking down complex features into manageable chunks
- Planning development sprints and estimating effort
- Ensuring complete feature coverage from specifications

**Not needed for:**
- Simple, single-step implementations
- Exploratory or research activities
- Bug fixes and maintenance work

## Related Commands

- `/create-spec` - Create specifications before task breakdown
- `/execute-tasks` - Implement the tasks created by this command
- `/resume-task` - Continue task execution after interruptions

## Implementation Details

Detailed task creation process and templates are defined in:
@.agentic-workflow/instructions/core/create-tasks.md
