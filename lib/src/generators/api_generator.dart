import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../utils/logger.dart';
import '../exceptions/clean_arc_exception.dart';
import 'generator.dart';

/// Generator for API models
class ApiGenerator extends Generator {
  final String url;
  final String basePath;
  final Dio _dio;

  ApiGenerator(this.url, this.basePath) : _dio = Dio();

  @override
  Future<void> generate() async {
    CleanArcLogger.info('Fetching API specification from $url...');

    try {
      final response = await _dio.get(url);
      final spec = response.data;

      if (spec == null) {
        throw ApiException('Failed to parse API specification');
      }

      // Create models directory
      final modelsDir = await createDirectory(
        path.join(basePath, 'lib', 'data', 'models'),
      );

      // Generate models from definitions
      await _generateModels(spec['definitions'], modelsDir.path);

      // Generate API client
      await _generateApiClient(spec['paths'], modelsDir.path);

      CleanArcLogger.info('API models generated successfully');
    } catch (e, stackTrace) {
      throw ApiException(
        'Failed to generate API models',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _generateModels(
    Map<String, dynamic> definitions,
    String outputPath,
  ) async {
    for (final entry in definitions.entries) {
      final className = _formatClassName(entry.key);
      final properties = entry.value['properties'] as Map<String, dynamic>?;

      if (properties == null) continue;

      final content = _generateModelClass(className, properties);
      final fileName = _formatFileName(className);

      await createFile(
        path.join(outputPath, '${fileName}.dart'),
        content,
      );

      await formatDartFile(path.join(outputPath, '${fileName}.dart'));
    }
  }

  Future<void> _generateApiClient(
    Map<String, dynamic> paths,
    String outputPath,
  ) async {
    final sb = StringBuffer();

    // Add imports
    sb.writeln("import 'package:dio/dio.dart';");
    sb.writeln();
    sb.writeln("import 'api_response.dart';");
    sb.writeln("import 'order.dart';");
    sb.writeln("import 'pet.dart';");
    sb.writeln("import 'user.dart';");
    sb.writeln();

    // Add class definition
    sb.writeln('/// Generated API client');
    sb.writeln('class ApiClient {');
    sb.writeln('  final Dio _dio;');
    sb.writeln('  final String baseUrl;');
    sb.writeln();

    // Add constructor
    sb.writeln('  ApiClient({String? baseUrl})');
    sb.writeln("      : baseUrl = baseUrl ?? 'https://petstore.swagger.io/v2',");
    sb.writeln('        _dio = Dio() {');
    sb.writeln('    _dio.options.baseUrl = this.baseUrl;');
    sb.writeln('  }');
    sb.writeln();

    // Generate methods for each path
    final methods = <String>{};
    for (final entry in paths.entries) {
      final path = entry.key;
      final operations = entry.value as Map<String, dynamic>;

      for (final op in operations.entries) {
        if (op.key == 'parameters') continue;

        final method = op.key;
        final operation = op.value as Map<String, dynamic>;
        final operationId = operation['operationId'] as String;

        // Skip duplicate methods
        if (methods.contains(operationId)) continue;
        methods.add(operationId);

        final summary = operation['summary'] as String?;
        final parameters = operation['parameters'] as List<dynamic>?;
        final responses = operation['responses'] as Map<String, dynamic>;

        // Add method documentation
        if (summary != null) {
          sb.writeln('  /// $summary');
        }

        // Get return type
        String returnType = 'void';
        final successResponse = responses['200'] ?? responses['201'];
        if (successResponse != null) {
          final schema = successResponse['schema'] as Map<String, dynamic>?;
          if (schema != null) {
            returnType = _getResponseType(schema);
          }
        }

        // Generate method signature
        sb.write('  Future<$returnType> $operationId(');

        // Add parameters
        final hasParameters = parameters != null && parameters.isNotEmpty;
        if (hasParameters) {
          sb.write('{');
          for (final param in parameters) {
            final paramMap = param as Map<String, dynamic>;
            final paramName = _formatParameterName(paramMap['name'] as String);
            final paramType = _getParameterType(paramMap);
            final required = paramMap['required'] == true;
            
            if (required) {
              sb.write('required ');
            }
            sb.write('$paramType $paramName, ');
          }
          sb.write('}');
        }

        sb.writeln(') async {');

        // Generate method body
        sb.write(_generateMethodBody(method, path, parameters, returnType));
        sb.writeln('  }');
        sb.writeln();
      }
    }

    sb.writeln('}');
    await createFile(
      path.join(outputPath, 'api_client.dart'),
      sb.toString(),
    );

    await formatDartFile(path.join(outputPath, 'api_client.dart'));
  }

  String _generateModelClass(String className, Map<String, dynamic> properties) {
    final sb = StringBuffer();
    final imports = <String>{};

    // Add default imports
    sb.writeln("import 'package:json_annotation/json_annotation.dart';");

    // Add imports for referenced types
    for (final prop in properties.entries) {
      final ref = prop.value['\$ref'] as String?;
      if (ref != null) {
        final refType = ref.split('/').last;
        imports.add("import '${_formatFileName(refType)}.dart';");
      } else if (prop.value['type'] == 'array') {
        final items = prop.value['items'] as Map<String, dynamic>;
        final itemRef = items['\$ref'] as String?;
        if (itemRef != null) {
          final refType = itemRef.split('/').last;
          imports.add("import '${_formatFileName(refType)}.dart';");
        }
      }
    }

    // Write imports
    imports.forEach(sb.writeln);
    sb.writeln();

    sb.writeln("part '${_formatFileName(className)}.g.dart';");
    sb.writeln();

    // Add class documentation
    sb.writeln('/// Generated model for $className');
    sb.writeln('@JsonSerializable()');
    sb.writeln('class $className {');

    // Add properties
    for (final prop in properties.entries) {
      final type = _getPropertyType(prop.value);
      final name = prop.key;
      final description = prop.value['description'] as String?;

      if (description != null) {
        sb.writeln('  /// $description');
      }
      sb.writeln('  final $type $name;');
    }

    sb.writeln();

    // Add constructor
    sb.writeln('  const $className({');
    for (final prop in properties.entries) {
      sb.writeln('    required this.${prop.key},');
    }
    sb.writeln('  });');

    sb.writeln();

    // Add fromJson method
    sb.writeln('  factory $className.fromJson(Map<String, dynamic> json) =>');
    sb.writeln('      _\$${className}FromJson(json);');
    sb.writeln();

    // Add toJson method
    sb.writeln('  Map<String, dynamic> toJson() => _\$${className}ToJson(this);');

    sb.writeln('}');

    return sb.toString();
  }

  String _generateMethodBody(
    String method,
    String path,
    List<dynamic>? parameters,
    String returnType,
  ) {
    final sb = StringBuffer();
    final queryParams = <String>[];
    final pathParams = <String>[];
    final headerParams = <String>[];
    String? bodyParam;
    String? formDataParam;

    if (parameters != null) {
      for (final param in parameters) {
        final paramMap = param as Map<String, dynamic>;
        final paramName = _formatParameterName(paramMap['name'] as String);
        final inType = paramMap['in'] as String;

        switch (inType) {
          case 'query':
            queryParams.add(paramName);
            break;
          case 'path':
            pathParams.add(paramName);
            break;
          case 'header':
            headerParams.add(paramName);
            break;
          case 'body':
            bodyParam = paramName;
            break;
          case 'formData':
            formDataParam = paramName;
            break;
        }
      }
    }

    // Replace path parameters
    var requestPath = path;
    for (final param in pathParams) {
      requestPath = requestPath.replaceAll('{$param}', '\$$param');
    }

    // Generate query parameters
    if (queryParams.isNotEmpty) {
      sb.writeln('    final queryParameters = {');
      for (final param in queryParams) {
        sb.writeln('      \'$param\': $param,');
      }
      sb.writeln('    };');
      sb.writeln();
    }

    // Generate headers
    if (headerParams.isNotEmpty) {
      sb.writeln('    final headers = {');
      for (final param in headerParams) {
        sb.writeln('      if ($param != null) \'$param\': $param,');
      }
      sb.writeln('    };');
      sb.writeln();
    }

    // Generate form data
    if (formDataParam != null) {
      sb.writeln('    final formData = FormData.fromMap({');
      for (final param in parameters!) {
        final paramMap = param as Map<String, dynamic>;
        final paramName = _formatParameterName(paramMap['name'] as String);
        final inType = paramMap['in'] as String;
        if (inType == 'formData') {
          sb.writeln('      if ($paramName != null) \'$paramName\': $paramName,');
        }
      }
      sb.writeln('    });');
      sb.writeln();
    }

    // Generate request
    sb.write('    ');
    if (returnType != 'void') {
      sb.write('final response = ');
    }
    sb.write('await _dio.${method.toLowerCase()}(');
    sb.write("'$requestPath'");

    if (queryParams.isNotEmpty) {
      sb.write(', queryParameters: queryParameters');
    }
    if (headerParams.isNotEmpty) {
      sb.write(', options: Options(headers: headers)');
    }
    if (bodyParam != null) {
      if (returnType.startsWith('List<')) {
        sb.write(', data: $bodyParam.map((item) => item.toJson()).toList()');
      } else {
        sb.write(', data: $bodyParam.toJson()');
      }
    }
    if (formDataParam != null) {
      sb.write(', data: formData');
    }
    sb.writeln(');');

    // Generate response handling
    if (returnType != 'void') {
      if (returnType.startsWith('List<')) {
        final itemType = returnType.substring(5, returnType.length - 1);
        sb.writeln('    return (response.data as List)');
        sb.writeln('        .map((item) => $itemType.fromJson(item as Map<String, dynamic>))');
        sb.writeln('        .toList();');
      } else if (returnType == 'String') {
        sb.writeln("    return response.data['message'] as String;");
      } else if (returnType == 'Map<String, int>') {
        sb.writeln('    return Map<String, int>.from(response.data as Map);');
      } else {
        sb.writeln('    return $returnType.fromJson(response.data as Map<String, dynamic>);');
      }
    }

    return sb.toString();
  }

  String _formatParameterName(String name) {
    return name.replaceAll('-', '_').replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  String _getParameterType(Map<String, dynamic> parameter) {
    final schema = parameter['schema'] as Map<String, dynamic>?;
    if (schema != null) {
      return _getPropertyType(schema);
    }

    final type = parameter['type'] as String?;
    final format = parameter['format'] as String?;

    switch (type) {
      case 'integer':
        return format == 'int64' ? 'int' : 'int';
      case 'number':
        return format == 'float' ? 'double' : 'double';
      case 'string':
        return 'String';
      case 'boolean':
        return 'bool';
      case 'array':
        final items = parameter['items'] as Map<String, dynamic>;
        final itemType = _getPropertyType(items);
        return 'List<$itemType>';
      case 'file':
        return 'dynamic';
      default:
        return 'dynamic';
    }
  }

  String _getResponseType(Map<String, dynamic> schema) {
    final type = schema['type'] as String?;
    final ref = schema['\$ref'] as String?;

    if (ref != null) {
      return _formatClassName(ref.split('/').last);
    }

    if (type == 'array') {
      final items = schema['items'] as Map<String, dynamic>;
      final itemType = _getPropertyType(items);
      return 'List<$itemType>';
    }

    return _getPropertyType(schema);
  }

  String _getPropertyType(Map<String, dynamic> property) {
    final type = property['type'] as String?;
    final format = property['format'] as String?;
    final ref = property['\$ref'] as String?;

    if (ref != null) {
      return _formatClassName(ref.split('/').last);
    }

    switch (type) {
      case 'integer':
        return format == 'int64' ? 'int' : 'int';
      case 'number':
        return format == 'float' ? 'double' : 'double';
      case 'string':
        if (format == 'date-time') return 'DateTime';
        if (format == 'date') return 'DateTime';
        if (format == 'binary') return 'List<int>';
        return 'String';
      case 'boolean':
        return 'bool';
      case 'array':
        final items = property['items'] as Map<String, dynamic>;
        final itemType = _getPropertyType(items);
        return 'List<$itemType>';
      case 'object':
        final additionalProperties = property['additionalProperties'] as Map<String, dynamic>?;
        if (additionalProperties != null) {
          final valueType = _getPropertyType(additionalProperties);
          return 'Map<String, $valueType>';
        }
        return 'Map<String, dynamic>';
      default:
        return 'dynamic';
    }
  }

  String _formatClassName(String name) {
    return name.replaceAll(RegExp(r'[«»]'), '_');
  }

  String _formatFileName(String className) {
    return className.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)?.toLowerCase()}',
    ).substring(1);
  }
}
