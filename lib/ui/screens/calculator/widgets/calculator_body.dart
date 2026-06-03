import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/calculator/bloc/calc_bloc.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:family_budget/widgets/app_text_field.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:family_budget/gen/strings.g.dart';

import 'text_field_calculator_widget.dart';

class CalculatorBody extends StatefulWidget {
  const CalculatorBody({
    super.key,
    this.oldState,
    required this.isLoading,
  });

  final CalculatorInitState? oldState;
  final bool isLoading;

  @override
  State<CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  static const _currencies = Currency.values;

  late final TextEditingController _searchController;
  late final TextEditingController _firstCountController;
  late final TextEditingController _secondCountController;

  List<Currency> _filteredCurrencies = _currencies;
  Currency? _first;
  Currency? _second;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.oldState?.searchText);
    _firstCountController =
        TextEditingController(text: widget.oldState?.count?.toString());
    _secondCountController = TextEditingController(
        text: widget.oldState?.answer?.toString().replaceAll('.', ','));
    _first = widget.oldState?.first;
    _second = widget.oldState?.second;
    _filterCurrencies(widget.oldState?.searchText ?? '');
  }

  @override
  void didUpdateWidget(covariant CalculatorBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.oldState?.answer != widget.oldState?.answer) {
      _secondCountController.text =
          widget.oldState?.answer?.toString().replaceAll('.', ',') ?? '';
    }
  }

  void _filterCurrencies(String value) {
    final query = value.toUpperCase();
    _filteredCurrencies = _currencies
        .where((currency) =>
            currency.value.contains(query) ||
            currency.displayName.toUpperCase().contains(query))
        .toList();
  }

  void _selectCurrency(Currency currency) {
    setState(() {
      if (_first == null && _second != currency) {
        _first = currency;
      } else if (_second == null && _first != currency) {
        _second = currency;
      } else {
        if (_second == currency) {
          _second = null;
        } else if (_first == currency) {
          _first = null;
        }
      }
    });
  }

  void _calculate() {
    final count =
        double.tryParse(_firstCountController.text.replaceAll(',', '.'));
    if (_first != null && _second != null && count != null) {
      context.read<CalculatorBloc>().add(CalculateEvent(
            first: _first!,
            second: _second!,
            count: count,
            searchText: _searchController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppScaffold(
        willPop: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSearchField(theme),
              const SizedBox(height: 20),
              _buildConversionRow(context, theme),
              const SizedBox(height: 20),
              _buildCalculateButton(),
              if (_filteredCurrencies.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildCurrencyList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return AppTextField(
      padding: 4,
      prefix: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SvgPicture.asset('assets/icons/search.svg',
            color: AppColors.button),
      ),
      hintText: t.calculator.search,
      hintStyle: theme.textTheme.titleSmall?.copyWith(
        color: AppColors.colorScheme.primary.withOpacity(0.9),
      ),
      textController: _searchController,
      colorBorder: AppColors.colorScheme.primary,
      onChange: (value) => setState(() => _filterCurrencies(value)),
    );
  }

  Widget _buildConversionRow(BuildContext context, ThemeData theme) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        color: AppColors.onSecondary.withOpacity(0.94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCurrencySelector(
              theme, _first, () => setState(() => _first = null)),
          TextFieldCalculatorWidget(
            borderColor: AppColors.complementaryBlue,
            controller: _firstCountController,
            onChanged: _secondCountController.clear,
          ),
          Text(
            ' = ',
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.secondary,
            ),
          ),
          TextFieldCalculatorWidget(
            borderColor: AppColors.primary,
            controller: _secondCountController,
            readOnly: true,
          ),
          _buildCurrencySelector(
              theme, _second, () => setState(() => _second = null)),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(
      ThemeData theme, Currency? currency, VoidCallback onTap) {
    return SizedBox(
      width: 48,
      child: InkWell(
        onTap: currency != null ? onTap : null,
        child: Center(
          child: Text(
            currency?.value ?? '???',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      height: 40,
      child: AppButton(
        padding: 0,
        gradientColors: const [
          AppColors.complementaryBlue,
          AppColors.primary,
          AppColors.primary,
          AppColors.complementaryBlue,
        ],
        title: widget.isLoading ? '' : t.calculator.calculateBtn,
        isDisabled: widget.isLoading,
        onPressed: _calculate,
        child: widget.isLoading ? LoadingGif() : null,
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: _filteredCurrencies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) =>
            _buildCurrencyItem(_filteredCurrencies[index]),
      ),
    );
  }

  Widget _buildCurrencyItem(Currency currency) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.onSecondary.withOpacity(0.94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _selectCurrency(currency),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _first == currency
                        ? AppColors.complementaryBlue
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(currency.value,
                    style: const TextStyle(color: AppColors.background)),
                const SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Text(
                    currency.displayName,
                    style: const TextStyle(color: AppColors.background),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Container(
              width: 10,
              height: 30,
              decoration: BoxDecoration(
                color: _second == currency
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
