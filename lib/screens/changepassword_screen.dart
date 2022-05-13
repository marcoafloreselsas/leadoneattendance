import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
                          builder: (context) => const LoginScreen()));
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
                        changepassword(emailController.text, passwordController.text, newPasswordController.text);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Save Changes')),
              ],
            ),
          ),
        ));
  }
    Future<void> changepassword(email, password, newpassword) async{
    try{
        final response = await http.post(Uri.parse('https://f6a1-45-65-152-57.ngrok.io/password'),
        headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>
        {
          'Email' : email,
          'Password' : password,
          'NewPassword' : newpassword
        }));
        // var datos = jsonDecode(response.body); // C H E C K    T H I S
        if(response.body != '0'){
          //Cuadro de diálogo que muestra que los datos son correctos.
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertChangePasswordOk();
              });
          debugPrint('Usuario Correcto, cambios realizados.');
        } else{
          //Cuadro de diálogo que indica que los datos son incorrectos.
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertChangePasswordError();
              });
          debugPrint('Usuario Incorrecto');
          
        }
    } on TimeoutException{
      debugPrint('Tiempo de proceso excedido.');
    }
  }
}
