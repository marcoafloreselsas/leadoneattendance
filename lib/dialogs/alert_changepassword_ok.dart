import 'package:flutter/material.dart';

class AlertChangePasswordOk extends StatelessWidget {
  const AlertChangePasswordOk({Key? key}) : super(key: key);

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
              Text('Se ha actualizado su contraseña exitosamente.')
            ],
          ),
        ),
        actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/LoginScreen');
                    },
                    child: const Text('OK')),
        ]);
  }
}
