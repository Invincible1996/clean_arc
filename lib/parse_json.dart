// import 'dart:io';
//
// import 'package:clean_arc/extension/string_extension.dart';
// import 'package:clean_arc/utils/date_format_util.dart';
// import 'package:dio/dio.dart';
//
// /// 解析swagger生成的json文件 获取属性 使用dio请求接口
// void parseJson(String url) async {
//   // dio 请求接口
//   // 'http://47.97.6.227:8081/v2/api-docs'
//   final res = await Dio().get(url);
//
//   // print(res.data);
//
//   /// 获取所有的path
//   final paths = res.data['paths'];
//
//   String currentDir = Directory.current.path;
//
//   print(currentDir);
//
//   createFolderIfNotExists('$currentDir/lib/src/api_service');
//
//   /// 创建api_url 文件 用于存放所有的api接口
//   final apiFile = File('$currentDir/lib/src/api_service/api_url.dart');
//   apiFile.createSync();
//   apiFile.writeAsStringSync('''
//   /// author : kevin
//   /// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
//   /// description : api url
//   class ApiUrl {
//     // Add your api url here
//     ${generateApiUrl(paths)}
//   }
//   ''');
//
//   ///生成service文件 用于存放所有的api接口
//   final serviceFile = File('$currentDir/lib/src/api_service/service.dart');
//   serviceFile.createSync();
//   serviceFile.writeAsStringSync('''
//   /// author : kevin
//   /// date : 2021/8/19 10:00
//   /// description : service
//   class Service {
//     // Add your service here
//     ${generateServiceFunc(paths)}
//   }
//   ''');
//
//   // 格式化生成的文件
//   Process.run('flutter', ['format', 'api_url.dart']);
// }
//
// void createFolderIfNotExists(String path) {
//   final directory = Directory(path);
//
//   // 检查文件夹是否存在
//   if (!directory.existsSync()) {
//     // 如果文件夹不存在，则创建它
//     directory.createSync(recursive: true);
//     print('文件夹已创建：$path');
//   } else {
//     print('文件夹已存在：$path');
//   }
// }
//
// generateServiceFunc(Map<String, dynamic> paths) {
//   StringBuffer result = StringBuffer();
//   paths.forEach((key, value) {
//     result.write('''
//     /// path: $key
//     static Future<void> ${key.toMethodName}() async {
//       // Add your service here
//     }
//     ''');
//   });
//   return result.toString();
// }
//
// /// 生成api url
// String generateApiUrl(Map<String, dynamic> paths) {
//   StringBuffer result = StringBuffer();
//   paths.forEach((key, value) {
//     result.write('''
//     /// description: ${generateDescription(value)}
//     static const String ${key.toMethodName} = "$key";\n
//     ''');
//   });
//   return result.toString();
// }
//
// String generateDescription(value) {
//   // get 请求
//   if (value['get'] != null) {
//     return value['get']['summary'];
//   }
//
//   // post 请求
//   if (value['post'] != null) {
//     return value['post']['summary'];
//   }
//
//   return '';
// }
//----------------------------------------------------------------
import 'dart:io';

import 'package:clean_arc/extension/string_extension.dart';
import 'package:clean_arc/utils/date_format_util.dart';
import 'package:dio/dio.dart';

void parseJson(String url) async {
  final res = await Dio().get(url);
  final data = res.data;

  String currentDir = Directory.current.path;
  print(currentDir);

  createFolderIfNotExists('$currentDir/lib/src/api_service');
  createFolderIfNotExists('$currentDir/lib/src/models');

  generateApiUrlFile(currentDir, data['paths']);
  generateServiceFile(currentDir, data['paths']);
  generateModelFiles(currentDir, data['definitions']);
}

void createFolderIfNotExists(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('文件夹已创建：$path');
  } else {
    print('文件夹已存在：$path');
  }
}

void generateApiUrlFile(String currentDir, Map<String, dynamic> paths) {
  final apiFile = File('$currentDir/lib/src/api_service/api_url.dart');
  apiFile.createSync();
  apiFile.writeAsStringSync('''
/// author : kevin
/// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
/// description : api url
class ApiUrl {
${generateApiUrl(paths)}
}
''');
}

String generateApiUrl(Map<String, dynamic> paths) {
  StringBuffer result = StringBuffer();
  paths.forEach((key, value) {
    var description = generateDescription(value);
    result.write('''
  /// description: $description
  static const String ${key.toMethodName} = "$key";\n
''');
  });
  return result.toString();
}

void generateServiceFile(String currentDir, Map<String, dynamic> paths) {
  final serviceFile = File('$currentDir/lib/src/api_service/service.dart');
  serviceFile.createSync();
  serviceFile.writeAsStringSync('''
import 'package:dio/dio.dart';
import 'api_url.dart';
${generateImports(paths)}

/// author : kevin
/// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
/// description : service
class Service {
  final Dio _dio;

  Service(this._dio);

${generateServiceFunctions(paths)}
}
''');
}

String generateImports(Map<String, dynamic> paths) {
  Set<String> imports = {};
  paths.forEach((key, value) {
    var operation = value.values.first;
    if (operation != null) {
      var parameters = operation['parameters'];
      if (parameters is List && parameters.isNotEmpty) {
        var schema = parameters[0]['schema'];
        if (schema != null && schema['\$ref'] != null) {
          var paramSchema = schema['\$ref'];
          imports.add(
              "import '../models/${paramSchema.split('/').last.toLowerCase()}.dart';");
        }
      }
      var responses = operation['responses'];
      if (responses != null && responses['200'] != null) {
        var schema = responses['200']['schema'];
        if (schema != null && schema['\$ref'] != null) {
          var respSchema = schema['\$ref'];
          imports.add(
              "import '../models/${respSchema.split('/').last.toLowerCase()}.dart';");
        }
      }
    }
  });
  return imports.join('\n');
}

String generateServiceFunctions(Map<String, dynamic> paths) {
  StringBuffer result = StringBuffer();
  paths.forEach((key, value) {
    var operation = value.values.first;
    if (operation != null) {
      var methodName = key.split('/').last.toMethodName;
      var description = generateDescription(value);
      var returnType = 'dynamic';
      var paramType = 'dynamic';
      var method = 'post'; // default to POST if not specified

      if (operation['operationId'] != null) {
        var operationParts = operation['operationId'].toString().split('Using');
        if (operationParts.length > 1) {
          method = operationParts[1].toLowerCase();
        }
      }

      var parameters = operation['parameters'];
      if (parameters is List && parameters.isNotEmpty) {
        var schema = parameters[0]['schema'];
        if (schema != null && schema['\$ref'] != null) {
          paramType = schema['\$ref'].split('/').last;
        }
      }

      var responses = operation['responses'];
      if (responses != null && responses['200'] != null) {
        var schema = responses['200']['schema'];
        if (schema != null && schema['\$ref'] != null) {
          final last = schema['\$ref'].split('/').last;

          if (last.contains('«') &&
              last.contains('»') &&
              last.contains('object')) {
            returnType = last
                .replaceAll('«', '<')
                .replaceAll('»', '>')
                .replaceAll('object', 'bool');
          } else {
            returnType = last.replaceAll('«', '<').replaceAll('»', '>');
          }
          // returnType = schema['\$ref'].split('/').last;
        }
      }

      result.write('''
  /// path: $key
  /// description: $description
  Future<$returnType> $methodName($paramType input) async {
    try {
      final response = await _dio.$method(
        ApiUrl.$methodName,
        data: input.toJson(),
      );
      return $returnType.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to $methodName: \$e');
    }
  }

''');
    }
  });
  return result.toString();
}

String camelToSnakeCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (Match m) => (m.start > 0 ? '_' : '') + m.group(0)!.toLowerCase(),
  );
}

void generateModelFiles(String currentDir, Map<String, dynamic> definitions) {
  //

  definitions.forEach((key, value) {
    // ReplyEntity«BasePageRespDTO«CustomerHoldDTO»» 需要生成第一个 ReplyEntity.dart
    // ignore key contains « eg: Result«List«StringKeyValueDTO»»
    if (value != null && value is Map<String, dynamic>) {
      // file name AllocateRuleAllocateTypeCreateDTO => allocate_rule_allocate_type_create_dto.dart
      final fileName = '${camelToSnakeCase(key.split('DTO').first)}.dart';
      final modelFile = File('$currentDir/lib/src/models/$fileName');
      modelFile.createSync();
      modelFile.writeAsStringSync(generateModelClass(key, value));
    } else {
      print(
          'Warning: Definition for $key is null or not a Map. Skipping this model.');
    }
  });
}

// generate model class
String generateModelClass(String className, Map<String, dynamic> definition) {
  // ReplyEntity«BasePageRespDTO«TagUserLeadHoldingRespDTO»»
  if (className.contains('«')) {
    className = className.split('«').first;
  }

  StringBuffer result = StringBuffer();
  var properties = definition['properties'];
  if (properties == null || properties is! Map<String, dynamic>) {
    print(
        'Warning: Properties for $className are null or not a Map. Generating an empty class.');
    properties = <String, dynamic>{};
  }

  result.write('''
class $className {
${generateModelProperties(properties)}

  $className({
${generateConstructorParams(properties)}
  });

  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
${generateFromJsonParams(properties)}
    );
  }

  Map<String, dynamic> toJson() {
    return {
${generateToJsonParams(properties)}
    };
  }
}
''');
  return result.toString();
}

// generate model properties
String generateModelProperties(Map<String, dynamic> properties) {
  StringBuffer result = StringBuffer();
  properties.forEach((key, value) {
    if (value != null && value is Map<String, dynamic>) {
      var type = getPropertyType(value);
      result.write('  $type? $key;\n');
    }
  });
  return result.toString();
}

String generateConstructorParams(Map<String, dynamic> properties) {
  StringBuffer result = StringBuffer();
  properties.forEach((key, value) {
    if (value != null && value is Map<String, dynamic>) {
      result.write('    this.$key,\n');
    }
  });
  return result.toString();
}

String generateFromJsonParams(Map<String, dynamic> properties) {
  StringBuffer result = StringBuffer();
  properties.forEach((key, value) {
    if (value != null && value is Map<String, dynamic>) {
      var type = getPropertyType(value);
      if (type == 'List<dynamic>') {
        result.write(
            '      $key: json[\'$key\'] != null ? List<dynamic>.from(json[\'$key\']) : null,\n');
      } else {
        result.write('      $key: json[\'$key\'],\n');
      }
    }
  });
  return result.toString();
}

String generateToJsonParams(Map<String, dynamic> properties) {
  StringBuffer result = StringBuffer();
  properties.forEach((key, value) {
    if (value != null && value is Map<String, dynamic>) {
      result.write('      if ($key != null) \'$key\': $key,\n');
    }
  });
  return result.toString();
}

String getPropertyType(Map<String, dynamic> property) {
  switch (property['type']) {
    case 'integer':
      return 'int';
    case 'number':
      return 'double';
    case 'boolean':
      return 'bool';
    case 'array':
      return 'List<dynamic>';
    default:
      return 'String';
  }
}

String generateDescription(Map<String, dynamic> value) {
  if (value['get'] != null) {
    return value['get']['summary'];
  }
  if (value['post'] != null) {
    return value['post']['summary'];
  }
  return '';
}
