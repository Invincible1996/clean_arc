# Clean Arc 🏗️

[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.3.1-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Clean Arc is a powerful command-line tool designed to streamline your Flutter development process by automatically generating project structures that follow Clean Architecture principles. Say goodbye to manual folder creation and boilerplate code!

## ✨ Features

- 🏗️ Generate complete Flutter project structure following Clean Architecture
- 📁 Create feature modules with data, domain, and presentation layers
- 🔄 Auto-generate data models from Swagger/OpenAPI specifications
- 🎯 Maintain consistent project structure across your team
- ⚡ Boost development efficiency

## 🚀 Installation

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

## 📖 Usage

### Generate Project Framework

Create a basic Clean Architecture project structure:

```bash
clean_arc --framework
```

This will generate the following structure:
```
lib/
├── core/
├── data/
├── domain/
└── presentation/
```

### Create Feature Module

Generate a new feature with all necessary layers:

```bash
clean_arc --feature user_authentication
```

This creates:
```
lib/
└── features/
    └── user_authentication/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
```

### Generate API Models

Generate data models from your Swagger/OpenAPI specification:

```bash
clean_arc --api https://your-api-swagger-url.com
```

## 🎯 Best Practices

- Run commands from your Flutter project root directory
- Ensure your project has a valid `pubspec.yaml` file
- Follow the generated structure for consistency
- Use feature-based folder organization for better scalability

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Troubleshooting

### Common Issues

1. **Command not found**
   - Ensure PATH is correctly set in your shell configuration
   - Try running `dart pub global list` to verify installation

2. **Generation fails**
   - Verify you're in a Flutter project root directory
   - Check if `pubspec.yaml` exists
   - Ensure you have write permissions

For more issues, please check our [GitHub Issues](https://github.com/Invincible1996/clean_arc/issues) page.

## 📫 Support

- Create an [Issue](https://github.com/Invincible1996/clean_arc/issues) for bug reports
- Star ⭐ the repository if you find it helpful
- Follow for updates
