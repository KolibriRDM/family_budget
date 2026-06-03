import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:rxdart/rxdart.dart';

import '../styles/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    required this.textController,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.color = Colors.transparent,
    this.onChange,
    this.onComplete,
    this.onTap,
    this.formKey,
    this.maxLines = 1,
    this.readOnly = false,
    this.enableFocus = false,
    this.suffix,
    this.prefix,
    this.width,
    this.height,
    this.radius = 6,
    this.textLength,
    this.textInputFormatter,
    this.obscureText,
    this.autofillHints,
    this.textInputAction,
    this.padding,
    this.onTapOutside,
    this.hintStyle,
    required this.colorBorder,
    this.textInputType,
    this.inputFormatter,
  }) : super(key: key);

  final TextStyle? hintStyle;
  final TextEditingController textController;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final Color? color;
  final Function(String)? onChange;
  final Function()? onComplete;
  final Function()? onTap;
  final Function()? onTapOutside;
  final GlobalKey<FormState>? formKey;
  final bool readOnly;
  final bool enableFocus;
  final int maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final double? width;
  final double? height;
  final double radius;
  final double? padding;
  final Color colorBorder;
  final int? textLength;
  final TextInputFormatter? textInputFormatter;
  final bool? obscureText;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextInputFormatter? inputFormatter;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? (widget.maxLines * 24 + 20),
          alignment: Alignment.center,
          width: widget.width,
          padding: EdgeInsets.only(
            right: widget.suffix == null ? 12 : 0,
            left: widget.prefix == null ? 12 : 0,
            top: widget.padding ?? 0,
            bottom: (widget.padding ?? 0) + 4,
          ),
          decoration: BoxDecoration(
            color: widget.color ?? Colors.black,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              width: 1,
              color: widget.colorBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSecondary.withOpacity(0.9),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextFormField(
            cursorColor: AppColors.primary,
            controller: widget.textController,
            focusNode: widget.focusNode,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.secondary,
            ),
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            keyboardType: widget.textInputType,
            inputFormatters: [
              if (widget.inputFormatter != null) widget.inputFormatter!,
              if (widget.textInputFormatter != null) widget.textInputFormatter!,
              if (widget.textLength != null)
                LengthLimitingTextInputFormatter(widget.textLength!),
            ],
            onChanged: widget.onChange,
            onEditingComplete: widget.onComplete,
            obscureText: widget.obscureText ?? false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
            ),
          ),
        ),
      ],
    );
  }
}
