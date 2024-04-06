import 'package:flutter/material.dart';
import 'package:student_application/models/multiple_display_error.dart';
import 'package:student_application/models/participation.dart';
import 'package:student_application/services/screen_capture_service.dart';

import '/services/api/participation_service.dart';
import 'multi_display_dialog.dart';

class ExamScreen extends StatefulWidget {
  final Participation participation;
  final ScreenCaptureService captureService;

  const ExamScreen({
    super.key,
    required this.participation,
    required this.captureService,
  });

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
  void dispose() {
    if (captureService.isRecording) {
      captureService.stopRecording();
    }
    super.dispose();
  }

  void toggleRecording() async {
    if (captureService.isRecording) {
      await captureService.stopRecording();
      setState(() {});
      return;
    }
    try {
      await captureService.startRecording();
      setState(() {});
    } on MultipleDisplayError {
      if (!mounted) return;
      showDialog(context: context, builder: (context) => MultiDisplayDialog());
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void endExam() {
    if (captureService.isRecording) {
      captureService.stopRecording();
    }
    endParticipation(participation);
    Navigator.of(context).pop();
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
          children: [
            Text(
              'Exam: ${participation.examId} [${participation.classRoomId}]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(participation.studentId),
            Text(participation.fullName),
            Text(participation.email),
            SizedBox(height: 30),
            FilledButton.icon(
              onPressed: toggleRecording,
              icon: Icon(captureService.isRecording
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outlined),
              label: Text(captureService.isRecording
                  ? 'Stop Recording'
                  : 'Start Recording'),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: endExam,
              icon: Icon(Icons.exit_to_app),
              label: Text('End Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
