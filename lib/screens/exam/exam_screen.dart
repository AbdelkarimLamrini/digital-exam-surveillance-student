import 'package:flutter/material.dart';
import 'package:student_application/models/participation.dart';
import 'package:student_application/services/screen_capture_service.dart';

import '/services/api/participation_service.dart';

class ExamScreen extends StatefulWidget {
  ExamScreen({super.key, required this.participation});

  final Participation participation;
  final ScreenCaptureService captureService = ScreenCaptureService();

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late Participation participation;
  late ScreenCaptureService captureService;

  @override
  void initState() {
    super.initState();
    participation = widget.participation;
    captureService = widget.captureService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Exam Tool'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Exam: ${participation.examId} [${participation.classRoomId}]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              participation.studentId,
            ),
            Text(
              participation.fullName,
            ),
            Text(
              participation.email,
            ),
            SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () async {
                if (captureService.isRecording) {
                  // await captureService.attemptStopRecording();
                } else {
                  //await captureService.attemptStartRecording();
                }
                setState(() {});
              },
              icon: Icon(captureService.isRecording
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outlined),
              label: Text(captureService.isRecording
                  ? 'Stop Recording'
                  : 'Start Recording'),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                if (captureService.isRecording) {
                  captureService.attemptStopRecording();
                }
                endExam(participation);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('End Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
