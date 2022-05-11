import 'package:flutter/material.dart';

class AlertEditRecordErrorOne extends StatelessWidget {
  const AlertEditRecordErrorOne({Key? key}) : super(key: key);

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
              Text('La hora de entrada no debe ser mayor a la hora de salida.')
            ],
          ),
        ),
        actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/LoginScreen');
                    },
                    child: const Text('Save Changes')),
        ]);
  }
}
