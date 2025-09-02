# TypeScript Style Guide

## Context

TypeScript formatting and type definition guidelines for Expo React Native projects.

<conditional-block context-check="typescript-configuration">
IF this TypeScript Configuration section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using TypeScript Configuration already in context"
ELSE:
  READ: The following TypeScript configuration guidelines

## TypeScript Configuration

### Strict Mode Settings
- Always use TypeScript in strict mode
- Enable all strict checks in tsconfig.json
- Use explicit return types for functions

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

### Import/Export Conventions
- Use explicit imports instead of wildcard imports
- Group imports in this order: external libraries, internal modules, relative imports
- Use default exports for components, named exports for utilities

```tsx
// External libraries
import React, { useState, useEffect } from 'react'
import { View, Text, TouchableOpacity } from 'react-native'
import { StyleSheet } from 'react-native-unistyles'
import { useNavigation } from '@react-navigation/native'

// Internal modules
import { apiClient } from '@/services/api'
import { formatDate } from '@/utils/date'
import { colors } from '@/theme/colors'

// Relative imports
import { UserCard } from './UserCard'
import { LoadingSpinner } from '../common/LoadingSpinner'

// Type imports (use 'import type' for types only)
import type { User } from '@/types/user'
import type { NavigationProp } from '@react-navigation/native'
```
</conditional-block>

<conditional-block context-check="interface-definitions">
IF this Interface Definitions section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Interface Definitions already in context"
ELSE:
  READ: The following interface and type definitions

## Interface and Type Definitions

### Props Interfaces
- Always define props as interfaces (not types for props)
- Use PascalCase with 'Props' suffix
- Make optional properties explicit with ?
- Document complex props with JSDoc comments

```tsx
/**
 * Props for the UserProfile component
 */
interface UserProfileProps {
  /** User data to display */
  user: User
  /** Whether to show edit controls */
  editable?: boolean
  /** Callback when user presses edit button */
  onEdit?: (userId: string) => void
  /** Custom styling for the container */
  style?: StyleProp<ViewStyle>
  /** Test identifier for automated testing */
  testID?: string
}

const UserProfile: React.FC<UserProfileProps> = ({
  user,
  editable = false,
  onEdit,
  style,
  testID
}) => {
  // Component implementation
}
```

### Data Models
- Use interfaces for data structures
- Use string unions for predefined values
- Use const assertions for readonly data

```tsx
// Data models
interface User {
  readonly id: string
  name: string
  email: string
  avatar?: string
  role: UserRole
  preferences: UserPreferences
  createdAt: Date
  updatedAt: Date
}

interface UserPreferences {
  theme: 'light' | 'dark' | 'auto'
  language: string
  notifications: boolean
  privacy: {
    profileVisible: boolean
    activityVisible: boolean
  }
}

// String unions for type safety
type UserRole = 'admin' | 'user' | 'guest'
type NavigationRoute = 'Home' | 'Profile' | 'Settings' | 'Login'

// Const assertions for readonly data
const USER_ROLES = ['admin', 'user', 'guest'] as const
const SUPPORTED_LANGUAGES = ['en', 'es', 'fr', 'de'] as const
```

### API Response Types
- Define interfaces for all API responses
- Use generics for common response patterns
- Handle error types explicitly

```tsx
// Generic API response wrapper
interface ApiResponse<T> {
  data: T
  status: number
  message: string
  timestamp: string
}

interface ApiError {
  code: string
  message: string
  details?: Record<string, unknown>
}

// Specific API response types
interface GetUserResponse extends ApiResponse<User> {}
interface GetUsersResponse extends ApiResponse<User[]> {}

// API service with proper typing
class UserService {
  async getUser(id: string): Promise<User> {
    try {
      const response = await apiClient.get<GetUserResponse>(`/users/${id}`)
      return response.data.data
    } catch (error) {
      if (error instanceof ApiError) {
        throw new Error(`Failed to fetch user: ${error.message}`)
      }
      throw error
    }
  }

  async updateUser(id: string, updates: Partial<User>): Promise<User> {
    const response = await apiClient.put<GetUserResponse>(`/users/${id}`, updates)
    return response.data.data
  }
}
```
</conditional-block>

<conditional-block context-check="function-typing">
IF this Function Typing section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Function Typing already in context"
ELSE:
  READ: The following function typing guidelines

## Function Typing

### Function Declarations
- Always specify return types for functions
- Use arrow functions for inline callbacks
- Use function declarations for named functions

```tsx
// Function with explicit return type
const calculateTotal = (items: CartItem[]): number => {
  return items.reduce((total, item) => total + item.price * item.quantity, 0)
}

// Async function with proper error handling
const fetchUserData = async (userId: string): Promise<User | null> => {
  try {
    const user = await userService.getUser(userId)
    return user
  } catch (error) {
    console.error('Failed to fetch user:', error)
    return null
  }
}

// Event handler typing
const handleUserPress = (user: User): void => {
  navigation.navigate('UserDetail', { userId: user.id })
}

// Complex function with multiple parameters
const processUserData = (
  users: User[],
  filters: UserFilter[],
  sortBy: keyof User = 'name'
): ProcessedUserData => {
  const filteredUsers = applyFilters(users, filters)
  const sortedUsers = sortUsers(filteredUsers, sortBy)
  
  return {
    users: sortedUsers,
    totalCount: users.length,
    filteredCount: sortedUsers.length
  }
}
```

### Hook Typing
- Properly type custom hooks
- Use generic constraints where appropriate
- Return tuple types for hooks that return multiple values

```tsx
// Custom hook with proper typing
const useUserData = (userId: string): {
  user: User | null
  loading: boolean
  error: string | null
  refetch: () => Promise<void>
} => {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchUser = useCallback(async (): Promise<void> => {
    try {
      setLoading(true)
      setError(null)
      const userData = await userService.getUser(userId)
      setUser(userData)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }, [userId])

  useEffect(() => {
    fetchUser()
  }, [fetchUser])

  return { user, loading, error, refetch: fetchUser }
}

// Generic hook
const useAsyncData = <T>(
  fetchFn: () => Promise<T>,
  deps: React.DependencyList = []
): [T | null, boolean, string | null] => {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true)
        const result = await fetchFn()
        setData(result)
        setError(null)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error')
      } finally {
        setLoading(false)
      }
    }

    loadData()
  }, deps)

  return [data, loading, error]
}
```

### Event Handler Typing
- Use proper event types from React Native
- Extract complex event handling logic to separate functions

```tsx
interface FormComponentProps {
  onSubmit: (data: FormData) => void
  onCancel: () => void
}

const FormComponent: React.FC<FormComponentProps> = ({ onSubmit, onCancel }) => {
  const [text, setText] = useState('')
  
  const handleTextChange = (value: string): void => {
    setText(value)
  }
  
  const handleSubmitPress = (): void => {
    const formData: FormData = {
      text,
      timestamp: new Date()
    }
    onSubmit(formData)
  }

  return (
    <View>
      <TextInput
        value={text}
        onChangeText={handleTextChange}
        placeholder="Enter text" />
      <TouchableOpacity onPress={handleSubmitPress}>
        <Text>Submit</Text>
      </TouchableOpacity>
    </View>
  )
}
```
</conditional-block>

<conditional-block context-check="utility-types">
IF this Utility Types section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Utility Types already in context"
ELSE:
  READ: The following utility types and generic patterns

## Utility Types and Generics

### Common Utility Types
- Use built-in TypeScript utility types effectively
- Create custom utility types for common patterns
- Leverage conditional types for complex scenarios

```tsx
// Using built-in utility types
type UserUpdate = Partial<Pick<User, 'name' | 'email' | 'preferences'>>
type UserKeys = keyof User
type RequiredUserFields = Required<Pick<User, 'id' | 'name' | 'email'>>

// Custom utility types
type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
type NonNullable<T> = T extends null | undefined ? never : T

// API related types
type ApiEndpoint = 'users' | 'posts' | 'comments'
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE'

interface ApiRequest<T = unknown> {
  endpoint: ApiEndpoint
  method: HttpMethod
  data?: T
  params?: Record<string, string | number>
}

// Form handling types
type FormErrors<T> = {
  [K in keyof T]?: string
}

type FormState<T> = {
  values: T
  errors: FormErrors<T>
  touched: { [K in keyof T]?: boolean }
  isSubmitting: boolean
}
```

### Generic Components
- Use generics for reusable components
- Provide default type parameters where appropriate
- Use constraints to limit generic types

```tsx
// Generic list component
interface ListProps<T> {
  data: T[]
  renderItem: (item: T, index: number) => React.ReactNode
  keyExtractor: (item: T) => string
  emptyMessage?: string
  loading?: boolean
}

const List = <T extends { id: string }>({
  data,
  renderItem,
  keyExtractor,
  emptyMessage = 'No items found',
  loading = false
}: ListProps<T>): React.ReactElement => {
  if (loading) {
    return <LoadingSpinner />
  }

  if (data.length === 0) {
    return <Text>{emptyMessage}</Text>
  }

  return (
    <FlatList
      data={data}
      renderItem={({ item, index }) => renderItem(item, index)}
      keyExtractor={keyExtractor} />
  )
}

// Usage
<List<User>
  data={users}
  renderItem={(user) => <UserCard user={user} />}
  keyExtractor={(user) => user.id}
  emptyMessage="No users found" />
```

### Type Guards and Assertions
- Use type guards for runtime type checking
- Avoid type assertions unless absolutely necessary
- Create custom type guards for complex checks

```tsx
// Type guard functions
const isUser = (obj: unknown): obj is User => {
  return (
    typeof obj === 'object' &&
    obj !== null &&
    typeof (obj as User).id === 'string' &&
    typeof (obj as User).name === 'string' &&
    typeof (obj as User).email === 'string'
  )
}

const isApiError = (error: unknown): error is ApiError => {
  return (
    typeof error === 'object' &&
    error !== null &&
    typeof (error as ApiError).code === 'string' &&
    typeof (error as ApiError).message === 'string'
  )
}

// Using type guards
const handleApiResponse = (response: unknown): User[] => {
  if (Array.isArray(response) && response.every(isUser)) {
    return response
  }
  throw new Error('Invalid response format')
}

// Discriminated unions
type LoadingState = {
  status: 'loading'
}

type SuccessState = {
  status: 'success'
  data: User[]
}

type ErrorState = {
  status: 'error'
  error: string
}

type AsyncState = LoadingState | SuccessState | ErrorState

// Type-safe state handling
const handleAsyncState = (state: AsyncState): React.ReactNode => {
  switch (state.status) {
    case 'loading':
      return <LoadingSpinner />
    case 'success':
      return <UserList users={state.data} />
    case 'error':
      return <ErrorMessage message={state.error} />
  }
}
```
</conditional-block>

<conditional-block context-check="react-native-types">
IF this React Native Types section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using React Native Types already in context"
ELSE:
  READ: The following React Native specific typing patterns

## React Native Specific Types

### Navigation Types
- Define navigation parameter lists
- Type navigation props properly
- Use type-safe navigation calls

```tsx
// Navigation parameter types
type RootStackParamList = {
  Home: undefined
  Profile: { userId: string }
  Settings: { section?: string }
  UserDetail: { userId: string; tab?: 'info' | 'posts' }
}

type TabParamList = {
  HomeTab: undefined
  ProfileTab: undefined
  SettingsTab: undefined
}

// Navigation prop types
type ProfileScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Profile'>
type ProfileScreenRouteProp = RouteProp<RootStackParamList, 'Profile'>

interface ProfileScreenProps {
  navigation: ProfileScreenNavigationProp
  route: ProfileScreenRouteProp
}

// Component with navigation
const ProfileScreen: React.FC<ProfileScreenProps> = ({ navigation, route }) => {
  const { userId } = route.params

  const handleEditPress = (): void => {
    navigation.navigate('Settings', { section: 'profile' })
  }

  return (
    <View>
      {/* Screen content */}
    </View>
  )
}

// Using with useNavigation hook
const SomeComponent: React.FC = () => {
  const navigation = useNavigation<ProfileScreenNavigationProp>()

  const navigateToProfile = (userId: string): void => {
    navigation.navigate('Profile', { userId })
  }

  return <TouchableOpacity onPress={() => navigateToProfile('123')} />
}
```

### Style Types
- Use proper StyleProp types
- Type theme objects appropriately
- Create type-safe style utilities

```tsx
import { StyleProp, ViewStyle, TextStyle, ImageStyle } from 'react-native'

interface StyledComponentProps {
  containerStyle?: StyleProp<ViewStyle>
  textStyle?: StyleProp<TextStyle>
  imageStyle?: StyleProp<ImageStyle>
}

// Theme typing
interface Theme {
  colors: {
    primary: string
    secondary: string
    background: string
    surface: string
    text: {
      primary: string
      secondary: string
    }
  }
  spacing: {
    xs: number
    sm: number
    md: number
    lg: number
    xl: number
  }
  typography: {
    h1: TextStyle
    h2: TextStyle
    body: TextStyle
    caption: TextStyle
  }
  borderRadius: {
    sm: number
    md: number
    lg: number
  }
}

// Unistyles integration
declare module 'react-native-unistyles' {
  export interface UnistylesThemes {
    light: Theme
    dark: Theme
  }
}
```

### Component Ref Types
- Use proper ref types for React Native components
- Type forwarded refs correctly
- Handle imperative component methods

```tsx
// Component with ref
interface CustomInputProps {
  placeholder: string
  onChangeText: (text: string) => void
}

const CustomInput = React.forwardRef<TextInput, CustomInputProps>(
  ({ placeholder, onChangeText }, ref) => {
    return (
      <TextInput
        ref={ref}
        placeholder={placeholder}
        onChangeText={onChangeText}
        style={styles.input} />
    )
  }
)

// Using the ref
const ParentComponent: React.FC = () => {
  const inputRef = useRef<TextInput>(null)

  const focusInput = (): void => {
    inputRef.current?.focus()
  }

  return (
    <View>
      <CustomInput
        ref={inputRef}
        placeholder="Enter text"
        onChangeText={setText} />
      <TouchableOpacity onPress={focusInput}>
        <Text>Focus Input</Text>
      </TouchableOpacity>
    </View>
  )
}
```
</conditional-block>