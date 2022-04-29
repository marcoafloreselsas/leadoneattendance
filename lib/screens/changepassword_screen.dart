import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Change Password'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginFieldsPage()));
                },
                icon: const Icon(Icons.save_outlined)),
          ],
        ),
        body: Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/leadone_logo.png',
                  width: 300,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'Please, fill in the following fields.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required.';
                    }
                    String pattern = r'\w+@\w+\.\w+';
                    if (!RegExp(pattern).hasMatch(value)) {
                      return 'Invalid Email address format.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      true, // Para que el texto introducido solo sean "••••••••"
                  decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText:
                      true, // Para que el texto introducido solo sean "••••••••"
                  decoration: const InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 39, 55, 146),
                        primary: Colors.white, //TEXT COLOR
                        minimumSize: const Size(120, 50) //TAMANO - WH
                        ),
                    onPressed: () {
                      setState(() {
                        // _futureInsertRecord = createRecord(); //parametros a insertar
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginFieldsPage()));
                    },
                    child: const Text('Save Changes')),
              ], //MARTHA TIENE UN MARCAPASOS QUE LE ALEGRA EL CORAZON NO TIENE QUE DARLE VUELTA ES AUTOMATICO
            ),
          ),
        ));
  }
}
