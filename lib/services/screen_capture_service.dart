import 'dart:async';
import 'dart:io';

import '/shared/constants/ffmpeg_constants.dart';
import '/shared/utils/platform_utils.dart';
import 'notification_service.dart';
import 'systray_service.dart';

class ScreenCaptureService {
  final String outputStream;
  Process? recordingProcess;
  bool isRecording = false;
  bool manuallyStopped = false;

  ScreenCaptureService(this.outputStream);

  Future<void> startRecording() async {
    if (isRecording) return;

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
      SystemTrayService.changeSystemTrayGreen();
      recordingProcess = await Process.start(command, arguments);
      isRecording = true;
      manuallyStopped = false;

      recordingProcess?.exitCode.then((exitCode) {
        if (exitCode == 0) return;
        print('FFmpeg exited with code $exitCode');
        SystemTrayService.changeSystemTrayRed();
        NotificationService.showNotification(
          "Recording Stopped",
          "FFmpeg exited unexpectedly with code $exitCode!",
        );
        isRecording = false;
        recordingProcess = null;
        manuallyStopped = false;
      });
    } catch (e) {
      SystemTrayService.changeSystemTrayRed();
      print('Error running FFmpeg: $e');
      isRecording = false;
      recordingProcess = null;
      manuallyStopped = false;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;
    try {
      recordingProcess?.kill();
      await recordingProcess?.exitCode;
      recordingProcess = null;
      manuallyStopped = true;
      isRecording = false;

      SystemTrayService.changeSystemTrayRed();
      NotificationService.showNotification(
        "Recording Stopped",
        "You manually stopped the recording!",
      );
    } catch (e) {
      print('Error stopping FFmpeg: $e');
    }
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
