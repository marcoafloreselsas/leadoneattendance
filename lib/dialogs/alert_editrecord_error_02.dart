import 'package:flutter/material.dart';

class AlertEditRecordErrorTwo extends StatelessWidget {
  const AlertEditRecordErrorTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/error.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text('Los valores son iguales. No hay necesidad de actualizar.')
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'))
        ]);
  }
}
