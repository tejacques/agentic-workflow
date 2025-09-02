# Tech Stack

## Context

Global tech stack defaults for Agentic Project Workflow projects, overridable in project-specific `docs/product/tech-stack.md`.

Client
- App Framework: Expo React Native
- Language: TypeScript
- Mobile Framework: Expo Latest Stable
- Build Tool: Expo Development Build (expo start for development / eas build for production)
- Unit Testing: Jest with React Native Testing Library
- E2E Testing: Playwright for Web, Maestro for iOS / Android
- Linting: ESLint with TypeScript and React Native rules
- Code Formatting: Prettier
- Import Strategy: ES6 modules
- Package Manager: npm
- Node Version: Latest LTS (for development tooling)
- Styling: React Native StyleSheet + React Native Paper theming
- Design System Components: React-Native-Paper latest
- Font Provider: @expo-google-fonts
- Icons: Expo Vector Icons (@expo/vector-icons)
- Navigation: Expo Router
- State Management: Legend-State (IndexedDB on Web and AsyncStorage on iOS and Android)
- Notifications: Expo Notifications
- HTTP Client: Fetch API (or Axios for complex needs)

Backend
- Primary Database: Firebase Firestore
- Backend Framework: Node.js with TypeScript
- Application Hosting: Cloudflare Workers
- Push Notifications: Firebase FCM
- Analytics: Firebase
- Error Monitoring: Firebase Crashlytics
- Experimentation: Statsig
- Hosting Region: Primary region based on user base
- Database Hosting: Firebase
- Database Backups: Daily automated
- Asset Storage: Cloudflare R2
- CDN: Cloudflare
- Asset Access: Private with signed URLs

CI/CD:
- CI/CD Platform: GitHub Actions
- CI/CD Trigger: Push to main/staging branches
- Tests: Run before deployment
- Production Environment: main branch
- Staging Environment: staging branch
