// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  double? get totalCount => throw _privateConstructorUsedError;
  CategoryModel? get category => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  bool? get hasReceipt => throw _privateConstructorUsedError;
  ReceiptModel? get receipt => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
          ExpenseModel value, $Res Function(ExpenseModel) then) =
      _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'total_count') double? totalCount,
      CategoryModel? category,
      DateTime? date,
      @JsonKey(name: 'user_id') int? userId,
      bool? hasReceipt,
      ReceiptModel? receipt});

  $CategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? totalCount = freezed,
    Object? category = freezed,
    Object? date = freezed,
    Object? userId = freezed,
    Object? hasReceipt = freezed,
    Object? receipt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCount: freezed == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      hasReceipt: freezed == hasReceipt
          ? _value.hasReceipt
          : hasReceipt // ignore: cast_nullable_to_non_nullable
              as bool?,
      receipt: freezed == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as ReceiptModel?,
    ) as $Val);
  }

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
          _$ExpenseModelImpl value, $Res Function(_$ExpenseModelImpl) then) =
      __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'total_count') double? totalCount,
      CategoryModel? category,
      DateTime? date,
      @JsonKey(name: 'user_id') int? userId,
      bool? hasReceipt,
      ReceiptModel? receipt});

  @override
  $CategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
      _$ExpenseModelImpl _value, $Res Function(_$ExpenseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? totalCount = freezed,
    Object? category = freezed,
    Object? date = freezed,
    Object? userId = freezed,
    Object? hasReceipt = freezed,
    Object? receipt = freezed,
  }) {
    return _then(_$ExpenseModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCount: freezed == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      hasReceipt: freezed == hasReceipt
          ? _value.hasReceipt
          : hasReceipt // ignore: cast_nullable_to_non_nullable
              as bool?,
      receipt: freezed == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as ReceiptModel?,
    ));
  }
}

/// @nodoc

class _$ExpenseModelImpl implements _ExpenseModel {
  const _$ExpenseModelImpl(
      {this.id,
      @JsonKey(name: 'total_count') this.totalCount,
      this.category,
      this.date,
      @JsonKey(name: 'user_id') this.userId,
      this.hasReceipt,
      this.receipt});

  @override
  final int? id;
  @override
  @JsonKey(name: 'total_count')
  final double? totalCount;
  @override
  final CategoryModel? category;
  @override
  final DateTime? date;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final bool? hasReceipt;
  @override
  final ReceiptModel? receipt;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, totalCount: $totalCount, category: $category, date: $date, userId: $userId, hasReceipt: $hasReceipt, receipt: $receipt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.hasReceipt, hasReceipt) ||
                other.hasReceipt == hasReceipt) &&
            (identical(other.receipt, receipt) || other.receipt == receipt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, totalCount, category, date, userId, hasReceipt, receipt);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);
}

abstract class _ExpenseModel implements ExpenseModel {
  const factory _ExpenseModel(
      {final int? id,
      @JsonKey(name: 'total_count') final double? totalCount,
      final CategoryModel? category,
      final DateTime? date,
      @JsonKey(name: 'user_id') final int? userId,
      final bool? hasReceipt,
      final ReceiptModel? receipt}) = _$ExpenseModelImpl;

  @override
  int? get id;
  @override
  @JsonKey(name: 'total_count')
  double? get totalCount;
  @override
  CategoryModel? get category;
  @override
  DateTime? get date;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  bool? get hasReceipt;
  @override
  ReceiptModel? get receipt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
