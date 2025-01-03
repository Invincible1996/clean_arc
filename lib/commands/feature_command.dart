import 'package:args/command_runner.dart';
import '../services/feature_creator.dart';

class FeatureCommand extends Command {
  @override
  final name = 'feature';
  @override
  final description = 'Create a new feature module';

  FeatureCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Feature module name')
      ..addFlag('route', help: 'Add auto route annotation', defaultsTo: false);
  }

  @override
  Future<void> run() async {
    final featureName = argResults?['name'] as String?;
    if (featureName == null) {
      print('Please provide a feature module name');
      return;
    }

    final useRoute = argResults?['route'] as bool;

    final creator = FeatureCreator(
      name: featureName,
      useRoute: useRoute,
    );
    await creator.create();
  }
}