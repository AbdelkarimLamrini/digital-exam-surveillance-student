import 'package:flutter/material.dart';
import 'package:student_application/presentation/screens/homepage.dart';

import 'domain/services/notification_service.dart';
import 'domain/services/system_tray_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTrayService.initSystemTray();
  await NotificationService.startupNotif();
  runApp(const MyApp());
}