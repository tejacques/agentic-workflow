# Testing Style Guide

## Context

Jest and React Native Testing Library patterns with proper TypeScript typing for Expo React Native projects.

<conditional-block context-check="jest-typescript-patterns">
IF this Jest TypeScript Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Jest TypeScript Patterns already in context"
ELSE:
  READ: The following Jest with TypeScript patterns

## Jest + TypeScript Patterns

### Proper Mock Typing
Address common TypeScript + Jest typing issues with these patterns:

```typescript
// ✅ Correct: Typing function mocks
import React from 'react'
import { render } from '@testing-library/react-native'
import { getUserById } from '../services/userService'
import { UserProfile } from '../UserProfile'

// Mock the entire module
jest.mock('../services/userService')

// Type the mocked function properly
const mockGetUserById = jest.mocked(getUserById)

// Or using the explicit typing approach
const mockGetUserByIdAlt = getUserById as jest.MockedFunction<typeof getUserById>

describe('UserProfile', () => {
  beforeEach(() => {
    mockGetUserById.mockClear()
  })

  it('should fetch user data on mount', async () => {
    // Setup mock return value with proper typing
    mockGetUserById.mockResolvedValue({
      id: '123',
      name: 'John Doe',
      email: 'john@example.com'
    })

    render(<UserProfile userId="123" />)

    expect(mockGetUserById).toHaveBeenCalledWith('123')
  })
})
```

### React Native Component Mocks
Properly mock React Native components with TypeScript:

```typescript
// Mock React Navigation
jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({
    navigate: jest.fn(),
    goBack: jest.fn(),
    setOptions: jest.fn()
  }),
  useRoute: () => ({
    params: { userId: '123' }
  }),
  useFocusEffect: jest.fn()
}))

// Mock Expo components with proper typing
jest.mock('expo-notifications', () => ({
  requestPermissionsAsync: jest.fn().mockResolvedValue({ status: 'granted' }),
  scheduleNotificationAsync: jest.fn().mockResolvedValue('notification-id'),
  cancelScheduledNotificationAsync: jest.fn().mockResolvedValue(undefined)
}))

// Mock React Native Paper components
jest.mock('react-native-paper', () => ({
  Button: 'Button',
  Card: {
    Title: 'Card.Title',
    Content: 'Card.Content',
    Actions: 'Card.Actions'
  },
  TextInput: 'TextInput',
  useTheme: () => ({
    colors: {
      primary: '#007AFF',
      surface: '#FFFFFF'
    }
  })
}))
```

### Custom Hook Testing
Test custom hooks with proper TypeScript typing:

```typescript
import { renderHook, waitFor } from '@testing-library/react-native'
import { act } from 'react'
import { useUserData } from '../hooks/useUserData'
import { getUserById } from '../services/userService'

// Mock dependencies
jest.mock('../services/userService')
const mockGetUserById = jest.mocked(getUserById)

describe('useUserData', () => {
  it('should fetch and return user data', async () => {
    const mockUser = {
      id: '123',
      name: 'John Doe',
      email: 'john@example.com'
    }
    
    mockGetUserById.mockResolvedValue(mockUser)

    const { result } = renderHook(() => useUserData('123'))

    // Initial state
    expect(result.current.user).toBeNull()
    expect(result.current.loading).toBe(true)
    expect(result.current.error).toBeNull()

    // Wait for async operation to complete
    await waitFor(() => {
      expect(result.current.loading).toBe(false)
    })

    // Final state
    expect(result.current.user).toEqual(mockUser)
    expect(result.current.error).toBeNull()
  })

  it('should handle refetch correctly', async () => {
    const { result } = renderHook(() => useUserData('123'))

    // Wait for initial fetch
    await waitFor(() => {
      expect(result.current.loading).toBe(false)
    })

    // Test refetch function
    act(() => {
      result.current.refetch()
    })

    expect(result.current.loading).toBe(true)
    expect(mockGetUserById).toHaveBeenCalledTimes(2)
  })
})
```
</conditional-block>

<conditional-block context-check="component-testing-patterns">
IF this Component Testing Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Component Testing Patterns already in context"
ELSE:
  READ: The following React Native component testing patterns

## React Native Component Testing Patterns

### Component Tests
Test individual components with proper isolation:

```typescript
import React from 'react'
import { render, fireEvent, waitFor } from '@testing-library/react-native'
import { UserProfile } from '../UserProfile'
import { getUserById } from '../../services/userService'

// Mock external dependencies
jest.mock('../../services/userService')
jest.mock('@react-navigation/native')

const mockGetUserById = jest.mocked(getUserById)

// Create a proper wrapper for providers
const createTestWrapper = (props = {}) => {
  return render(
    <UserProfile
      userId="123"
      onEditPress={jest.fn()}
      {...props}
    />
  )
}

describe('UserProfile', () => {
  beforeEach(() => {
    jest.clearAllMocks()
    mockGetUserById.mockResolvedValue({
      id: '123',
      name: 'John Doe',
      email: 'john@example.com'
    })
  })

  it('should render loading state initially', () => {
    const { getByTestId } = createTestWrapper()
    
    expect(getByTestId('loading-spinner')).toBeTruthy()
  })

  it('should display user information after loading', async () => {
    const { getByText, queryByTestId } = createTestWrapper()

    // Wait for loading to complete
    await waitFor(() => {
      expect(queryByTestId('loading-spinner')).toBeNull()
    })

    expect(getByText('John Doe')).toBeTruthy()
    expect(getByText('john@example.com')).toBeTruthy()
  })

  it('should handle edit button press', async () => {
    const mockOnEditPress = jest.fn()
    const { getByText } = createTestWrapper({ onEditPress: mockOnEditPress })

    await waitFor(() => {
      expect(getByText('John Doe')).toBeTruthy()
    })

    fireEvent.press(getByText('Edit'))

    expect(mockOnEditPress).toHaveBeenCalledWith('123')
  })

  // Regression test example
  it('should handle null email gracefully', async () => {
    // Regression test for #123: Component crashes when email is null
    mockGetUserById.mockResolvedValue({
      id: '123',
      name: 'John Doe',
      email: null
    })

    const { getByText, queryByText } = createTestWrapper()

    await waitFor(() => {
      expect(getByText('John Doe')).toBeTruthy()
    })

    // Should not crash and should not display email
    expect(queryByText('null')).toBeNull()
  })
})
```

### Form Component Testing
Test form interactions and validation:

```typescript
import React from 'react'
import { render, fireEvent, waitFor } from '@testing-library/react-native'
import { LoginForm } from '../LoginForm'

describe('LoginForm', () => {
  const mockOnSubmit = jest.fn()

  beforeEach(() => {
    jest.clearAllMocks()
  })

  it('should validate email format', async () => {
    const { getByTestId, getByText } = render(
      <LoginForm onSubmit={mockOnSubmit} />
    )

    const emailInput = getByTestId('email-input')
    const submitButton = getByText('Sign In')

    // Enter invalid email
    fireEvent.changeText(emailInput, 'invalid-email')
    fireEvent.press(submitButton)

    await waitFor(() => {
      expect(getByText('Please enter a valid email address')).toBeTruthy()
    })

    expect(mockOnSubmit).not.toHaveBeenCalled()
  })

  it('should submit with valid credentials', async () => {
    const { getByTestId, getByText } = render(
      <LoginForm onSubmit={mockOnSubmit} />
    )

    const emailInput = getByTestId('email-input')
    const passwordInput = getByTestId('password-input')
    const submitButton = getByText('Sign In')

    // Enter valid credentials
    fireEvent.changeText(emailInput, 'user@example.com')
    fireEvent.changeText(passwordInput, 'password123')
    fireEvent.press(submitButton)

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        email: 'user@example.com',
        password: 'password123'
      })
    })
  })
})
```

### List Component Testing
Test FlatList and other list components:

```typescript
import React from 'react'
import { render, fireEvent } from '@testing-library/react-native'
import { UserList } from '../UserList'

const mockUsers = [
  { id: '1', name: 'John Doe', email: 'john@example.com' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com' }
]

describe('UserList', () => {
  it('should render all users', () => {
    const { getByText } = render(
      <UserList users={mockUsers} onUserPress={jest.fn()} />
    )

    expect(getByText('John Doe')).toBeTruthy()
    expect(getByText('Jane Smith')).toBeTruthy()
  })

  it('should handle user press', () => {
    const mockOnUserPress = jest.fn()
    const { getByText } = render(
      <UserList users={mockUsers} onUserPress={mockOnUserPress} />
    )

    fireEvent.press(getByText('John Doe'))

    expect(mockOnUserPress).toHaveBeenCalledWith(mockUsers[0])
  })

  it('should show empty state when no users', () => {
    const { getByText } = render(
      <UserList users={[]} onUserPress={jest.fn()} />
    )

    expect(getByText('No users found')).toBeTruthy()
  })
})
```
</conditional-block>

<conditional-block context-check="async-testing-patterns">
IF this Async Testing Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Async Testing Patterns already in context"
ELSE:
  READ: The following async testing patterns

## Async Testing Patterns

### API Call Testing
Test components that make API calls:

```typescript
import React from 'react'
import { render, waitFor, fireEvent } from '@testing-library/react-native'
import { UserDashboard } from '../UserDashboard'
import { apiClient } from '../../services/apiClient'

// Mock the API service
jest.mock('../../services/apiClient')
const mockApiClient = jest.mocked(apiClient)

describe('UserDashboard', () => {
  beforeEach(() => {
    jest.clearAllMocks()
  })

  it('should load user data on mount', async () => {
    const mockUserData = {
      id: '123',
      name: 'John Doe',
      stats: { posts: 5, followers: 100 }
    }

    mockApiClient.get.mockResolvedValue({ data: mockUserData })

    const { getByText, getByTestId } = render(<UserDashboard userId="123" />)

    // Should show loading initially
    expect(getByTestId('loading-indicator')).toBeTruthy()

    // Wait for data to load
    await waitFor(() => {
      expect(getByText('John Doe')).toBeTruthy()
    })

    expect(getByText('5 posts')).toBeTruthy()
    expect(getByText('100 followers')).toBeTruthy()
    expect(mockApiClient.get).toHaveBeenCalledWith('/users/123')
  })

  it('should handle API errors gracefully', async () => {
    const consoleError = jest.spyOn(console, 'error').mockImplementation(() => {})
    
    mockApiClient.get.mockRejectedValue(new Error('Network error'))

    const { getByText, queryByTestId } = render(<UserDashboard userId="123" />)

    await waitFor(() => {
      expect(queryByTestId('loading-indicator')).toBeNull()
    })

    expect(getByText('Failed to load user data')).toBeTruthy()
    
    consoleError.mockRestore()
  })

  it('should retry loading on retry button press', async () => {
    // First call fails
    mockApiClient.get.mockRejectedValueOnce(new Error('Network error'))
    // Second call succeeds
    mockApiClient.get.mockResolvedValue({
      data: { id: '123', name: 'John Doe', stats: { posts: 5, followers: 100 } }
    })

    const { getByText } = render(<UserDashboard userId="123" />)

    // Wait for error state
    await waitFor(() => {
      expect(getByText('Failed to load user data')).toBeTruthy()
    })

    // Press retry
    fireEvent.press(getByText('Retry'))

    // Wait for success
    await waitFor(() => {
      expect(getByText('John Doe')).toBeTruthy()
    })

    expect(mockApiClient.get).toHaveBeenCalledTimes(2)
  })
})
```

### Navigation Testing
Test navigation behavior properly:

```typescript
import React from 'react'
import { render, fireEvent, waitFor } from '@testing-library/react-native'
import { NavigationContainer } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { useNavigation } from '@react-navigation/native'
import { ProfileScreen } from '../ProfileScreen'

// Mock navigation before using it
jest.mock('@react-navigation/native', () => ({
  ...jest.requireActual('@react-navigation/native'),
  useNavigation: jest.fn()
}))

const Stack = createNativeStackNavigator()

const NavigationTestWrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <NavigationContainer>
    <Stack.Navigator>
      <Stack.Screen name="Test" component={() => children} />
    </Stack.Navigator>
  </NavigationContainer>
)

describe('ProfileScreen Navigation', () => {
  it('should navigate to settings when edit button is pressed', async () => {
    const mockNavigate = jest.fn()
    
    // Mock useNavigation hook
    jest.mocked(useNavigation).mockReturnValue({
      navigate: mockNavigate,
      goBack: jest.fn(),
      setOptions: jest.fn()
    } as any)

    const { getByText } = render(
      <NavigationTestWrapper>
        <ProfileScreen />
      </NavigationTestWrapper>
    )

    await waitFor(() => {
      expect(getByText('Edit Profile')).toBeTruthy()
    })

    fireEvent.press(getByText('Edit Profile'))

    expect(mockNavigate).toHaveBeenCalledWith('Settings', {
      section: 'profile'
    })
  })
})
```

### Timer and Animation Testing
Handle timers and animations in tests:

```typescript
import React from 'react'
import { render, waitFor } from '@testing-library/react-native'
import { SuccessNotification } from '../SuccessNotification'

describe('SuccessNotification', () => {
  beforeEach(() => {
    jest.useFakeTimers()
  })

  afterEach(() => {
    jest.runOnlyPendingTimers()
    jest.useRealTimers()
  })

  it('should show success message after delay', async () => {
    const { getByText, queryByText } = render(
      <SuccessNotification message="Saved successfully" />
    )

    // Should not be visible initially
    expect(queryByText('Saved successfully')).toBeNull()

    // Fast-forward timers
    jest.advanceTimersByTime(500)

    await waitFor(() => {
      expect(getByText('Saved successfully')).toBeTruthy()
    })

    // Should disappear after timeout
    jest.advanceTimersByTime(3000)

    await waitFor(() => {
      expect(queryByText('Saved successfully')).toBeNull()
    })
  })
})
```
</conditional-block>

<conditional-block context-check="test-organization">
IF this Test Organization section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Test Organization patterns already in context"
ELSE:
  READ: The following test file organization patterns

## Test File Organization

### File Structure
Organize tests following these conventions:

```
src/
├── components/
│   ├── UserProfile/
│   │   ├── UserProfile.test.tsx          // Component tests
│   │   ├── UserProfile.integration.test.tsx // Integration tests
│   │   └── __snapshots__/               // Auto-managed by Jest
│   │       └── UserProfile.test.tsx.snap
│   ├── UserProfile.tsx                  // Main component file
│   ├── UserCard/
│   │   ├── UserCard.test.tsx
│   │   └── __snapshots__/
│   └── UserCard.tsx
├── services/
│   ├── apiService.ts
│   ├── apiService.test.ts
│   ├── userService.ts
│   └── __mocks__/                       // Jest manual mocks (adjacent to services)
│       ├── apiService.ts
│       └── userService.ts
└── utils/
    ├── dateHelpers.ts
    ├── dateHelpers.test.ts
    ├── testUtils.ts                     // Shared test utilities
    └── __mocks__/
        └── dateHelpers.ts
```

### Import Patterns
With this structure, imports remain clean and semantic:

```typescript
// Clean component imports
import { UserProfile } from './UserProfile'
import { UserCard } from '../UserCard'

// Test imports
import { UserProfile } from '../UserProfile'

// Jest automatically finds service mocks when you call:
jest.mock('../../services/apiService')  // Uses services/__mocks__/apiService.ts
```

### Test Naming Conventions
Use these naming patterns consistently:

```typescript
// Unit tests: [filename].test.(ts|tsx)
// For utilities, pure functions, and individual methods
describe('calculateTotal', () => {
  it('should calculate total with tax', () => {
    expect(calculateTotal(100, 0.1)).toBe(110)
  })
  
  it('should handle zero tax rate', () => {
    expect(calculateTotal(100, 0)).toBe(100)
  })
})

// Component tests: [filename].test.tsx
// For React components - rendering, props, user interactions
describe('UserProfile', () => {
  it('should render user name and email', () => {
    // Test component rendering
  })
  
  it('should call onEdit when edit button is pressed', () => {
    // Test user interactions
  })
})

// Integration tests: [filename].integration.test.(ts|tsx)
// Test multiple components/services working together
describe('UserProfile Integration', () => {
  it('should fetch user data and display profile', async () => {
    // Test component + API service integration
  })
  
  it('should update user data and refresh display', async () => {
    // Test full user flow
  })
})
```

### Jest Manual Mock Organization
Follow Jest's manual mock convention - place `__mocks__` adjacent to the module being mocked:

```typescript
// services/__mocks__/apiService.ts - Jest manual mock
export const apiService = {
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn()
}

// services/__mocks__/userService.ts - Jest manual mock
export const getUserById = jest.fn()
export const updateUser = jest.fn()
export const deleteUser = jest.fn()

// utils/__mocks__/timeHelpers.ts - Mock timers for fast tests
export const delay = (ms: number): Promise<void> => {
  return Promise.resolve() // Resolve immediately instead of waiting
}

export const debounce = <T extends (...args: any[]) => void>(
  func: T,
  delay: number
): T => {
  return func // Return function that calls immediately in tests
}

export const exponentialBackoff = async <T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 1000
): Promise<T> => {
  // In tests, retry immediately without delays
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn()
    } catch (error) {
      if (attempt === maxRetries - 1) throw error
      // No delay in tests - retry immediately
    }
  }
  throw new Error('Max retries exceeded')
}

// utils/testUtils.ts - Test utilities (not Jest mocks)
export const mockUser = {
  id: '123',
  name: 'John Doe',
  email: 'john@example.com',
  avatar: 'https://example.com/avatar.jpg'
}

export const mockUsers = [
  mockUser,
  {
    id: '456',
    name: 'Jane Smith',
    email: 'jane@example.com'
  }
]
```

### Using Manual Mocks in Tests
Jest automatically uses manual mocks when you call `jest.mock()`:

```typescript
// components/UserProfile/UserProfile.test.tsx
import React from 'react'
import { render, waitFor } from '@testing-library/react-native'
import { UserProfile } from '../UserProfile'
import { delay } from '../../utils/timeHelpers'

// Jest automatically uses services/__mocks__/apiService.ts
jest.mock('../../services/apiService')

// Mock timers to make tests fast
jest.mock('../../utils/timeHelpers')

// Import test utilities (not automatic mocks)
import { mockUser } from '../../utils/testUtils'

describe('UserProfile', () => {
  it('should handle delayed operations in tests', async () => {
    // This delay() call will resolve immediately in tests due to the mock
    await delay(1000)
    
    // Test continues without waiting
    expect(true).toBe(true)
  })
})
```

### Timer Testing with jest.useFakeTimers()
For more control over timing, use Jest's fake timers:

```typescript
import React from 'react'
import { render, waitFor } from '@testing-library/react-native'
import { DelayedMessage } from '../DelayedMessage'

describe('DelayedMessage', () => {
  beforeEach(() => {
    jest.useFakeTimers()
  })

  afterEach(() => {
    jest.runOnlyPendingTimers()
    jest.useRealTimers()
  })

  it('should show message after specified delay', async () => {
    const { getByText, queryByText } = render(
      <DelayedMessage message="Hello" delay={2000} />
    )

    // Message should not be visible initially
    expect(queryByText('Hello')).toBeNull()

    // Fast-forward time by 2 seconds
    jest.advanceTimersByTime(2000)

    // Message should now be visible
    await waitFor(() => {
      expect(getByText('Hello')).toBeTruthy()
    })
  })

  it('should debounce rapid function calls', () => {
    const mockCallback = jest.fn()
    const debouncedFn = debounce(mockCallback, 500)

    // Call multiple times rapidly
    debouncedFn('call1')
    debouncedFn('call2')
    debouncedFn('call3')

    // Should not have been called yet
    expect(mockCallback).not.toHaveBeenCalled()

    // Fast-forward past debounce delay
    jest.advanceTimersByTime(500)

    // Should only be called once with the last arguments
    expect(mockCallback).toHaveBeenCalledTimes(1)
    expect(mockCallback).toHaveBeenCalledWith('call3')
  })
})
```

### Test Utilities
Create shared utilities for common test patterns:

```typescript
// utils/testUtils.ts
import React from 'react'
import { render } from '@testing-library/react-native'
import { PaperProvider } from 'react-native-paper'
import { NavigationContainer } from '@react-navigation/native'
import { lightTheme } from '../theme/paperTheme'

// Custom render function with providers
export const renderWithProviders = (ui: React.ReactElement, options = {}) => {
  const Wrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => (
    <PaperProvider theme={lightTheme}>
      <NavigationContainer>
        {children}
      </NavigationContainer>
    </PaperProvider>
  )

  return render(ui, { wrapper: Wrapper, ...options })
}

// Mock factories
export const createMockUser = (overrides = {}) => ({
  id: '123',
  name: 'Test User',
  email: 'test@example.com',
  ...overrides
})

export const createMockNavigation = () => ({
  navigate: jest.fn(),
  goBack: jest.fn(),
  setOptions: jest.fn(),
  addListener: jest.fn(() => jest.fn())
})
```
</conditional-block>