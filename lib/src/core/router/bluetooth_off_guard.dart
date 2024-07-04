import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:kofezavr_scale/src/core/router/app_router.dart';

class BluetoothOffGuard extends AutoRouteGuard {
  BluetoothOffGuard({
    required bool Function() isBluetoothOff,
    required Stream bluetoothUpdatedStream,
  })  : _isBluetoothOff = isBluetoothOff,
        _bluetoothUpdatedStream = bluetoothUpdatedStream;

  final bool Function() _isBluetoothOff;
  final Stream _bluetoothUpdatedStream;

  bool _canNavigate() => _isBluetoothOff();

  StreamSubscription? _bluetoothUpdatedSub;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_canNavigate()) {
      resolver.next();
      return;
    }
    router.removeWhere(
      (route) => (route.name == BluetoothOffRoute.name),
    );

    await _bluetoothUpdatedSub?.cancel();
    _bluetoothUpdatedSub = _bluetoothUpdatedStream.listen((_) {
      if (!_canNavigate()) return;
      resolver.resolveNext(true, reevaluateNext: false);
    });

    await resolver.redirect(const BluetoothOffRoute());

    await _bluetoothUpdatedSub?.cancel();
  }
}
