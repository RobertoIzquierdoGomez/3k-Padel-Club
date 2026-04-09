import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String tag = "APP"}) {
    final now = DateTime.now();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final time =
        "${twoDigits(now.hour)}:"
        "${twoDigits(now.minute)}:"
        "${twoDigits(now.second)}";

    if (kDebugMode) {
      debugPrint("$time-[$tag][INFO]-$message");
    }
  }

  static void error(String message, {String tag = "APP"}) {
    final now = DateTime.now();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final time =
        "${twoDigits(now.hour)}:"
        "${twoDigits(now.minute)}:"
        "${twoDigits(now.second)}";
    debugPrint("$time-[$tag][ERROR]-$message");
  }

  static void warning(String message, {String tag = "APP"}) {
    final now = DateTime.now();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final time =
        "${twoDigits(now.hour)}:"
        "${twoDigits(now.minute)}:"
        "${twoDigits(now.second)}";
    if (kDebugMode) {
      debugPrint("$time-[$tag][WARNING]-$message");
    }
  }
}
