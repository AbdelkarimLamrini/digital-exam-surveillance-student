import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  static Future<void> startupNotif() async {
    await localNotifier.setup(
      appName: 'Recording stopped!',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  static void showNotification(String notificationTitle, String notificationMessage) {
    LocalNotification notification = LocalNotification(
      title: notificationTitle,
      body: notificationMessage,
    );
    notification.show();
  }
}