import 'package:family_budget/data/domain/receipt_parse_result.dart';
import 'package:family_budget/data/models/receipt_item_model.dart';
import 'package:family_budget/data/models/receipt_model.dart';

class _AmountMatch {
  const _AmountMatch({
    required this.raw,
    required this.value,
  });

  final String raw;
  final double value;
}

class ReceiptParserService {
  static final RegExp _moneyPattern = RegExp(
    r'(?:^|[^\d])(\d{1,7}(?:[.,-]\s?\d{1,2}|\s+\d{2}))(?!\d)',
  );

  ReceiptParseResult parse(
    String rawText, {
    String? imagePath,
  }) {
    final normalizedText = rawText.replaceAll('\r', '');
    final lines = normalizedText
        .split('\n')
        .map(_normalizeLine)
        .where((line) => line.isNotEmpty)
        .toList();

    final warnings = <String>[];
    final storeName = _extractStoreName(lines);
    final receiptDateTime = _extractDateTime(lines);
    final totalAmount = _extractTotal(lines);
    final items = _extractItems(lines);

    if (lines.isEmpty) {
      warnings.add(
          'Текст чека не распознан. Заполните сумму и позиции вручную.');
    }

    if (storeName == null) {
      warnings.add('Название магазина не найдено.');
    }

    if (receiptDateTime == null) {
      warnings.add('Дата чека не найдена.');
    }

    var effectiveTotal = totalAmount ?? 0;
    if (effectiveTotal == 0 && items.isNotEmpty) {
      effectiveTotal =
          items.fold<double>(0, (sum, item) => sum + item.lineTotal);
      warnings.add('Итог чека не найден, использована сумма позиций.');
    } else if (effectiveTotal == 0) {
      warnings.add('Итог чека не найден.');
    }

    if (items.isEmpty) {
      warnings.add(
          'Не удалось уверенно распознать позиции. Проверьте чек вручную.');
    }

    final itemsTotal =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    if (effectiveTotal > 0 &&
        items.isNotEmpty &&
        (itemsTotal - effectiveTotal).abs() > 0.5) {
      warnings.add('Сумма позиций отличается от итога чека.');
    }

    return ReceiptParseResult(
      receipt: ReceiptModel(
        storeName: storeName,
        receiptDateTime: receiptDateTime,
        totalAmount: effectiveTotal,
        rawText: normalizedText,
        imagePath: imagePath,
        isPartiallyRecognized: warnings.isNotEmpty,
        items: items,
      ),
      warnings: warnings,
    );
  }

  String? _extractStoreName(List<String> lines) {
    for (final line in lines.take(5)) {
      final cleaned = _normalizeStoreName(line);
      if (cleaned.length < 3) continue;
      if (_isServiceLine(cleaned)) continue;
      return cleaned;
    }
    return null;
  }

  DateTime? _extractDateTime(List<String> lines) {
    final patterns = [
      RegExp(r'(\d{2})[./-](\d{2})[./-](\d{4})\s+(\d{2}):(\d{2})(?::(\d{2}))?'),
      RegExp(r'(\d{2})[./-](\d{2})[./-](\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?'),
      RegExp(r'(\d{4})[./-](\d{2})[./-](\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?'),
    ];

    for (final line in lines) {
      for (final pattern in patterns) {
        final match = pattern.firstMatch(line);
        if (match == null) continue;
        if (pattern.pattern.startsWith(r'(\d{2})')) {
          final yearGroup = int.parse(match.group(3)!);
          final year = yearGroup < 100 ? 2000 + yearGroup : yearGroup;
          return DateTime(
            year,
            int.parse(match.group(2)!),
            int.parse(match.group(1)!),
            int.parse(match.group(4)!),
            int.parse(match.group(5)!),
            int.tryParse(match.group(6) ?? '') ?? 0,
          );
        }
        return DateTime(
          int.parse(match.group(1)!),
          int.parse(match.group(2)!),
          int.parse(match.group(3)!),
          int.parse(match.group(4)!),
          int.parse(match.group(5)!),
          int.tryParse(match.group(6) ?? '') ?? 0,
        );
      }
    }
    return null;
  }

  double? _extractTotal(List<String> lines) {
    final totalPattern = RegExp(
      r'(ИТОГ|ИТОГО|СУММА|К ОПЛАТЕ|ВСЕГО)\s*[:=\-]?\s*(\d{1,7}(?:[.,-]\s?\d{1,2}|\s+\d{2}))',
      caseSensitive: false,
    );

    for (var index = lines.length - 1; index >= 0; index--) {
      final line = lines[index];
      final match = totalPattern.firstMatch(line);
      if (match != null) {
        return _parseDouble(match.group(2)!);
      }

      final upper = line.toUpperCase();
      if (!_isTotalMarkerLine(upper)) continue;

      final inlineAmounts = _extractAmounts(line);
      if (inlineAmounts.isNotEmpty) {
        return inlineAmounts.last.value;
      }

      for (var offset = 1;
          offset <= 2 && index + offset < lines.length;
          offset++) {
        final candidate = lines[index + offset];
        final candidateAmounts = _extractAmounts(candidate);
        if (candidateAmounts.isEmpty) continue;
        return candidateAmounts.last.value;
      }
    }

    return null;
  }

  List<ReceiptItemModel> _extractItems(List<String> lines) {
    final items = <ReceiptItemModel>[];
    final sectionLines = _extractItemSection(lines);

    for (var index = 0; index < sectionLines.length; index++) {
      final line = _stripHeaderTokens(sectionLines[index]);
      final upper = line.toUpperCase();
      if (line.isEmpty) continue;
      if (_isServiceLine(upper)) continue;

      final weightedMatch = RegExp(
        r'^(.+?)\s+(\d+[.,]\d{1,3})\s*[XxХ*х]\s*(\d+[.,]\d{1,2})\s+(\d+[.,]\d{1,2})$',
      ).firstMatch(line);
      if (weightedMatch != null) {
        items.add(
          ReceiptItemModel(
            name: weightedMatch.group(1)!.trim(),
            quantity: _parseDouble(weightedMatch.group(2)!),
            unitPrice: _parseDouble(weightedMatch.group(3)!),
            lineTotal: _parseDouble(weightedMatch.group(4)!),
          ),
        );
        continue;
      }

      final inlineAmounts = _extractAmounts(line);
      if (_looksLikeItemLine(line, inlineAmounts)) {
        final name = _stripMoneyAndUnits(line);
        if (_hasMeaningfulName(name)) {
          items.add(
            ReceiptItemModel(
              name: name,
              quantity: _extractQuantity(line) ?? 1,
              unitPrice: _extractUnitPrice(line, inlineAmounts),
              lineTotal: inlineAmounts.last.value,
            ),
          );
          continue;
        }
      }

      if (_looksLikeNameOnlyLine(line) && index + 1 < sectionLines.length) {
        final numericWindow = <String>[];
        for (var offset = 1;
            offset <= 5 && index + offset < sectionLines.length;
            offset++) {
          final candidate = sectionLines[index + offset];
          if (_looksLikeNameOnlyLine(candidate)) break;
          if (_isServiceLine(candidate.toUpperCase()) ||
              _isHeaderLine(candidate.toUpperCase()) ||
              _isDateLikeLine(candidate)) {
            break;
          }
          numericWindow.add(candidate);
        }

        final joinedWindow = numericWindow.join(' ');
        final windowAmounts = _extractAmounts(joinedWindow);
        if (windowAmounts.isNotEmpty) {
          items.add(
            ReceiptItemModel(
              name: line,
              quantity: _extractQuantity(joinedWindow) ?? 1,
              unitPrice: _extractUnitPrice(joinedWindow, windowAmounts),
              lineTotal: windowAmounts.last.value,
            ),
          );
          continue;
        }
      }

      final simpleMatch =
          RegExp(r'^(.+?)\s+(\d+[.,]\d{1,2})$').firstMatch(line);
      if (simpleMatch != null) {
        final name = simpleMatch.group(1)!.trim();
        if (name.length < 2 || !_hasMeaningfulName(name)) continue;
        items.add(
          ReceiptItemModel(
            name: name,
            quantity: 1,
            lineTotal: _parseDouble(simpleMatch.group(2)!),
          ),
        );
      }
    }

    return items;
  }

  List<String> _extractItemSection(List<String> lines) {
    final section = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final upper = lines[i].toUpperCase();
      if (_isHeaderLine(upper)) {
        section.add(lines[i]);
        continue;
      }
      if (_isTotalsBoundaryLine(upper)) break;
      section.add(lines[i]);
    }
    return section;
  }

  bool _isServiceLine(String value) {
    const serviceWords = [
      'ИТОГ',
      'ИТОГО',
      'К ОПЛАТЕ',
      'СУММА',
      'СПАСИБО',
      'КАССИР',
      'СДАЧА',
      'НАЛИЧНЫМИ',
      'БЕЗНАЛ',
      'КАРТА',
      'ПРИХОД',
      'ИНН',
      'ФН',
      'ФД',
      'ФП',
      'РН ККТ',
      'СНО',
      'САЙТ ФНС',
      'МЕСТО РАСЧЕТОВ',
      'МАГАЗИН',
      'АО "ТАНДЕР"',
      'КАССОВЫЙ ЧЕК',
      'ВОЗВРАТ',
      'ЧЕК',
      'ОПЛАТА',
      'ТЕРМИНАЛ',
      'КОМИССИЯ',
      'ДОКУМЕНТ',
      'КАССА',
      'СКИДКА',
      'БОНУС',
    ];

    return serviceWords.any(value.contains);
  }

  bool _isHeaderLine(String value) {
    return value.contains('ЦЕНА') ||
        value.contains('КОЛ-ВО') ||
        value.contains('КОЛВО') ||
        value.contains('КОЛ ВО') ||
        value.contains('КОЛИЧЕСТВО') ||
        value.contains('СТОИМОСТЬ') ||
        value.contains('СКИДКА') ||
        value.contains('СО СКИДКОЙ') ||
        value.contains('МОЯ ЦЕНА');
  }

  bool _isTotalsBoundaryLine(String value) {
    return _isTotalMarkerLine(value) ||
        value.contains('НАЛИЧНЫМИ') ||
        value.contains('БЕЗНАЛИЧ') ||
        value.contains('БЕЗНАЛ') ||
        value.contains('КАРТА') ||
        value.contains('МЕСТО РАСЧЕТОВ') ||
        value.contains('КАССИР') ||
        value.contains('КАССОВЫЙ ЧЕК') ||
        value.contains('ИНН') ||
        value.contains('QR') ||
        value.contains('ФН') ||
        value.contains('ФД') ||
        value.contains('ФП');
  }

  bool _isTotalMarkerLine(String value) {
    return value.contains('ИТОГ') ||
        value.contains('ИТОГО') ||
        value.contains('К ОПЛАТЕ') ||
        value.contains('СУММА') ||
        value.contains('ВСЕГО');
  }

  bool _looksLikeItemLine(String line, List<_AmountMatch> inlineAmounts) {
    if (inlineAmounts.isEmpty) return false;
    if (!_containsLetters(line)) return false;
    if (_isServiceLine(line.toUpperCase()) ||
        _isHeaderLine(line.toUpperCase()) ||
        _isDateLikeLine(line)) {
      return false;
    }
    if (inlineAmounts.length == 1 &&
        !_endsWithAmount(line.trim())) {
      return false;
    }
    return _hasMeaningfulName(_stripMoneyAndUnits(line));
  }

  bool _looksLikeNameOnlyLine(String line) {
    final upper = line.toUpperCase();
    if (_isServiceLine(upper) || _isHeaderLine(upper)) return false;
    if (_isDateLikeLine(line)) return false;
    if (RegExp(r'^\d+[.,]\d{1,2}$').hasMatch(line)) return false;
    return _hasMeaningfulName(_stripMoneyAndUnits(line));
  }

  bool _containsLetters(String value) {
    return RegExp(r'[A-Za-zА-Яа-я]').hasMatch(value);
  }

  bool _hasMeaningfulName(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'[/\\]'), ' ')
        .replaceAll(RegExp(r'[^A-Za-zА-Яа-я\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    const ignoredTokens = {
      'ШТ',
      'КГ',
      'Г',
      'Л',
      'ПАК',
      'УПАК',
      'PCS',
      'П',
      'У',
      'В',
    };

    for (final token in cleaned.split(' ')) {
      if (token.length < 3) continue;
      if (ignoredTokens.contains(token.toUpperCase())) continue;
      return true;
    }
    return false;
  }

  bool _isDateLikeLine(String value) {
    return RegExp(r'\d{2}[./-]\d{2}[./-](\d{2}|\d{4})').hasMatch(value) ||
        RegExp(r'\b\d{2}:\d{2}(:\d{2})?\b').hasMatch(value);
  }

  double? _extractUnitPrice(String line, List<_AmountMatch> amounts) {
    if (amounts.length < 2) return null;
    if (_extractQuantity(line) != null) {
      return amounts.first.value;
    }
    return amounts[amounts.length - 2].value;
  }

  double? _extractQuantity(String line) {
    final quantityMatch = RegExp(r'(\d+[.,]?\d*)\s*(ШТ|КГ|Г|Л|ПАК|УПАК|PCS|PC)',
            caseSensitive: false)
        .firstMatch(line);
    if (quantityMatch != null) {
      return _parseDouble(quantityMatch.group(1)!);
    }

    final explicitCountMatch =
        RegExp(r'(\d+[.,]?\d{0,3})\s*[XxХ*х]').firstMatch(line);
    if (explicitCountMatch != null) {
      return _parseDouble(explicitCountMatch.group(1)!);
    }

    final reversedCountMatch =
        RegExp(r'[XxХ*х]\s*(\d+[.,]?\d{0,3})').firstMatch(line);
    if (reversedCountMatch != null) {
      return _parseDouble(reversedCountMatch.group(1)!);
    }

    return null;
  }

  String _stripMoneyAndUnits(String line) {
    return line
        .replaceAll(_moneyPattern, ' ')
        .replaceAll(
            RegExp(r'\b\d+[.,]?\d*\s*(ШТ|КГ|Г|Л|ПАК|УПАК|PCS|PC)\b',
                caseSensitive: false),
            ' ')
        .replaceAll(RegExp(r'[=×]'), ' ')
        .replaceAll(RegExp(r'\b[PXxХ*х]\b'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _stripHeaderTokens(String line) {
    return line
        .replaceAll(RegExp(r'ЦЕНА СО СКИДКОЙ', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'МОЯ ЦЕНА', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'КОЛ-?ВО', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'КОЛИЧЕСТВО', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\bЦЕНА\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\bСТОИМОСТЬ\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\bИТОГ\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _normalizeLine(String line) {
    return line
        .replaceAll('\t', ' ')
        .replaceAll(RegExp(r'[|]'), ' ')
        .replaceAll('×', 'x')
        .replaceAll(RegExp(r'\s*=\s*'), ' = ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _normalizeStoreName(String line) {
    final normalized = _normalizeLine(line);
    if (normalized.isEmpty) return normalized;

    final cyrillicOnly = normalized
        .replaceAll(RegExp(r'[^0-9A-Za-zА-Яа-яЁё\s"«»\-]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (RegExp(r'[А-Яа-яЁё]').hasMatch(cyrillicOnly)) {
      final tokens = cyrillicOnly.split(' ').where((token) {
        final upper = token.toUpperCase();
        if (upper.length <= 2 && !RegExp(r'[А-Яа-яЁё]').hasMatch(token)) {
          return false;
        }
        if (RegExp(r'^[A-Z]{1,3}$').hasMatch(upper)) {
          return false;
        }
        return true;
      }).toList();
      if (tokens.isNotEmpty) {
        return tokens.join(' ');
      }
    }

    return cyrillicOnly;
  }

  double _parseDouble(String input) {
    var normalized = input.trim();
    if (RegExp(r'^\d{1,7}\s+\d{2}$').hasMatch(normalized)) {
      normalized = normalized.replaceFirst(RegExp(r'\s+'), '.');
    } else {
      normalized = normalized.replaceAll(' ', '');
    }

    normalized = normalized
        .replaceAll(',', '.')
        .replaceFirst(RegExp(r'(?<=\d)-(?=\d{1,2}$)'), '.');
    return double.tryParse(normalized) ?? 0;
  }

  List<_AmountMatch> _extractAmounts(String line) {
    return _moneyPattern
        .allMatches(line)
        .map((match) {
          final raw = match.group(1)!;
          return _AmountMatch(raw: raw, value: _parseDouble(raw));
        })
        .where((amount) => amount.value > 0)
        .toList();
  }

  bool _endsWithAmount(String line) {
    final matches = _moneyPattern.allMatches(line).toList();
    if (matches.isEmpty) return false;
    return matches.last.end == line.length;
  }
}
