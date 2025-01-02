import 'dart:io';
import 'package:clean_arc/src/enums/state_management.dart';
import 'package:clean_arc/src/generators/generator.dart';

/// Generator for feature modules
class FeatureGenerator extends Generator {
  final String basePath;
  final String featureName;
  final StateManagement stateManagement;

  FeatureGenerator(
    this.basePath,
    this.featureName, {
    this.stateManagement = StateManagement.riverpod,
  });

  @override
  Future<void> generate() async {
    final featuresFolder = '$basePath/lib/src/features/$featureName';
    Directory(featuresFolder).createSync(recursive: true);

    // Create layer directories
    _createDirectories(featuresFolder);

    // Generate files
    await _generateFiles(featuresFolder);
  }

  void _createDirectories(String featuresFolder) {
    // Data layer
    Directory('$featuresFolder/data/datasource').createSync(recursive: true);
    Directory('$featuresFolder/data/models').createSync();
    Directory('$featuresFolder/data/repositories').createSync();

    // Domain layer
    Directory('$featuresFolder/domain/repositories').createSync(recursive: true);
    Directory('$featuresFolder/domain/entities').createSync();
    Directory('$featuresFolder/domain/usecases').createSync();

    // Presentation layer
    Directory('$featuresFolder/presentation/screens').createSync(recursive: true);
    Directory('$featuresFolder/presentation/widgets').createSync();

    // State management specific directories
    switch (stateManagement) {
      case StateManagement.riverpod:
        Directory('$featuresFolder/presentation/providers').createSync();
        Directory('$featuresFolder/presentation/providers/state').createSync();
        Directory('$featuresFolder/presentation/providers/notifier').createSync();
        break;
      case StateManagement.bloc:
        Directory('$featuresFolder/presentation/bloc').createSync();
        break;
    }
  }

  Future<void> _generateFiles(String featuresFolder) async {
    // Data layer
    _generateDataSourceFile(featuresFolder);
    _generateModelFile(featuresFolder);
    _generateRepositoryImplFile(featuresFolder);

    // Domain layer
    _generateRepositoryFile(featuresFolder);
    _generateEntityFile(featuresFolder);
    _generateUseCaseFile(featuresFolder);

    // Presentation layer
    _generateScreenFile(featuresFolder);
    _generateStateManagementFiles(featuresFolder);
  }

  void _generateDataSourceFile(String featuresFolder) {
    final file = File('$featuresFolder/data/datasource/${featureName}_datasource.dart');
    file.writeAsStringSync('''
import 'package:dio/dio.dart';

abstract class ${_pascalCase(featureName)}Datasource {
  Future<void> getData();
}

class ${_pascalCase(featureName)}DatasourceImpl implements ${_pascalCase(featureName)}Datasource {
  final Dio dio;

  ${_pascalCase(featureName)}DatasourceImpl(this.dio);

  @override
  Future<void> getData() async {
    // TODO: Implement getData
    throw UnimplementedError();
  }
}
''');
  }

  void _generateModelFile(String featuresFolder) {
    final file = File('$featuresFolder/data/models/${featureName}_model.dart');
    file.writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/${featureName}_entity.dart';

part '${featureName}_model.freezed.dart';
part '${featureName}_model.g.dart';

@freezed
class ${_pascalCase(featureName)}Model with _\$${_pascalCase(featureName)}Model {
  const factory ${_pascalCase(featureName)}Model({
    required String id,
    required String name,
  }) = _${_pascalCase(featureName)}Model;

  factory ${_pascalCase(featureName)}Model.fromJson(Map<String, dynamic> json) =>
      _\$${_pascalCase(featureName)}ModelFromJson(json);

  factory ${_pascalCase(featureName)}Model.fromEntity(${_pascalCase(featureName)}Entity entity) =>
      ${_pascalCase(featureName)}Model(
        id: entity.id,
        name: entity.name,
      );
}
''');
  }

  void _generateRepositoryImplFile(String featuresFolder) {
    final file = File('$featuresFolder/data/repositories/${featureName}_repository_impl.dart');
    file.writeAsStringSync('''
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasource/${featureName}_datasource.dart';

class ${_pascalCase(featureName)}RepositoryImpl implements ${_pascalCase(featureName)}Repository {
  final ${_pascalCase(featureName)}Datasource datasource;

  ${_pascalCase(featureName)}RepositoryImpl(this.datasource);

  @override
  Future<void> getData() async {
    return datasource.getData();
  }
}
''');
  }

  void _generateRepositoryFile(String featuresFolder) {
    final file = File('$featuresFolder/domain/repositories/${featureName}_repository.dart');
    file.writeAsStringSync('''
abstract class ${_pascalCase(featureName)}Repository {
  Future<void> getData();
}
''');
  }

  void _generateEntityFile(String featuresFolder) {
    final file = File('$featuresFolder/domain/entities/${featureName}_entity.dart');
    file.writeAsStringSync('''
class ${_pascalCase(featureName)}Entity {
  final String id;
  final String name;

  const ${_pascalCase(featureName)}Entity({
    required this.id,
    required this.name,
  });
}
''');
  }

  void _generateUseCaseFile(String featuresFolder) {
    final file = File('$featuresFolder/domain/usecases/get_${featureName}.dart');
    file.writeAsStringSync('''
import '../repositories/${featureName}_repository.dart';

class Get${_pascalCase(featureName)} {
  final ${_pascalCase(featureName)}Repository repository;

  Get${_pascalCase(featureName)}(this.repository);

  Future<void> call() async {
    return repository.getData();
  }
}
''');
  }

  void _generateScreenFile(String featuresFolder) {
    final file = File('$featuresFolder/presentation/screens/${featureName}_screen.dart');
    switch (stateManagement) {
      case StateManagement.riverpod:
        file.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifier/${featureName}_notifier.dart';

class ${_pascalCase(featureName)}Screen extends ConsumerWidget {
  const ${_pascalCase(featureName)}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${featureName}Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${_pascalCase(featureName)}'),
      ),
      body: state.when(
        data: (data) => const Center(child: Text('${_pascalCase(featureName)} Screen')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}
''');
        break;
      case StateManagement.bloc:
        file.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/${featureName}_bloc.dart';

class ${_pascalCase(featureName)}Screen extends StatelessWidget {
  const ${_pascalCase(featureName)}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${_pascalCase(featureName)}Bloc()..add(const ${_pascalCase(featureName)}Event.started()),
      child: BlocBuilder<${_pascalCase(featureName)}Bloc, ${_pascalCase(featureName)}State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('${_pascalCase(featureName)}'),
            ),
            body: state.when(
              initial: () => const Center(child: Text('Initial')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: () => const Center(child: Text('${_pascalCase(featureName)} Screen')),
              error: (message) => Center(child: Text(message)),
            ),
          );
        },
      ),
    );
  }
}
''');
        break;
    }
  }

  void _generateStateManagementFiles(String featuresFolder) {
    switch (stateManagement) {
      case StateManagement.riverpod:
        _generateRiverpodFiles(featuresFolder);
        break;
      case StateManagement.bloc:
        _generateBlocFiles(featuresFolder);
        break;
    }
  }

  void _generateRiverpodFiles(String featuresFolder) {
    // State
    final stateFile = File('$featuresFolder/presentation/providers/state/${featureName}_state.dart');
    stateFile.writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${featureName}_state.freezed.dart';

@freezed
class ${_pascalCase(featureName)}State with _\$${_pascalCase(featureName)}State {
  const factory ${_pascalCase(featureName)}State.data() = _Data;
  const factory ${_pascalCase(featureName)}State.loading() = _Loading;
  const factory ${_pascalCase(featureName)}State.error(String message) = _Error;
}
''');

    // Notifier
    final notifierFile = File('$featuresFolder/presentation/providers/notifier/${featureName}_notifier.dart');
    notifierFile.writeAsStringSync('''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/${featureName}_state.dart';
import '../../../domain/usecases/get_${featureName}.dart';

final ${featureName}Provider = StateNotifierProvider<${_pascalCase(featureName)}Notifier, ${_pascalCase(featureName)}State>(
  (ref) => ${_pascalCase(featureName)}Notifier(),
);

class ${_pascalCase(featureName)}Notifier extends StateNotifier<${_pascalCase(featureName)}State> {
  ${_pascalCase(featureName)}Notifier() : super(const ${_pascalCase(featureName)}State.loading());

  Future<void> getData() async {
    try {
      state = const ${_pascalCase(featureName)}State.loading();
      // TODO: Implement getData
      state = const ${_pascalCase(featureName)}State.data();
    } catch (e) {
      state = ${_pascalCase(featureName)}State.error(e.toString());
    }
  }
}
''');
  }

  void _generateBlocFiles(String featuresFolder) {
    final blocFile = File('$featuresFolder/presentation/bloc/${featureName}_bloc.dart');
    blocFile.writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/usecases/get_${featureName}.dart';

part '${featureName}_event.dart';
part '${featureName}_state.dart';
part '${featureName}_bloc.freezed.dart';

class ${_pascalCase(featureName)}Bloc extends Bloc<${_pascalCase(featureName)}Event, ${_pascalCase(featureName)}State> {
  ${_pascalCase(featureName)}Bloc() : super(const ${_pascalCase(featureName)}State.initial()) {
    on<${_pascalCase(featureName)}Event>((event, emit) async {
      await event.when(
        started: () async {
          try {
            emit(const ${_pascalCase(featureName)}State.loading());
            // TODO: Implement getData
            emit(const ${_pascalCase(featureName)}State.loaded());
          } catch (e) {
            emit(${_pascalCase(featureName)}State.error(e.toString()));
          }
        },
      );
    });
  }
}
''');

    final eventFile = File('$featuresFolder/presentation/bloc/${featureName}_event.dart');
    eventFile.writeAsStringSync('''
part of '${featureName}_bloc.dart';

@freezed
class ${_pascalCase(featureName)}Event with _\$${_pascalCase(featureName)}Event {
  const factory ${_pascalCase(featureName)}Event.started() = _Started;
}
''');

    final stateFile = File('$featuresFolder/presentation/bloc/${featureName}_state.dart');
    stateFile.writeAsStringSync('''
part of '${featureName}_bloc.dart';

@freezed
class ${_pascalCase(featureName)}State with _\$${_pascalCase(featureName)}State {
  const factory ${_pascalCase(featureName)}State.initial() = _Initial;
  const factory ${_pascalCase(featureName)}State.loading() = _Loading;
  const factory ${_pascalCase(featureName)}State.loaded() = _Loaded;
  const factory ${_pascalCase(featureName)}State.error(String message) = _Error;
}
''');
  }

  String _pascalCase(String text) {
    return text
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join('');
  }
}
