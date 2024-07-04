import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kofezavr_scale/src/core/router/app_router.dart';
import 'package:kofezavr_scale/src/core/utils/error_formatter.dart';
import 'package:kofezavr_scale/src/core/utils/extensions/context_extension.dart';

abstract mixin class BluetoothController {
  BluetoothAdapterState get state;

  void turnOn();
}

class BluetoothScope extends StatefulWidget {
  const BluetoothScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static BluetoothController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      context.inhOf<_InheritedBluetoothScope>(listen: listen).controller;

  @override
  State<BluetoothScope> createState() => _BluetoothScopeState();
}

class _BluetoothScopeState extends State<BluetoothScope> with BluetoothController {
  @override
  BluetoothAdapterState get state => _adapterState;

  @override
  void turnOn() {
    if (!Platform.isAndroid) return;

    final scaffoldMessenger =
        ScaffoldMessenger.maybeOf(context) ?? AppRouter.getRootScaffoldMessengerKey.currentState;

    unawaited(FlutterBluePlus.turnOn().onError((Object e, s) {
      scaffoldMessenger?.showSnackBar(SnackBar(
        content: Text(
          'Error Turning On: '
          '${ErrorFormatter.format(e)}',
        ),
      ));
      Error.throwWithStackTrace(e, s);
    }));
  }

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    unawaited(_adapterStateStateSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedBluetoothScope(
        controller: this,
        state: state,
        child: widget.child,
      );
}

class _InheritedBluetoothScope extends InheritedWidget {
  const _InheritedBluetoothScope({
    required this.controller,
    required this.state,
    required super.child,
  });

  final BluetoothController controller;
  final BluetoothAdapterState state;

  @override
  bool updateShouldNotify(covariant _InheritedBluetoothScope oldWidget) {
    if (oldWidget.state != state) return true;
    return false;
  }
}
