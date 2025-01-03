import 'package:args/command_runner.dart';
import '../services/feature_creator.dart';

class FeatureCommand extends Command {
  @override
  final name = 'feature';
  @override
  final description = '创建新的功能模块';

  FeatureCommand() {
    argParser.addOption('name', abbr: 'n', help: '功能模块名称');
  }

  @override
  Future<void> run() async {
    final featureName = argResults?['name'] as String?;
    if (featureName == null) {
      print('请提供功能模块名称');
      return;
    }

    final creator = FeatureCreator(name: featureName);
    await creator.create();
  }
}