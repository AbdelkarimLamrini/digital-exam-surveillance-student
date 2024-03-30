import 'package:flutter/material.dart';

void showConsentDialog(BuildContext context, VoidCallback onProceed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Welcome to the Exam Tool'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '⚠️ Disclaimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'By proceeding with the login, you consent to screen sharing during the exam. Only the shared screen will be visible to the exam tutor. The app does not have access to private files or other personal information.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text('Please click next to proceed.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Next'),
            onPressed: onProceed,
          ),
        ],
      );
    },
  );
}