import 'package:flutter/material.dart';

class AlertChangePasswordError extends StatelessWidget {
  const AlertChangePasswordError({Key? key}) : super(key: key);

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
              Text('El correo electronico y/o contraseña son incorrectos.')
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
