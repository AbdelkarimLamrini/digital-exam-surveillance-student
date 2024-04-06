import 'package:flutter/material.dart';

import '/models/error_response.dart';
import '/models/participation_form.dart';
import '/screens/exam/exam_screen.dart';
import '/services/api/participation_service.dart';
import '/services/screen_capture_service.dart';
import '/shared/utils/platform_utils.dart';
import 'consent_dialog.dart';
import 'illegal_apps_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _examIdController = TextEditingController();
  final TextEditingController _classRoomIdController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ErrorResponse? errorResponse;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => _showDialogs(context));
  }

  void _showDialogs(BuildContext context) {
    showDialog(context: context, builder: (context) => ConsentDialog());
    if (illegalAppsRunning()) {
      showDialog(context: context, builder: (context) => IllegalAppsDialog());
    }
  }

  void onSubmit(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      var participation = await startParticipation(ParticipationForm(
        studentId: _studentIdController.text,
        examId: _examIdController.text,
        classRoomId: _classRoomIdController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
      ));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExamScreen(
            participation: participation,
            captureService: ScreenCaptureService(participation.rtmpStreamUrl),
          ),
        ),
      );
    } on ErrorResponse catch (e) {
      setState(() {
        errorResponse = e;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong while submitting the form'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Exam Tool'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Fill in to start the exam',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _studentIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Student ID',
                      errorText: errorResponse?.fieldErrors['studentId'],
                    ),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^\d{7}-\d{2}$').hasMatch(value)) {
                        return 'Invalid format, expected: 1234567-89';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _examIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Exam ID',
                      errorText: errorResponse?.fieldErrors['examId'],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Exam ID cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _classRoomIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Classroom',
                      errorText: errorResponse?.fieldErrors['classRoomId'],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Classroom cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Full Name',
                      errorText: errorResponse?.fieldErrors['fullName'],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Student Email',
                      errorText: errorResponse?.fieldErrors['email'],
                    ),
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^\w+\.\w+@[\w+.]+\w[be|com]$')
                              .hasMatch(value)) {
                        return 'Invalid email format, use your student email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => onSubmit(context),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
