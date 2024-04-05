import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/shared/utils/platform_utils.dart';
import 'notification_service.dart';
import 'systray_service.dart';

class ScreenCaptureService {
  String? outputStream;
  bool isRecording = false;
  bool manuallyStopped = false;
  Process? recordingProcess;

  ScreenCaptureService();

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isRecording ? Colors.green : Colors.red,
    ));
  }

  Future<void> toggleRecording() async {
    isRecording = !isRecording;
    _setStatusBarColor();
    if (isRecording) {
      String grabCommand = getGrabCommand();
      String display = getDisplay();
      assert (outputStream != null, 'Output stream is null');
      const String command = 'ffmpeg';
      final List<String> arguments = [
        '-f',
        grabCommand,
        '-r',
        '30',
        '-i',
        display,
        '-c:v',
        'libx264',
        '-preset',
        'ultrafast',
        '-pix_fmt',
        'yuv420p',
        '-g',
        '50',
        '-b:v',
        '4000k',
        '-maxrate',
        '4000k',
        '-bufsize',
        '8000k',
        '-f',
        'flv',
        outputStream!,
      ];
      print('Running FFmpeg with arguments: $arguments');
      SystemTrayService.changeSystemTrayGreen();
      try {
        recordingProcess = await Process.start(command, arguments);
        recordingProcess?.exitCode.then((int? exitCode) {
          if (exitCode != 0) {
            SystemTrayService.changeSystemTrayRed();
            NotificationService.showNotification("Recording stopped due to connection error", "Please try again!");
            
            if (manuallyStopped == true) {
              print(recordingProcess.toString());
              attemptStopRecording();
            } else {
            print('FFmpeg exited with code $exitCode');
            isRecording = !isRecording;
            recordingProcess = null;
            manuallyStopped = false;
            _setStatusBarColor();
            }
          }
        });
      } catch (e) {
        print('Error running FFmpeg: $e');
        isRecording = !isRecording;
        recordingProcess = null;
        manuallyStopped = false;
        _setStatusBarColor();
      }
    } else {
      recordingProcess?.kill();
      recordingProcess = null;
      manuallyStopped = false;
      _setStatusBarColor();
    }
  }

  // Future<void> attemptStartRecording() async {
  //   if (isRecording) {
  //     await toggleRecording();
  //   } else {
  //     try {
  //       int displayCount = await getConnectedDisplays();
  //       if (displayCount > 1) {
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Multiple Displays Detected"),
  //               content: const Text("Please disable all but the main display before starting. The exam won't be recorded if there are multiple displays enabled"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('OK'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       } else {
  //         await toggleRecording();
  //       }
  //     } catch (e) {
  //       print('Error determining display count: $e');
  //     }
  //   }
  // }

  Future<void> attemptStopRecording() async {
    if (isRecording && recordingProcess != null) {
      try {
        await recordingProcess!.kill();
        isRecording = !isRecording;
        manuallyStopped = true;
        NotificationService.showNotification("Recording Stopped", "You manually stopped the recording!");
      } catch (e) {
        print('Error stopping recording: $e');
      }
      recordingProcess = null;
      _setStatusBarColor();
    } else {
      print('Recording process is null or not recording.');
    }
  }

  void reconnectRecording() {
    int teller = 3;
    print('Reconnecting...');
    recordingProcess?.kill(ProcessSignal.sigint);
    recordingProcess = null;
    
    Timer(Duration(seconds: 5), () {
      if (recordingProcess?.exitCode != -1) {
        toggleRecording();
        isRecording = true;
        NotificationService.showNotification("Automatic Reconnection", "Continue your exam!");
      } else if (teller > 0) {
        reconnectRecording();
        teller = teller -1;
        print(teller);
      } else {
        NotificationService.showNotification("Automatic Reconnection Failed", "Notify your supervisor!");
      }
    });
  }
}