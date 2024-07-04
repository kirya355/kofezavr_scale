import 'package:shared_preferences/shared_preferences.dart';

/// Class that provides seamless access to the shared preferences.
///
/// Inspired by https://pub.dev/packages/typed_preferences
abstract base class PreferencesDao {
  const PreferencesDao({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;
  final SharedPreferences _sharedPreferences;

  /// Obtain [bool] entry from the preferences.
  PreferencesEntry<bool> boolEntry(String key) => TypedEntry<bool>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [double] entry from the preferences.
  PreferencesEntry<double> doubleEntry(String key) => TypedEntry<double>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [int] entry from the preferences.
  PreferencesEntry<int> intEntry(String key) => TypedEntry<int>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [String] entry from the preferences.
  PreferencesEntry<String> stringEntry(String key) => TypedEntry<String>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [Iterable<String>] entry from the preferences.
  PreferencesEntry<Iterable<String>> iterableStringEntry(String key) => TypedEntry<Iterable<String>>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );
}

/// [PreferencesEntry] describes a single entry in the preferences.
/// This is used to get and set values in the preferences.
abstract base class PreferencesEntry<T extends Object> {
  const PreferencesEntry();

  /// The key of the entry in the preferences.
  String get key;

  /// Obtain the value of the entry from the preferences.
  T? read();

  /// Set the value of the entry in the preferences.
  Future<void> set(T value);

  /// Remove the entry from the preferences.
  Future<void> remove();

  /// Set the value of the entry in the preferences if the value is not null.
  Future<void> setIfNullRemove(T? value) => value == null ? remove() : set(value);
}

/// A [PreferencesEntry] that is typed to a specific type [T].
///
/// You can also create subclasses of this class to create adapters for custom
/// types.
///
/// ```dart
/// class CustomTypeEntry extends TypedEntry<CustomType> {
///  CustomTypeEntry({
///   required SharedPreferences sharedPreferences,
///   required String key,
///  }) : super(sharedPreferences: sharedPreferences, key: key);
///
///  @override
///  CustomType? read() {
///   final value = _sharedPreferences.get(key);
///
///   if (value == null) return null;
///
///   return CustomType.fromJson(value);
///  }
///
///  @override
///  Future<void> set(CustomType value) => _sharedPreferences.setString(
///   key,
///   value.toJson(),
///  );
/// }
/// ```
base class TypedEntry<T extends Object> extends PreferencesEntry<T> {
  TypedEntry({
    required SharedPreferences sharedPreferences,
    required this.key,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  final String key;

  @override
  T? read() {
    final value = _sharedPreferences.get(key);

    if (value == null) return null;

    if (value is T) return value;

    throw StateError(
      'The value of $key is not of type ${T.runtimeType.toString()}',
    );
  }

  @override
  Future<void> set(T value) => switch (value) {
        final int value => _sharedPreferences.setInt(key, value),
        final double value => _sharedPreferences.setDouble(key, value),
        final String value => _sharedPreferences.setString(key, value),
        final bool value => _sharedPreferences.setBool(key, value),
        final Iterable<String> value => _sharedPreferences.setStringList(
            key,
            value.toList(),
          ),
        _ => throw StateError(
            '$T is not a valid type for a preferences entry value.',
          ),
      };

  @override
  Future<void> remove() => _sharedPreferences.remove(key);
}
