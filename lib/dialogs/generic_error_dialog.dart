import 'package:flutter/material.dart';

class GenericErrorDialog extends AlertDialog {
  const GenericErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ops...'),
      content: const Text('Algo de errado aconteceu. Por favor, tente novamente.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK')),
      ],
    );
  }
}
