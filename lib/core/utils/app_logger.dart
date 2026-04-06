import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String tag = "APP"}){
    if(kDebugMode){
      debugPrint("[$tag][INFO] $message");
    }
  }

  static void error(String message, {String tag = "APP"}){
    debugPrint("[$tag][ERROR] $message");
  }
  
  static void warning(String message, {String tag = "APP"}) {
  if (kDebugMode) {
    debugPrint("[$tag][WARNING] $message");
  }
}
}
