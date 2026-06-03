import 'package:bloc/bloc.dart';
import 'package:family_budget/data/repositories/currency_repository.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/mixins/error_handler_mixin.dart';
import 'package:family_budget/helpers/mixins/state_saver_mixin.dart';
import 'package:injectable/injectable.dart';

part 'calc_event.dart';

part 'calc_state.dart';

@injectable
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState>
    with
        ErrorHandlerMixin<CalculatorEvent, CalculatorState>,
        StateSaverMixin<CalculatorEvent, CalculatorState> {
  CalculatorBloc(this._currencyRepo) : super(CalculatorLoadingState()) {
    oldState = CalculatorLoadingState();
    on<CalculatorInitEvent>(_onInitialEvent);
    on<CalculateEvent>(_onCalculateEvent);
  }

  final CurrencyRepository _currencyRepo;

  Future<void> _onInitialEvent(
      CalculatorInitEvent event, Emitter<CalculatorState> emit) async {
    emit(CalculatorInitState());
  }

  Future<void> _onCalculateEvent(
      CalculateEvent event, Emitter<CalculatorState> emit) async {
    emit(CalculatorLoadingState());
    try {
      final conv = await _currencyRepo.getRate(
          event.count, event.first.value, event.second.value);
      final answer = double.parse(conv.result.toStringAsFixed(2));
      emit(CalculatorInitState(
        first: event.first,
        second: event.second,
        count: event.count,
        answer: answer,
        searchText: event.searchText,
      ));
    } catch (ex) {
      emitError(emit, ex);
      emit(oldState);
    }
  }

  @override
  CalculatorState createErrorState(
      {required String message, required PageState pageState}) {
    return CalculatorInfoState(message: message, pageState: pageState);
  }
}
