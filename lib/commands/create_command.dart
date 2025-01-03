

import 'package:args/command_runner.dart';
import '../services/project_creator.dart';

class CreateCommand extends Command {
  @override
  final name = 'create';
  @override
  final description = '创建新的 Flutter Clean Architecture 项目';

  CreateCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: '项目名称')
      ..addOption('org', help: '组织名称', defaultsTo: 'com.example')
      ..addFlag('riverpod', help: '使用 Riverpod', defaultsTo: true)
      ..addFlag('dio', help: '使用 Dio', defaultsTo: true)
      ..addFlag('hive', help: '使用 Hive', defaultsTo: true);
  }

  @override
  Future<void> run() async {
    final projectName = argResults?['name'] as String?;
    if (projectName == null) {
      print('请提供项目名称');
      return;
    }

    final creator = ProjectCreator(
      name: projectName,
      organization: argResults?['org'] as String,
      useRiverpod: argResults?['riverpod'] as bool,
      useDio: argResults?['dio'] as bool,
      useHive: argResults?['hive'] as bool,
    );

    await creator.create();
  }
}