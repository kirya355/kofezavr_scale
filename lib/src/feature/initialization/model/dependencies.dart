import 'package:kofezavr_scale/src/feature/app/logic/tracking_manager.dart';
import 'package:kofezavr_scale/src/feature/initialization/logic/composition_root.dart';
import 'package:kofezavr_scale/src/feature/settings/bloc/settings_bloc.dart';

/// Composed dependencies from the [CompositionRoot].
///
/// This class is used to pass dependencies to the application.
base class Dependencies {
  const Dependencies({
    required this.settingsBloc,
    required this.errorTrackingManager,
  });

  /// [SettingsBloc] instance, used to manage theme and locale.
  final SettingsBloc settingsBloc;

  /// [ErrorTrackingManager] instance, used to report errors.
  final ErrorTrackingManager errorTrackingManager;
}

/// Result of composition
final class CompositionResult {
  const CompositionResult({
    required this.dependencies,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => '$CompositionResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
