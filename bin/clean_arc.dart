import 'dart:io';

import 'package:args/args.dart';
import 'package:clean_arc/clean_arc.dart' as clean_arc;
import 'package:clean_arc/parse_json.dart';

void main(List<String> arguments) {
  var parser = ArgParser();
  parser.addOption('mode');
  parser.addFlag('verbose', defaultsTo: true);
  var results = parser.parse(['--mode', 'debug', 'something', 'else']);

  print(results.options); // debug
  print(results.rest); // true

  // check if the root folder is flutter project containing pubspec.yaml
  if (!File('pubspec.yaml').existsSync()) {
    print(
        '⚠️ Please run this command in the root folder of a flutter project. ⚠️');
    exit(0);
  }

  if (arguments.isEmpty) {
    // show help
    print('''
    ⚠️ 
    Usage: clean_arc <command> [arguments]
    To generate a feature folder: clean_arc feature:<feature_name>
    To generate an api file: clean_arc api:<api_url>
    ⚠️ 
    ''');
    exit(0);
  }

  // feature:user 创建目录
  if (arguments[0].contains('feature')) {
    print('current command is create feature folder');
    final featureName = arguments[1];
    if (featureName.isEmpty) {
      print('⚠️ Please enter the feature name. ⚠️');
      exit(0);
    }
    clean_arc.cleanArc(featureName);
  }

  if (arguments[0].contains('api')) {
    print('current command is create api file');

    // api:http://47.97.6.227:8081/v2/api-docs
    final url = arguments[1];
    if (url.isEmpty) {
      print('⚠️ Please enter the api url. ⚠️');
      exit(0);
    }
    parseJson(url);
  }
}
