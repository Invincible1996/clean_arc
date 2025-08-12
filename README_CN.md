# Clean Arc 🎯

*[English](README.md) | [中文](README_CN.md)*

[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/Invincible1996/clean_arc.svg)](https://github.com/Invincible1996/clean_arc/stargazers)

Clean Arc 是一个强大的命令行工具，旨在通过自动生成遵循 Clean Architecture 原则的项目结构来简化您的 Flutter 开发过程。告别手动创建文件夹和样板代码！

## ✨ 功能特性

- 🏗️ **完整的整洁架构结构** - 生成 Domain、Data 和 Presentation 三层架构
- 🧩 **功能模块生成** - 创建包含所有必要层级的功能模块
- 🔄 **状态管理集成** - 内置 Riverpod 支持
- 🌐 **网络层设置** - 包含 Dio HTTP 客户端配置
- 🗂️ **自动路由集成** - 自动路由生成和配置
- 📦 **JSON 序列化** - 支持 JSON 的自动模型生成
- ⚡ **开发效率** - 大幅减少样板代码

## 🚀 快速开始

### 环境要求
- Dart SDK >=3.0.0
- Flutter SDK（用于项目生成）
- macOS、Linux 或 Windows

### 安装

**从 GitHub 安装：**
```bash
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

**从本地源码安装：**
```bash
git clone https://github.com/Invincible1996/clean_arc.git
cd clean_arc
dart pub global activate --source path .
```

**添加到环境变量（如需要）：**
```bash
# macOS/Linux (zsh)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc

# macOS/Linux (bash)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

**验证安装：**
```bash
clean_arc --help
```

## 📖 使用方法

### 创建新项目

```bash
# 基本项目创建
clean_arc create --name my_app --org com.example

# 包含所有选项
clean_arc create \
  --name my_flutter_app \
  --org com.yourcompany \
  --riverpod \    # 启用 Riverpod（默认：true）
  --dio \         # 启用 Dio（默认：true）
  --hive          # 启用 Hive（默认：true）
```

### 添加功能模块

```bash
# 基础功能模块
clean_arc feature --name user

# 带自动路由的功能模块
clean_arc feature --name user --route
```

### 生成的项目结构

```
my_app/
├── lib/
│   ├── main.dart
│   ├── core/                     # 核心基础设施
│   │   ├── api/
│   │   ├── config/
│   │   ├── di/                   # 依赖注入
│   │   ├── error/                # 错误处理
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── network/              # 网络配置
│   │   │   └── dio_client.dart
│   │   ├── router/               # 应用路由
│   │   │   └── app_router.dart
│   │   ├── storage/              # 本地存储
│   │   ├── theme/                # 应用主题
│   │   ├── usecases/             # 基础用例类
│   │   └── widgets/              # 共享组件
│   └── features/                 # 功能模块
│       └── user/                 # 示例功能
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
└── pubspec.yaml                  # 预配置依赖项
```

## 🔧 开发工作流

1. **创建项目：**
   ```bash
   clean_arc create --name my_app --org com.example
   cd my_app
   ```

2. **添加功能：**
   ```bash
   clean_arc feature --name auth --route
   clean_arc feature --name profile --route
   ```

3. **生成代码：**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **运行项目：**
   ```bash
   flutter run
   ```

## 📦 包含的依赖

生成的项目包含这些精心选择的包：

```yaml
dependencies:
  flutter_riverpod: ^2.5.1         # 状态管理
  dio: ^5.4.1                      # HTTP 客户端
  auto_route: ^7.8.4               # 代码生成路由器
  dartz: ^0.10.1                   # 函数式编程
  equatable: ^2.0.3                # 值相等性
  json_annotation: ^4.8.1          # JSON 序列化
  shared_preferences: ^2.2.2        # 本地存储
  internet_connection_checker: ^0.0.1  # 网络状态检查

dev_dependencies:
  build_runner: ^2.4.8             # 代码生成
  json_serializable: ^6.7.1        # JSON 序列化
  auto_route_generator: ^7.3.2     # 路由生成
  flutter_lints: ^2.0.0            # 代码规范
```

## 🔨 高级用法

**更新工具：**
```bash
# 如果有构建脚本
./build.sh

# 手动更新
dart pub global deactivate clean_arc
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

**清理缓存：**
```bash
dart pub cache clean
rm -rf .dart_tool
dart pub get
```

## ❓ 常见问题

| 问题 | 解决方案 |
|------|----------|
| `clean_arc: 找不到命令` | 将 `~/.pub-cache/bin` 添加到您的 PATH |
| 权限被拒绝 | 使用 `sudo` 或检查目录权限 |
| 生成失败 | 确保您在包含 `pubspec.yaml` 的 Flutter 项目根目录中 |
| 依赖项过期 | 将工具更新到最新版本 |

## 🤝 贡献

我们欢迎贡献！请查看我们的[贡献指南](CONTRIBUTING.md)。

1. Fork 仓库
2. 创建您的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📞 支持

- 🐛 [报告问题](https://github.com/Invincible1996/clean_arc/issues)
- ⭐ 如果觉得有用，请给仓库加星
- 👀 关注获取更新

## 📄 许可证

该项目根据 MIT 许可证获得许可 - 有关详细信息，请参阅 [LICENSE](LICENSE) 文件。

---

<div align="center">
  <p>由 Clean Arc 团队用 ❤️ 制作</p>
  <p>
    <a href="https://github.com/Invincible1996/clean_arc">⭐ 给项目加星</a> •
    <a href="https://github.com/Invincible1996/clean_arc/issues">🐛 报告问题</a> •
    <a href="https://github.com/Invincible1996/clean_arc/issues">💡 功能建议</a>
  </p>
</div>