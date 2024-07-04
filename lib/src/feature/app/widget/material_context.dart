import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kofezavr_scale/src/core/constant/localization/localization.dart';
import 'package:kofezavr_scale/src/core/router/app_router.dart';
import 'package:kofezavr_scale/src/core/router/bluetooth_off_guard.dart';
import 'package:kofezavr_scale/src/feature/bluetooth/widget/bluetooth_scope.dart';
import 'package:kofezavr_scale/src/feature/settings/widget/settings_scope.dart';

/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
class MaterialContext extends StatefulWidget {
  const MaterialContext({
    super.key,
    required this.builder,
  });

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  final TransitionBuilder builder;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final AppRouter _appRouter;

  late final ValueNotifier<BluetoothAdapterState> _reevaluateListenable;

  final _bluetoothUpdatedStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _reevaluateListenable = ValueNotifier<BluetoothAdapterState>(BluetoothScope.of(
      context,
      listen: false,
    ).state);
    _appRouter = AppRouter(
      bluetoothOffGuard: BluetoothOffGuard(
        isBluetoothOff: () =>
            BluetoothScope.of(context, listen: false).state == BluetoothAdapterState.on,
        bluetoothUpdatedStream: _bluetoothUpdatedStream.stream,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final bluetoothAdapterState = BluetoothScope.of(context).state;
    _reevaluateListenable.value = bluetoothAdapterState;
    _bluetoothUpdatedStream.add(bluetoothAdapterState);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _reevaluateListenable.dispose();
    unawaited(_bluetoothUpdatedStream.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return MaterialApp.router(
      title: 'Kofezavr Scale',
      scrollBehavior: _MyCustomScrollBehavior(),
      scaffoldMessengerKey: AppRouter.getRootScaffoldMessengerKey,
      routerConfig: _appRouter.config(
        reevaluateListenable: _reevaluateListenable,
      ),
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      locale: locale,
      builder: (context, child) => MediaQuery.withNoTextScaling(
        key: MaterialContext._globalKey,
        child: widget.builder(context, child),
      ),
    );
  }
}

class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
