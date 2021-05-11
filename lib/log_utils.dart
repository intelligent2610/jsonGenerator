import 'package:flutter/foundation.dart';

class LogUtils {
  static void d(
    dynamic data, {
    String stacktrace,
    bool fullStacktrace = false,
  }) {
    if (kReleaseMode) {
      return;
    }
    print('[${DateTime.now().toUtc()}] ${data?.toString()}');
    if ((stacktrace?.isNotEmpty ?? false) && fullStacktrace) {
      final listLine = stacktrace.split('\n');
      listLine.forEach(print);
    } else if (stacktrace?.isNotEmpty ?? false) {
      final listLine = stacktrace.split('\n');
      if (listLine.isNotEmpty) print(listLine[0]);
    }
  }
}
