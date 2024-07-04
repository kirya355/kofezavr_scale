import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kofezavr_scale/src/core/router/bluetooth_off_guard.dart';
import 'package:kofezavr_scale/src/feature/bluetooth/widget/bluetooth_off_screen.dart';
import 'package:kofezavr_scale/src/feature/home/widget/home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter({
    required final BluetoothOffGuard bluetoothOffGuard,
  })  : _bluetoothOffGuard = bluetoothOffGuard,
        super(navigatorKey: _navigatorKey);

  static BuildContext? get getCurrentContext => _navigatorKey.currentContext;
  static GlobalKey<ScaffoldMessengerState> get getRootScaffoldMessengerKey =>
      _rootScaffoldMessengerKey;

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  static final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final BluetoothOffGuard _bluetoothOffGuard;

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      page: BluetoothOffRoute.page,
    ),
    AutoRoute(
      initial: true,
      page: HomeRoute.page,
      guards: [
        _bluetoothOffGuard,
      ],
    ),
  ];
}
