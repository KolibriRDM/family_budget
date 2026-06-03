import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  int _previousIndex = 0;

  int get previousIndex => _previousIndex;

  void updateIndex(int index) {
    _previousIndex = state;
    emit(index);
  }

  void getDiagram() => emit(0);

  void getCalculator() => emit(1);

  void getDebtLoad() => emit(2);

  void getProfile() => emit(3);
}
