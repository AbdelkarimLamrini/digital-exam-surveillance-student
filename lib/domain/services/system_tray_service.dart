import 'dart:io';
import 'package:system_tray/system_tray.dart';

class SystemTrayService {
  static final SystemTray _systemTray = SystemTray();

  static String getTrayPath(String imageName) {
    return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
  }

  static Future<void> initSystemTray() async {
    String redIconPath = getTrayPath('KdG-Red');

    await _systemTray.initSystemTray(iconPath: redIconPath);
  }

  static Future<void> changeSystemTrayRed() async {
    String redIconPath = getTrayPath('KdG-Red');

    _systemTray.destroy();
    await _systemTray.initSystemTray(iconPath: redIconPath);
  }

  static Future<void> changeSystemTrayGreen() async {
    String greenIconPath = getTrayPath('KdG-Green');

    _systemTray.destroy();
    await _systemTray.initSystemTray(iconPath: greenIconPath);
  }
}