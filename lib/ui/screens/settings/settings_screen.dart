import 'package:auto_route/auto_route.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/services/notification_service.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ru';

  Future<void> _handleNotificationPermission(bool value) async {
    if (value) {
      final notificationService = NotificationService();
      final hasPermission = await notificationService.requestPermission();
      setState(() => _notificationsEnabled = hasPermission);
    } else {
      setState(() => _notificationsEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedLanguage = TranslationProvider.of(context).locale.languageCode;

    return Builder(builder: (context) {
      final t = context.t;
      final theme = Theme.of(context);
      return AppScaffold(
        appBar: AppBar(
          title:
              Text(t.settings.settings, style: theme.textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: AppColors.background,
        ),
        statusBarPadding: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.onSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        t.settings.notification,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                      trailing: CupertinoSwitch(
                        value: _notificationsEnabled,
                        onChanged: _handleNotificationPermission,
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.background),
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: AppColors.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          t.settings.language,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.background,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          initialValue: _selectedLanguage,
                          onSelected: (String value) async {
                            await getIt<Preferences>().saveLocale(value);
                            if (mounted) {
                              setState(() => _selectedLanguage = value);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'ru',
                              child: Text(
                                t.settings.russian,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'en',
                              child: Text(
                                t.settings.english,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedLanguage == 'ru'
                                    ? t.settings.russian
                                    : t.settings.english,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.background,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
