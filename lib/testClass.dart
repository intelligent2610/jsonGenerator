import 'package:equatable/equatable.dart';
import 'log_utils.dart';

class UserModelTest extends Equatable {
  final String? id;
  final String? name;
  final double? distance;
  final int? helped;
  final int? helps;
  final String? situation;
  final String? phone;
  final Location? location;

  UserModelTest({
    this.id,
    this.name,
    this.distance,
    this.helped,
    this.helps,
    this.situation,
    this.phone,
    this.location,
  });

  UserModelTest copyWith({
    String? id,
    String? name,
    double? distance,
    int? helped,
    int? helps,
    String? situation,
    String? phone,
    Location? location,
  }) {
    return UserModelTest(
      id: id ?? this.id,
      name: name ?? this.name,
      distance: distance ?? this.distance,
      helped: helped ?? this.helped,
      helps: helps ?? this.helps,
      situation: situation ?? this.situation,
      phone: phone ?? this.phone,
      location: location ?? this.location,);
  }

  factory UserModelTest.fromJson(Map<String, dynamic> json) {
    try {
      final userModelTest = UserModelTest(
        id: json['id'],
        name: json['name'],
        distance: json['distance'],
        helped: json['helped'],
        helps: json['helps'],
        situation: json['situation'],
        phone: json['phone'],
        location: json.containsKey('location') ? Location.fromJson(
            json['location']) : null,
      );
      return userModelTest;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
    throw 'Wrong data null';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['id'] = id;
      data['name'] = name;
      data['distance'] = distance;
      data['helped'] = helped;
      data['helps'] = helps;
      data['situation'] = situation;
      data['phone'] = phone;
      if location != null) {
        data['location'] = location?.toJson();
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

    return data;
  }

  @override
  List<Object?> get props =>
      [
        id,
        name,
        distance,
        helped,
        helps,
        situation,
        phone,
        location,
      ];
}

class Location extends Equatable {
  final double? lat;
  final double? long;

  Location({
    this.lat,
    this.long,
  });

  Location copyWith({
    double? lat,
    double? long,
  }) {
    return Location(
      lat: lat ?? this.lat,
      long: long ?? this.long,);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    try {
      final location = Location(
        lat: json['lat'],
        long: json['long'],
      );
      return location;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
    throw 'Wrong data null';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['lat'] = lat;
      data['long'] = long;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

    return data;
  }

  @override
  List<Object?> get props =>
      [
        lat,
        long,
      ];
}