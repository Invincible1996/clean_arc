class CoreTemplates {
  static String mainFile(bool useRiverpod) => '''
import 'package:flutter/material.dart';
${useRiverpod ? "import 'package:flutter_riverpod/flutter_riverpod.dart';" : ''}
import 'core/router/app_router.dart';

void main() {
  runApp(${useRiverpod ? 'const ProviderScope(child: MyApp())' : 'const MyApp()'});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    
    return MaterialApp.router(
      title: 'Flutter Clean Architecture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
    );
  }
}
''';

  /// use auto_route not go_router
  static String get appRouter => '''
  import 'package:auto_route/auto_route.dart';
  part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _\$AppRouter {
  @override
  List<AutoRoute> get routes => [        
      ];
}
  ''';

  static String get dioClient => '''
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    )..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
''';

  static String get storageService => '''
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
''';

  static String get appTheme => '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
''';

  static String get failures => '''
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ValidationFailure extends Failure {
  final String message;

  ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}
''';

  static String get exceptions => '''
class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}
''';

  static String get usecase => '''
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
''';
}
