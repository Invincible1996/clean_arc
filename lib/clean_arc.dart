import 'dart:io';

import 'package:clean_arc/extension/string_extension.dart';
import 'package:clean_arc/src/enums/state_management.dart';
import 'package:clean_arc/utils/date_format_util.dart';

void cleanArc(String featureName, {StateManagement stateManagement = StateManagement.riverpod}) {
  // framework
  if (featureName == 'framework') {
    print('current command is create framework directory for clean architecture');
    // 创建基本的项目结构
    // lib/
    // |-- core/
    // |   |-- models/
    // |   |-- constants/
    // |   |   |-- api_constants.dart
    // |   |   |-- app_constants.dart
    // |   |-- themes/
    // |   |   |-- app_theme.dart
    // |   |-- utils/
    // |   |   |-- helpers.dart
    // |   |-- services/
    // |   |   |-- api_service.dart
    // |   |   |-- storage_service.dart
    // |-- routes/
    // |   |-- app_router.dart
    // |   |-- app_router.gr.dart
    // |
    // |-- main.dart

    // 在当前目录下的 "lib/src" 路径中创建新文件夹
    String srcFolder = 'lib/src';
    Directory(srcFolder).createSync(recursive: true);

    // 1. 创建core文件夹
    Directory('$srcFolder/core').createSync();

    // 1.0 创建models文件夹
    Directory('$srcFolder/core/models').createSync();

    // 1.1 创建constants文件夹
    Directory('$srcFolder/core/constants').createSync();
    // 1.1.1 创建api_constants.dart
    final apiConstantsFile =
        File('$srcFolder/core/constants/api_constants.dart');
    apiConstantsFile.createSync();
    apiConstantsFile.writeAsStringSync('''

    abstract class ApiConstants {
    // Add your variables here
  }
  ''');
    // 1.1.2 创建app_constants.dart
    final appConstantsFile =
        File('$srcFolder/core/constants/app_constants.dart');
    appConstantsFile.createSync();
    appConstantsFile.writeAsStringSync('''
    /// author : kevin
    /// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
    /// This is AppConstants
    abstract class AppConstants {
    // Add your variables here
  }
  ''');
    // 1.2 创建themes文件夹
    Directory('$srcFolder/core/themes').createSync();
    // 1.2.1 创建app_theme.dart
    final appThemeFile = File('$srcFolder/core/themes/app_theme.dart');
    appThemeFile.createSync();
    appThemeFile.writeAsStringSync('''
    /// author : 
    /// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
    /// This is AppTheme
    abstract class AppTheme {
    // Add your variables here
  }
  ''');
    // 1.3 创建utils文件夹
    Directory('$srcFolder/core/utils').createSync();
    // 1.3.1 创建helpers.dart
    final helpersFile = File('$srcFolder/core/utils/helpers.dart');
    helpersFile.createSync();
    helpersFile.writeAsStringSync('''
    abstract class Helpers {
    // Add your methods here
  }
  ''');

    // 1.4 创建services文件夹
    Directory('$srcFolder/core/services').createSync();
    // 1.4.1 创建api_service.dart
    final apiServiceFile = File('$srcFolder/core/services/api_service.dart');
    apiServiceFile.createSync();
    apiServiceFile.writeAsStringSync('''
    abstract class ApiService {
    // Add your methods here
  }
  ''');
    // 1.4.2 创建storage_service.dart
    final storageServiceFile =
        File('$srcFolder/core/services/storage_service.dart');

    storageServiceFile.createSync();
    storageServiceFile.writeAsStringSync('''
    abstract class StorageService {
    // Add your methods here
  }
  ''');
    // 2. 创建routes文件夹
    Directory('$srcFolder/routes').createSync();
    // 2.1 创建app_router.dart
    final appRouterFile = File('$srcFolder/routes/app_router.dart');
    appRouterFile.createSync();
    appRouterFile.writeAsStringSync('''
    abstract class AppRouter {
    // Add your methods here
  }
  ''');
    // 2.2 创建app_router.dart
    final appRouterGrFile = File('$srcFolder/routes/app_router.dart');
    appRouterGrFile.createSync();
    appRouterGrFile.writeAsStringSync('''
    abstract class AppRouterGr {
    // Add your methods here
  }
  ''');

    return;
  }

  print('featureName: $featureName');

  /// 在src目录下的features目录下创建文件夹 名称为featureName 代码如下
  /// 获取当前工作目录
  String currentDir = Directory.current.path;

  /// 在当前目录下的 "lib/src/features" 路径中创建新文件夹
  String featuresFolder = '$currentDir/lib/src/features/$featureName';
  Directory(featuresFolder).createSync(recursive: true);

  print('featuresFolder: $featuresFolder');

  /// featureName文件夹目录下创建三个文件夹 data domain presentation
  Directory('$featuresFolder/data').createSync();
  Directory('$featuresFolder/domain').createSync();
  Directory('$featuresFolder/presentation').createSync();

  /// data目录下创建三个文件夹 datasource models repositories
  Directory('$featuresFolder/data/datasource').createSync();
  Directory('$featuresFolder/data/models').createSync();
  Directory('$featuresFolder/data/repositories').createSync();

  /// domain目录下创建一个文件夹 providers,repositories,entities,
  Directory('$featuresFolder/domain/providers').createSync();
  Directory('$featuresFolder/domain/repositories').createSync();
  Directory('$featuresFolder/domain/entities').createSync();

  /// presentation目录下创建两个文件夹 screen widgets providers
  Directory('$featuresFolder/presentation/screens').createSync();
  Directory('$featuresFolder/presentation/widgets').createSync();
  Directory('$featuresFolder/presentation/providers').createSync();

  /// 根据状态管理框架创建不同的目录结构
  switch (stateManagement) {
    case StateManagement.riverpod:
      /// presentation/providers目录下创建文件夹state and notifier
      Directory('$featuresFolder/presentation/providers/state').createSync();
      Directory('$featuresFolder/presentation/providers/notifier').createSync();
      break;
    case StateManagement.bloc:
      /// presentation/bloc目录下创建文件夹
      Directory('$featuresFolder/presentation/bloc').createSync();
      break;
  }

  print('🎉 $featureName feature folder created successfully. 🎉');

  /// datasource目录下创建一个文件名为featureName_datasource.dart的文件
  final datasourceFile =
      File('$featuresFolder/data/datasource/${featureName}_datasource.dart');
  datasourceFile.createSync();
  datasourceFile.writeAsStringSync('''
  /// author : kevin
  /// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
  /// This is ${featureName.toClassName}Datasource
 abstract  class ${featureName.toClassName}Datasource {
    // Add your methods here
  }
  ''');

  /// models目录下创建一个文件名为featureName_model.dart的文件
  final modelFile =
      File('$featuresFolder/data/models/${featureName}_model.dart');
  modelFile.createSync();
  modelFile.writeAsStringSync('''
  /// This is ${featureName.toClassName}Model 
  class ${featureName.toClassName}Model {
    // Add your methods here
  }
  ''');

  /// repositories目录下创建一个文件名为featureName_repository_impl.dart的文件
  final repositoryFile = File(
      '$featuresFolder/data/repositories/${featureName}_repository_impl.dart');
  repositoryFile.createSync();
  repositoryFile.writeAsStringSync('''
  import '../../domain/repositories/${featureName}_repository.dart';

  class ${featureName.toClassName}RepositoryImpl implements ${featureName.toClassName}Repository {
    // Add your methods here
  }
  ''');

  /// providers目录下创建一个文件名为featureName_provider.dart的文件
  final providerFile =
      File('$featuresFolder/domain/providers/${featureName}_provider.dart');
  providerFile.createSync();
  providerFile.writeAsStringSync('''
  /// This is ${featureName.toClassName}Provider
  
  ''');

  /// repositories目录下创建一个文件名为featureName_repository.dart的文件
  final repositoryFile2 = File(
      '$featuresFolder/domain/repositories/${featureName}_repository.dart');
  repositoryFile2.createSync();
  repositoryFile2.writeAsStringSync('''

 abstract class ${featureName.toClassName}Repository {
    // Add your methods here
  }
  ''');

  /// entities目录下创建一个文件名为featureName_entity.dart的文件
  final entityFile =
      File('$featuresFolder/domain/entities/${featureName}_entity.dart');
  entityFile.createSync();
  entityFile.writeAsStringSync('''
  class ${featureName.toClassName}Entity {
    // Add your methods here
  }
  ''');

  /// screen目录下创建一个文件名为featureName_screen.dart的文件
  final screenFile =
      File('$featuresFolder/presentation/screens/${featureName}_screen.dart');
  screenFile.createSync();

  switch (stateManagement) {
    case StateManagement.riverpod:
      screenFile.writeAsStringSync('''
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  class ${featureName.toClassName}Screen extends ConsumerWidget {
    const ${featureName.toClassName}Screen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('${featureName.toClassName}'),
        ),
        body: Center(
          child: Text('${featureName.toClassName} Screen')
        ),
      );
    }
  }
  ''');
      break;
    case StateManagement.bloc:
      screenFile.writeAsStringSync('''
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../bloc/${featureName}_bloc.dart';

  class ${featureName.toClassName}Screen extends StatelessWidget {
    const ${featureName.toClassName}Screen({super.key});

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => ${featureName.toClassName}Bloc(),
        child: BlocBuilder<${featureName.toClassName}Bloc, ${featureName.toClassName}State>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('${featureName.toClassName}'),
              ),
              body: Center(
                child: Text('${featureName.toClassName} Screen')
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

  /// 根据状态管理框架生成不同的状态管理文件
  switch (stateManagement) {
    case StateManagement.riverpod:
      /// providers/state目录下创建一个文件名为featureName_state.dart的文件
      final stateFile = File(
          '$featuresFolder/presentation/providers/state/${featureName}_state.dart');
      stateFile.createSync();
      stateFile.writeAsStringSync('''
  import 'package:freezed_annotation/freezed_annotation.dart';

  part '${featureName}_state.freezed.dart';

  @freezed
  class ${featureName.toClassName}State with _\$${featureName.toClassName}State {
    const factory ${featureName.toClassName}State({
      @Default(false) bool isLoading,
      String? error,
    }) = _${featureName.toClassName}State;
  }
  ''');

      /// providers/notifier目录下创建一个文件名为featureName_notifier.dart的文件
      final notifierFile = File(
          '$featuresFolder/presentation/providers/notifier/${featureName}_notifier.dart');
      notifierFile.createSync();
      notifierFile.writeAsStringSync('''
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../state/${featureName}_state.dart';

  final ${featureName}Provider = StateNotifierProvider<${featureName.toClassName}Notifier, ${featureName.toClassName}State>(
    (ref) => ${featureName.toClassName}Notifier(),
  );

  class ${featureName.toClassName}Notifier extends StateNotifier<${featureName.toClassName}State> {
    ${featureName.toClassName}Notifier() : super(const ${featureName.toClassName}State());

    // Add your methods here
  }
  ''');
      break;
    case StateManagement.bloc:
      /// bloc目录下创建bloc、event和state文件
      final blocFile =
          File('$featuresFolder/presentation/bloc/${featureName}_bloc.dart');
      blocFile.createSync();
      blocFile.writeAsStringSync('''
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:freezed_annotation/freezed_annotation.dart';

  part '${featureName}_event.dart';
  part '${featureName}_state.dart';
  part '${featureName}_bloc.freezed.dart';

  class ${featureName.toClassName}Bloc extends Bloc<${featureName.toClassName}Event, ${featureName.toClassName}State> {
    ${featureName.toClassName}Bloc() : super(const ${featureName.toClassName}State()) {
      on<${featureName.toClassName}Event>((event, emit) {
        event.map(
          started: (event) async {
            // Add your logic here
          },
        );
      });
    }
  }
  ''');

      final eventFile =
          File('$featuresFolder/presentation/bloc/${featureName}_event.dart');
      eventFile.createSync();
      eventFile.writeAsStringSync('''
  part of '${featureName}_bloc.dart';

  @freezed
  class ${featureName.toClassName}Event with _\$${featureName.toClassName}Event {
    const factory ${featureName.toClassName}Event.started() = _Started;
  }
  ''');

      final stateFile =
          File('$featuresFolder/presentation/bloc/${featureName}_state.dart');
      stateFile.createSync();
      stateFile.writeAsStringSync('''
  part of '${featureName}_bloc.dart';

  @freezed
  class ${featureName.toClassName}State with _\$${featureName.toClassName}State {
    const factory ${featureName.toClassName}State({
      @Default(false) bool isLoading,
      String? error,
    }) = _${featureName.toClassName}State;
  }
  ''');
      break;
  }
}
