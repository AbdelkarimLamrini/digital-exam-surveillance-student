import 'package:flutter/material.dart';
import 'package:student_application/models/error_response.dart';
import 'package:student_application/screens/exam/exam_screen.dart';
import 'package:student_application/screens/login/consent_dialog.dart';
import 'package:student_application/screens/login/illegal_apps_dialog.dart';
import 'package:student_application/shared/utils/platform_utils.dart';

import '../../models/participation_form.dart';
import '/services/api/participation_service.dart';

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
      var participation = await startExam(ParticipationForm(
        studentId: _studentIdController.text,
        examId: _examIdController.text,
        classRoomId: _classRoomIdController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
      ));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExamScreen(participation: participation),
        ),
      );
    } on ErrorResponse catch (e) {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Student ID',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Exam ID',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Classroom',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Full Name',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Student Email',
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^\w+\.\w+@[\w+.]+\w[be|com]$').hasMatch(value)) {
                      return 'Invalid email format, use your student email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => onSubmit(context),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
