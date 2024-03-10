import 'dart:io';

import 'package:clean_arc/clean_arc.dart' as clean_arc;

void main(List<String> arguments) {
  print(arguments);
  if (arguments.isEmpty) {
    print('⚠️ Please enter the feature name. ⚠️');
    exit(0);
  }

  // feature:user 创建目录
  if (arguments[0].contains('feature:')) {
    print('current command is create feature folder');
    clean_arc.cleanArc(arguments[0].split(':')[1]);
  }

  if (arguments[0].contains('api')) {
    print('current command is create api file');
    clean_arc.parseJson();
  }
}
