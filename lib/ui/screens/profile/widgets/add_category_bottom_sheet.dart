import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide colorToHex;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:family_budget/gen/strings.g.dart';

void showAddCategoryBottomSheet({
  required BuildContext context,
  required Function(String name, String color, String icon) onCategoryAdded,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (_) => AddCategoryBottomSheet(onCategoryAdded: onCategoryAdded),
  );
}

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key, required this.onCategoryAdded});

  final Function(String name, String color, String icon) onCategoryAdded;

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;
  String _selectedIcon = 'assets/icons/categories/icon_1.svg';
  final _icons = List.generate(
      29, (index) => 'assets/icons/categories/icon_${index + 1}.svg');

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Center(
          child: Text(
            t.profile.enterColor,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ColorPicker(
                pickerColor: _selectedColor,
                onColorChanged: (color) =>
                    setState(() => _selectedColor = color),
                paletteType: PaletteType.hslWithHue,
                enableAlpha: false,
                showLabel: false,
              ),
              AppButton(
                title: t.profile.saveBtn,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 39,
                radius: 10,
                gradientColors: _gradientColors,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validate() {
    if (_nameController.text.isEmpty) {
      showMessage(message: t.profile.enterTitle, type: PageState.info);
      return false;
    }
    return true;
  }

  static const _gradientColors = [
    AppColors.complementaryBlue,
    AppColors.primary,
    AppColors.primary,
    AppColors.complementaryBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _buildHeader(theme),
              const SizedBox(height: 14),
              _buildColorIconSelector(),
              const SizedBox(height: 14),
              _buildNameField(theme),
              const SizedBox(height: 16),
              Expanded(child: _buildIconsGrid()),
              const SizedBox(height: 12),
              SizedBox(width: 200, child: _buildAddButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30, height: 30),
        Text(
          t.profile.newCategory,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surface,
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.white.withOpacity(0.72),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorIconSelector() {
    return GestureDetector(
      onTap: _pickColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.74),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _selectedColor.withOpacity(0.42)),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: SvgPicture.asset(
                  _selectedIcon,
                  colorFilter: ColorFilter.mode(
                    _selectedColor,
                    BlendMode.srcIn,
                  ),
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.profile.enterColor,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.profile.enterTitleHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.58),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedColor,
                border: Border.all(color: AppColors.white.withOpacity(0.32)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.24)),
      ),
      child: TextField(
        controller: _nameController,
        cursorColor: AppColors.lightPrimary,
        maxLength: 30,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: t.profile.enterTitleHint,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.white.withOpacity(0.42),
            fontWeight: FontWeight.w400,
          ),
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildIconsGrid() {
    return GridView.builder(
      itemCount: _icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      itemBuilder: (_, index) {
        final icon = _icons[index];
        final isSelected = _selectedIcon == icon;
        return InkWell(
          onTap: () => setState(() => _selectedIcon = icon),
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isSelected
                  ? _selectedColor.withOpacity(0.18)
                  : AppColors.surface.withOpacity(0.72),
              border: Border.all(
                color: isSelected
                    ? _selectedColor.withOpacity(0.86)
                    : AppColors.primary.withOpacity(0.12),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 25,
                height: 25,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? _selectedColor
                      : AppColors.white.withOpacity(0.72),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return AppButton(
      title: t.profile.saveBtn,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 39,
      radius: 12,
      gradientColors: _gradientColors,
      onPressed: () {
        if (_validate()) {
          widget.onCategoryAdded(
            _nameController.text,
            colorToHex(_selectedColor),
            _selectedIcon,
          );
          Navigator.pop(context);
        }
      },
    );
  }
}
