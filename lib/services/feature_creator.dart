// lib/services/feature_creator.dart

import 'dart:io';

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
    // 确保 core 目录存在
    await Directory('lib/core/network').create(recursive: true);
    await Directory('lib/core/error').create(recursive: true);
    await Directory('lib/core/usecases').create(recursive: true);

    // 创建核心基础设施文件
    final coreFiles = {
      'lib/core/network/network_info.dart': _networkInfoTemplate,
      'lib/core/error/failures.dart': _failuresTemplate,
      'lib/core/usecases/usecase.dart': _usecaseBaseTemplate,
    };

    // 创建核心文件（如果不存在）
    for (final entry in coreFiles.entries) {
      final file = File(entry.key);
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(entry.value);
        print('📝 Created core file: ${entry.key}');
      }
    }

    final files = {
      // Domain Layer
      'lib/features/$name/domain/entities/${name}_entity.dart': _entityTemplate,
      'lib/features/$name/domain/repositories/${name}_repository.dart':
          _repositoryTemplate,
      'lib/features/$name/domain/usecases/get_${name}.dart': _usecaseTemplate,

      // Data Layer
      'lib/features/$name/data/models/${name}_model.dart': _modelTemplate,
      'lib/features/$name/data/datasources/${name}_remote_data_source.dart':
          _remoteDataSourceTemplate,
      'lib/features/$name/data/repositories/${name}_repository_impl.dart':
          _repositoryImplTemplate,

      // Presentation Layer
      'lib/features/$name/presentation/providers/${name}_provider.dart':
          _providerTemplate,
      'lib/features/$name/presentation/screens/${name}_screen.dart':
          _screenTemplate,
    };

    for (final entry in files.entries) {
      final file = File(entry.key);
      await file.create(recursive: true);
      await file.writeAsString(entry.value);
      print('📝 Created: ${entry.key}');
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
    
    // Get the project name from pubspec.yaml
    final pubspecFile = File('pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsString();
    final projectName = RegExp(r'name:\s+(\S+)').firstMatch(pubspecContent)?.group(1) ?? 'app';

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
    final projectName = RegExp(r'name:\s+(\S+)').firstMatch(pubspecContent)?.group(1) ?? 'app';

    // Add import statement
    final importStatement = "import 'package:$projectName/features/${name.toLowerCase()}/presentation/screens/${name.toLowerCase()}_screen.dart';\n";
    final insertIndex = content.indexOf("import 'package:auto_route/auto_route.dart';") + 
        "import 'package:auto_route/auto_route.dart';".length;
    
    // Add route
    final routesIndex = content.indexOf('routes => [') + 'routes => ['.length;
    final routeToAdd = '''

        AutoRoute(
          path: '/${name.toLowerCase()}',
          page: ${_pascalCase}Route.page,
        ),''';

    final newContent = content.replaceRange(
      0,
      content.length,
      content.substring(0, insertIndex) + '\n' + importStatement + content.substring(insertIndex, routesIndex) + routeToAdd + content.substring(routesIndex),
    );

    await routerFile.writeAsString(newContent);
  }

  String get _entityTemplate => '''
class ${_pascalCase}Entity {
  // TODO: Define your entity properties here
  
  const ${_pascalCase}Entity();
}
''';

  String get _repositoryTemplate => '''
abstract class ${_pascalCase}Repository {
  // TODO: Define your repository methods here
}
''';

  String get _usecaseTemplate => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/${name}_entity.dart';
import '../repositories/${name}_repository.dart';

class Get${_pascalCase} implements UseCase<${_pascalCase}Entity, NoParams> {
  final ${_pascalCase}Repository repository;

  Get${_pascalCase}(this.repository);

  @override
  Future<Either<Failure, ${_pascalCase}Entity>> call(NoParams params) async {
    // Implement the use case logic here
    throw UnimplementedError();
  }
}
''';

  String get _modelTemplate => '''
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/${name}_entity.dart';

part '${name}_model.g.dart';

@JsonSerializable()
class ${_pascalCase}Model {
  // TODO: Define your model properties here
  
  const ${_pascalCase}Model();

  factory ${_pascalCase}Model.fromJson(Map<String, dynamic> json) => 
      _\$${_pascalCase}ModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${_pascalCase}ModelToJson(this);

  ${_pascalCase}Entity toEntity() {
    // Implement conversion to entity
    throw UnimplementedError();
  }

  static List<${_pascalCase}Entity> toEntityList(List<${_pascalCase}Model> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
''';

  String get _remoteDataSourceTemplate => '''
import 'package:dio/dio.dart';
import '../models/${name}_model.dart';

abstract class ${_pascalCase}RemoteDataSource {
  // Define your remote data source methods here
}

class ${_pascalCase}RemoteDataSourceImpl implements ${_pascalCase}RemoteDataSource {
  final Dio dio;

  ${_pascalCase}RemoteDataSourceImpl({required this.dio});

  // Implement your remote data source methods here
}
''';

  String get _repositoryImplTemplate => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/${name}_entity.dart';
import '../../domain/repositories/${name}_repository.dart';
import '../datasources/${name}_remote_data_source.dart';

class ${_pascalCase}RepositoryImpl implements ${_pascalCase}Repository {
  final ${_pascalCase}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ${_pascalCase}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // Implement your repository methods here
}
''';

  String get _providerTemplate {
    if (!useRiverpod) return '';
    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/${name}_entity.dart';

// State
class ${_pascalCase}State {
  final bool isLoading;
  final List<${_pascalCase}Entity> items;
  final String? error;

  const ${_pascalCase}State({
    this.isLoading = false,
    this.items = const [],
    this.error,
  });

  ${_pascalCase}State copyWith({
    bool? isLoading,
    List<${_pascalCase}Entity>? items,
    String? error,
  }) {
    return ${_pascalCase}State(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}

// Provider
final ${_camelCase}Provider = StateNotifierProvider<${_pascalCase}Notifier, ${_pascalCase}State>(
  (ref) => ${_pascalCase}Notifier(),
);

// Notifier
class ${_pascalCase}Notifier extends StateNotifier<${_pascalCase}State> {
  ${_pascalCase}Notifier() : super(const ${_pascalCase}State());

  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true);
    try {
      // Implement data loading
      state = state.copyWith(
        isLoading: false,
        items: [],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
''';
  }

  String get _screenTemplate => '''
import 'package:flutter/material.dart';
${useRiverpod ? "import 'package:flutter_riverpod/flutter_riverpod.dart';" : ""}
${useRoute ? "import 'package:auto_route/auto_route.dart';" : ""}

${useRoute ? "@RoutePage()" : ""}
class ${_pascalCase}Screen extends ${useRiverpod ? 'ConsumerWidget' : 'StatelessWidget'} {
  const ${_pascalCase}Screen({super.key});

  @override
  Widget build(BuildContext context${useRiverpod ? ', WidgetRef ref' : ''}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${_pascalCase}'),
      ),
      body: const Center(
        child: Text('${_pascalCase} Screen'),
      ),
    );
  }
}
''';

  String get _networkInfoTemplate => '''
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
''';

  String get _failuresTemplate => '''
abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}
''';

  String get _usecaseBaseTemplate => '''
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
''';

  String get _pascalCase {
    return name[0].toUpperCase() + name.substring(1);
  }

  String get _camelCase {
    return name[0].toLowerCase() + name.substring(1);
  }

  void _printNextSteps() {
    print('\n📝 Next steps:');
    print('1. Implement your business logic in the $name feature module');
    print('2. Run build_runner to generate JSON serialization code:');
    print('   flutter pub run build_runner build --delete-conflicting-outputs');
    print('3. Add the new feature to your routing configuration');
  }
}
