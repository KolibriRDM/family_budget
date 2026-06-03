import 'package:freezed_annotation/freezed_annotation.dart';

part 'rate_model.freezed.dart';
part 'rate_model.g.dart';

@Freezed()
class RateModel with _$RateModel {
  const factory RateModel({
    required bool valid,
    required int updated,
    required String base,
    required Map<String, double> rates,
  }) = _RateModel;

  factory RateModel.fromJson(Map<String, Object?> json) =>
      _$RateModelFromJson(json);
}
