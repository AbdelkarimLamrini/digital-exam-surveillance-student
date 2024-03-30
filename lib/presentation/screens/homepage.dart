import 'package:flutter/material.dart';
import 'package:student_application/domain/screenrecorder_widget.dart';
import 'package:student_application/platform_utils.dart';
import 'package:student_application/presentation/widgets/consent_dialog_widget.dart';
import 'package:student_application/presentation/widgets/student_login_dialog_widget.dart';
import 'package:student_application/use_cases/end_exam.dart';

import '../../domain/extensions.dart';
import '../../domain/services/system_tray_service.dart';
import '../../domain/student_participation.dart';
import '../../use_cases/submit_participation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(statusTitle: 'KdG Exam Tool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.statusTitle});

  final String statusTitle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _examIdController = TextEditingController();
  final TextEditingController _classRoomIdController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudentParticipation? studentParticipation;
  late ScreenRecorderWidget screenRecorder;

  @override
  void initState() {
    super.initState();
    SystemTrayService.initSystemTray();
    checkRunningApplications(context);
    screenRecorder = ScreenRecorderWidget(context);
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        initWidgets();
      }
    });
  }

  void initWidgets() {
    // Show the consent dialog first
    showConsentDialog(navigatorKey.currentState!.overlay!.context, () {
      Navigator.of(navigatorKey.currentState!.overlay!.context).pop();
      showStudentLoginDialog(
        context: navigatorKey.currentState!.overlay!.context,
        studentIdController: _studentIdController,
        examIdController: _examIdController,
        classRoomIdController: _classRoomIdController,
        fullNameController: _fullNameController,
        emailController: _emailController,
        formKey: _formKey,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(unSuccessfulLoginSnackBar);
          }
          try {
            var participation = await submitForm(StudentParticipationForm(
                studentId: _studentIdController.text,
                examId: _examIdController.text,
                classRoomId: _classRoomIdController.text,
                fullName: _fullNameController.text,
                email: _emailController.text));
            setState(() {
              studentParticipation = participation;
            });
            screenRecorder.outputStream = participation.rtmpStreamUrl;
            ScaffoldMessenger.of(context).showSnackBar(successfulLoginSnackBar);
            Navigator.of(context).pop();
          } on Exception catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.getMessage),
              backgroundColor: Colors.red,
            ));
          }
        },
      );
    });
  }

  static const successfulLoginSnackBar = SnackBar(
    content: Text('You Successfully Logged In!'),
    backgroundColor: Colors.green,
  );
  static const unSuccessfulLoginSnackBar = SnackBar(
    content: Text('The form is not valid! Please check the fields.'),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.statusTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Exam: ${studentParticipation?.examId ?? '/'} [${studentParticipation?.classRoomId ?? '/'}]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${studentParticipation?.studentId}',
            ),
            Text(
              '${studentParticipation?.fullName}',
            ),
            Text(
              '${studentParticipation?.email}',
            ),
            SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () async {
                if (screenRecorder.isRecording) {
                  await screenRecorder.attemptStopRecording();
                } else {
                  await screenRecorder.attemptStartRecording();
                }
                setState(() {});
              },
              icon: Icon(screenRecorder.isRecording
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outlined),
              label: Text(screenRecorder.isRecording
                  ? 'Stop Recording'
                  : 'Start Recording'),
            ),
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                if (studentParticipation == null) {
                  return;
                }
                if (screenRecorder.isRecording) {
                  await screenRecorder.attemptStopRecording();
                }
                await endExam(studentParticipation!);
                studentParticipation = null;
                initWidgets();
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
