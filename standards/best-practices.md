# Development Best Practices

## Context

Global development guidelines for Agentic Project Workflow projects.

<conditional-block context-check="core-principles">
IF this Core Principles section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Core Principles already in context"
ELSE:
  READ: The following principles

## Core Principles

### Keep It Simple
- Implement code in the fewest lines possible
- Avoid over-engineering solutions
- Choose straightforward approaches over clever ones

### Optimize for Readability
- Prioritize code clarity over micro-optimizations
- Write self-documenting code with clear variable names
- Add comments for "why" not "what"

### DRY (Don't Repeat Yourself)
- Extract repeated business logic to private methods
- Extract repeated UI markup to reusable components
- Create utility functions for common operations

### File Structure
- Keep files focused on a single responsibility
- Group related functionality together
- Use consistent naming conventions
</conditional-block>

<conditional-block context-check="dependencies" task-condition="choosing-external-library">
IF current task involves choosing an external library:
  IF Dependencies section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Dependencies guidelines already in context"
  ELSE:
    READ: The following guidelines
ELSE:
  SKIP: Dependencies section not relevant to current task

## Dependencies

### Choose Libraries Wisely
When adding third-party dependencies for React Native/Expo:
- Verify Expo SDK compatibility and support
- Check for React Native version compatibility
- Select libraries with active maintenance:
  - Recent commits (within last 6 months)
  - Active issue resolution
  - Good documentation
  - TypeScript support
- Prefer Expo-compatible libraries when available
- Check bundle size impact on app performance
</conditional-block>

<conditional-block context-check="react-native-performance" task-condition="performance-optimization">
IF current task involves performance optimization:
  IF React Native Performance section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using React Native Performance guidelines already in context"
  ELSE:
    READ: The following performance guidelines
ELSE:
  SKIP: Performance guidelines not relevant to current task

## React Native Performance Guidelines

### Component Optimization
- Use React.memo for components with stable props
- Implement useCallback for event handlers passed to children
- Use useMemo for expensive calculations
- Avoid creating objects/arrays in render methods

### List Performance
- Use FlatList/SectionList for large data sets
- Implement proper keyExtractor functions
- Use getItemLayout when item heights are fixed
- Configure appropriate initialNumToRender and windowSize

### Image Optimization
- Always specify image dimensions to prevent layout shifts
- Use appropriate resizeMode for different use cases
- Implement progressive image loading for large images
- Consider using FastImage for better caching

### Navigation Performance
- Use lazy loading for screen components
- Implement proper focus/blur listeners for expensive operations
- Avoid heavy computations during transitions

### Memory Management
- Remove event listeners in cleanup functions
- Cancel ongoing API requests when components unmount
- Use weak references where appropriate
- Monitor and address memory leaks in development
</conditional-block>

<conditional-block context-check="mobile-best-practices" task-condition="mobile-development">
IF current task involves mobile app development:
  IF Mobile Best Practices section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Mobile Best Practices already in context"
  ELSE:
    READ: The following mobile development guidelines
ELSE:
  SKIP: Mobile best practices not relevant to current task

## Mobile Development Best Practices

### User Experience
- Design for touch interactions (minimum 44pt touch targets)
- Implement proper loading states and feedback
- Handle network connectivity gracefully
- Provide offline functionality where possible
- Use platform-appropriate navigation patterns

### Platform Integration
- Follow platform-specific design guidelines (iOS HIG, Material Design)
- Implement proper deep linking
- Handle platform permissions appropriately
- Use native modules sparingly and wisely
- Test on both platforms throughout development

### Security
- Store sensitive data securely (Keychain/Keystore)
- Implement proper authentication flows
- Use HTTPS for all network requests
- Validate all user inputs
- Implement proper certificate pinning for production

### Accessibility
- Provide meaningful accessibility labels
- Support screen readers properly
- Ensure proper color contrast ratios
- Test with accessibility tools
- Support dynamic font sizes
</conditional-block>

<conditional-block context-check="testing-best-practices" task-condition="testing">
IF current task involves writing or updating tests:
  IF Testing Best Practices section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Testing Best Practices already in context"
  ELSE:
    READ: The following testing best practices
ELSE:
  SKIP: Testing best practices not relevant to current task

## Testing Best Practices

### Testing Philosophy
Follow the testing pyramid approach:
- **Unit Tests (70%)**: Fast, isolated tests for individual functions and components
- **Integration Tests (20%)**: Test multiple components working together
- **E2E Tests (10%)**: Full user workflows with Playwright (web) and Maestro (mobile)

### Test Organization
- Place test files side-by-side with source code for easy maintenance
- Use descriptive test names that explain the expected behavior
- Group related tests using `describe` blocks
- Keep tests focused on a single behavior per test case

### React Native Testing Considerations
- Test component behavior, not implementation details
- Use React Native Testing Library queries (getByText, getByRole, etc.)
- Test user interactions (press, type, scroll) rather than internal state
- Mock external dependencies (navigation, API calls, native modules)
- Test both iOS and Android specific behaviors when applicable

### Performance and Reliability
- Keep tests fast by avoiding unnecessary async operations
- Use proper cleanup in `afterEach` and `afterAll` hooks
- Mock expensive operations (network calls, file system, animations)
- Run tests in isolation - each test should be independent
- Use `waitFor` for async operations instead of arbitrary timeouts

### Test Data Management
- Use factories or builders for creating test data
- Keep test data minimal and focused on the scenario being tested
- Use realistic but safe test data (no real user information)
- Create reusable mock data in `__mocks__` directories

### Regression Testing
- Add regression tests as regular test cases with descriptive names
- Include bug ticket references in comments: `// Regression test for #123`
- Focus regression tests on the specific bug scenario
- Ensure regression tests would have caught the original bug
</conditional-block>

<conditional-block context-check="timing-and-delays" task-condition="timers-delays">
IF current task involves timers, delays, or async operations:
  IF Timing and Delays section already read in current context:
    SKIP: Re-reading this section
    NOTE: "Using Timing and Delays guidelines already in context"
  ELSE:
    READ: The following timing and delay guidelines
ELSE:
  SKIP: Timing guidelines not relevant to current task

## Timing and Delays

### Avoid Arbitrary Delays
**NEVER** use sleeps, timeouts, or delays except for legitimate cases:
- ✅ **Exponential backoff with jitter** for retry logic
- ✅ **Debouncing user input** (search, form validation)
- ✅ **Rate limiting** API calls
- ✅ **Animation timing** that matches design requirements

**❌ NEVER use delays for:**
- Waiting for API responses (use proper async/await)
- Fixing race conditions (identify and fix the root cause)
- Working around timing issues (fix the underlying problem)
- Arbitrary delays hoping something will "be ready"

### Proper Async Patterns
Use proper async patterns instead of delays:

```typescript
// ❌ Wrong: Using delays to wait
const fetchUserData = async () => {
  setLoading(true)
  await delay(1000) // Never do this!
  const user = await apiService.getUser()
  setUser(user)
  setLoading(false)
}

// ✅ Correct: Proper async handling
const fetchUserData = async () => {
  try {
    setLoading(true)
    const user = await apiService.getUser()
    setUser(user)
  } catch (error) {
    setError(error.message)
  } finally {
    setLoading(false)
  }
}
```

### Legitimate Timer Usage
When you DO need timers, centralize them for easy testing:

```typescript
// utils/timeHelpers.ts
export const delay = (ms: number): Promise<void> => {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

export const debounce = <T extends (...args: any[]) => void>(
  func: T,
  delay: number
): T => {
  let timeoutId: NodeJS.Timeout
  return ((...args: any[]) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => func(...args), delay)
  }) as T
}

export const exponentialBackoff = async <T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 1000
): Promise<T> => {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn()
    } catch (error) {
      if (attempt === maxRetries - 1) throw error
      
      // Exponential backoff with jitter
      const jitter = Math.random() * 0.1 * baseDelay
      const delayMs = Math.min(baseDelay * Math.pow(2, attempt) + jitter, 30000)
      await delay(delayMs)
    }
  }
  throw new Error('Max retries exceeded')
}
```

### Testing Timer-Dependent Code
Always mock timers in tests to make them fast and deterministic:

```typescript
// utils/__mocks__/timeHelpers.ts - Jest manual mock
export const delay = (ms: number): Promise<void> => {
  // Resolve immediately in tests instead of waiting
  return Promise.resolve()
}

export const debounce = <T extends (...args: any[]) => void>(
  func: T,
  delay: number
): T => {
  // Return function that calls immediately in tests
  return func
}

// In tests, use jest.useFakeTimers() for more control
```
</conditional-block>
