import 'dart:async';

import 'package:kofezavr_scale/src/core/utils/refined_logger.dart';
import 'package:kofezavr_scale/src/feature/app/logic/app_runner.dart';

void main() => runZonedGuarded(
      () async => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
