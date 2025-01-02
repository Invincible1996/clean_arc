import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;
import '../exceptions/clean_arc_exception.dart';
import '../utils/logger.dart';

/// Configuration for Clean Arc
class CleanArcConfig {
  /// Default configuration file name
  static const String defaultConfigFile = '.clean_arc_config.yaml';

  /// Templates configuration
  final Map<String, TemplateConfig> templates;

  /// API configuration
  final ApiConfig apiConfig;

  /// Creates a new [CleanArcConfig]
  CleanArcConfig({
    required this.templates,
    required this.apiConfig,
  });

  /// Loads configuration from the specified file
  static Future<CleanArcConfig> load([String? configPath]) async {
    final configFile = File(configPath ?? defaultConfigFile);
    
    if (!configFile.existsSync()) {
      CleanArcLogger.info('No config file found, using default configuration');
      return _getDefaultConfig();
    }

    try {
      final content = await configFile.readAsString();
      final yaml = loadYaml(content) as Map;
      
      return CleanArcConfig(
        templates: _parseTemplates(yaml['templates'] as Map?),
        apiConfig: _parseApiConfig(yaml['api'] as Map?),
      );
    } catch (e, stackTrace) {
      throw ConfigException(
        'Failed to load configuration file',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  static CleanArcConfig _getDefaultConfig() {
    return CleanArcConfig(
      templates: {
        'feature': TemplateConfig(
          path: 'templates/feature',
          extensions: ['.dart', '.yaml'],
          format: true,
        ),
        'api': TemplateConfig(
          path: 'templates/api',
          extensions: ['.dart'],
          format: true,
        ),
      },
      apiConfig: ApiConfig(
        timeout: Duration(seconds: 30),
        retries: 3,
      ),
    );
  }

  static Map<String, TemplateConfig> _parseTemplates(Map? yaml) {
    if (yaml == null) return _getDefaultConfig().templates;

    final templates = <String, TemplateConfig>{};
    for (final entry in yaml.entries) {
      final key = entry.key as String;
      final value = entry.value as Map;
      templates[key] = TemplateConfig(
        path: value['path'] as String? ?? 'templates/$key',
        extensions: (value['extensions'] as List?)?.cast<String>() ?? ['.dart'],
        format: value['format'] as bool? ?? true,
      );
    }
    return templates;
  }

  static ApiConfig _parseApiConfig(Map? yaml) {
    if (yaml == null) return _getDefaultConfig().apiConfig;

    return ApiConfig(
      timeout: Duration(
        seconds: yaml['timeout_seconds'] as int? ?? 30,
      ),
      retries: yaml['retries'] as int? ?? 3,
    );
  }
}

/// Configuration for a template
class TemplateConfig {
  /// Path to the template directory
  final String path;

  /// File extensions to process
  final List<String> extensions;

  /// Whether to format generated code
  final bool format;

  /// Creates a new [TemplateConfig]
  TemplateConfig({
    required this.path,
    required this.extensions,
    required this.format,
  });
}

/// Configuration for API operations
class ApiConfig {
  /// Timeout for API requests
  final Duration timeout;

  /// Number of retries for failed requests
  final int retries;

  /// Creates a new [ApiConfig]
  ApiConfig({
    required this.timeout,
    required this.retries,
  });
}

/// Exception thrown when configuration related operations fail
class ConfigException extends CleanArcException {
  ConfigException(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}
