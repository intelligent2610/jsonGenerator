import 'log_utils.dart';

class FlutterClass{
  final String id;
  final String specificulture;
  final String status;
  final Obj obj;
  final String parentType;

  FlutterClass({
    this.id,
    this.specificulture,
    this.status,
    this.obj,
    this.parentType,
  });

  FlutterClass copyWith({
    id,
    specificulture,
    status,
    obj,
    parentType,
  }) {
    return FlutterClass(
      id: id ?? this.id,
      specificulture: specificulture ?? this.specificulture,
      status: status ?? this.status,
      obj: obj ?? this.obj,
      parentType: parentType ?? this.parentType,);
  }

  factory FlutterClass.fromJson(Map<String, dynamic> json) {
    try {
      final flutterClass = FlutterClass(id: json['id'],
        specificulture: json['specificulture'],
        status: json['status'],
        obj: json['obj'],
        parentType: json['parentType'],
      );
      return flutterClass;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['id'] = id;
      data['specificulture'] = specificulture;
      data['status'] = status;
      data['obj'] = obj;
      data['parentType'] = parentType;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

    return data;
  }
}

class Obj{
  final String id;
  final String title;
  final String name;
  final List<MobileAppMenuItem> mobileAppMenuItem;

  Obj({
    this.id,
    this.title,
    this.name,
    this.mobileAppMenuItem,
  });

  Obj copyWith({
    id,
    title,
    name,
    mobileAppMenuItem,
  }) {
    return Obj(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      mobileAppMenuItem: mobileAppMenuItem ?? this.mobileAppMenuItem,);
  }

  factory Obj.fromJson(Map<String, dynamic> json) {
    try {
      final obj = Obj(id: json['id'],
        title: json['title'],
        name: json['name'],
        mobileAppMenuItem: json['mobile_app_menu_item'],
      );
      return obj;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['id'] = id;
      data['title'] = title;
      data['name'] = name;
      data['mobile_app_menu_item'] = mobileAppMenuItem;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

    return data;
  }
}

class MobileAppMenuItem{
  final String id;
  final String title;
  final String type;
  final String databaseName;
  final String searchValue;

  MobileAppMenuItem({
    this.id,
    this.title,
    this.type,
    this.databaseName,
    this.searchValue,
  });

  MobileAppMenuItem copyWith({
    id,
    title,
    type,
    databaseName,
    searchValue,
  }) {
    return MobileAppMenuItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      databaseName: databaseName ?? this.databaseName,
      searchValue: searchValue ?? this.searchValue,);
  }

  factory MobileAppMenuItem.fromJson(Map<String, dynamic> json) {
    try {
      final mobileAppMenuItem = MobileAppMenuItem(id: json['id'],
        title: json['title'],
        type: json['type'],
        databaseName: json['database_name'],
        searchValue: json['search_value'],
      );
      return mobileAppMenuItem;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['id'] = id;
      data['title'] = title;
      data['type'] = type;
      data['database_name'] = databaseName;
      data['search_value'] = searchValue;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

    return data;
  }
}