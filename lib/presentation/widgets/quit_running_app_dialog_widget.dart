
import 'package:flutter/material.dart';

void showQuitAppsDialog(BuildContext context, VoidCallback onProceed) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Third-Party Applications Detected'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'To ensure the integrity of the process, please quit all third-party applications, including Discord, before proceeding.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: onProceed,
          ),
        ],
      );
    },
  );
}
