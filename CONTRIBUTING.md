# Contributing to Test App

Thank you for your interest in contributing to Test App! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Environment details (Flutter version, OS, device)

### Suggesting Features

1. Check if the feature has been suggested
2. Create an issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach

### Code Contributions

1. **Fork the repository**
   ```bash
   git clone https://github.com/ealiusazamsha/test-app.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding standards below
   - Write tests for new functionality
   - Update documentation as needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add: Brief description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Provide a clear description
   - Reference related issues
   - Wait for review

## Coding Standards

### Dart/Flutter Style

- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues

### Code Organization

- **Models**: Data structures in `lib/models/`
- **Services**: Business logic in `lib/services/`
- **Screens**: UI pages in `lib/screens/`
- **Widgets**: Reusable components in `lib/widgets/`
- **Utils**: Helper functions in `lib/utils/`

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private**: prefix with `_`

### Documentation

- Add doc comments for public APIs
- Use `///` for documentation comments
- Include examples for complex functions

Example:
```dart
/// Fetches posts from WordPress API.
///
/// Returns a list of [WordPressPost] objects.
/// Returns an empty list if the request fails.
///
/// Example:
/// ```dart
/// final posts = await wordpressService.getPosts(page: 1);
/// ```
Future<List<WordPressPost>> getPosts({int page = 1}) async {
  // implementation
}
```

### Testing

- Write unit tests for services and utilities
- Write widget tests for UI components
- Maintain test coverage above 70%

Test file naming:
- `feature_test.dart` for unit tests
- `feature_widget_test.dart` for widget tests

### Commit Messages

Follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test changes
- `chore:` Build/config changes

Examples:
```
feat: Add biometric authentication support
fix: Resolve token refresh issue on iOS
docs: Update setup instructions for Keycloak
```

## Development Workflow

1. **Setup environment**
   ```bash
   flutter pub get
   cp .env.example .env
   # Edit .env with your credentials
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Check code quality**
   ```bash
   flutter analyze
   flutter format .
   ```

## Pull Request Process

1. Update the README.md if needed
2. Update CHANGELOG.md with notable changes
3. Ensure all tests pass
4. Request review from maintainers
5. Address review feedback
6. Squash commits if requested
7. Wait for approval and merge

## Project Structure

```
test_app/
├── lib/
│   ├── main.dart           # Entry point
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   ├── services/           # Business logic
│   ├── utils/              # Utilities
│   └── widgets/            # Reusable widgets
├── test/                   # Test files
├── android/                # Android config
├── ios/                    # iOS config
└── assets/                 # Assets
```

## Questions?

- Open an issue for questions
- Join our discussions
- Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

Thank you for contributing! 🎉
