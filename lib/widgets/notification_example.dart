import 'package:family_budget/data/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationExample extends StatelessWidget {
  const NotificationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пример уведомлений'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final notificationService = NotificationService();
                await notificationService.initNotifications();
                await notificationService.sendDelayedReminderNotification();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Уведомление будет отправлено через 10 секунд'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Отправить напоминание через 10 секунд'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Вы получите уведомление даже если закроете приложение',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
