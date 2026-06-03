import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversion_model.freezed.dart';
part 'conversion_model.g.dart';

@Freezed()
class ConversionModel with _$ConversionModel {
  const factory ConversionModel({
    required double ammount,
    required String from,
    required String to,
    required double result,
  }) = _ConversionModel;

  factory ConversionModel.fromJson(Map<String, Object?> json) =>
      _$ConversionModelFromJson(json);
}
