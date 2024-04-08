import 'package:flutter/material.dart';
import 'package:student_application/screens/login/login_screen.dart';

import 'services/notification_service.dart';
import 'services/systray_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTrayService.initSystemTray();
  await NotificationService.setupNotifier();
  runApp(const ExamTool());
}

class ExamTool extends StatelessWidget {
  const ExamTool({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Tool',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
