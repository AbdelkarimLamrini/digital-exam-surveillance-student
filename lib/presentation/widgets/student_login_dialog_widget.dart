import 'package:flutter/material.dart';

void showStudentLoginDialog({
  required BuildContext context,
  required TextEditingController studentIdController,
  required TextEditingController examIdController,
  required TextEditingController classRoomIdController,
  required TextEditingController fullNameController,
  required TextEditingController emailController,
  required GlobalKey<FormState> formKey,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Details'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: studentIdController,
                  decoration: const InputDecoration(hintText: 'Student ID'),
                  validator: (value) {
                    if (value == null || !RegExp(r'^\d{7}-\d{2}$').hasMatch(value)) {
                      return 'Invalid format, expected: 1234567-89';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: examIdController,
                  decoration: const InputDecoration(hintText: 'Exam ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Exam ID cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: classRoomIdController,
                  decoration: const InputDecoration(hintText: 'Class Room ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Class Room ID cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(hintText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Student Email'),
                  validator: (value) {
                    if (value == null || !RegExp(r'^\w+\.\w+@student\.kdg\.be$').hasMatch(value)) {
                      return 'Invalid email format, use your KdG email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}