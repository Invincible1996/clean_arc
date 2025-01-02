import 'dart:io';
import 'package:clean_arc/src/commands/command.dart';
import 'package:clean_arc/src/config/config.dart';
import 'package:clean_arc/src/exceptions/clean_arc_exception.dart';
import 'package:clean_arc/src/utils/logger.dart';

Future<void> main(List<String> arguments) async {
  // Initialize logger
  CleanArcLogger.init();

  try {
    // Load configuration
    final config = await CleanArcConfig.load();

    // Create command factory
    final factory = CommandFactory(config);

    // Parse and validate arguments
    if (arguments.isEmpty) {
      _showHelp();
      exit(0);
    }

    // Create and execute command
    final command = factory.create(arguments);
    await command.execute();
  } on CleanArcException catch (e) {
    CleanArcLogger.error(e.message, e.cause, e.stackTrace);
    exit(1);
  } catch (e, stackTrace) {
    CleanArcLogger.error('An unexpected error occurred', e, stackTrace);
    exit(1);
  }
}

void _showHelp() {
  CleanArcLogger.info('''
⚡ Clean Arc - Flutter Clean Architecture Generator

Usage: clean_arc <command> [arguments]

Commands:
  framework              Generate basic Clean Architecture project structure
  feature <name>         Create a new feature module with all necessary layers
  api <url>             Generate models from Swagger/OpenAPI specification

Options:
  -s, --state           State management framework to use (riverpod or bloc)
                        Default: riverpod

Examples:
  clean_arc framework
  clean_arc feature user_authentication
  clean_arc feature user_authentication --state bloc
  clean_arc api https://api.example.com/swagger.json

For more information, visit: https://github.com/your-username/clean_arc
''');
}
