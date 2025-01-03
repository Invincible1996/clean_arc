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
- Mac, Linux, or Windows operating system

### macOS/Linux

```bash
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git

# Add to PATH (if not already done)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc  # or .bashrc/.bash_profile
source ~/.zshrc  # or .bashrc/.bash_profile
```

### Windows

1. Install using dart pub:
```powershell
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

2. Add to PATH:
   - Open Windows PowerShell as Administrator
   - Run the following command to add the pub-cache bin directory to your user PATH:
```powershell
$env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$env:LOCALAPPDATA\Pub\Cache\bin",
    [EnvironmentVariableTarget]::User
)
```
   - Close and reopen PowerShell/Command Prompt

Alternatively, you can manually add the PATH:
1. Press Win + X and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "User variables", select "Path" and click "Edit"
5. Click "New" and add: `%LOCALAPPDATA%\Pub\Cache\bin`
6. Click "OK" to save

### Verify Installation

After installation, verify that clean_arc is available:
```bash
clean_arc --version
```

## Usage

### Create a New Flutter Project with Clean Architecture

```bash
clean_arc create --name my_project --org com.example
```

This command will:
1. Create a new Flutter project
2. Set up Clean Architecture structure
3. Add necessary dependencies
4. Configure basic project files

The generated project structure:

```
my_project/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   └── network_info.dart
│   │   └── usecases/
│   │       └── usecase.dart
│   └── features/
│       └── (your feature modules will go here)
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

### Create a New Feature Module

Basic usage:
```bash
clean_arc feature --name user
```

With auto-route support:
```bash
clean_arc feature --name user --route
```

When using the `--route` flag, the tool will:
1. Add `@RoutePage()` annotation to the screen
2. Create/update `app_router.dart` if it doesn't exist
3. Add the route to the router configuration
4. Add auto_route dependencies to pubspec.yaml

After adding routes, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
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
