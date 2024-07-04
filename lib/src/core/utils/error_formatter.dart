import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final class ErrorFormatter {
  ErrorFormatter._();

  static String format(Object? e) => switch (e) {
        (final PlatformException e) => '${e.message}',
        (final FlutterBluePlusException e) => '${e.description}',
        _ => '$e',
      };
}
