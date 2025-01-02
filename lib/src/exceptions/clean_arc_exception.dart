/// Base exception class for Clean Arc
class CleanArcException implements Exception {
  /// The error message
  final String message;

  /// The original error that caused this exception
  final dynamic cause;

  /// Stack trace of the error
  final StackTrace? stackTrace;

  /// Creates a new [CleanArcException]
  CleanArcException(
    this.message, {
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('CleanArcException: $message');
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    return buffer.toString();
  }
}

/// Exception thrown when API related operations fail
class ApiException extends CleanArcException {
  ApiException(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

/// Exception thrown when file operations fail
class FileException extends CleanArcException {
  FileException(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

/// Exception thrown when code generation fails
class CodeGenException extends CleanArcException {
  CodeGenException(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

/// Exception thrown when command execution fails
class CommandException extends CleanArcException {
  CommandException(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}
