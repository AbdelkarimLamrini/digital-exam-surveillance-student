import 'package:flutter/material.dart';

class MultiDisplayDialog extends StatelessWidget {
  const MultiDisplayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Multiple Displays Detected"),
      content: const Text(
          "Please disable all but the primary display before starting. The exam won't be recorded if there are multiple displays enabled"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
