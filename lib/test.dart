String generateReplyEntityCode(String inputType) {
  // 提取类型层级
  List<String> typeHierarchy = _extractTypeHierarchy(inputType);

  // 检查最内层类型是否为基本类型
  const basicTypesWithEmptyData = {
    'int',
    'double',
    'String',
    'string',
    'object'
  };
  String dataExpression;

  if (typeHierarchy.last == 'boolean') {
    // 如果是 boolean 类型，返回 bool
    dataExpression = 'bool';
  } else if (basicTypesWithEmptyData.contains(typeHierarchy.last)) {
    // 如果是 string 或 object，返回空字符串
    dataExpression = "''";
  } else if (typeHierarchy.length == 1) {
    // 未知单一类型，返回空字符串
    dataExpression = "''";
  } else {
    // 嵌套类型，生成 fromJson 代码
    String content = 'response.data';
    for (int i = typeHierarchy.length - 1; i >= 1; i--) {
      content = '${typeHierarchy[i]}.fromJson($content)';
    }
    dataExpression = content;
  }

  // 模板生成代码
  return '''
ReplyEntity(
  data: $dataExpression,
  code: 'success',
  message: 'success',
);
''';
}

// 提取嵌套类型层次
List<String> _extractTypeHierarchy(String inputType) {
  List<String> hierarchy = [];
  RegExp typePattern = RegExp(r'([a-zA-Z0-9]+)«?');
  Iterable<RegExpMatch> matches = typePattern.allMatches(inputType);

  for (var match in matches) {
    if (match.group(1) != null) {
      hierarchy.add(match.group(1)!);
    }
  }

  return hierarchy;
}

// 示例调用
void main() {
  print(generateReplyEntityCode(
      'ReplyEntity«BasePageResDTO«ListMarketImportAllocateRecordRespDTO»»'));
  print(generateReplyEntityCode('ReplyEntity«MarketApplyAutoAssignResp»'));
  print(generateReplyEntityCode('ReplyEntity«boolean»'));
  print(generateReplyEntityCode('ReplyEntity«string»'));
  print(generateReplyEntityCode('ReplyEntity«object»'));
  print(generateReplyEntityCode('ReplyEntity«UnknownType»'));
}
