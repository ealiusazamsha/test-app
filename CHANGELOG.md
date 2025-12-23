# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-12-23

### Added
- Theme customization service with Light, Dark, and System modes
- Profile editing screen with form validation
- WordPress post creation interface
- API Services management screen with testing tools
- Floating action button for quick post creation
- Theme switcher in Settings screen
- Quick access templates for popular APIs (JSONPlaceholder, GitHub)
- Enhanced Material Design 3 theming

### Improved
- Settings screen with theme customization controls
- Navigation flow with new screens
- User experience with better visual feedback
- Demo mode support across all new features
- Form validation and error messages

### Changed
- Updated main.dart to support theme switching
- Enhanced home screen with FAB and new screen links
- Improved settings screen layout

## [1.1.0] - 2024-12-23

### Added
- Demo mode authentication
- Demo posts when WordPress unavailable
- Demo droplets for Digital Ocean
- Post Detail screen with full content view
- Digital Ocean screen with droplet management
- Settings screen with app preferences
- Back navigation on all screens
- Demo mode indicators throughout app

### Improved
- Authentication with automatic fallback
- Error handling and user feedback
- Navigation with back buttons
- UI with demo mode badges

### Fixed
- Authentication issues when backend not configured
- Frontend-backend integration problems
- Missing navigation elements

## [1.0.0] - 2024-12-23

### Added
- Initial Flutter project setup
- Keycloak authentication integration
  - Username/password login
  - Token management (access & refresh tokens)
  - Secure token storage using FlutterSecureStorage
  - Automatic token refresh
  - User information retrieval
- WordPress REST API integration
  - Fetch posts and pages
  - Create new posts (authenticated)
  - Search functionality
  - Category management
- Digital Ocean API integration
  - List droplets
  - Create droplets
  - Account information
- API service layer
  - Generic REST operations (GET, POST, PUT, DELETE)
  - External service integration
  - File upload support
  - Request/response interceptors
- UI Screens
  - Splash screen with authentication check
  - Login screen with Keycloak
  - Home screen with navigation
  - Posts listing from WordPress
  - Services dashboard
  - User profile screen
- Data models
  - User model
  - WordPress Post model
- Utilities
  - Logger utility
  - Constants
  - Loading widget
  - Error widget
- Configuration
  - Environment variables support
  - Android configuration
  - iOS configuration
  - Analysis options for linting
- Documentation
  - Comprehensive README
  - Development guide
  - Contributing guidelines
  - Configuration documentation
- Testing
  - Model unit tests
  - Test infrastructure setup

### Security
- Secure token storage implementation
- HTTPS enforcement for API calls
- JWT token validation

## [Unreleased]

### Planned Features
- Biometric authentication
- Offline data synchronization
- Push notifications
- Multi-language support
- Dark mode support
- Advanced WordPress features (comments, media upload)
- More Digital Ocean operations
- Analytics integration
