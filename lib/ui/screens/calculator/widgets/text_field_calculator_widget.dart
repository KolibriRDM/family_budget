import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCalculatorWidget extends StatelessWidget {
  const TextFieldCalculatorWidget({
    super.key,
    required this.borderColor,
    this.readOnly = false,
    required this.controller,
    this.onChanged,
  });

  final Color borderColor;
  final bool readOnly;
  final TextEditingController controller;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: borderColor));
    return Flexible(
      child: TextField(
        readOnly: readOnly,
        textAlign: TextAlign.center,
        controller: controller,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.secondary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*[.,]?\d*$')),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border,
        ),
        onChanged: (_) => onChanged?.call(),
      ),
    );
  }
}
