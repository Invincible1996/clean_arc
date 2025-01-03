// lib/templates/feature_templates.dart

class FeatureTemplates {
  // Data Layer Templates
  static String dataSourceTemplate(String name) => '''
import 'package:dio/dio.dart';
import '../models/${name}_model.dart';

abstract class ${name.pascalCase}RemoteDataSource {
  Future<List<${name.pascalCase}Model>> getAll();
  Future<${name.pascalCase}Model> getById(String id);
}

class ${name.pascalCase}RemoteDataSourceImpl implements ${name.pascalCase}RemoteDataSource {
  final Dio dio;

  ${name.pascalCase}RemoteDataSourceImpl({required this.dio});

  @override
  Future<List<${name.pascalCase}Model>> getAll() async {
    try {
      final response = await dio.get('/api/${name.toLowerCase()}s');
      return (response.data as List)
          .map((json) => ${name.pascalCase}Model.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch ${name.toLowerCase()}s: \${e.message}');
    }
  }

  @override
  Future<${name.pascalCase}Model> getById(String id) async {
    try {
      final response = await dio.get('/api/${name.toLowerCase()}s/\$id');
      return ${name.pascalCase}Model.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch ${name.toLowerCase()}: \${e.message}');
    }
  }
}
''';

  static String modelTemplate(String name) => '''
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/entities/${name}_entity.dart';

part '${name}_model.freezed.dart';
part '${name}_model.g.dart';

@freezed
class ${name.pascalCase}Model extends ${name.pascalCase}Entity with _\$${name.pascalCase}Model {
  const factory ${name.pascalCase}Model({
    required String id,
    required String title,
    @Default('') String description,
  }) = _${name.pascalCase}Model;

  factory ${name.pascalCase}Model.fromJson(Map<String, dynamic> json) =>
      _\$${name.pascalCase}ModelFromJson(json);
}
''';

  static String repositoryImplTemplate(String name) => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/${name}_entity.dart';
import '../../domain/repositories/${name}_repository.dart';
import '../datasources/${name}_remote_data_source.dart';

class ${name.pascalCase}RepositoryImpl implements ${name.pascalCase}Repository {
  final ${name.pascalCase}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ${name.pascalCase}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<${name.pascalCase}Entity>>> getAll() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItems = await remoteDataSource.getAll();
        return Right(remoteItems);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ${name.pascalCase}Entity>> getById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItem = await remoteDataSource.getById(id);
        return Right(remoteItem);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
''';

  // Domain Layer Templates
  static String entityTemplate(String name) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${name}_entity.freezed.dart';

@freezed
class ${name.pascalCase}Entity with _\$${name.pascalCase}Entity {
  const factory ${name.pascalCase}Entity({
    required String id,
    required String title,
    @Default('') String description,
  }) = _${name.pascalCase}Entity;
}
''';

  static String repositoryTemplate(String name) => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/${name}_entity.dart';

abstract class ${name.pascalCase}Repository {
  Future<Either<Failure, List<${name.pascalCase}Entity>>> getAll();
  Future<Either<Failure, ${name.pascalCase}Entity>> getById(String id);
}
''';

  static String useCaseTemplate(String name) => '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/${name}_entity.dart';
import '../repositories/${name}_repository.dart';

class Get${name.pascalCase}s implements UseCase<List<${name.pascalCase}Entity>, NoParams> {
  final ${name.pascalCase}Repository repository;

  Get${name.pascalCase}s(this.repository);

  @override
  Future<Either<Failure, List<${name.pascalCase}Entity>>> call(NoParams params) {
    return repository.getAll();
  }
}

class Get${name.pascalCase} implements UseCase<${name.pascalCase}Entity, Params> {
  final ${name.pascalCase}Repository repository;

  Get${name.pascalCase}(this.repository);

  @override
  Future<Either<Failure, ${name.pascalCase}Entity>> call(Params params) {
    return repository.getById(params.id);
  }
}

class Params {
  final String id;
  const Params({required this.id});
}
''';

  // Presentation Layer Templates
  static String stateTemplate(String name) => '''
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/${name}_entity.dart';

part '${name}_state.freezed.dart';

@freezed
class ${name.pascalCase}State with _\$${name.pascalCase}State {
  const factory ${name.pascalCase}State.initial() = _Initial;
  const factory ${name.pascalCase}State.loading() = _Loading;
  const factory ${name.pascalCase}State.loaded(List<${name.pascalCase}Entity> items) = _Loaded;
  const factory ${name.pascalCase}State.error(String message) = _Error;
}
''';

  static String providerTemplate(String name) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/${name}_entity.dart';
import '../../domain/usecases/get_${name}.dart';
import '${name}_state.dart';

final ${name.camelCase}Provider =
    StateNotifierProvider<${name.pascalCase}Notifier, ${name.pascalCase}State>(
  (ref) => ${name.pascalCase}Notifier(
    get${name.pascalCase}s: ref.watch(get${name.pascalCase}sProvider),
  ),
);

class ${name.pascalCase}Notifier extends StateNotifier<${name.pascalCase}State> {
  final Get${name.pascalCase}s _get${name.pascalCase}s;

  ${name.pascalCase}Notifier({
    required Get${name.pascalCase}s get${name.pascalCase}s,
  })  : _get${name.pascalCase}s = get${name.pascalCase}s,
        super(const ${name.pascalCase}State.initial());

  Future<void> loadItems() async {
    state = const ${name.pascalCase}State.loading();
    final result = await _get${name.pascalCase}s(NoParams());
    state = result.fold(
      (failure) => ${name.pascalCase}State.error(failure.toString()),
      (items) => ${name.pascalCase}State.loaded(items),
    );
  }
}
''';

  static String screenTemplate(String name) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/${name}_provider.dart';
import '../widgets/${name}_list_item.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ${name.pascalCase}Screen extends ConsumerStatefulWidget {
  const ${name.pascalCase}Screen({super.key});

  @override
  ConsumerState<${name.pascalCase}Screen> createState() => _${name.pascalCase}ScreenState();
}

class _${name.pascalCase}ScreenState extends ConsumerState<${name.pascalCase}Screen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(${name.camelCase}Provider.notifier).loadItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(${name.camelCase}Provider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${name.pascalCase}'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('Initial State')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ${name.pascalCase}ListItem(
            item: items[index],
          ),
        ),
        error: (message) => Center(child: Text(message)),
      ),
    );
  }
}
''';

  static String widgetTemplate(String name) => '''
import 'package:flutter/material.dart';
import '../../domain/entities/${name}_entity.dart';

class ${name.pascalCase}ListItem extends StatelessWidget {
  final ${name.pascalCase}Entity item;

  const ${name.pascalCase}ListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.title),
        subtitle: Text(item.description),
        onTap: () {
          // TODO: Navigate to detail screen
        },
      ),
    );
  }
}
''';
}

// 扩展方法用于字符串转换
extension StringCaseExtension on String {
  String get pascalCase {
    return isEmpty
        ? ''
        : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get camelCase {
    return isEmpty ? '' : '${this[0].toLowerCase()}${substring(1)}';
  }
}
