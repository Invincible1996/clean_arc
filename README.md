# Clean Arc 🎯

*[English](README.md) | [中文](README_CN.md)*

[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/Invincible1996/clean_arc.svg)](https://github.com/Invincible1996/clean_arc/stargazers)

Clean Arc is a powerful command-line tool designed to streamline your Flutter development process by automatically generating project structures that follow Clean Architecture principles. Say goodbye to manual folder creation and boilerplate code!

## ✨ Features

- 🏗️ **Complete Clean Architecture Structure** - Generates Domain, Data, and Presentation layers
- 🧩 **Feature Module Generation** - Create feature modules with all necessary layers
- 🔄 **State Management Integration** - Built-in support for Riverpod
- 🌐 **Network Layer Setup** - Includes Dio HTTP client configuration
- 🗂️ **Auto Route Integration** - Automatic route generation and configuration
- 📦 **JSON Serialization** - Automatic model generation with JSON support
- ⚡ **Development Efficiency** - Dramatically reduce boilerplate code

## 🚀 Quick Start

### Prerequisites
- Dart SDK >=3.0.0
- Flutter SDK (for project generation)
- macOS, Linux, or Windows

### Installation

**From GitHub:**
```bash
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

**From Local Source:**
```bash
git clone https://github.com/Invincible1996/clean_arc.git
cd clean_arc
dart pub global activate --source path .
```

**Add to PATH (if needed):**
```bash
# macOS/Linux (zsh)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc

# macOS/Linux (bash)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

**Verify Installation:**
```bash
clean_arc --help
```

## 📖 Usage

### Create New Project

```bash
# Basic project creation
clean_arc create --name my_app --org com.example

# With all options
clean_arc create \
  --name my_flutter_app \
  --org com.yourcompany \
  --riverpod \    # Enable Riverpod (default: true)
  --dio \         # Enable Dio (default: true)  
  --hive          # Enable Hive (default: true)
```

### Add Feature Module

```bash
# Basic feature
clean_arc feature --name user

# Feature with auto-route
clean_arc feature --name user --route
```

### Generated Project Structure

```
my_app/
├── lib/
│   ├── main.dart
│   ├── core/                     # Core infrastructure
│   │   ├── api/
│   │   ├── config/
│   │   ├── di/                   # Dependency injection
│   │   ├── error/                # Error handling
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── network/              # Network configuration
│   │   │   └── dio_client.dart
│   │   ├── router/               # App routing
│   │   │   └── app_router.dart
│   │   ├── storage/              # Local storage
│   │   ├── theme/                # App theming
│   │   ├── usecases/             # Base use case classes
│   │   └── widgets/              # Shared widgets
│   └── features/                 # Feature modules
│       └── user/                 # Example feature
│           ├── data/
│           │   ├── datasources/
│           │   ├── models/
│           │   └── repositories/
│           ├── domain/
│           │   ├── entities/
│           │   ├── repositories/
│           │   └── usecases/
│           └── presentation/
│               ├── providers/
│               ├── screens/
│               └── widgets/
├── assets/
│   ├── icons/
│   ├── images/
│   └── translations/
└── pubspec.yaml                  # Pre-configured dependencies
```

## 🔧 Development Workflow

1. **Create Project:**
   ```bash
   clean_arc create --name my_app --org com.example
   cd my_app
   ```

2. **Add Features:**
   ```bash
   clean_arc feature --name auth --route
   clean_arc feature --name profile --route
   ```

3. **Generate Code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run Project:**
   ```bash
   flutter run
   ```

## 📦 Included Dependencies

The generated projects include these carefully selected packages:

```yaml
dependencies:
  flutter_riverpod: ^2.5.1         # State management
  dio: ^5.4.1                      # HTTP client
  auto_route: ^7.8.4               # Code generation router
  dartz: ^0.10.1                   # Functional programming
  equatable: ^2.0.3                # Value equality
  json_annotation: ^4.8.1          # JSON serialization
  shared_preferences: ^2.2.2        # Local storage
  internet_connection_checker: ^0.0.1  # Network status

dev_dependencies:
  build_runner: ^2.4.8             # Code generation
  json_serializable: ^6.7.1        # JSON serialization
  auto_route_generator: ^7.3.2     # Route generation
  flutter_lints: ^2.0.0            # Linting rules
```

## 🔨 Advanced Usage

**Update Tool:**
```bash
# If you have the build script
./build.sh

# Manual update
dart pub global deactivate clean_arc
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

**Clean Cache:**
```bash
dart pub cache clean
rm -rf .dart_tool
dart pub get
```

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| `clean_arc: command not found` | Add `~/.pub-cache/bin` to your PATH |
| Permission denied | Use `sudo` or check directory permissions |
| Generation fails | Ensure you're in a Flutter project root with `pubspec.yaml` |
| Outdated dependencies | Update the tool to the latest version |

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md).

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p>Made with ❤️ by Clean Arc Team</p>
  <p>
    <a href="https://github.com/Invincible1996/clean_arc">⭐ Star this repo</a> •
    <a href="https://github.com/Invincible1996/clean_arc/issues">🐛 Report Bug</a> •
    <a href="https://github.com/Invincible1996/clean_arc/issues">💡 Request Feature</a>
  </p>
</div>