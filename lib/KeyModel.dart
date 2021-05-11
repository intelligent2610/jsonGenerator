class KeyModel {
  final key;
  final originalKey;
  final isClass;
  final dataType;
  final isArray;

  KeyModel({
    this.key,
    this.dataType,
    this.isArray = false,
    this.isClass = false,
    this.originalKey,
  });
}
