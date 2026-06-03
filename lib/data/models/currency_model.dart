import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

@Freezed()
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required bool valid,
    required Map<String, String> currencies,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(Map<String, Object?> json) =>
      _$CurrencyModelFromJson(json);
}
