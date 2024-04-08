import 'package:flutter/material.dart';

class IllegalAppsDialog extends StatelessWidget {
  const IllegalAppsDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Acknowledge'),
        ),
      ],
    );
  }
}
