import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@Freezed()
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    int? id,
    String? name,
    String? color,
    String? icon,
    int? userId,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, Object?> json) =>
      _$CategoryModelFromJson(json);
}
