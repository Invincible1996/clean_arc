import 'dart:io';

import 'package:clean_arc/extension/string_extension.dart';
import 'package:clean_arc/test.dart';

/// author kevin
/// date 10/31/24 13:10

// "responses": {
// "200": {
// "description": "OK",
// "schema": {
// "$ref": "#/definitions/ReplyEntity«TDictCommonListRespVO»"
// }
// },
// "201": {
// "description": "Created"
// },
// "401": {
// "description": "Unauthorized"
// },
// "403": {
// "description": "Forbidden"
// },
// "404": {
// "description": "Not Found"
// }
// }
// only handle 200
String generateResponse(Map<String, dynamic> responses) {
  if (responses.containsKey('200')) {
    if (responses['200'].containsKey('schema')) {
      if (responses['200']['schema'].containsKey('\$ref')) {
        return responses['200']['schema']['\$ref']
            .toString()
            .split("#/definitions/")[1]
            .replaceAll("«", "<")
            .replaceAll("object", "String")
            .replaceAll("string", "String")
            .replaceAll("boolean", "bool")
            .replaceAll("»", ">");
      }
    }
  }
  return 'dynamic';
}

// "parameters": [
// 					{
// 						"in": "body",
// 						"name": "req",
// 						"description": "req",
// 						"required": true,
// 						"schema": {
// 							"$ref": "#/definitions/IdReqDTO"
// 						}
// 					]
// only handle body
String generateRequest(List<dynamic> parameters) {
  if (parameters.isEmpty) {
    return '';
  }
  for (var item in parameters) {
    if (item.containsKey('schema')) {
      if (item['schema'].containsKey(r'$ref')) {
        // eg: IdReqDTO req to IdReqDTO req
        return '''
        ${item['schema'][r'$ref'].toString().split("#/definitions/")[1].replaceAll("«", "<").replaceAll("»", ">")} req
        ''';
      } else {
        return item['schema']['type'];
      }
    } else {
      return item['name'];
    }
  }
  return 'dynamic';
}

String generateNestedFromJsonCode(String genericType) {
  // 移除可能的空白字符
  genericType = genericType.trim();

  // 分割嵌套的泛型类型
  List<String> types = [];
  int currentStart = 0;
  int bracketCount = 0;

  for (int i = 0; i < genericType.length; i++) {
    if (genericType[i] == '«') {
      bracketCount++;
    } else if (genericType[i] == '»') {
      bracketCount--;
    }

    if (bracketCount == 0 && genericType[i] == '«') {
      types.add(genericType.substring(currentStart, i).trim());
      currentStart = i + 1;
    }
  }

  // 添加最后一个类型
  if (currentStart < genericType.length) {
    types.add(
        genericType.substring(currentStart, genericType.length - 1).trim());
  }

  // 生成嵌套的 fromJson 调用
  return generateFromJsonCall(types);
}

String generateFromJsonCall(List<String> types) {
  if (types.length == 1) {
    // 单一泛型情况
    return '${types[0]}.fromJson(response.data)';
  }

  // 递归生成嵌套的 fromJson 调用
  String result = types.last + '.fromJson(json)';

  for (int i = types.length - 2; i >= 0; i--) {
    result = '${types[i]}.fromJson(response.data, (json) => $result)';
  }

  return result;
}

String generateReturnString(Map<String, dynamic> responses) {
  if (responses.containsKey('200')) {
    // "$ref": "#/definitions/ReplyEntity«MarketApplyAutoAssignResp»"
    // return ReplyEntity.fromJson(
    //   response.data,
    //       (json) => MarketApplyAutoAssignResp.fromJson(json),
    // );
    // get ReplyEntity then get MarketApplyAutoAssignResp
    // return ReplyEntity.fromJson(
    //   response.data,
    //       (json) => MarketApplyAutoAssignResp.fromJson(json),
    // );

    // "$ref": "#/definitions/ReplyEntity«BasePageResDTO«ListMarketImportAllocateRecordRespDTO»»"
    // return ReplyEntity.fromJson(
    //   response.data,
    //       (json) => BasePageResDTO.fromJson(json, (json) => ListMarketImportAllocateRecordRespDTO.fromJson(json)),
    // );
    if (responses['200'].containsKey('schema')) {
      if (responses['200']['schema'].containsKey(r'$ref')) {
        String ref = responses['200']['schema'][r'$ref']
            .toString()
            .split("#/definitions/")[1];

        // 测试用例
        // String type1 = 'ReplyEntity«BasePageResDTO«ListMarketImportAllocateRecordRespDTO»»';
        // String type2 = 'ReplyEntity«MarketApplyAutoAssignResp»';

        print('''
        --------------------------------
        ${generateReplyEntityCode(ref)}
        --------------------------------
        ''');

        // if ref contains one « then get type and subtype
        // if
        // String type = ref.split("«")[0];
        // String subType = ref.split("«")[1].split("»")[0];

        return generateReplyEntityCode(ref);
      }
    }
  }
  return 'response.data';
}

void generateFunction(Map<String, dynamic> paths, String description) {
  print('generateFunction start ✅');
  StringBuffer sb = StringBuffer();
  sb.write('''
  import 'package:dio/dio.dart';
  import 'struct.dart';
  /// author kevin
  ''');

  paths.forEach((key, value) {
    // print(key);
    // if value contains post or get
    // return ReplyEntity.fromJson(
    //   response.data,
    //       (json) => MarketApplyAutoAssignResp.fromJson(json),
    // );
    if (value.containsKey('post')) {
      sb.write('''
  /// ${value['post']['summary']}
  Future<${generateResponse(value['post']['responses'])}> ${key.toMethodName}(${generateRequest(
        value['post']?['parameters'] ?? [],
      )}) async {
    final response = await Dio().post('$key');
    return ${generateReturnString(value['post']['responses'])};
    }
      ''');
    } else if (value.containsKey('get')) {
      sb.write('''
  /// ${value['get']['summary']}
   Future<${generateResponse(value['get']['responses'])}> ${key.toMethodName}() async {
    final response = await Dio().post('$key');
    return response.data;
    }
      ''');
    }
  });
  print(sb.toString());
  print('generateFunction done ✅');
  // write to file in the directory created above with the name struct.dart
  File file = File('$description/service.dart');
  file.writeAsString(sb.toString());
  print('✅ write to file done ✅');
  // format the file
  Process.run('dart', ['format', '$description/service.dart']);
  print('format done ✅');
}
