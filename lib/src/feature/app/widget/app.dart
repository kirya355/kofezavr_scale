import 'package:flutter/material.dart';
import 'package:kofezavr_scale/src/feature/app/widget/material_context.dart';
import 'package:kofezavr_scale/src/feature/bluetooth/widget/bluetooth_scope.dart';
import 'package:kofezavr_scale/src/feature/initialization/logic/composition_root.dart';
import 'package:kofezavr_scale/src/feature/initialization/model/dependencies.dart';
import 'package:kofezavr_scale/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:kofezavr_scale/src/feature/settings/widget/settings_scope.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// [App] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
class App extends StatelessWidget {
  /// {@macro app}
  const App({required this.result, super.key});

  /// The result from the [CompositionRoot].
  final CompositionResult result;

  @override
  Widget build(BuildContext context) => DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: DependenciesScope(
          dependencies: result.dependencies,
          child: SettingsScope(
            settingsBloc: result.dependencies.settingsBloc,
            child: BluetoothScope(
              child: MaterialContext(
                builder: (context, child) => child!,
              ),
            ),
          ),
        ),
      );
}
