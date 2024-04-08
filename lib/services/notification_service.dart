import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  static Future<void> setupNotifier() async {
    await localNotifier.setup(
      appName: 'Exam Tool',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  static void showNotification(String notificationTitle, String notificationMessage) {
    var notification = LocalNotification(
      title: notificationTitle,
      body: notificationMessage,
    );
    notification.show();
  }
}
