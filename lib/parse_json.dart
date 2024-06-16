import 'dart:io';

import 'package:clean_arc/extension/string_extension.dart';
import 'package:clean_arc/utils/date_format_util.dart';
import 'package:dio/dio.dart';

/// 解析swagger生成的json文件 获取属性 使用dio请求接口
void parseJson(String url) async {
  // dio 请求接口
  // 'http://47.97.6.227:8081/v2/api-docs'
  final res = await Dio().get(url);

  print(res.data);

  /// 获取所有的path
  final paths = res.data['paths'];

  /// 创建api_url 文件 用于存放所有的api接口
  final apiFile = File('api_url.dart');
  apiFile.createSync();
  apiFile.writeAsStringSync('''
  /// author : kevin
  /// date : ${DateFormatUtil.formatDateTime(DateTime.now())}
  /// description : api url
  class ApiUrl {
    // Add your api url here
    ${generateApiUrl(paths)}
  }
  ''');

  ///生成service文件 用于存放所有的api接口
  final serviceFile = File('service.dart');
  serviceFile.createSync();
  serviceFile.writeAsStringSync('''
  /// author : kevin
  /// date : 2021/8/19 10:00
  /// description : service
  class Service {
    // Add your service here
    ${generateServiceFunc(paths)}
  }
  ''');

  // 格式化生成的文件
  Process.run('flutter', ['format', 'api_url.dart']);
}

generateServiceFunc(Map<String, dynamic> paths) {
  StringBuffer result = StringBuffer();
  paths.forEach((key, value) {
    result.write('''
    /// path: $key
    static Future<void> ${key.toMethodName}() async {
      // Add your service here
    }
    ''');
  });
  return result.toString();
}

/// 生成api url
String generateApiUrl(Map<String, dynamic> paths) {
  StringBuffer result = StringBuffer();
  paths.forEach((key, value) {
    result.write('''
    /// description: ${generateDescription(value)}
    static const String ${key.toMethodName} = "$key";\n
    ''');
  });
  return result.toString();
}

String generateDescription(value) {
  // get 请求
  if (value['get'] != null) {
    return value['get']['summary'];
  }

  // post 请求
  if (value['post'] != null) {
    return value['post']['summary'];
  }

  return '';
}
