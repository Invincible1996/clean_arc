class FeatureTemplates {
  static String entity(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
class ${pascalCase}Entity {
  // TODO: Define your entity properties here

  const ${pascalCase}Entity();
}
''';
  }

  static String repository(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
abstract class ${pascalCase}Repository {
  // TODO: Define your repository methods here
}
''';
  }

  static String usecase(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/${name}_entity.dart';
import '../repositories/${name}_repository.dart';

class Get${pascalCase} implements UseCase<${pascalCase}Entity, NoParams> {
  final ${pascalCase}Repository repository;

  Get${pascalCase}(this.repository);

  @override
  Future<Either<Failure, ${pascalCase}Entity>> call(NoParams params) async {
    // Implement the use case logic here
    throw UnimplementedError();
  }
}
''';
  }

  static String model(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/${name}_entity.dart';

part '${name}_model.g.dart';

@JsonSerializable()
class ${pascalCase}Model {
  // TODO: Define your model properties here

  const ${pascalCase}Model();

  factory ${pascalCase}Model.fromJson(Map<String, dynamic> json) =>
      _\$${pascalCase}ModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${pascalCase}ModelToJson(this);

  ${pascalCase}Entity toEntity() {
    // Implement conversion to entity
    throw UnimplementedError();
  }

  static List<${pascalCase}Entity> toEntityList(List<${pascalCase}Model> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
''';
  }

  static String remoteDataSource(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
import '../../../../core/network/dio_client.dart';
import '../models/${name}_model.dart';

abstract class ${pascalCase}RemoteDataSource {
  // Define your remote data source methods here
}

class ${pascalCase}RemoteDataSourceImpl implements ${pascalCase}RemoteDataSource {
  final DioClient dioClient;

  ${pascalCase}RemoteDataSourceImpl(this.dioClient);

  // Implement your remote data source methods here
}
''';
  }

  static String repositoryImpl(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/${name}_entity.dart';
import '../../domain/repositories/${name}_repository.dart';
import '../datasources/${name}_remote_data_source.dart';

class ${pascalCase}RepositoryImpl implements ${pascalCase}Repository {
  final ${pascalCase}RemoteDataSource remoteDataSource;

  ${pascalCase}RepositoryImpl(this.remoteDataSource);

  // Implement your repository methods here
}
''';
  }

  static String provider(String name, bool useRiverpod) {
    if (!useRiverpod) return '';
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/${name}_entity.dart';

// State
class ${pascalCase}State {
  final bool isLoading;
  final List<${pascalCase}Entity> items;
  final String? error;

  const ${pascalCase}State({
    this.isLoading = false,
    this.items = const [],
    this.error,
  });

  ${pascalCase}State copyWith({
    bool? isLoading,
    List<${pascalCase}Entity>? items,
    String? error,
  }) {
    return ${pascalCase}State(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}

// Provider
final ${_toCamelCase(name)}Provider = StateNotifierProvider<${pascalCase}Notifier, ${pascalCase}State>(
  (ref) => ${pascalCase}Notifier(),
);

// Notifier
class ${pascalCase}Notifier extends StateNotifier<${pascalCase}State> {
  ${pascalCase}Notifier() : super(const ${pascalCase}State());

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

  static String domainProvider(String name) {
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/dio_client_provider.dart';
import '../../data/datasources/${name}_remote_data_source.dart';
import '../../data/repositories/${name}_repository_impl.dart';
import '../repositories/${name}_repository.dart';

final ${name}DataSourceProvider = Provider.family<${pascalCase}RemoteDataSource, DioClient>(
  (_, dioClient) => ${pascalCase}RemoteDataSourceImpl(dioClient),
);

final ${name}RepositoryProvider = Provider<${pascalCase}Repository>(
  (ref) {
    final DioClient dioClient = ref.watch(dioClientProvider);
    final ${pascalCase}RemoteDataSource dataSource =
        ref.watch(${name}DataSourceProvider(dioClient));
    return ${pascalCase}RepositoryImpl(dataSource);
  },
);
''';
  }

  static String screen(String name, {required bool useRiverpod, required bool useRoute}) {
    final pascalCase = _toPascalCase(name);
    return '''
import 'package:flutter/material.dart';
${useRiverpod ? "import 'package:flutter_riverpod/flutter_riverpod.dart';" : ""}
${useRoute ? "import 'package:auto_route/auto_route.dart';" : ""}

${useRoute ? "@RoutePage()" : ""}
class ${pascalCase}Screen extends ${useRiverpod ? 'ConsumerWidget' : 'StatelessWidget'} {
  const ${pascalCase}Screen({super.key});

  @override
  Widget build(BuildContext context${useRiverpod ? ', WidgetRef ref' : ''}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${pascalCase}'),
      ),
      body: const Center(
        child: Text('${pascalCase} Screen'),
      ),
    );
  }
}
''';
  }

  static String _toPascalCase(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  static String _toCamelCase(String text) {
    if (text.isEmpty) return '';
    return text[0].toLowerCase() + text.substring(1);
  }
}
