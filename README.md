# Clean Arc 

[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.3.1-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Clean Arc is a powerful command-line tool designed to streamline your Flutter development process by automatically generating project structures that follow Clean Architecture principles. Say goodbye to manual folder creation and boilerplate code!

## Features

- Generates a complete Clean Architecture structure
- Creates feature modules with all necessary layers
- Supports Riverpod for state management
- Includes Dio for network requests
- Generates JSON serializable models
- Boost development efficiency

## Installation

### Prerequisites

- Dart SDK >=3.3.1
- Flutter (for project generation)
- Mac or Linux operating system

### Quick Install

```bash
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

### Environment Setup

Add the following line to your `~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then reload your shell configuration:

```bash
source ~/.zshrc  # or .bashrc/.bash_profile
```

## Usage

### Create a New Feature Module

```bash
clean_arc feature --name user
```

This will generate the following structure:

```
lib/
└── features/
    └── user/
        ├── data/
        │   ├── datasources/
        │   │   └── user_remote_data_source.dart
        │   ├── models/
        │   │   └── user_model.dart
        │   └── repositories/
        │       └── user_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity.dart
        │   ├── repositories/
        │   │   └── user_repository.dart
        │   └── usecases/
        │       └── get_user.dart
        └── presentation/
            ├── providers/
            │   └── user_provider.dart
            ├── screens/
            │   └── user_screen.dart
            └── widgets/
```

### Generated Files

- **Entity**: Base domain model
- **Model**: Data model with JSON serialization
- **Repository**: Abstract repository interface
- **Repository Implementation**: Concrete repository implementation
- **Remote Data Source**: API communication layer
- **Use Case**: Business logic implementation
- **Provider**: State management (if using Riverpod)
- **Screen**: Basic UI implementation

## Dependencies

The generated code assumes you have the following dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dartz: ^0.10.1
  dio: ^5.3.3
  flutter_riverpod: ^2.4.5
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

## Next Steps After Generation

1. Implement your business logic in the generated feature module
2. Run build_runner to generate JSON serialization code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. Add the new feature to your routing configuration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Best Practices

- Run commands from your Flutter project root directory
- Ensure your project has a valid `pubspec.yaml` file
- Follow the generated structure for consistency
- Use feature-based folder organization for better scalability

## Troubleshooting

### Common Issues

1. **Command not found**
   - Ensure PATH is correctly set in your shell configuration
   - Try running `dart pub global list` to verify installation

2. **Generation fails**
   - Verify you're in a Flutter project root directory
   - Check if `pubspec.yaml` exists
   - Ensure you have write permissions

For more issues, please check our [GitHub Issues](https://github.com/Invincible1996/clean_arc/issues) page.

## Support

- Create an [Issue](https://github.com/Invincible1996/clean_arc/issues) for bug reports
- Star ⭐ the repository if you find it helpful
- Follow for updates
