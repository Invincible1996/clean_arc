library;

import 'dart:io';

import 'package:clean_arc/extension/string_extension.dart';
import 'package:dio/dio.dart';

///string is all letter

void generateClass(String url) async {
  if (url.isEmpty) {
    print('⚠️url is empty, please input a valid url.⚠️');
    return;
  }
  Dio dio = Dio();
  Response response = await dio.get(url);
  // 获取info中的description 作为文件夹的名称
  final String description =
      (response.data['info']['description'] as String).toUnderLine;
  // 创建文件夹
  Directory directory = Directory(description);
  if (!directory.existsSync()) {
    directory.createSync();
  }

  // getClassGeneric
  String getClassGeneric(String key) {
    if (key.contains('«')) {
      // String generic = key.substring(key.indexOf('«') + 1, key.lastIndexOf('»'));
      return '<T>';
    }
    return '';
  }

  Map<String, dynamic> definitions = response.data['definitions'];
  var sb = StringBuffer();

  // generateFunction(response.data['paths'], description);
  // return;
  for (var key in definitions.keys) {
    // if not contains letter, skip
    if (key.isNotContainLetter) {
      print('skip key: $key');
      continue;
    }

    var className = key;
    // BasePageResDTO«ListMarketImportAllocateRecordDetailRespDTO» => BasePageResDTO<T>
    if (key.contains('«')) {
      className = key.substring(0, key.indexOf('«'));
    }

    // if className is already exist, skip
    if (sb.toString().contains('class $className${getClassGeneric(key)} {')) {
      print('skip class: $className');
      continue;
    }

    sb.write('''
      /// ${definitions[key]['description']}
      class $className${getClassGeneric(key)} {\n''');
    generateProperties(key, definitions[key]['properties'], sb);
    generateConstructors(className, definitions[key]['properties'], sb);
    generateFromJson(key, definitions[key]['properties'], sb);
    // generateToJson(key, definitions[key]['properties'], sb);
    sb.write("}");
  }

  print(sb.toString());
  // write to file in the directory created above with the name struct.dart
  File file = File('$description/struct.dart');
  file.writeAsString(sb.toString());
  // format the file
  Process.run('dart', ['format', '$description/struct.dart']);
}

void generateFromJson(
    String className, Map<String, dynamic> properties, StringBuffer sb) {
  // if className contains '«', replace with 'T'
  // factory BasePageResDTO.fromJson(
  //     Map<String, dynamic> json,
  //     T Function(Map<String, dynamic>) fromJson
  //   ) {
  //     return BasePageResDTO(
  //       data: json['data'] != null
  //         ? (json['data'] as List).map((i) => fromJson(i as Map<String, dynamic>)).toList()
  //         : null,
  //       totalCount: json['totalCount'],
  //     );
  //   }

  if (className.contains('«')) {
    className = className.substring(0, className.indexOf('«'));
    sb.write('''
  factory $className.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson,) {
    return $className(
  
  ''');
  } else {
    sb.write('''
  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
  
  ''');
  }

  sb.write('''
      ${properties.keys.map((key) {
    if (properties[key].containsKey(r'$ref')) {
      String ref = properties[key][r'$ref'];
      String type = ref.substring(ref.lastIndexOf('/') + 1);
      // if (type.contains('«')) {
      //   type = 'T';
      // }
      if (type.contains('«')) {
        return '$key: json[\'$key\'] != null ? fromJson(json[\'$key\']) : null,';
      } else {
        return '$key: json[\'$key\'] != null ? $type.fromJson(json[\'$key\']) : null,';
      }
    } else {
      return '$key: json[\'$key\'],';
    }
  }).join('\n')}\n''');
  sb.write('''
    );
  }\n''');

  /// 添加换行
  sb.write('\n');
}

void generateToJson(
    String className, Map<String, dynamic> properties, StringBuffer sb) {}

void generateConstructors(
    String key, Map<String, dynamic> properties, StringBuffer sb) {
  sb.write('''
  $key({''');
  properties.forEach((key, value) {
    sb.write('this.$key,');
  });
  sb.write('});\n\n');
}

void generateProperties(
    String className, Map<String, dynamic> properties, StringBuffer sb) {
  properties.forEach((key, value) {
    // print(key);
    // get type from "$ref": "#/definitions/MarketAutoAssignResultDTO"
    if (value.containsKey(r'$ref')) {
      String ref = value[r'$ref'];
      String type = ref.substring(ref.lastIndexOf('/') + 1);
      if (type.contains('«')) {
        type = 'T';
      }
      sb.write('''
        /// ${value['description']}
        $type${type == 'dynamic' ? '' : '?'} $key;\n''');
    } else {
      sb.write('''
        /// ${value['description']}
        ${getDartType(className, value['type'], items: value['items'])} $key;\n''');
    }
  });
  // 添加换行
  sb.write('\n');
}

/// 获取泛型类型
String getGenericDartType(String className, Map<String, dynamic>? items) {
  if (items != null && items.containsKey(r'$ref')) {
    String ref = items['\$ref'];
    if (className.contains('«')) {
      return 'T';
    }
    if (ref.contains('«')) {
      return "dynamic";
    }
    String type = ref.substring(ref.lastIndexOf('/') + 1);
    return type;
  } else if (items != null && items.containsKey('type')) {
    return getDartType(className, items['type'], items: items['items']);
  }
  return 'dynamic';
}

String getDartType(String className, String type,
    {Map<String, dynamic>? items}) {
  switch (type) {
    case 'string':
      return 'String?';
    case 'integer':
      return 'int?';
    case 'number':
      return 'double?';
    case 'boolean':
      return 'bool?';
    case 'array':
      return 'List<${getGenericDartType(className, items)}>?';
    default:
      return 'dynamic';
  }
}
