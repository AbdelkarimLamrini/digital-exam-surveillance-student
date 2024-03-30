import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_application/presentation/widgets/quit_running_app_dialog_widget.dart';

String getGrabCommand() {
  if (Platform.isLinux) {
    return 'x11grab';
  } else if (Platform.isWindows) {
    return 'gdigrab';
  } else if (Platform.isMacOS) {
    return 'avfoundation';
  } else {
    print('Unsupported platform');
    exit(1);
  }
}

String getDisplay() {
  if (Platform.isLinux) {
    final String? display = Platform.environment['DISPLAY'];
    if (display == null) {
      exit(1);
    }
    return display;
  } else if (Platform.isWindows) {
    return 'desktop';
  } else if (Platform.isMacOS) {
    const String command = 'ffmpeg';

    final List<String> arguments = [
      '-f',
      'avfoundation',
      '-list_devices',
      'true',
      '-i',
      '""'
    ];
    final result = Process.runSync(command, arguments);

    RegExp exp = RegExp(r'\[(\d+)\] Capture screen 0');
    RegExpMatch? match = exp.firstMatch(result.stderr.toString());
    var display = match?.group(1);

    if (display == null) {
      exit(1);
    }

    return '$display:';
  } else {
    print('Unsupported platform');
    exit(1);
  }
}

Future<int> getConnectedDisplays() async {
  String command;
  List<String> arguments;

  if (Platform.isLinux) {
    command = 'bash';
    arguments = ['-c', 'xrandr --query | grep " connected" | wc -l'];
  } else if (Platform.isWindows) {
    command = 'powershell.exe';
    arguments = [
      '-NoProfile',
      '-Command',
      'Add-Type -AssemblyName System.Windows.Forms; '
      '[System.Windows.Forms.Screen]::AllScreens.Count.ToString()'
    ];
  } else if (Platform.isMacOS) {
    command = 'zsh';
    arguments = ['-c', 'system_profiler SPDisplaysDataType | grep "Resolution:" | wc -l'];
  } else {
    throw Exception('Unsupported platform');
  }

  final result = await Process.run(command, arguments);
  if (result.exitCode == 0) {
    print('Connected displays: ${result.stdout}');
    return int.tryParse(result.stdout) ?? 0;
  } else {
    throw Exception('Failed to get connected displays');
  }
}

Future<void> checkRunningApplications(BuildContext context) async {
  String shell = Platform.isMacOS ? 'zsh' : Platform.isWindows ? 'PowerShell' : 'bash';
  String command;
  if (Platform.isMacOS || Platform.isLinux) {
    command = "ps aux | grep '[D]iscord'";
  } else if (Platform.isWindows) {
    command = 'tasklist | findstr /i "Discord"';
  } else {
    print('Unsupported platform');
    return;
  }

  try {
    ProcessResult result = await Process.run(shell, ['-c',command]);
  
    bool isRunning = result.stdout.toString().trim().isNotEmpty && result.stdout.toString().contains('Discord');

    if (isRunning) {
      print('Discord is running');
      showQuitAppsDialog(context, () {
       
        Navigator.of(context).pop();
      });
    } else {
      print('Discord is not running');
    }
  } catch (e) {
    print('Failed to run command: $e');
  }
}