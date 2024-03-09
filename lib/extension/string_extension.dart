/// author : kevin zhang
/// date : 2024-03-09
/// desc => String Extension
extension StringExtension on String {
  /// fileName to className ,
  /// eg: user_repository.dart to UserRepository | test.dart to Test
  String get toClassName {
    return split('_')
        .map((e) {
          return e[0].toUpperCase() + e.substring(1);
        })
        .join()
        .split('.')
        .first;
  }
}
