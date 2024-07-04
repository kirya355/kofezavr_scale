import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kofezavr_scale/src/feature/bluetooth/widget/bluetooth_scope.dart';

@RoutePage()
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = BluetoothScope.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: theme.colorScheme.onSurface,
            ),
            Text(
              'Bluetooth Adapter is ${controller.state.name}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
            ),
            if (Platform.isAndroid)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: controller.turnOn,
                  child: const Text('TURN ON'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
