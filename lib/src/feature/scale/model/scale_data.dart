import 'package:freezed_annotation/freezed_annotation.dart';

part 'scale_data.freezed.dart';
part 'scale_data.g.dart';

@freezed
class ScaleData with _$ScaleData {
  const factory ScaleData({
    required final String value,
  }) = _ScaleData;

  const ScaleData._();

  factory ScaleData.fromJson(Map<String, Object?> json) => _$ScaleDataFromJson(json);
}
