import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:clean_arc/commands/create_command.dart';
import 'package:clean_arc/commands/feature_command.dart';

void main(List<String> arguments) {
  CommandRunner('clean_arc', 'Flutter Clean Architecture 项目生成器')
    ..addCommand(CreateCommand())
    ..addCommand(FeatureCommand())
    ..run(arguments).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
}
