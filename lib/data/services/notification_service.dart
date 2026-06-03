import 'package:flutter/foundation.dart';
import 'package:family_budget/data/models/default_reminder_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> requestPermission() async {
    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      final granted = await platform.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlatform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlatform != null) {
      final result = await iosPlatform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }

    return false;
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Пример уведомления',
      'Это текст уведомления',
      details,
      payload: 'Тестовый payload',
    );
  }

  Future<void> setupDefaultReminders() async {
    final List<DefaultReminderModel> reminders = [
      DefaultReminderModel(
        id: 1,
        title: 'Проверь свои расходы!',
        description: 'Проверь свои расходы за неделю.',
        date: DateTime.now().add(const Duration(days: 7)),
        isRecurring: true,
      ),
      DefaultReminderModel(
        id: 2,
        title: 'Не забудь про зарплату!',
        description: 'Проверь поступление зарплаты.',
        date: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
        isRecurring: false,
      ),
    ];

    for (var reminder in reminders) {
      await scheduleDefaultReminder(reminder);
    }
  }

  Future<void> scheduleDefaultReminder(DefaultReminderModel reminder) async {
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(reminder.date, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id,
      reminder.title,
      reminder.description,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Автоматические напоминания',
          channelDescription: 'Напоминания по умолчанию',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          reminder.isRecurring ? DateTimeComponents.dayOfMonthAndTime : null,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> setupRecurringReminders() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      'Проверь баланс!',
      'Не забудь проверить свои доходы и расходы.',
      _nextInstanceOfWeeklyTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recurring_channel',
          'Регулярные напоминания',
          channelDescription: 'Напоминания о проверке баланса',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfWeeklyTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 9); // 9:00 AM

    // Если текущее время после 9:00, добавляем день
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Ищем следующий понедельник
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Отправляет уведомление с напоминанием подсчитать расходы через 10 секунд
  Future<void> sendDelayedReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Напоминания',
      channelDescription: 'Канал для напоминаний о расходах',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Напоминание',
      'Не забудьте внести расходы за сегодня!',
      notificationDetails,
    );
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
}
