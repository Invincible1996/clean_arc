// lib/services/feature_creator.dart

import 'dart:io';
import '../templates/feature_templates.dart';

String _pascalCase(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}

class FeatureCreator {
  final String name;
  final bool useRoute;
  bool useRiverpod = true;

  FeatureCreator({
    required this.name,
    this.useRoute = false,
  });

  Future<void> create() async {
    // Check if in Flutter project root directory
    if (!await _isFlutterProject()) {
      print('❌ Please run this command in the Flutter project root directory');
      return;
    }

    // Check if feature module already exists
    if (await _featureExists()) {
      print('❌ Feature module "$name" already exists');
      return;
    }

    // Check if using Riverpod
    useRiverpod = await _checkRiverpod();

    print('🚀 Creating feature module: $name');

    // 1. Create directory structure
    await _createDirectories();

    // 2. Create base files
    await _createFiles();

    // 3. Update router if needed
    if (useRoute) {
      await _updateRouter();
    }

    print('✅ Feature module created successfully!');
    _printNextSteps();
  }

  Future<bool> _isFlutterProject() async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) {
      return false;
    }
    final content = await pubspecFile.readAsString();
    return content.contains('flutter:');
  }

  Future<bool> _featureExists() async {
    final featureDir = Directory('lib/features/$name');
    return await featureDir.exists();
  }

  Future<bool> _checkRiverpod() async {
    final pubspecFile = File('pubspec.yaml');
    final content = await pubspecFile.readAsString();
    return content.contains('flutter_riverpod:');
  }

  Future<void> _createDirectories() async {
    final directories = [
      // Data Layer
      'lib/features/$name/data/datasources',
      'lib/features/$name/data/models',
      'lib/features/$name/data/repositories',

      // Domain Layer
      'lib/features/$name/domain/entities',
      'lib/features/$name/domain/repositories',
      'lib/features/$name/domain/usecases',
      'lib/features/$name/domain/providers',

      // Presentation Layer
      'lib/features/$name/presentation/providers',
      'lib/features/$name/presentation/screens',
      'lib/features/$name/presentation/widgets',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
      print('📁 Created: $dir');
    }
  }

  Future<void> _createFiles() async {
    final files = {
      // Domain Layer
      'lib/features/$name/domain/entities/${name}_entity.dart':
          FeatureTemplates.entity(name),
      'lib/features/$name/domain/repositories/${name}_repository.dart':
          FeatureTemplates.repository(name),
      'lib/features/$name/domain/usecases/get_${name}.dart':
          FeatureTemplates.usecase(name),

      // Data Layer
      'lib/features/$name/data/models/${name}_model.dart':
          FeatureTemplates.model(name),
      'lib/features/$name/data/datasources/${name}_remote_data_source.dart':
          FeatureTemplates.remoteDataSource(name),
      'lib/features/$name/data/repositories/${name}_repository_impl.dart':
          FeatureTemplates.repositoryImpl(name),

      // Presentation Layer
      'lib/features/$name/presentation/providers/${name}_provider.dart':
          FeatureTemplates.provider(name, useRiverpod),
      'lib/features/$name/presentation/screens/${name}_screen.dart':
          FeatureTemplates.screen(name, useRiverpod: useRiverpod, useRoute: useRoute),
    };

    for (final entry in files.entries) {
      final file = File(entry.key);
      await file.create(recursive: true);
      await file.writeAsString(entry.value);
      print('📝 Created: ${entry.key}');
    }

    // Create domain providers
    if (useRiverpod) {
      await File('lib/features/$name/domain/providers/${name}_providers.dart')
          .writeAsString(FeatureTemplates.domainProvider(name));
      print('📄 Created: domain providers');
    }
  }

  Future<void> _updateRouter() async {
    final routerFile = File('lib/core/router/app_router.dart');
    if (!await routerFile.exists()) {
      await _createRouterFile();
    }
    await _addRouteToRouter();
  }

  Future<void> _createRouterFile() async {
    await Directory('lib/core/router').create(recursive: true);
    final routerFile = File('lib/core/router/app_router.dart');

    await routerFile.writeAsString('''
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _\$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Add your routes here
      ];
}
''');
  }

  Future<void> _addRouteToRouter() async {
    final routerFile = File('lib/core/router/app_router.dart');
    final content = await routerFile.readAsString();

    // Get the project name from pubspec.yaml
    final pubspecFile = File('pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsString();
    final projectName =
        RegExp(r'name:\s+(\S+)').firstMatch(pubspecContent)?.group(1) ?? 'app';

    // Add import statement
    final importStatement =
        "import 'package:$projectName/features/${name.toLowerCase()}/presentation/screens/${name.toLowerCase()}_screen.dart';\n";
    final insertIndex =
        content.indexOf("import 'package:auto_route/auto_route.dart';") +
            "import 'package:auto_route/auto_route.dart';".length;

    // Add route
    final routesIndex = content.indexOf('routes => [') + 'routes => ['.length;
    final routeToAdd = '''

        AutoRoute(
          path: '/${name.toLowerCase()}',
          page: ${_pascalCase(name)}Route.page,
        ),''';

    final newContent = content.replaceRange(
      0,
      content.length,
      content.substring(0, insertIndex) +
          '\n' +
          importStatement +
          content.substring(insertIndex, routesIndex) +
          routeToAdd +
          content.substring(routesIndex),
    );

    await routerFile.writeAsString(newContent);
  }

  void _printNextSteps() {
    print('\n📝 Next steps:');
    print('1. Implement your business logic in the $name feature module');
    print('2. Run build_runner to generate JSON serialization code:');
    print('   flutter pub run build_runner build --delete-conflicting-outputs');
    print('3. Add the new feature to your routing configuration');
  }
}
