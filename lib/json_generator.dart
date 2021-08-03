import 'dart:convert';

import 'KeyModel.dart';
import 'log_utils.dart';

class JsonGen {
  Map jsonMap;
  bool useEquatable = true;
  bool useNullSafety = true;
  bool hasConstructor = true;
  bool hasCopyWith = true;
  bool hasTryCatch = true;
  String pathLog;

  Map<String, Map<KeyModel, dynamic>> listSubClass =
      <String, Map<KeyModel, dynamic>>{};

  void initJson(
    String text, {
    bool useEquatable,
    bool useNullSafety,
    bool hasConstructor,
    bool hasCopyWith,
    bool hasTryCatch,
    String pathLog,
  }) {
    this.useEquatable = useEquatable;
    this.useNullSafety = useNullSafety;
    this.hasConstructor = hasConstructor;
    this.hasCopyWith = hasCopyWith;
    this.hasTryCatch = hasTryCatch;
    this.pathLog = pathLog;

    ///Convert string to json
    jsonMap = json.decode(text);
    listSubClass.clear();
  }

  ///Create Class
  /// ==================================================================================================

  void convertSubClass(Map jsonMap, String className) {
    listSubClass[className] = <KeyModel, dynamic>{};
    defineVariable(listSubClass[className], jsonMap);
  }

  String doGen() {
    return "${useEquatable ? "import 'package:equatable/equatable.dart';\n" : ""}" +
        "${hasTryCatch ? "${pathLog.isNotEmpty ? pathLog : "import 'log_utils.dart'"};\n\n" : ""}" +
        listSubClass.entries
            .map((e) =>
                "class ${e.key} ${useEquatable ? "extends Equatable" : ""}{\n"
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
                "${genToJson(data: e.value)}"
                "\n"
                "\n"
                "${genProps(data: e.value)}"
                "\n}")
            .toList()
            .join("\n\n");
  }

  ///Generate Fields
  String genFields(Map<KeyModel, dynamic> data) {
    return data.entries
        .map((e) =>
            "${useEquatable ? "final " : ""}${e.value}${useNullSafety ? "?" : ""} ${e.key.key};")
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
    return "$className copyWith({\n${data.entries.map((e) => "${e.value}${useNullSafety ? "?" : ""} ${e.key.key},").toList().join("\n")}\n}) {\n"
        "return $className(\n"
        "${data.entries.map((e) => "${e.key.key}: ${e.key.key} ?? this.${e.key.key},").toList().join("\n")}"
        ");\n"
        "}";
  }

  ///Generate factory fromJson
  String genFromJson({String className, Map<KeyModel, dynamic> data}) {
    return "factory $className.fromJson(Map<String, dynamic> json) {\n"
        "${doWithTryCatch("final ${className.decapitalize()} = $className(\n"
            "${data.entries.map((e) => genFieldFromJson(e.key)).toList().join("\n")}\n"
            ");\n"
            "return ${className.decapitalize()};\n")}"
        "}";
  }

  ///Generate factory toJson
  String genToJson({Map<KeyModel, dynamic> data}) {
    return "Map<String, dynamic> toJson() {\n"
        "final data = <String, dynamic>{};\n"
        "${doWithTryCatch("${data.entries.map((e) => genFieldToJson(e.key)).toList().join("\n")}\n", hasReturnNull: false)}\nreturn data;\n"
        "}";
  }

  ///Generate props
  String genProps({Map<KeyModel, dynamic> data}) {
    if (!useEquatable) {
      return "";
    }
    return "@override\n"
        "List<Object${useNullSafety ? "?" : ""}> get props => [\n"
        "${data.entries.map((e) => '${e.key.key},').toList().join("\n")}\n"
        "];";
  }

  /// ======================
  String genFieldFromJson(KeyModel keyModel) {
    if (keyModel.isArray) {
      if (keyModel.isClass) {
        return "${keyModel.key}: json.containsKey('${keyModel.originalKey}') ? json['${keyModel.originalKey}']?.map<${keyModel.dataType}>((e)=>${keyModel.dataType}.fromJson(e))?.toList():null,";
      } else {
        return "${keyModel.key}: json.containsKey('${keyModel.originalKey}') ? json['${keyModel.originalKey}']?.cast<${keyModel.dataType}>(): null,";
      }
    } else {
      if (keyModel.isClass) {
        return "${keyModel.key}: json.containsKey('${keyModel.originalKey}') ? "
            "${keyModel.dataType}.fromJson(json['${keyModel.originalKey}']):null,";
      } else {
        return "${keyModel.key}: json['${keyModel.originalKey}'],";
      }
    }
  }

  String genFieldToJson(KeyModel keyModel) {
    if (keyModel.isArray) {
      if (keyModel.isClass) {
        return "if (${keyModel.key} != null) {\n"
            "data['${keyModel.originalKey}'] = ${keyModel.key}?.map((v) => v.toJson()).toList();"
            "\n}";
      } else {
        return "data['${keyModel.originalKey}'] = ${keyModel.key};";
      }
    } else {
      if (keyModel.isClass) {
        return "if ${keyModel.key} != null) {\n"
            "data['${keyModel.originalKey}'] =${keyModel.key}?.toJson();"
            "\n}";
      } else {
        return "data['${keyModel.originalKey}'] = ${keyModel.key};";
      }
    }
  }

  /// ==================================================================================================

  ///Add Try catch to Source
  String doWithTryCatch(String source,
      {bool hasReturnNull = true, String className}) {
    if (!hasTryCatch) {
      return source;
    }
    return "try {\n"
        "$source"
        "} catch (e, stacktrace) {\n"
        "LogUtils.d(e, stacktrace: stacktrace.toString());\n"
        "}\n"
        "${hasReturnNull ? "throw 'Wrong data $className';\n" : ""}";
  }

  /// ==================================================================================================
  ///

  void defineVariable(Map<KeyModel, dynamic> field, Map data) {
    try {
      data.entries.forEach((e) {
        if (e.value is String) {
          field[KeyModel(
            key: genFieldName(e.key),
            originalKey: e.key,
            dataType: 'String',
          )] = "String";
        } else if (e.value is int) {
          field[KeyModel(
            key: genFieldName(e.key),
            originalKey: e.key,
            dataType: 'int',
          )] = "int";
        } else if (e.value is bool) {
          field[KeyModel(
            key: genFieldName(e.key),
            originalKey: e.key,
            dataType: 'bool',
          )] = "bool";
        } else if (e.value is double) {
          field[KeyModel(
            key: genFieldName(e.key),
            originalKey: e.key,
            dataType: 'double',
          )] = "double";
        } else if (e.value is Map) {
          final subClassName = genClassName(e.key);
          if (!listSubClass.containsKey(subClassName)) {
            convertSubClass(e.value, subClassName);
          }
          field[KeyModel(
            key: genFieldName(e.key),
            originalKey: e.key,
            isClass: true,
            dataType: subClassName,
          )] = "$subClassName";
        } else if (e.value is List) {
          final List listData = e.value;
          if (listData.isNotEmpty) {
            final firstItem = listData[0];
            if (firstItem is String) {
              field[KeyModel(
                key: genFieldName(e.key),
                originalKey: e.key,
                isArray: true,
                dataType: 'String',
              )] = "List<String>";
            } else if (firstItem is int) {
              field[KeyModel(
                key: genFieldName(e.key),
                originalKey: e.key,
                isArray: true,
                dataType: 'int',
              )] = "List<int>";
            } else if (firstItem is bool) {
              field[KeyModel(
                key: genFieldName(e.key),
                originalKey: e.key,
                isArray: true,
                dataType: 'bool',
              )] = "List<bool>";
            } else if (firstItem is double) {
              field[KeyModel(
                key: genFieldName(e.key),
                originalKey: e.key,
                isArray: true,
                dataType: 'double',
              )] = "List<double>";
            } else if (firstItem is Map) {
              final subClassName = genClassName(e.key);
              if (!listSubClass.containsKey(subClassName)) {
                convertSubClass(firstItem, subClassName);
              }
              field[KeyModel(
                key: genFieldName(e.key),
                originalKey: e.key,
                isArray: true,
                isClass: true,
                dataType: subClassName,
              )] = "List<$subClassName>";
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
