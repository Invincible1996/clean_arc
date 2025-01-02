import 'dart:async';
import 'dart:io';
import '../exceptions/clean_arc_exception.dart';
import '../utils/logger.dart';
import '../config/config.dart';
import '../generators/generator.dart';
import '../generators/feature_generator.dart';
import '../generators/api_generator.dart';
import 'package:args/args.dart';
import '../enums/state_management.dart';

/// Base class for all commands
abstract class Command {
  /// The configuration for the command
  final CleanArcConfig config;

  /// Creates a new [Command]
  Command(this.config);

  /// Executes the command
  Future<void> execute();

  /// Validates the command's arguments
  Future<void> validate();

  /// Checks if the current directory is a Flutter project
  Future<void> validateFlutterProject() async {
    if (!File('pubspec.yaml').existsSync()) {
      throw CommandException(
        'Please run this command in the root folder of a Flutter project',
      );
    }

    // Check for platform-specific folders
    final platformFolders = [
      'android',
      'ios',
      'macos',
      'web',
      'windows',
      'linux',
    ];

    final hasAnyPlatform = platformFolders.any(
      (folder) => Directory(folder).existsSync(),
    );

    if (!hasAnyPlatform) {
      throw CommandException(
        'This does not appear to be a Flutter project. '
        'Please ensure you have at least one platform folder '
        '(android, ios, macos, web, windows, or linux).',
      );
    }
  }
}

/// Command for generating framework structure
class FrameworkCommand extends Command {
  FrameworkCommand(super.config);

  @override
  Future<void> execute() async {
    try {
      await validate();
      
      final generator = FrameworkGenerator(Directory.current.path);
      await generator.generate();
      
      CleanArcLogger.info('Framework structure generated successfully');
    } catch (e, stackTrace) {
      throw CommandException(
        'Failed to generate framework structure',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> validate() async {
    await validateFlutterProject();
  }
}

/// Command for generating feature structure
class FeatureCommand extends Command {
  /// Name of the feature to generate
  final String featureName;
  final StateManagement stateManagement;

  FeatureCommand(super.config, this.featureName, this.stateManagement);

  @override
  Future<void> execute() async {
    try {
      await validate();
      
      final generator = FeatureGenerator(
        Directory.current.path,
        featureName,
        stateManagement: stateManagement,
      );
      await generator.generate();
      
      CleanArcLogger.info('Feature structure generated successfully');
    } catch (e, stackTrace) {
      throw CommandException(
        'Failed to generate feature structure',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> validate() async {
    await validateFlutterProject();
    
    if (featureName.isEmpty) {
      throw CommandException('Feature name cannot be empty');
    }

    // Check if feature name is valid
    if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(featureName)) {
      throw CommandException(
        'Invalid feature name. Feature names must start with a lowercase letter '
        'and can only contain lowercase letters, numbers, and underscores.',
      );
    }

    // Check if feature already exists
    final featurePath = Directory(
      '${Directory.current.path}/lib/features/$featureName',
    );
    
    if (await featurePath.exists()) {
      throw CommandException(
        'Feature "$featureName" already exists. '
        'Please choose a different name or delete the existing feature.',
      );
    }
  }
}

/// Command for generating API models
class ApiCommand extends Command {
  /// URL of the API specification
  final String url;

  ApiCommand(super.config, this.url);

  @override
  Future<void> execute() async {
    try {
      await validate();
      
      final generator = ApiGenerator(
        url,
        Directory.current.path,
      );
      await generator.generate();
      
      CleanArcLogger.info('API models generated successfully');
    } catch (e, stackTrace) {
      throw CommandException(
        'Failed to generate API models',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> validate() async {
    await validateFlutterProject();
    
    if (url.isEmpty) {
      throw CommandException('API URL cannot be empty');
    }
    
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw CommandException('Invalid API URL format');
      }
    } catch (e) {
      throw CommandException('Invalid API URL: $e');
    }
  }
}

/// Factory for creating commands
class CommandFactory {
  final CleanArcConfig config;

  CommandFactory(this.config);

  /// Creates a command based on the arguments
  Command create(List<String> args) {
    final parser = ArgParser()
      ..addCommand('framework')
      ..addCommand('feature')
      ..addCommand('api')
      ..addOption('state',
          abbr: 's',
          help: 'State management framework to use (riverpod or bloc)',
          allowed: ['riverpod', 'bloc'],
          defaultsTo: 'riverpod');

    final results = parser.parse(args);
    final command = results.command;

    if (command == null) {
      throw CommandException('No command specified');
    }

    switch (command.name) {
      case 'framework':
        return FrameworkCommand(config);
      case 'feature':
        if (command.arguments.isEmpty) {
          throw CommandException('No feature name specified');
        }
        final stateManagement = StateManagement.values.firstWhere(
          (e) => e.name == results['state'],
          orElse: () => StateManagement.riverpod,
        );
        return FeatureCommand(config, command.arguments.first, stateManagement);
      case 'api':
        if (command.arguments.isEmpty) {
          throw CommandException('No API URL specified');
        }
        return ApiCommand(config, command.arguments.first);
      default:
        throw CommandException(
          'Unknown command: ${command.name}. '
          'Available commands: framework, feature, api',
        );
    }
  }
}
