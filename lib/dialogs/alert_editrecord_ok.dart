import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/mainpage_screen_user.dart';

class AlertEditRecordOk extends StatelessWidget {
  const AlertEditRecordOk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/success.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text('El registro se ha modificado exitosamente.')
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                
              },
              child: const Text('Aceptar'))
        ]);
  }
}
