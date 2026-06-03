import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/widgets/app_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

void showMessage({
  required String message,
  required PageState type,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: kIsWeb ? ToastGravity.TOP_RIGHT : ToastGravity.TOP,
    timeInSecForIosWeb: 3,
    backgroundColor: getMessageColor(type),
    textColor: Colors.white,
    fontSize: 16,
    webBgColor: getMessageHexColor(type),
  );
}

Color getMessageColor(PageState type) {
  switch (type) {
    case PageState.error:
      return Colors.red;
    case PageState.success:
      return Colors.green;
    case PageState.info:
      return Colors.blue;
    default:
      return Colors.red;
  }
}

String getMessageHexColor(PageState type) {
  switch (type) {
    case PageState.error:
      return 'linear-gradient(to right, #ff0000, #ff5050)';
    case PageState.success:
      return "linear-gradient(to right, #00b09b, #96c93d)";
    case PageState.info:
      return 'linear-gradient(to right, #33ccff, #00ffff)';
    case PageState.load:
    default:
      return 'linear-gradient(to right, #ff0000, #ff0000)';
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  Color barrierColor = Colors.black54,
  double? maxWidth,
  EdgeInsets? padding,
  EdgeInsetsGeometry? margin,
}) {
  return showDialog<T>(
    barrierColor: barrierColor,
    context: context,
    builder: (context) => AppDialog(
      margin: margin,
      padding: padding,
      maxWidth: maxWidth,
      child: child,
      backgroundColor: AppColors.background,
    ),
  );
}

/// Преобразует Color в строку HEX формата #RRGGBB
String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

/// Преобразует строку HEX в Color
Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');

  if (hex.length == 6) {
    hex = 'FF$hex';
  }

  return Color(int.parse(hex, radix: 16));
}

// Метод для определения цвета иконки по цвету фона
Color getIconColor(Color backgroundColor) {
  final hslColor = HSLColor.fromColor(backgroundColor);
  return hslColor.lightness > 0.7 ? Colors.black : Colors.white;
}

getRequestFormatDate(DateTime date) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
}

LangEnum getLang(String value) {
  return switch (value) {
    "ru" => LangEnum.ru,
    "en" => LangEnum.en,
    _ => LangEnum.en,
  };
}
