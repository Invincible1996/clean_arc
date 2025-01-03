import 'dart:io';

import '../templates/core_templates.dart';

class ProjectCreator {
  final String name;
  final String organization;
  final bool useRiverpod;
  final bool useDio;
  final bool useHive;

  ProjectCreator({
    required this.name,
    required this.organization,
    this.useRiverpod = true,
    this.useDio = true,
    this.useHive = true,
  });

  Future<void> create() async {
    print('🚀 创建 Flutter 项目: $name');

    // 1. 创建基础 Flutter 项目
    final result = await Process.run(
      'flutter',
      [
        'create',
        '--org',
        organization,
        '--project-name',
        name,
        '--platforms',
        'ios,android',
        name,
      ],
    );

    if (result.exitCode != 0) {
      print('❌ 创建项目失败: ${result.stderr}');
      return;
    }

    // 2. 创建目录结构
    await _createProjectStructure();

    // 3. 更新 pubspec.yaml
    await _updatePubspec();

    // 4. 添加模板文件
    await _addTemplateFiles();

    // 5. 运行 pub get
    await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: name,
    );

    print('✅ 项目创建成功!');
    _printNextSteps();
  }

  Future<void> _createProjectStructure() async {
    print('📁 创建项目结构...');
    final directories = [
      // Core Layer
      'lib/core/api',
      'lib/core/config',
      'lib/core/constants',
      'lib/core/di',
      'lib/core/extensions',
      'lib/core/router',
      'lib/core/services',
      'lib/core/storage',
      'lib/core/theme',
      'lib/core/utils',
      'lib/core/widgets',

      // Features Layer - 只创建空的 features 目录
      'lib/features',

      // Resources
      'assets/icons',
      'assets/images',
      'assets/translations',
    ];

    for (final dir in directories) {
      await Directory('$name/$dir').create(recursive: true);
      print('  ✓ Created $dir');
    }
  }

  Future<void> _updatePubspec() async {
    final pubspecFile = File('$name/pubspec.yaml');
    var content = await pubspecFile.readAsString();

    final dependencies = <String, String>{
      if (useRiverpod) 'flutter_riverpod': '^2.5.1',
      if (useDio) 'dio': '^5.4.1',
      if (useHive) ...{
        'hive': '^2.2.3',
        'hive_flutter': '^1.1.0',
      },
      'auto_route': '^7.8.4',
      'internet_connection_checker': '^0.0.1',
      'dartz': '^0.10.1',
      'equatable': '^2.0.3',
      'json_annotation': '^4.8.1',
      'shared_preferences': '^2.2.2',
    };

    final devDependencies = <String, String>{
      'flutter_lints': '^2.0.0',
      'build_runner': '^2.4.8',
      'json_serializable': '^6.7.1',
      'auto_route_generator': '^7.3.2',
      if (useHive) 'hive_generator': '^2.0.1',
    };

    // 添加依赖
    final depSection =
        dependencies.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');
    final devDepSection =
        devDependencies.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');

    content = content.replaceAll(
      RegExp(r'dependencies:.*?dev_dependencies:', dotAll: true),
      'dependencies:\n  flutter:\n    sdk: flutter\n$depSection\n\ndev_dependencies:',
    );

    content = content.replaceAll(
      RegExp(r'dev_dependencies:.*?flutter:', dotAll: true),
      'dev_dependencies:\n  flutter_test:\n    sdk: flutter\n$devDepSection\n\nflutter:',
    );

    await pubspecFile.writeAsString(content);
  }

  Future<void> _addTemplateFiles() async {
    print('📄 添加模板文件...');

    final files = {
      'lib/main.dart': CoreTemplates.mainFile(useRiverpod),
      'lib/core/router/app_router.dart': CoreTemplates.appRouter,
      if (useDio) 'lib/core/network/dio_client.dart': CoreTemplates.dioClient,
      'lib/core/storage/storage_service.dart': CoreTemplates.storageService,
      'lib/core/theme/app_theme.dart': CoreTemplates.appTheme,
      // 添加错误处理相关文件
      'lib/core/error/failures.dart': CoreTemplates.failures,
      'lib/core/error/exceptions.dart': CoreTemplates.exceptions,
      'lib/core/usecases/usecase.dart': CoreTemplates.usecase,
    };

    for (final entry in files.entries) {
      final file = File('$name/${entry.key}');
      await file.create(recursive: true);
      await file.writeAsString(entry.value);
      print('  ✓ Created ${entry.key}');
    }
  }

  void _printNextSteps() {
    print('\n📝 下一步:');
    print('  1. cd $name');
    print('  2. flutter pub get');
    print('  3. dart run build_runner watch --delete-conflicting-outputs');
    print('  3. flutter run');
  }
}
