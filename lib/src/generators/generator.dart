import 'dart:io';
import 'package:path/path.dart' as path;
import '../exceptions/clean_arc_exception.dart';
import '../utils/logger.dart';

/// Base class for all generators
abstract class Generator {
  /// Generates the code
  Future<void> generate();

  /// Creates a directory if it doesn't exist
  Future<Directory> createDirectory(String dirPath) async {
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  /// Creates a file with the given content
  Future<File> createFile(String filePath, String content) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
    return file;
  }

  /// Formats a Dart file
  Future<void> formatDartFile(String filePath) async {
    try {
      final result = await Process.run('dart', ['format', filePath]);
      if (result.exitCode != 0) {
        CleanArcLogger.warning('Failed to format $filePath: ${result.stderr}');
      }
    } catch (e) {
      CleanArcLogger.warning('Failed to format $filePath: $e');
    }
  }

  /// Checks if a directory exists
  Future<bool> directoryExists(String dirPath) async {
    return Directory(dirPath).exists();
  }

  /// Checks if a file exists
  Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }
}

/// Generator for framework structure
class FrameworkGenerator extends Generator {
  final String basePath;
  final List<String> layers = [
    'core',
    'data',
    'domain',
    'presentation',
  ];

  FrameworkGenerator(this.basePath);

  @override
  Future<void> generate() async {
    CleanArcLogger.info('Generating framework structure...');

    // Create lib directory if it doesn't exist
    final libDir = await createDirectory(path.join(basePath, 'lib'));

    // Create each layer
    for (final layer in layers) {
      final layerPath = path.join(libDir.path, layer);
      await createDirectory(layerPath);
      await _generateLayerStructure(layer, layerPath);
    }

    CleanArcLogger.info('Framework structure generated successfully');
  }

  Future<void> _generateLayerStructure(String layer, String layerPath) async {
    switch (layer) {
      case 'core':
        await _generateCoreLayer(layerPath);
      case 'data':
        await _generateDataLayer(layerPath);
      case 'domain':
        await _generateDomainLayer(layerPath);
      case 'presentation':
        await _generatePresentationLayer(layerPath);
    }
  }

  Future<void> _generateCoreLayer(String layerPath) async {
    final directories = [
      'constants',
      'error',
      'network',
      'utils',
    ];

    for (final dir in directories) {
      await createDirectory(path.join(layerPath, dir));
    }

    // Create base files
    await _createBaseFiles(layerPath);
  }

  Future<void> _generateDataLayer(String layerPath) async {
    final directories = [
      'datasources',
      'models',
      'repositories',
    ];

    for (final dir in directories) {
      await createDirectory(path.join(layerPath, dir));
    }
  }

  Future<void> _generateDomainLayer(String layerPath) async {
    final directories = [
      'entities',
      'repositories',
      'usecases',
    ];

    for (final dir in directories) {
      await createDirectory(path.join(layerPath, dir));
    }
  }

  Future<void> _generatePresentationLayer(String layerPath) async {
    final directories = [
      'bloc',
      'pages',
      'widgets',
    ];

    for (final dir in directories) {
      await createDirectory(path.join(layerPath, dir));
    }
  }

  Future<void> _createBaseFiles(String corePath) async {
    // Create base exception
    await createFile(
      path.join(corePath, 'error', 'exceptions.dart'),
      '''
/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final dynamic cause;

  AppException(this.message, [this.cause]);

  @override
  String toString() => message;
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException(String message, [dynamic cause]) : super(message, cause);
}

/// Cache related exceptions
class CacheException extends AppException {
  CacheException(String message, [dynamic cause]) : super(message, cause);
}
''',
    );

    // Create base failure
    await createFile(
      path.join(corePath, 'error', 'failures.dart'),
      '''
/// Base failure class for the application
abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

/// Server failure
class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error occurred']) : super(message);
}

/// Cache failure
class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error occurred']) : super(message);
}
''',
    );

    // Create network client
    await createFile(
      path.join(corePath, 'network', 'network_client.dart'),
      '''
import 'package:dio/dio.dart';
import '../error/exceptions.dart';

/// Network client for making HTTP requests
class NetworkClient {
  final Dio _dio;

  NetworkClient() : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException('Network error occurred', e);
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException('Network error occurred', e);
    }
  }
}
''',
    );
  }
}
