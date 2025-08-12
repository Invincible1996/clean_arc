/// Clean Arc - Flutter Clean Architecture Generator
/// 
/// A command-line tool for generating Flutter projects with Clean Architecture.
/// This library provides utilities for creating standardized project structures
/// and feature modules following Clean Architecture principles.
library clean_arc;

// Export commands for external usage
export 'commands/create_command.dart';
export 'commands/feature_command.dart';

// Export services for advanced usage
export 'services/project_creator.dart';
export 'services/feature_creator.dart';

// Export templates for customization
export 'templates/core_templates.dart';
export 'templates/feature_templates.dart';