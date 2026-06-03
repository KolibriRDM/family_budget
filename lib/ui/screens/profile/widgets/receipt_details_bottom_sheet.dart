import 'package:family_budget/data/models/receipt_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showReceiptDetailsBottomSheet(
  BuildContext context, {
  required ReceiptModel receipt,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ReceiptDetailsBottomSheet(receipt: receipt),
  );
}

class ReceiptDetailsBottomSheet extends StatelessWidget {
  const ReceiptDetailsBottomSheet({
    super.key,
    required this.receipt,
  });

  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSecondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Text('Расшифровка чека', style: theme.textTheme.displayMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      receipt.storeName ?? 'Магазин не найден',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '${receipt.totalAmount.toStringAsFixed(2)} RUB',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: AppColors.lightPrimary),
                  ),
                ],
              ),
              if (receipt.receiptDateTime != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(receipt.receiptDateTime!),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.secondary),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: receipt.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = receipt.items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.name,
                                style: theme.textTheme.bodyLarge),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.lineTotal.toStringAsFixed(2)} RUB',
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
