import 'package:logging/logging.dart';

/// Logger utility for Clean Arc
class CleanArcLogger {
  static final Logger _logger = Logger('CleanArc');
  static bool _initialized = false;

  /// Initialize the logger with the specified level
  static void init({Level level = Level.INFO}) {
    if (_initialized) return;

    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      final emoji = _getLevelEmoji(record.level);
      print('$emoji ${record.time}: ${record.message}');
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('Stack trace:\n${record.stackTrace}');
      }
    });

    _initialized = true;
  }

  /// Log an info message
  static void info(String message) {
    _ensureInitialized();
    _logger.info(message);
  }

  /// Log a warning message
  static void warning(String message) {
    _ensureInitialized();
    _logger.warning(message);
  }

  /// Log an error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.severe(message, error, stackTrace);
  }

  /// Log a debug message
  static void debug(String message) {
    _ensureInitialized();
    _logger.fine(message);
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      init();
    }
  }

  static String _getLevelEmoji(Level level) {
    if (level == Level.SEVERE) return '🚨';
    if (level == Level.WARNING) return '⚠️';
    if (level == Level.INFO) return '📝';
    if (level == Level.FINE) return '🔍';
    return '📌';
  }
}
