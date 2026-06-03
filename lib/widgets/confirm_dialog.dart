import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/data/models/income_model.dart';
import 'package:family_budget/data/repositories/user_repository.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_button.dart';

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  required dynamic item,
  String? confirmText,
  String? cancelText,
  List<Color> confirmColors = const [
    AppColors.complementaryBlue,
    AppColors.primary,
    AppColors.primary,
    AppColors.complementaryBlue,
  ],
  List<Color> cancelColors = const [
    AppColors.surface,
    AppColors.surface,
    AppColors.surface,
    AppColors.surface,
  ],
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.subText,
                  ),
            ),
            const SizedBox(height: 12),
            if (item is ExpenseModel || item is IncomeModel)
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: hexToColor(item.category?.color ?? ''),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.category?.icon ?? '',
                        height: 30,
                        width: 30,
                        color: getIconColor(
                            hexToColor(item.category?.color ?? '')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.category?.name}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.totalCount} ${getIt.get<UserRepository>().curUser.currency}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AppButton(
                    title: cancelText ?? t.general.cancelBtn,
                    gradientColors: cancelColors,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    title: confirmText ?? t.profile.deleteBtn,
                    gradientColors: confirmColors,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
