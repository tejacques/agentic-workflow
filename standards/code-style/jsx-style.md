# JSX Style Guide

## Context

React Native JSX formatting and component structure guidelines for Expo projects.

<conditional-block context-check="jsx-formatting">
IF this JSX Formatting section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using JSX Formatting rules already in context"
ELSE:
  READ: The following JSX formatting rules

## JSX Formatting

### Component Structure
- Use functional components with TypeScript interfaces
- Props interface should be defined above the component
- Export components as default at the bottom of the file

```tsx
interface UserProfileProps {
  user: User
  onEditPress: () => void
  isLoading?: boolean
}

const UserProfile: React.FC<UserProfileProps> = ({
  user,
  onEditPress,
  isLoading = false
}) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>
        {user.name}
      </Text>
    </View>
  )
}

export default UserProfile
```

### JSX Element Formatting
- Use 4 spaces for indentation
- Place each prop on its own line for components with multiple props
- Keep opening tag on the same line if there's only one prop
- Align closing brackets consistently

```tsx
// Single prop - same line
<Text style={styles.title}>Hello World</Text>

// Multiple props - each on new line
<TouchableOpacity
  style={styles.button}
  onPress={handlePress}
  activeOpacity={0.7}
  testID="submit-button">
  <Text style={styles.buttonText}>Submit</Text>
</TouchableOpacity>

// Self-closing components
<Image
  source={require('./assets/logo.png')}
  style={styles.logo}
  resizeMode="contain" />
```

### Prop Ordering
Order props in this sequence:
1. Key prop (if applicable)
2. Style props (style, contentContainerStyle, etc.)
3. Event handlers (onPress, onChange, etc.)
4. Boolean props
5. Data props
6. Test props (testID, accessibilityLabel)

```tsx
<FlatList
  style={styles.list}
  contentContainerStyle={styles.listContent}
  onRefresh={handleRefresh}
  onEndReached={handleLoadMore}
  refreshing={isRefreshing}
  horizontal={false}
  data={items}
  keyExtractor={item => item.id}
  renderItem={renderItem}
  testID="items-list" />
```
</conditional-block>

<conditional-block context-check="component-patterns">
IF this Component Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Component Patterns already in context"
ELSE:
  READ: The following component patterns

## Component Patterns

### Hook Organization
- Group useState hooks together
- Group useEffect hooks together
- Group custom hooks together
- Group utility functions together

```tsx
const UserProfile: React.FC<UserProfileProps> = ({ userId }) => {
  // State hooks grouped together
  const [user, setUser] = useState<User | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  // Custom hooks grouped together
  const navigation = useNavigation()
  const { theme } = useUnistyles()
  
  // Effect hooks grouped together
  useEffect(() => {
    fetchUser()
  }, [userId])
  
  // Utility functions grouped together
  const fetchUser = async () => {
    setIsLoading(true)
    try {
      const userData = await getUserById(userId)
      setUser(userData)
    } catch (err) {
      setError(err.message)
    } finally {
      setIsLoading(false)
    }
  }
  
  const handleEdit = () => {
    navigation.navigate('EditProfile', { userId })
  }
  
  // Render method at the bottom
  return (
    // JSX here
  )
}
```

### Conditional Rendering
- Use logical AND (&&) for simple show/hide
- Use ternary operator for either/or scenarios
- Extract complex conditions to variables or functions

```tsx
const ProfileView: React.FC<Props> = ({ user, isLoading, error }) => {
  // Extract complex conditions
  const shouldShowEmptyState = !isLoading && !user && !error
  const shouldShowError = !isLoading && error
  
  return (
    <View style={styles.container}>
      {/* Simple show/hide */}
      {isLoading && <ActivityIndicator size="large" />}
      
      {/* Either/or scenarios */}
      {user ? (
        <UserDetails user={user} />
      ) : shouldShowEmptyState ? (
        <EmptyState message="No user found" />
      ) : null}
      
      {/* Error handling */}
      {shouldShowError && (
        <ErrorMessage 
          message={error} 
          onRetry={handleRetry} />
      )}
    </View>
  )
}
```

### List Rendering
- Always provide meaningful key props
- Extract renderItem to separate functions for readability
- Use proper TypeScript typing for list data

```tsx
interface Item {
  id: string
  title: string
  subtitle?: string
}

const ItemsList: React.FC<{ items: Item[] }> = ({ items }) => {
  const renderItem = ({ item }: ListRenderItemInfo<Item>) => (
    <View style={styles.itemContainer}>
      <Text style={styles.itemTitle}>{item.title}</Text>
      {item.subtitle && (
        <Text style={styles.itemSubtitle}>{item.subtitle}</Text>
      )}
    </View>
  )
  
  const renderSeparator = () => <View style={styles.separator} />
  
  return (
    <FlatList
      data={items}
      renderItem={renderItem}
      ItemSeparatorComponent={renderSeparator}
      keyExtractor={item => item.id}
      showsVerticalScrollIndicator={false} />
  )
}
```
</conditional-block>

<conditional-block context-check="styling-integration">
IF this Styling Integration section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Styling Integration patterns already in context"
ELSE:
  READ: The following styling integration patterns

## Styling Integration

### Unistyles Patterns
- Define styles at the bottom of the component file
- Use theme parameter for consistent theming
- Leverage runtime (rt) for responsive design

```tsx
const UserCard: React.FC<UserCardProps> = ({ user, variant = 'default' }) => {
  return (
    <View style={styles.container}>
      <Image 
        source={{ uri: user.avatar }}
        style={styles.avatar} />
      <View style={styles.content}>
        <Text style={styles.name}>{user.name}</Text>
        <Text style={styles.email}>{user.email}</Text>
      </View>
    </View>
  )
}

const styles = StyleSheet.create((theme, rt) => ({
  container: {
    flexDirection: 'row',
    padding: theme.spacing.md,
    backgroundColor: theme.colors.surface,
    borderRadius: theme.borderRadius.md,
    marginBottom: theme.spacing.sm,
    
    // Responsive design
    variants: {
      size: {
        small: { padding: theme.spacing.sm },
        large: { padding: theme.spacing.lg }
      }
    }
  },
  
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    marginRight: theme.spacing.md
  },
  
  content: {
    flex: 1,
    justifyContent: 'center'
  },
  
  name: {
    fontSize: theme.typography.body.fontSize,
    fontWeight: theme.typography.body.fontWeight,
    color: theme.colors.text.primary,
    marginBottom: theme.spacing.xs
  },
  
  email: {
    fontSize: theme.typography.caption.fontSize,
    color: theme.colors.text.secondary
  }
}))
```

### Style Array Usage
- Use array syntax for conditional styles
- Keep base styles first, conditional styles after

```tsx
<View style={[
  styles.button,
  isPressed && styles.buttonPressed,
  isDisabled && styles.buttonDisabled,
  variant === 'primary' && styles.buttonPrimary
]}>
  <Text style={[
    styles.buttonText,
    variant === 'primary' && styles.buttonTextPrimary
  ]}>
    {title}
  </Text>
</View>
```

### Dynamic Styling
- Use Unistyles variants for theme-based variations
- Use style arrays for state-based variations
- Avoid inline styles unless absolutely necessary

```tsx
// Preferred: Using variants
const styles = StyleSheet.create((theme, rt) => ({
  button: {
    variants: {
      variant: {
        primary: {
          backgroundColor: theme.colors.primary,
          borderColor: theme.colors.primary
        },
        secondary: {
          backgroundColor: 'transparent',
          borderColor: theme.colors.primary,
          borderWidth: 1
        }
      },
      size: {
        small: { 
          height: 32,
          paddingHorizontal: theme.spacing.sm 
        },
        large: { 
          height: 48,
          paddingHorizontal: theme.spacing.lg 
        }
      }
    }
  }
}))

// Usage with variants
styles.useVariants({
  variant: 'primary',
  size: 'large'
})
```
</conditional-block>

<conditional-block context-check="performance-patterns">
IF this Performance Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Performance Patterns already in context"
ELSE:
  READ: The following performance patterns

## Performance Patterns

### Memoization
- Use React.memo for components that receive stable props
- Use useMemo for expensive calculations
- Use useCallback for event handlers passed to child components

```tsx
interface ExpensiveComponentProps {
  data: ComplexData
  onItemPress: (id: string) => void
}

const ExpensiveComponent = React.memo<ExpensiveComponentProps>(({ 
  data, 
  onItemPress 
}) => {
  const processedData = useMemo(() => {
    return data.items.map(item => ({
      ...item,
      displayName: `${item.firstName} ${item.lastName}`
    }))
  }, [data.items])
  
  return (
    <FlatList
      data={processedData}
      renderItem={({ item }) => (
        <TouchableOpacity onPress={() => onItemPress(item.id)}>
          <Text>{item.displayName}</Text>
        </TouchableOpacity>
      )}
      keyExtractor={item => item.id} />
  )
})

// Parent component
const ParentComponent = () => {
  const handleItemPress = useCallback((id: string) => {
    navigation.navigate('Detail', { id })
  }, [navigation])
  
  return (
    <ExpensiveComponent 
      data={complexData}
      onItemPress={handleItemPress} />
  )
}
```

### Image Optimization
- Always specify image dimensions
- Use appropriate resizeMode
- Implement proper loading and error states

```tsx
<Image
  source={{ uri: imageUrl }}
  style={styles.image}
  resizeMode="cover"
  onLoad={() => setImageLoaded(true)}
  onError={() => setImageError(true)} />
```

### Safe Area Handling
- Use SafeAreaView for screen-level components
- Consider edge-to-edge content appropriately

```tsx
import { SafeAreaView } from 'react-native-safe-area-context'

const ScreenComponent = () => {
  return (
    <SafeAreaView style={styles.container} edges={['top', 'left', 'right']}>
      <StatusBar barStyle="dark-content" />
      <ScrollView style={styles.content}>
        {/* Screen content */}
      </ScrollView>
    </SafeAreaView>
  )
}
```
</conditional-block>