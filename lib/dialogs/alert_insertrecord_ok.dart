// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AlertInsertRecordOk extends StatelessWidget {
  const AlertInsertRecordOk({Key? key}) : super(key: key);

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
            children: [Text(('alerts.alertinsertrecordok').tr(), textAlign: TextAlign.center,)],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/MainScreenUser');
              },
              child: const Text('alerts.alertResponse3').tr())
        ]);
  }
}
