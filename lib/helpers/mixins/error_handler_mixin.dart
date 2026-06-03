import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:family_budget/helpers/enums.dart';

mixin ErrorHandlerMixin<Event, State> on Bloc<Event, State> {
  void emitError(Emitter<State> emit, dynamic ex) {
    final error = ex;
    final errorState = createErrorState(
      message: error is DioException
          ? error.response?.data?.toString() ?? error.toString()
          : error.toString(),
      pageState: PageState.error,
    );
    emit(errorState);
  }

  State createErrorState({
    required String message,
    required PageState pageState,
  });
}
