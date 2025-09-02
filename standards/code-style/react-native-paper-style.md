# React Native Paper Style Guide

## Context

React Native Paper component usage and theming guidelines for Expo projects.

<conditional-block context-check="paper-theming">
IF this Paper Theming section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Paper Theming patterns already in context"
ELSE:
  READ: The following React Native Paper theming and usage patterns

## React Native Paper Setup

### Theme Configuration
Configure React Native Paper theme at the root of your application:

```tsx
// theme/paperTheme.ts
import { MD3LightTheme, MD3DarkTheme } from 'react-native-paper'

export const lightTheme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#007AFF',
    onPrimary: '#FFFFFF',
    primaryContainer: '#CCE7FF',
    onPrimaryContainer: '#001E2F',
    secondary: '#5856D6',
    onSecondary: '#FFFFFF',
    secondaryContainer: '#E0DFFF',
    onSecondaryContainer: '#1A1B26',
    tertiary: '#34C759',
    onTertiary: '#FFFFFF',
    error: '#FF3B30',
    onError: '#FFFFFF',
    errorContainer: '#FFDAD4',
    onErrorContainer: '#410001',
    surface: '#FFFFFF',
    onSurface: '#1A1C1E',
    surfaceVariant: '#F2F2F7',
    onSurfaceVariant: '#46464A',
    outline: '#C6C6C8',
    background: '#FEFBFF',
    onBackground: '#1A1C1E'
  }
}

export const darkTheme = {
  ...MD3DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    primary: '#0A84FF',
    onPrimary: '#FFFFFF',
    primaryContainer: '#004A77',
    onPrimaryContainer: '#CCE7FF',
    secondary: '#7B79FF',
    onSecondary: '#2E2F3B',
    secondaryContainer: '#454651',
    onSecondaryContainer: '#E0DFFF',
    tertiary: '#30D158',
    onTertiary: '#FFFFFF',
    error: '#FF453A',
    onError: '#690002',
    errorContainer: '#930006',
    onErrorContainer: '#FFDAD4',
    surface: '#1C1C1E',
    onSurface: '#E5E5E7',
    surfaceVariant: '#46464A',
    onSurfaceVariant: '#C7C7CC',
    outline: '#8E8E93',
    background: '#000000',
    onBackground: '#E5E5E7'
  }
}

// App.tsx
import { PaperProvider } from 'react-native-paper'
import { useColorScheme } from 'react-native'

export default function App() {
  const colorScheme = useColorScheme()
  const theme = colorScheme === 'dark' ? darkTheme : lightTheme

  return (
    <PaperProvider theme={theme}>
      {/* Your app content */}
    </PaperProvider>
  )
}
```

### Custom Theme Hook
Create a custom hook to access theme consistently:

```tsx
// hooks/useAppTheme.ts
import { useTheme } from 'react-native-paper'
import type { MD3Theme } from 'react-native-paper'

export const useAppTheme = () => {
  return useTheme<MD3Theme>()
}
```
</conditional-block>

<conditional-block context-check="component-usage">
IF this Component Usage section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Component Usage patterns already in context"
ELSE:
  READ: The following React Native Paper component usage patterns

## Component Usage Patterns

### Button Components
Use Paper buttons with consistent styling patterns:

```tsx
import { Button, IconButton } from 'react-native-paper'
import { useAppTheme } from '../hooks/useAppTheme'

interface AppButtonProps {
  title: string
  onPress: () => void
  variant?: 'filled' | 'outlined' | 'text'
  disabled?: boolean
  loading?: boolean
  icon?: string
}

const AppButton: React.FC<AppButtonProps> = ({
  title,
  onPress,
  variant = 'filled',
  disabled = false,
  loading = false,
  icon
}) => {
  const theme = useAppTheme()

  return (
    <Button
      mode={variant === 'filled' ? 'contained' : variant === 'outlined' ? 'outlined' : 'text'}
      onPress={onPress}
      disabled={disabled}
      loading={loading}
      icon={icon}
      style={styles.button}
      labelStyle={styles.buttonLabel}
      contentStyle={styles.buttonContent}>
      {title}
    </Button>
  )
}

const styles = StyleSheet.create({
  button: {
    marginVertical: 8,
    borderRadius: 12
  },
  buttonLabel: {
    fontSize: 16,
    fontWeight: '600'
  },
  buttonContent: {
    paddingVertical: 4
  }
})
```

### Card Components
Standardize card layouts with Paper Card:

```tsx
import { Card, Title, Paragraph } from 'react-native-paper'

interface AppCardProps {
  title: string
  subtitle?: string
  content: string
  imageUri?: string
  actions?: React.ReactNode
  onPress?: () => void
}

const AppCard: React.FC<AppCardProps> = ({
  title,
  subtitle,
  content,
  imageUri,
  actions,
  onPress
}) => {
  return (
    <Card style={styles.card} onPress={onPress}>
      {imageUri && (
        <Card.Cover 
          source={{ uri: imageUri }} 
          style={styles.cardCover} />
      )}
      <Card.Content style={styles.cardContent}>
        <Title style={styles.cardTitle}>{title}</Title>
        {subtitle && (
          <Paragraph style={styles.cardSubtitle}>{subtitle}</Paragraph>
        )}
        <Paragraph style={styles.cardContent}>{content}</Paragraph>
      </Card.Content>
      {actions && (
        <Card.Actions style={styles.cardActions}>
          {actions}
        </Card.Actions>
      )}
    </Card>
  )
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: 16,
    marginVertical: 8,
    elevation: 4,
    borderRadius: 12
  },
  cardCover: {
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12
  },
  cardContent: {
    padding: 16
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 4
  },
  cardSubtitle: {
    fontSize: 14,
    opacity: 0.7,
    marginBottom: 8
  },
  cardActions: {
    justifyContent: 'flex-end',
    padding: 16
  }
})
```

### Input Components
Standardize form inputs with Paper TextInput:

```tsx
import { TextInput, HelperText } from 'react-native-paper'

interface AppTextInputProps {
  label: string
  value: string
  onChangeText: (text: string) => void
  placeholder?: string
  error?: string
  disabled?: boolean
  multiline?: boolean
  secureTextEntry?: boolean
  keyboardType?: KeyboardTypeOptions
  autoCapitalize?: 'none' | 'sentences' | 'words' | 'characters'
}

const AppTextInput: React.FC<AppTextInputProps> = ({
  label,
  value,
  onChangeText,
  placeholder,
  error,
  disabled = false,
  multiline = false,
  secureTextEntry = false,
  keyboardType = 'default',
  autoCapitalize = 'sentences'
}) => {
  return (
    <View style={styles.inputContainer}>
      <TextInput
        label={label}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        disabled={disabled}
        multiline={multiline}
        secureTextEntry={secureTextEntry}
        keyboardType={keyboardType}
        autoCapitalize={autoCapitalize}
        mode="outlined"
        style={styles.textInput}
        error={!!error}
        outlineStyle={styles.inputOutline}
      />
      {error && (
        <HelperText type="error" visible={!!error}>
          {error}
        </HelperText>
      )}
    </View>
  )
}

const styles = StyleSheet.create({
  inputContainer: {
    marginVertical: 8
  },
  textInput: {
    backgroundColor: 'transparent'
  },
  inputOutline: {
    borderRadius: 8,
    borderWidth: 1.5
  }
})
```

### List Components
Use Paper List components for consistent list layouts:

```tsx
import { List, Avatar, Divider } from 'react-native-paper'

interface ListItemData {
  id: string
  title: string
  subtitle?: string
  description?: string
  avatarUri?: string
  icon?: string
  onPress?: () => void
}

interface AppListProps {
  data: ListItemData[]
  showDividers?: boolean
}

const AppList: React.FC<AppListProps> = ({ 
  data, 
  showDividers = false 
}) => {
  const renderItem = (item: ListItemData, index: number) => (
    <View key={item.id}>
      <List.Item
        title={item.title}
        description={item.subtitle}
        onPress={item.onPress}
        left={(props) => 
          item.avatarUri ? (
            <Avatar.Image 
              {...props} 
              source={{ uri: item.avatarUri }} 
              size={48} />
          ) : item.icon ? (
            <List.Icon {...props} icon={item.icon} />
          ) : null
        }
        right={(props) => 
          item.onPress ? (
            <List.Icon {...props} icon="chevron-right" />
          ) : null
        }
        titleStyle={styles.listTitle}
        descriptionStyle={styles.listDescription}
        style={styles.listItem}
      />
      {showDividers && index < data.length - 1 && (
        <Divider style={styles.divider} />
      )}
    </View>
  )

  return (
    <View style={styles.listContainer}>
      {data.map(renderItem)}
    </View>
  )
}

const styles = StyleSheet.create({
  listContainer: {
    backgroundColor: 'transparent'
  },
  listItem: {
    paddingVertical: 12,
    paddingHorizontal: 16
  },
  listTitle: {
    fontSize: 16,
    fontWeight: '600'
  },
  listDescription: {
    fontSize: 14,
    marginTop: 4
  },
  divider: {
    marginHorizontal: 16
  }
})
```
</conditional-block>

<conditional-block context-check="layout-styling">
IF this Layout Styling section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Layout Styling patterns already in context"
ELSE:
  READ: The following layout styling patterns with React Native StyleSheet

## Layout Styling with React Native StyleSheet

### Container Patterns
Use consistent container patterns for layout:

```tsx
import { StyleSheet, View, ScrollView } from 'react-native'
import { useAppTheme } from '../hooks/useAppTheme'

const ScreenTemplate: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const theme = useAppTheme()

  return (
    <View style={[styles.screenContainer, { backgroundColor: theme.colors.background }]}>
      <ScrollView 
        style={styles.scrollContainer}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}>
        {children}
      </ScrollView>
    </View>
  )
}

const styles = StyleSheet.create({
  screenContainer: {
    flex: 1
  },
  scrollContainer: {
    flex: 1
  },
  scrollContent: {
    flexGrow: 1,
    padding: 16
  },
  
  // Common layout patterns
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  
  rowContainer: {
    flexDirection: 'row',
    alignItems: 'center'
  },
  
  spaceBetween: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  
  // Spacing utilities
  marginVerticalSm: {
    marginVertical: 8
  },
  marginVerticalMd: {
    marginVertical: 16
  },
  marginVerticalLg: {
    marginVertical: 24
  },
  
  paddingHorizontalSm: {
    paddingHorizontal: 8
  },
  paddingHorizontalMd: {
    paddingHorizontal: 16
  },
  paddingHorizontalLg: {
    paddingHorizontal: 24
  }
})
```

### Responsive Layouts
Create responsive layouts using Dimensions and flexible styling:

```tsx
import { Dimensions, StyleSheet } from 'react-native'

const { width: SCREEN_WIDTH } = Dimensions.get('window')
const BREAKPOINT_TABLET = 768

const ResponsiveComponent: React.FC = () => {
  const isTablet = SCREEN_WIDTH >= BREAKPOINT_TABLET

  return (
    <View style={[
      styles.container,
      isTablet ? styles.tabletContainer : styles.mobileContainer
    ]}>
      <View style={[
        styles.content,
        isTablet ? styles.tabletContent : styles.mobileContent
      ]}>
        {/* Content */}
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16
  },
  
  mobileContainer: {
    flexDirection: 'column'
  },
  
  tabletContainer: {
    flexDirection: 'row',
    padding: 24
  },
  
  content: {
    flex: 1
  },
  
  mobileContent: {
    marginVertical: 8
  },
  
  tabletContent: {
    marginHorizontal: 12,
    maxWidth: 600
  },
  
  // Grid patterns
  gridContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between'
  },
  
  gridItem: {
    width: '48%',
    marginBottom: 16
  },
  
  tabletGridItem: {
    width: '31%',
    marginBottom: 20
  }
})
```

### Theme Integration
Integrate Paper theme with custom StyleSheet styling:

```tsx
import { StyleSheet } from 'react-native'
import { useAppTheme } from '../hooks/useAppTheme'

const ThemedComponent: React.FC = () => {
  const theme = useAppTheme()
  
  // Create theme-aware styles
  const dynamicStyles = StyleSheet.create({
    container: {
      backgroundColor: theme.colors.surface,
      borderColor: theme.colors.outline,
      borderWidth: 1,
      borderRadius: 12,
      padding: 16
    },
    text: {
      color: theme.colors.onSurface,
      fontSize: 16
    },
    accent: {
      color: theme.colors.primary,
      fontWeight: '600'
    },
    muted: {
      color: theme.colors.onSurfaceVariant,
      fontSize: 14
    }
  })

  return (
    <View style={[styles.wrapper, dynamicStyles.container]}>
      <Text style={dynamicStyles.text}>Main content</Text>
      <Text style={dynamicStyles.accent}>Accent text</Text>
      <Text style={dynamicStyles.muted}>Muted text</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  wrapper: {
    marginVertical: 12
  }
})
```
</conditional-block>

<conditional-block context-check="accessibility-patterns">
IF this Accessibility Patterns section already read in current context:
  SKIP: Re-reading this section
  NOTE: "Using Accessibility Patterns already in context"
ELSE:
  READ: The following accessibility patterns for React Native Paper components

## Accessibility Patterns

### Accessible Components
Always include proper accessibility props:

```tsx
import { Button, Card, TextInput } from 'react-native-paper'

const AccessibleForm: React.FC = () => {
  return (
    <View>
      <TextInput
        label="Email"
        value={email}
        onChangeText={setEmail}
        accessibilityLabel="Email address input"
        accessibilityHint="Enter your email address to sign in"
        autoCapitalize="none"
        keyboardType="email-address"
      />
      
      <Button
        mode="contained"
        onPress={handleSubmit}
        accessibilityLabel="Sign in button"
        accessibilityHint="Tap to sign in with your credentials"
        accessibilityRole="button">
        Sign In
      </Button>
      
      <Card
        onPress={handleCardPress}
        accessible={true}
        accessibilityLabel={`Article: ${article.title}`}
        accessibilityHint="Tap to read the full article"
        accessibilityRole="button">
        <Card.Content>
          <Title>{article.title}</Title>
          <Paragraph>{article.excerpt}</Paragraph>
        </Card.Content>
      </Card>
    </View>
  )
}
```

### Screen Reader Support
Structure content for optimal screen reader experience:

```tsx
const AccessibleScreen: React.FC = () => {
  return (
    <ScrollView>
      <View
        accessible={false}
        accessibilityRole="header">
        <Title 
          accessibilityRole="text"
          accessibilityLabel="Screen title">
          Dashboard
        </Title>
      </View>
      
      <View
        accessible={false}
        accessibilityRole="main">
        <Paragraph 
          accessibilityLabel="Welcome message"
          importantForAccessibility="yes">
          Welcome back! Here's your daily overview.
        </Paragraph>
        
        {/* Content sections with proper headings */}
        <Title 
          accessibilityRole="text"
          accessibilityLabel="Statistics section">
          Today's Statistics
        </Title>
        
        {/* Statistics content */}
      </View>
    </ScrollView>
  )
}
```
</conditional-block>