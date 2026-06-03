import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/models/category_model.dart';
import 'package:family_budget/data/models/receipt_item_model.dart';
import 'package:family_budget/data/models/receipt_model.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/receipt_scan/widgets/receipt_item_editor_tile.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ReceiptReviewResult {
  const ReceiptReviewResult({
    required this.receipt,
    required this.categoryId,
  });

  final ReceiptModel receipt;
  final int categoryId;
}

class ReceiptReviewBottomSheet extends StatefulWidget {
  const ReceiptReviewBottomSheet({
    super.key,
    required this.initialReceipt,
    this.warnings = const [],
  });

  final ReceiptModel initialReceipt;
  final List<String> warnings;

  @override
  State<ReceiptReviewBottomSheet> createState() =>
      _ReceiptReviewBottomSheetState();
}

class _ReceiptReviewBottomSheetState extends State<ReceiptReviewBottomSheet> {
  late ReceiptModel _receipt;
  late final TextEditingController _storeController;
  late final TextEditingController _totalController;
  CategoryModel? _selectedCategory;
  DateTime? _selectedDateTime;
  bool _wasManuallyChanged = false;

  @override
  void initState() {
    super.initState();
    _receipt = widget.initialReceipt;
    _storeController = TextEditingController(text: _receipt.storeName ?? '');
    _totalController = TextEditingController(
      text: _receipt.totalAmount > 0 ? _receipt.totalAmount.toString() : '',
    );
    _selectedDateTime = _receipt.receiptDateTime;
    final cubit = getIt<CategoriesCubit>();
    if (cubit.state is! CategoriesLoaded) {
      cubit.loadCategories();
    }
  }

  @override
  void dispose() {
    _storeController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _markManualChange() {
    _wasManuallyChanged = true;
  }

  void _updateItem(int index, ReceiptItemModel item) {
    final items = [..._receipt.items];
    items[index] = item;
    setState(() {
      _markManualChange();
      _receipt = _receipt.copyWith(
        items: items,
        isManuallyCorrected: true,
      );
    });
  }

  void _addItem() {
    setState(() {
      _markManualChange();
      _receipt = _receipt.copyWith(
        items: [
          ..._receipt.items,
          const ReceiptItemModel(
            name: '',
            quantity: 1,
            lineTotal: 0,
            isManuallyCorrected: true,
          ),
        ],
        isManuallyCorrected: true,
      );
    });
  }

  void _removeItem(int index) {
    final items = [..._receipt.items]..removeAt(index);
    setState(() {
      _markManualChange();
      _receipt = _receipt.copyWith(
        items: items,
        isManuallyCorrected: true,
      );
    });
  }

  double get _itemsTotal =>
      _receipt.items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get _effectiveTotal =>
      double.tryParse(_totalController.text.replaceAll(',', '.')) ??
      (_receipt.totalAmount > 0 ? _receipt.totalAmount : _itemsTotal);

  List<String> get _effectiveWarnings {
    final totalsDiffer = _effectiveTotal > 0 &&
        _itemsTotal > 0 &&
        (_itemsTotal - _effectiveTotal).abs() > 0.5;
    final warnings = widget.warnings
        .where((warning) =>
            totalsDiffer ||
            !warning.startsWith('Сумма позиций отличается от итога чека'))
        .toList();

    if (totalsDiffer) {
      warnings.add(
        'Сумма позиций отличается от итога чека на ${(_itemsTotal - _effectiveTotal).abs().toStringAsFixed(2)} RUB.',
      );
    }
    return warnings.toSet().toList();
  }

  Future<void> _pickDateTime() async {
    final initial = _selectedDateTime ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;

    setState(() {
      _markManualChange();
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _useItemsTotal() {
    setState(() {
      _markManualChange();
      _totalController.text = _itemsTotal.toStringAsFixed(2);
    });
  }

  ReceiptModel _buildReceiptForSave() {
    return ReceiptModel(
      id: _receipt.id,
      expenseId: _receipt.expenseId,
      storeName: _storeController.text.trim().isEmpty
          ? null
          : _storeController.text.trim(),
      receiptDateTime: _selectedDateTime,
      totalAmount: _effectiveTotal,
      currency: _receipt.currency,
      rawText: _receipt.rawText,
      imagePath: _receipt.imagePath,
      isPartiallyRecognized: _receipt.isPartiallyRecognized,
      isManuallyCorrected:
          _receipt.isManuallyCorrected || _wasManuallyChanged,
      items: _receipt.items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _selectedDateTime != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!)
        : 'Дата не найдена';

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Column(
              children: [
                _buildHandle(),
                const SizedBox(height: 12),
                Text(
                  'Проверка чека',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SummaryCard(
                          storeName: _storeController.text.trim().isEmpty
                              ? 'Магазин не найден'
                              : _storeController.text.trim(),
                          dateLabel: formattedDate,
                          total: _effectiveTotal,
                        ),
                        const SizedBox(height: 14),
                        _ReviewTextField(
                          label: 'Магазин',
                          controller: _storeController,
                          onChanged: (_) {
                            setState(_markManualChange);
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _ReviewTextField(
                                label: 'Итог',
                                controller: _totalController,
                                onChanged: (_) {
                                  setState(_markManualChange);
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _DateButton(
                              label: formattedDate,
                              onPressed: _pickDateTime,
                            ),
                          ],
                        ),
                        if (_receipt.items.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _UseItemsTotalButton(
                            onPressed: _useItemsTotal,
                            total: _itemsTotal,
                          ),
                        ],
                        if (_effectiveWarnings.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _WarningCard(warnings: _effectiveWarnings),
                        ],
                        const SizedBox(height: 16),
                        _SectionTitle(
                          title: 'Категория чека',
                          subtitle: 'Выберите категорию для расхода',
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<CategoriesCubit, CategoriesState>(
                          bloc: getIt<CategoriesCubit>(),
                          builder: (context, state) {
                            if (state is! CategoriesLoaded) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.lightPrimary,
                                  ),
                                ),
                              );
                            }
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.categories.map((category) {
                                final selected =
                                    _selectedCategory?.id == category.id;
                                return _CategoryChoice(
                                  category: category,
                                  selected: selected,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle(
                          title: 'Позиции чека',
                          subtitle: '${_receipt.items.length} позиций',
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(
                          _receipt.items.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ReceiptItemEditorTile(
                              item: _receipt.items[index],
                              onChanged: (value) => _updateItem(index, value),
                              onDelete: () => _removeItem(index),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Добавить позицию'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            foregroundColor: AppColors.white,
                            backgroundColor: AppColors.surface.withOpacity(0.5),
                            side: BorderSide(
                              color: AppColors.primary.withOpacity(0.34),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  title: 'Сохранить чек',
                  onPressed: () {
                    if (_selectedCategory?.id == null) {
                      showMessage(
                        message: 'Выберите категорию для чека.',
                        type: PageState.info,
                      );
                      return;
                    }
                    if (_effectiveTotal <= 0) {
                      showMessage(
                        message: 'Укажите итоговую сумму чека.',
                        type: PageState.info,
                      );
                      return;
                    }

                    Navigator.of(context).pop(
                      ReceiptReviewResult(
                        categoryId: _selectedCategory!.id!,
                        receipt: _buildReceiptForSave(),
                      ),
                    );
                  },
                  gradientColors: const [
                    AppColors.lightPrimary,
                    AppColors.primary,
                    AppColors.primary,
                    AppColors.complementaryBlue,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 46,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.32),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.storeName,
    required this.dateLabel,
    required this.total,
  });

  final String storeName;
  final String dateLabel;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.76),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.92),
                  AppColors.complementaryBlue.withOpacity(0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withOpacity(0.58),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${total.toStringAsFixed(2)} RUB',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTextField extends StatelessWidget {
  const _ReviewTextField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.62),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        cursorColor: AppColors.lightPrimary,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.white.withOpacity(0.48),
          ),
          floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.lightPrimary,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 52,
      child: Material(
        color: AppColors.surface.withOpacity(0.62),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Tooltip(
            message: label,
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.lightPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _UseItemsTotalButton extends StatelessWidget {
  const _UseItemsTotalButton({
    required this.onPressed,
    required this.total,
  });

  final VoidCallback onPressed;
  final double total;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.functions_rounded, size: 18),
      label: Text('Взять сумму позиций: ${total.toStringAsFixed(2)} RUB'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.white.withOpacity(0.52),
          ),
        ),
      ],
    );
  }
}

class _CategoryChoice extends StatelessWidget {
  const _CategoryChoice({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final CategoryModel category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = hexToColor(category.color ?? '');
    final icon = category.icon ?? '';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? color.withOpacity(0.78)
                : AppColors.primary.withOpacity(0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon.isNotEmpty) ...[
              SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category.name ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white.withOpacity(selected ? 0.95 : 0.78),
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.checkStatus.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.checkStatus.withOpacity(0.42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.checkStatus,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: warnings
                  .map((warning) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          warning,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.86),
                                height: 1.18,
                              ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
