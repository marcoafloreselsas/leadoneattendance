import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AlertSelectEmployee extends StatelessWidget {
  const AlertSelectEmployee({Key? key}) : super(key: key);

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
            children: [Text(('alerts.alertSelectEmployee').tr(),textAlign: TextAlign.center)],
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('OK'))
        ]);
  }
}
