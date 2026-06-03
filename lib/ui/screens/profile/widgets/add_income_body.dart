import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/models/category_model.dart';
import 'package:family_budget/data/models/income_model.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:family_budget/widgets/app_text_field.dart';
import 'package:family_budget/widgets/confirm_dialog.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_budget/gen/strings.g.dart';

import 'add_category_bottom_sheet.dart';
import 'category_picker_tile.dart';

class AddIncomeBody extends StatefulWidget {
  const AddIncomeBody({super.key, this.income});

  final IncomeModel? income;

  @override
  State<AddIncomeBody> createState() => _AddIncomeBodyState();
}

class _AddIncomeBodyState extends State<AddIncomeBody> {
  final _totalCountController = TextEditingController();
  DateTime? _selectedDate;
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      _totalCountController.text = widget.income!.totalCount.toString();
      _selectedDate = widget.income!.date;
      _selectedCategory = widget.income!.category;
    }
  }

  bool _validate() {
    if (_totalCountController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedCategory != null) {
      return true;
    }
    showMessage(message: t.profile.enterParameters, type: PageState.info);
    return false;
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    return pickedDate ?? DateTime.now();
  }

  void _onNewCategory(BuildContext context) {
    showAddCategoryBottomSheet(
      context: context,
      onCategoryAdded: (name, color, icon) =>
          context.read<CategoriesCubit>().addCategory(name, color, icon),
    );
  }

  void _onDeleteCategory(BuildContext context, CategoryModel category) {
    showConfirmDialog(
      context: context,
      title: t.profile.deletingCategory,
      message: '${t.profile.youSureDeleteCategory} "${category.name}"?',
      item: category,
      onConfirm: () =>
          context.read<CategoriesCubit>().deleteCategory(category.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            widget.income != null
                ? t.profile.changeIncomeTitle
                : t.profile.addIncomeTitle,
            style: theme.textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () =>
                context.read<ProfileBloc>().add(const ProfileInitialEvent()),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                textController: _totalCountController,
                colorBorder: AppColors.colorScheme.primary,
                hintText: t.profile.enterAmount,
                textInputType: TextInputType.number,
                textInputFormatter: FilteringTextInputFormatter.allow(
                    RegExp(r'^-?\d*[.,]?\d*$')),
                hintStyle: theme.textTheme.titleSmall
                    ?.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 20),
              _buildDateSelector(theme),
              const SizedBox(height: 20),
              Text(
                t.profile.enterCategory,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildCategoriesGrid(context)),
              const SizedBox(height: 10),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return InkWell(
      onTap: () async {
        _selectedDate = await _selectDate(context);
        setState(() {});
      },
      child: Text(
        _selectedDate?.formatNumberDate ?? t.profile.enterDate,
        style: theme.textTheme.displaySmall
            ?.copyWith(color: AppColors.colorScheme.primary),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) return LoadingGif();
        if (state is CategoriesLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 94,
            ),
            itemCount: state.categories.length + 1,
            itemBuilder: (_, index) => index == 0
                ? _buildNewCategoryButton(context)
                : _buildCategoryItem(
                    context,
                    state.categories[index - 1],
                  ),
          );
        }
        context.read<CategoriesCubit>().loadCategories();
        return LoadingGif();
      },
    );
  }

  Widget _buildNewCategoryButton(BuildContext context) {
    return CategoryPickerTile(
      title: t.profile.newBtn,
      accentColor: AppColors.lightPrimary,
      isNew: true,
      onTap: () => _onNewCategory(context),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel category) {
    final isSelected = _selectedCategory?.id == category.id;
    final color = hexToColor(category.color ?? '');
    return CategoryPickerTile(
      title: category.name ?? '',
      accentColor: color,
      iconAsset: category.icon,
      isSelected: isSelected,
      onTap: () => setState(() => _selectedCategory = category),
      onLongPress: () => _onDeleteCategory(context, category),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return AppButton(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      radius: 10,
      title: widget.income != null ? t.profile.changeBtn : t.profile.addBtn,
      textColor: AppColors.white,
      onPressed: () {
        if (_validate()) {
          if (widget.income == null) {
            context.read<ProfileBloc>().add(
                  ProfileAddIncomeEvent(
                    totalCount:
                        double.tryParse(_totalCountController.text) ?? 0,
                    categoryId: _selectedCategory!.id!,
                    date: _selectedDate!,
                  ),
                );
          } else {
            context.read<ProfileBloc>().add(
                  ProfileEditIncomeEvent(
                    incomeId: widget.income!.id!,
                    categoryId: _selectedCategory!.id!,
                    totalCount:
                        double.tryParse(_totalCountController.text) ?? 0,
                    date: _selectedDate!,
                  ),
                );
          }
        }
      },
      gradientColors: const [
        AppColors.complementaryBlue,
        AppColors.primary,
        AppColors.primary,
        AppColors.complementaryBlue,
      ],
    );
  }
}
