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

  /// first letter is lowercase, eg: /note/add to noteAdd
  String get toMethodName {
    final list = split('/');
    // 去除list中所有的空字符串
    list.removeWhere((element) => element.isEmpty);
    // list中第二、三个元素首字母大写
    for (var i = 1; i < list.length; i++) {
      list[i] = list[i][0].toUpperCase() + list[i].substring(1);
    }
    return list.join();
  }

  // get url from arguments
// eg:api:http://47.97.6.227:8081/v2/api-docs to http://
  String get toUrl {
    return split(':')[1].split('/').first;
  }
}
