import 'package:family_budget/data/domain/common_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin StateSaverMixin<TEvent, TState> on Bloc<TEvent, TState> {
  late TState oldState;

  bool Function(TState state)? additionalFilter;

  @override
  void emit(TState state) {
    bool shouldSave = true;

    if (state is LoadingState || state is InfoState) {
      shouldSave = false;
    }

    if (additionalFilter != null) {
      shouldSave = shouldSave && additionalFilter!(state);
    }

    if (shouldSave) {
      oldState = state;
    }

    super.emit(state);
  }
}
