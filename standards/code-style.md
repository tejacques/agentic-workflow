# Code Style Guide

## Context

Global code style rules for Agentic Project Workflow projects.

<conditional-block context-check="general-formatting">
IF this General Formatting section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using General Formatting rules already in context"
ELSE:
  READ: The following formatting rules

## General Formatting

### Indentation
- Use 4 spaces for indentation (never tabs)
- Maintain consistent indentation throughout files
- Align nested structures for readability

### Naming Conventions
- **Variables and Functions**: Use camelCase (e.g., `userProfile`, `calculateTotal`)
- **Components and Classes**: Use PascalCase (e.g., `UserProfile`, `PaymentProcessor`)
- **Constants**: Use UPPER_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)
- **Types and Interfaces**: Use PascalCase (e.g., `UserData`, `ApiResponse`)
- **Files**: Use PascalCase for components (e.g., `UserProfile.tsx`), camelCase for utilities (e.g., `apiClient.ts`)

### String Formatting
- Use single quotes for strings: `'Hello World'`
- Use template literals for multi-line strings or complex interpolation

### Code Comments
- Add brief comments above non-obvious business logic
- Document complex algorithms or calculations
- Explain the "why" behind implementation choices
- Never remove existing comments unless removing the associated code
- Update comments when modifying code to maintain accuracy
- Keep comments concise and relevant
</conditional-block>

<conditional-block task-condition="jsx-components" context-check="jsx-style">
IF current task involves writing or updating JSX/React Native components:
  IF jsx-style.md already in context:
    SKIP: Re-reading this file
    NOTE: "Using JSX style guide already in context"
  ELSE:
    <context_fetcher_strategy>
      IF current agent is Claude Code AND context-fetcher agent exists:
        USE: @agent:context-fetcher
        REQUEST: "Get JSX and React Native component rules from code-style/jsx-style.md"
        PROCESS: Returned style rules
      ELSE:
        READ: @docs/standards/code-style/jsx-style.md
    </context_fetcher_strategy>
ELSE:
  SKIP: JSX style guide not relevant to current task
</conditional-block>

<conditional-block task-condition="typescript" context-check="typescript-style">
IF current task involves writing or updating TypeScript:
  IF typescript-style.md already in context:
    SKIP: Re-reading this file
    NOTE: "Using TypeScript style guide already in context"
  ELSE:
    <context_fetcher_strategy>
      IF current agent is Claude Code AND context-fetcher agent exists:
        USE: @agent:context-fetcher
        REQUEST: "Get TypeScript style rules from code-style/typescript-style.md"
        PROCESS: Returned style rules
      ELSE:
        READ: @docs/standards/code-style/typescript-style.md
    </context_fetcher_strategy>
ELSE:
  SKIP: TypeScript style guide not relevant to current task
</conditional-block>

<conditional-block task-condition="react-native-paper" context-check="paper-style">
IF current task involves React Native Paper components or theming:
  IF react-native-paper-style.md already in context:
    SKIP: Re-reading this file
    NOTE: "Using React Native Paper style guide already in context"
  ELSE:
    <context_fetcher_strategy>
      IF current agent is Claude Code AND context-fetcher agent exists:
        USE: @agent:context-fetcher
        REQUEST: "Get React Native Paper theming and component rules from code-style/react-native-paper-style.md"
        PROCESS: Returned style rules
      ELSE:
        READ: @docs/standards/code-style/react-native-paper-style.md
    </context_fetcher_strategy>
ELSE:
  SKIP: React Native Paper style guide not relevant to current task
</conditional-block>

<conditional-block task-condition="testing" context-check="testing-style">
IF current task involves writing or updating tests:
  IF testing-style.md already in context:
    SKIP: Re-reading this file
    NOTE: "Using Testing style guide already in context"
  ELSE:
    <context_fetcher_strategy>
      IF current agent is Claude Code AND context-fetcher agent exists:
        USE: @agent:context-fetcher
        REQUEST: "Get Jest and TypeScript testing patterns from code-style/testing-style.md"
        PROCESS: Returned testing patterns
      ELSE:
        READ: @docs/standards/code-style/testing-style.md
    </context_fetcher_strategy>
ELSE:
  SKIP: Testing style guide not relevant to current task
</conditional-block>
