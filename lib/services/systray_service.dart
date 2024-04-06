import 'dart:io';

import 'package:system_tray/system_tray.dart';

class SystemTrayService {
  static final SystemTray _systemTray = SystemTray();

  static String getTrayPath(String imageName) {
    return Platform.isWindows
        ? 'assets/$imageName.ico'
        : 'assets/$imageName.png';
  }

  static Future<void> initSystemTray() async {
    String redIconPath = getTrayPath('KdG-Red');

    await _systemTray.initSystemTray(iconPath: redIconPath);
  }

  static Future<void> setSystemTrayRed() async {
    String redIconPath = getTrayPath('KdG-Red');

    _systemTray.destroy();
    await _systemTray.initSystemTray(iconPath: redIconPath);
  }

  static Future<void> setSystemTrayGreen() async {
    String greenIconPath = getTrayPath('KdG-Green');

    _systemTray.destroy();
    await _systemTray.initSystemTray(iconPath: greenIconPath);
  }
}
