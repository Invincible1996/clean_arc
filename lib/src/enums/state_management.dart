/// Supported state management frameworks
enum StateManagement {
  /// Flutter Riverpod
  riverpod,
  /// Flutter Bloc
  bloc;

  /// Get the name of the framework
  String get name => toString().split('.').last;

  /// Get the package name for pubspec.yaml
  String get package {
    switch (this) {
      case StateManagement.riverpod:
        return 'flutter_riverpod';
      case StateManagement.bloc:
        return 'flutter_bloc';
    }
  }

  /// Get the package version for pubspec.yaml
  String get version {
    switch (this) {
      case StateManagement.riverpod:
        return '^2.4.9';
      case StateManagement.bloc:
        return '^8.1.2';
    }
  }
}
