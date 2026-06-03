import 'package:family_budget/helpers/enums.dart';

abstract class LoadingState {}

abstract class InfoState {
  String get message;
  PageState get pageState;
}
