import 'package:family_budget/data/models/receipt_item_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceiptItemEditorTile extends StatefulWidget {
  const ReceiptItemEditorTile({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
  });

  final ReceiptItemModel item;
  final ValueChanged<ReceiptItemModel> onChanged;
  final VoidCallback onDelete;

  @override
  State<ReceiptItemEditorTile> createState() => _ReceiptItemEditorTileState();
}

class _ReceiptItemEditorTileState extends State<ReceiptItemEditorTile> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _lineTotalController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    _unitPriceController =
        TextEditingController(text: widget.item.unitPrice?.toString() ?? '');
    _lineTotalController =
        TextEditingController(text: widget.item.lineTotal.toString());
  }

  @override
  void didUpdateWidget(covariant ReceiptItemEditorTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item == widget.item) return;

    _setControllerText(_nameController, widget.item.name);
    _setControllerText(_quantityController, widget.item.quantity.toString());
    _setControllerText(
      _unitPriceController,
      widget.item.unitPrice?.toString() ?? '',
    );
    _setControllerText(_lineTotalController, widget.item.lineTotal.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _lineTotalController.dispose();
    super.dispose();
  }

  void _setControllerText(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _emit() {
    widget.onChanged(
      widget.item.copyWith(
        name: _nameController.text.trim(),
        quantity:
            double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 1,
        unitPrice: _unitPriceController.text.trim().isEmpty
            ? null
            : double.tryParse(_unitPriceController.text.replaceAll(',', '.')),
        lineTotal:
            double.tryParse(_lineTotalController.text.replaceAll(',', '.')) ??
                0,
        isManuallyCorrected: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  onChanged: (_) => _emit(),
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.white),
                  decoration: const InputDecoration(
                    hintText: 'Название позиции',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon:
                    const Icon(Icons.delete_outline, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _NumericField(
                  controller: _quantityController,
                  label: 'Кол-во',
                  onChanged: _emit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumericField(
                  controller: _unitPriceController,
                  label: 'Цена',
                  onChanged: _emit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumericField(
                  controller: _lineTotalController,
                  label: 'Сумма',
                  onChanged: _emit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*[.,]?\d*$')),
      ],
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.secondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary),
        ),
      ),
    );
  }
}
