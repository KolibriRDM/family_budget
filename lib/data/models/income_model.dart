import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/models/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_model.freezed.dart';

@Freezed()
class IncomeModel with _$IncomeModel {
  const factory IncomeModel({
    int? id,
    @JsonKey(name: 'total_count') double? totalCount,
    CategoryModel? category,
    DateTime? date,
    @JsonKey(name: 'user_id') int? userId,
  }) = _IncomeModel;

  factory IncomeModel.fromJson(Map<String, Object?> json) {
    final categoriesCubit = getIt<CategoriesCubit>();
    final categories = categoriesCubit.state is CategoriesLoaded
        ? (categoriesCubit.state as CategoriesLoaded).categories
        : List.empty(growable: true);

    final categoryId = json['category_id'] as int?;
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel(
          id: categoryId, name: 'Неизвестная', icon: '', color: '#FFFFFF'),
    );

    return IncomeModel(
      id: json['id'] as int?,
      totalCount: (json['total_count'] as num?)?.toDouble(),
      category: category,
      date:
          json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      userId: json['user_id'] as int?,
    );
  }
}
