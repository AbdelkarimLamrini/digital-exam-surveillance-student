import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '/shared/constants/ffmpeg_constants.dart';
import '/shared/utils/platform_utils.dart';
import 'notification_service.dart';
import 'systray_service.dart';

class ScreenCaptureService {
  final String outputStream;
  Process? recordingProcess;
  final isRecording = ValueNotifier(false);
  bool manuallyStopped = false;

  ScreenCaptureService(this.outputStream);

  Future<void> startRecording() async {
    if (isRecording.value) return;

    try {
      var displayCount = getConnectedDisplayCount();
      if (displayCount > 1) {
        throw Exception('Multiple displays detected');
      }
    } catch (e) {
      print('Error determining display count: $e');
    }

    final (command, arguments) = getFFmpegCommand();
    try {
      SystemTrayService.setSystemTrayGreen();
      recordingProcess = await Process.start(command, arguments);
      isRecording.value = true;
      manuallyStopped = false;

      recordingProcess?.exitCode.then((exitCode) {
        if (exitCode == 0) return;
        if (manuallyStopped) return;
        notifyRecordingStoppedUnexpectedly(exitCode);
        isRecording.value = false;
        recordingProcess = null;
        manuallyStopped = false;
      });
    } catch (e) {
      SystemTrayService.setSystemTrayRed();
      print('Error running FFmpeg: $e');
      isRecording.value = false;
      recordingProcess = null;
      manuallyStopped = false;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;
    try {
      manuallyStopped = true;
      recordingProcess?.kill();
      recordingProcess = null;
      isRecording.value = false;
      notifyRecordingStoppedManually();
    } catch (e) {
      print('Error stopping FFmpeg: $e');
    }
  }

  void notifyRecordingStoppedManually() {
    print('FFmpeg process was stopped manually!');
    SystemTrayService.setSystemTrayRed();
    NotificationService.showNotification(
      "Recording Stopped",
      "You stopped recording!",
    );
  }

  void notifyRecordingStoppedUnexpectedly(int exitCode) {
    print('FFmpeg exited unexpectedly with code $exitCode!');
    SystemTrayService.setSystemTrayRed();
    NotificationService.showNotification(
      "Recording Stopped",
      "FFmpeg exited unexpectedly with code $exitCode!",
    );
  }

  (String, List<String>) getFFmpegCommand() {
    String grabCommand = getGrabCommand();
    String display = getDisplay();
    const String command = 'ffmpeg';
    final List<String> arguments = [
      '-f',
      grabCommand,
      '-r',
      frameRate,
      '-i',
      display,
      '-c:v',
      'libx264',
      '-preset',
      'ultrafast',
      '-pix_fmt',
      'yuv420p',
      '-g',
      gop,
      '-b:v',
      bitRate,
      '-maxrate',
      maxRate,
      '-bufsize',
      bufferSize,
      '-f',
      'flv',
      outputStream,
    ];
    print('Running FFmpeg with arguments: $arguments');
    return (command, arguments);
  }
}
