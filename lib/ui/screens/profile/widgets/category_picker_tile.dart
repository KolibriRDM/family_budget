import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryPickerTile extends StatelessWidget {
  const CategoryPickerTile({
    super.key,
    required this.title,
    required this.accentColor,
    required this.onTap,
    this.iconAsset,
    this.isSelected = false,
    this.isNew = false,
    this.onLongPress,
  });

  final String title;
  final Color accentColor;
  final String? iconAsset;
  final bool isSelected;
  final bool isNew;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withOpacity(0.18)
                : AppColors.surface.withOpacity(0.74),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? accentColor.withOpacity(0.82)
                  : AppColors.primary.withOpacity(0.16),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(isNew ? 0.12 : 0.18),
                  borderRadius: BorderRadius.circular(13),
                  border: isNew
                      ? Border.all(color: accentColor.withOpacity(0.55))
                      : null,
                ),
                child: Center(
                  child: isNew || iconAsset == null || iconAsset!.isEmpty
                      ? Icon(
                          isNew
                              ? Icons.add_rounded
                              : Icons.category_rounded,
                          color: accentColor,
                          size: 24,
                        )
                      : SvgPicture.asset(
                          iconAsset!,
                          width: 23,
                          height: 23,
                          colorFilter: ColorFilter.mode(
                            accentColor,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.white.withOpacity(0.78),
                  fontSize: 11.5,
                  height: 1.05,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
