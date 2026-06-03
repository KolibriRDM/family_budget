import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formats {
  static final phoneFormat = MaskTextInputFormatter(
    mask: '+# (###) ### ## ##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
}

String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$";

final RegExp emailRegex = RegExp(pattern);

RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

DateFormat inputDateFormat = DateFormat('dd-MM-yyyy hh:mm:ss a');
