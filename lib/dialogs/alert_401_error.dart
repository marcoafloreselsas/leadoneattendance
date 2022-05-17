import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class Alert401 extends StatelessWidget {
  const Alert401({Key? key}) : super(key: key);

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
            children: [Text(('alerts.alert401').tr(),textAlign: TextAlign.center)],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.clear(); //Para borrar T O D O.
                Navigator.pushNamed(context, '/LoginScreen');
              },
              child: const Text('alerts.alertResponse3').tr())
        ]);
  }
}
