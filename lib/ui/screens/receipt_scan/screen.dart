import 'dart:io';

import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/domain/receipt_qr_data.dart';
import 'package:family_budget/data/models/receipt_model.dart';
import 'package:family_budget/data/repositories/expense_repository.dart';
import 'package:family_budget/data/services/receipt_ocr_service.dart';
import 'package:family_budget/data/services/receipt_parser_service.dart';
import 'package:family_budget/data/services/receipt_qr_parser_service.dart';
import 'package:family_budget/data/services/receipt_qr_scanner_service.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:family_budget/ui/screens/receipt_scan/widgets/receipt_review_bottom_sheet.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen> {
  final ImagePicker _picker = ImagePicker();
  final ReceiptOcrService _ocrService = ReceiptOcrService();
  final ReceiptQrScannerService _qrScannerService = ReceiptQrScannerService();
  final ReceiptQrParserService _qrParserService = ReceiptQrParserService();
  final ReceiptParserService _parserService = ReceiptParserService();

  bool _isProcessing = false;
  String? _selectedImagePath;

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      if (file == null) return;

      setState(() {
        _selectedImagePath = file.path;
        _isProcessing = true;
      });

      String? qrRawValue;
      ReceiptQrData? qrData;
      ReceiptModel? providerReceipt;
      var qrFailed = false;
      var providerFailed = false;
      var providerAttempted = false;
      var ocrFailed = false;

      try {
        qrRawValue = await _qrScannerService.recognizeQr(file.path);
        qrData = _qrParserService.parse(qrRawValue);
      } on PlatformException {
        qrFailed = true;
      } catch (_) {
        qrFailed = true;
      }

      var rawText = '';
      try {
        rawText = await _ocrService.recognizeText(file.path);
      } catch (_) {
        ocrFailed = true;
      }

      final result = _parserService.parse(rawText, imagePath: file.path);
      if (qrRawValue != null && qrRawValue.trim().isNotEmpty) {
        providerAttempted = true;
        try {
          providerReceipt = await getIt<ExpenseRepository>()
              .resolveReceiptByQr(qrRawValue.trim());
        } catch (_) {
          providerFailed = true;
          providerReceipt = null;
        }
      }

      final mergedReceipt = _buildEffectiveReceipt(
        parsedReceipt: result.receipt,
        providerReceipt: providerReceipt,
        qrData: qrData,
        imagePath: file.path,
        rawText: rawText,
      );
      final warnings = _buildWarnings(
        parserWarnings: result.warnings,
        qrFailed: qrFailed,
        qrData: qrData,
        providerAttempted: providerAttempted,
        providerFailed: providerFailed,
        providerReceipt: providerReceipt,
        ocrFailed: ocrFailed,
        rawText: rawText,
      );

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      final reviewResult = await showModalBottomSheet<ReceiptReviewResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ReceiptReviewBottomSheet(
          initialReceipt: mergedReceipt,
          warnings: warnings,
        ),
      );

      if (reviewResult == null || !mounted) return;
      context.read<ProfileBloc>().add(
            ProfileAddReceiptExpenseEvent(
              totalCount: reviewResult.receipt.totalAmount,
              categoryId: reviewResult.categoryId,
              date: reviewResult.receipt.receiptDateTime ?? DateTime.now(),
              receipt: reviewResult.receipt,
            ),
          );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      showMessage(
        message: t.receiptScan.processError,
        type: PageState.error,
      );
    }
  }

  ReceiptModel _mergeReceiptWithQr(
    ReceiptModel parsedReceipt,
    ReceiptQrData? qrData,
  ) {
    if (qrData == null) {
      return parsedReceipt;
    }

    return parsedReceipt.copyWith(
      receiptDateTime: qrData.receiptDateTime ?? parsedReceipt.receiptDateTime,
      totalAmount: qrData.totalAmount ?? parsedReceipt.totalAmount,
      rawText: parsedReceipt.rawText,
    );
  }

  ReceiptModel _buildEffectiveReceipt({
    required ReceiptModel parsedReceipt,
    required ReceiptModel? providerReceipt,
    required ReceiptQrData? qrData,
    required String imagePath,
    required String rawText,
  }) {
    if (providerReceipt == null || providerReceipt.items.isEmpty) {
      final receipt = _mergeReceiptWithQr(parsedReceipt, qrData);
      return receipt.copyWith(
        imagePath: imagePath,
        rawText: rawText,
        isPartiallyRecognized: true,
      );
    }

    return providerReceipt.copyWith(
      imagePath: imagePath,
      rawText: rawText,
      totalAmount: providerReceipt.totalAmount == 0
          ? (qrData?.totalAmount ?? parsedReceipt.totalAmount)
          : providerReceipt.totalAmount,
      receiptDateTime: providerReceipt.receiptDateTime ??
          qrData?.receiptDateTime ??
          parsedReceipt.receiptDateTime,
      storeName: providerReceipt.storeName ?? parsedReceipt.storeName,
      isPartiallyRecognized: false,
    );
  }

  List<String> _buildWarnings({
    required List<String> parserWarnings,
    required bool qrFailed,
    required ReceiptQrData? qrData,
    required bool providerAttempted,
    required bool providerFailed,
    required ReceiptModel? providerReceipt,
    required bool ocrFailed,
    required String rawText,
  }) {
    final warnings = <String>[];

    if (providerReceipt == null || providerReceipt.items.isEmpty) {
      warnings.addAll(parserWarnings);
    }

    if (providerReceipt == null || providerReceipt.items.isEmpty) {
      if (ocrFailed) {
        warnings.add(
          'OCR не смог обработать изображение. Открыт ручной черновик чека.',
        );
      } else if (rawText.trim().isEmpty) {
        warnings.add(
          'На фото не найден читаемый текст. Проверьте чек вручную.',
        );
      }
    }

    if (qrFailed) {
      warnings.add(
        t.receiptScan.qrTemporaryFailed,
      );
    } else if (qrData == null) {
      warnings.add(
        t.receiptScan.qrNotRead,
      );
    } else if (providerFailed) {
      // Локальный разбор уже показан пользователю; техническая причина
      // недоступности провайдера не помогает при проверке чека.
    } else if (providerAttempted &&
        (providerReceipt == null || providerReceipt.items.isEmpty)) {
      warnings.add(
        t.receiptScan.qrItemsNotLoaded,
      );
    }

    return warnings.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = context.t.receiptScan;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () =>
              context.read<ProfileBloc>().add(const ProfileInitialEvent()),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(tt.title, style: theme.textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          children: [
            Expanded(child: _buildScanCard(theme, tt)),
            const SizedBox(height: 14),
            AppButton(
              title: tt.scanCamera,
              onPressed: () => _pickReceipt(ImageSource.camera),
              gradientColors: const [
                AppColors.lightPrimary,
                AppColors.primary,
                AppColors.primary,
                AppColors.complementaryBlue,
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _pickReceipt(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined, size: 20),
              label: Text(tt.choosePhoto),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppColors.surface.withOpacity(0.58),
                side: BorderSide(color: AppColors.primary.withOpacity(0.38)),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCard(ThemeData theme, dynamic tt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.74),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.document_scanner_outlined,
                  color: AppColors.lightPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Фото чека',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'OCR + QR с ручной проверкой',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.58),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.complementaryBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.complementaryBlue.withOpacity(0.35),
                  ),
                ),
                child: Text(
                  _selectedImagePath == null ? 'готово' : 'выбрано',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withOpacity(0.82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(child: _buildPreviewArea(theme, tt)),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(ThemeData theme, dynamic tt) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.72),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
          ),
          if (_selectedImagePath != null)
            Image.file(
              File(_selectedImagePath!),
              fit: BoxFit.cover,
            ),
          if (_selectedImagePath == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.82),
                            AppColors.complementaryBlue.withOpacity(0.82),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        size: 38,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tt.cameraHint,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.86),
                        height: 1.18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 18,
            top: 18,
            child: _buildGuideCorner(top: true, left: true),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: _buildGuideCorner(top: true, left: false),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: _buildGuideCorner(top: false, left: true),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: _buildGuideCorner(top: false, left: false),
          ),
          if (_isProcessing)
            Container(
              color: AppColors.black.withOpacity(0.54),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.white),
                    const SizedBox(height: 14),
                    Text(
                      tt.processing,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGuideCorner({required bool top, required bool left}) {
    final side = BorderSide(
      color: AppColors.white.withOpacity(0.74),
      width: 2,
    );
    return SizedBox(
      width: 34,
      height: 34,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: top ? side : BorderSide.none,
            bottom: top ? BorderSide.none : side,
            left: left ? side : BorderSide.none,
            right: left ? BorderSide.none : side,
          ),
        ),
      ),
    );
  }
}
