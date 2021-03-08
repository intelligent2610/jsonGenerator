import 'dart:convert';

import 'KeyModel.dart';
import 'log_utils.dart';

class JsonGen {
  Map jsonMap;
  bool useEquatable = true;
  bool hasConstructor = true;
  bool hasCopyWith = true;
  bool hasTryCatch = true;

  Map<String, Map<KeyModel, dynamic>> listSubClass =
      <String, Map<KeyModel, dynamic>>{};

  void initJson(String text) {
    ///Convert string to json
    jsonMap = json.decode(text);
  }

  ///Create Class
  /// ==================================================================================================

  void convertSubClass(Map jsonMap, String className) {
    listSubClass[className] = <KeyModel, dynamic>{};
    defineVariable(listSubClass[className], jsonMap);
  }

  String doGen() {
    return "${hasTryCatch ? "import 'log_utils.dart';\n\n" : ""}" +
        listSubClass.entries
            .map((e) => "class ${e.key}{\n"
                "${genFields(e.value)}\n"
                "\n"
                "${genConstructor(className: e.key, data: e.value)}"
                "\n"
                "\n"
                "${genCopyWith(className: e.key, data: e.value)}"
                "\n"
                "\n"
                "${genFromJson(className: e.key, data: e.value)}"
                "\n"
                "\n"
                "${genToJson(className: e.key, data: e.value)}"
                "\n}")
            .toList()
            .join("\n\n");
  }

  ///Generate Fields
  String genFields(Map<KeyModel, dynamic> data) {
    return data.entries
        .map((e) => "${e.value} ${e.key.key};")
        .toList()
        .join("\n");
  }

  ///Generate Constructor
  String genConstructor({String className, Map<KeyModel, dynamic> data}) {
    if (!hasConstructor) {
      return "";
    }
    return "$className({\n${data.entries.map((e) => "this.${e.key.key},").toList().join("\n")}\n});";
  }

  ///Generate Constructor
  String genCopyWith({String className, Map<KeyModel, dynamic> data}) {
    if (!hasCopyWith) {
      return "";
    }
    return "$className copyWith({\n${data.entries.map((e) => "${e.key.key},").toList().join("\n")}\n}) {\n"
        "return $className(\n"
        "${data.entries.map((e) => "${e.key.key}: ${e.key.key} ?? this.${e.key.key},").toList().join("\n")}"
        ");\n"
        "}";
  }

  ///Generate factory fromJson
  String genFromJson({String className, Map<KeyModel, dynamic> data}) {
    return "factory $className.fromJson(Map<String, dynamic> json) {\n"
        "${doWithTryCatch("final ${className.decapitalize()} = $className("
            "${data.entries.map((e) => "${e.key.key}: json['${e.key.originalKey}'],").toList().join("\n")}\n"
            ");\n"
            "return ${className.decapitalize()};\n")}"
        "}";
  }

  ///Generate factory toJson
  String genToJson({String className, Map<KeyModel, dynamic> data}) {
    return "Map<String, dynamic> toJson() {\n"
        "final data = <String, dynamic>{};\n"
        "${doWithTryCatch("${data.entries.map((e) => "data['${e.key.originalKey}'] = ${e.key.key};").toList().join("\n")}\n", hasReturnNull: false)}\nreturn data;\n"
        "}";
  }

  /// ==================================================================================================

  ///Add Try catch to Source
  String doWithTryCatch(String source, {bool hasReturnNull = true}) {
    if (!hasTryCatch) {
      return source;
    }
    return "try {\n"
        "$source"
        "} catch (e, stacktrace) {\n"
        "LogUtils.d(e, stacktrace: stacktrace.toString());\n"
        "}\n"
        "${hasReturnNull ? "return null;\n" : ""}";
  }

  /// ==================================================================================================
  ///

  void defineVariable(Map<KeyModel, dynamic> field, Map data) {
    try {
      data.entries.forEach((e) {
        if (e.value is String) {
          field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
              "String";
        } else if (e.value is int) {
          field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] = "int";
        } else if (e.value is bool) {
          field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
              "bool";
        } else if (e.value is double) {
          field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
              "double";
        } else if (e.value is Map) {
          final subClassName = genClassName(e.key);
          if (!listSubClass.containsKey(subClassName)) {
            convertSubClass(e.value, subClassName);
          }
          field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
              "$subClassName";
        } else if (e.value is List) {
          final List listData = e.value;
          if (listData.isNotEmpty) {
            final firstItem = listData[0];
            if (firstItem is String) {
              field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
                  "List<String>";
            } else if (firstItem is int) {
              field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
                  "List<int>";
            } else if (firstItem is bool) {
              field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
                  "List<bool>";
            } else if (firstItem is double) {
              field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
                  "List<double>";
            } else if (firstItem is Map) {
              final subClassName = genClassName(e.key);
              if (!listSubClass.containsKey(subClassName)) {
                convertSubClass(firstItem, subClassName);
              }
              field[KeyModel(key: genFieldName(e.key), originalKey: e.key)] =
                  "List<$subClassName>";
            }
          }
        }
      });
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString(), fullStacktrace: true);
    }
  }

  String genClassName(String key) {
    if (key.contains('_')) {
      List<String> names = key.split('_');
      return names.map((e) => e.capitalize()).toList().join('');
    } else {
      return key.capitalize();
    }
  }

  String genFieldName(String key) {
    if (key.contains('_')) {
      List<String> names = key.split('_');
      int index = 0;
      return names
          .map((e) {
            if (index == 0) {
              index++;
              return e.decapitalize();
            }
            return e.capitalize();
          })
          .toList()
          .join('');
    } else {
      return key.decapitalize();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String decapitalize() {
    return "${this[0].toLowerCase()}${this.substring(1)}";
  }
}
