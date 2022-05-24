import 'package:flutter/material.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:leadoneattendance/globals.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context)
        .viewInsets
        .bottom; //Empuja el contenido hacia arriba cuando aparece el teclado.

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus
          ?.unfocus(), //Se oculta el teclado cuando detecta algun gesto en cualquier lugar de la pantalla

      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('changepassword.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    changepassword(emailController.text,
                        passwordController.text, newPasswordController.text);
                  },
                  icon: const Icon(Icons.save_outlined)),
            ],
          ),
          body: SingleChildScrollView(
                          reverse: true,
              padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children:[ Padding(
                padding: const EdgeInsets.all(8.0),
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
                        'changepassword.title',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ).tr(),
                      const SizedBox(
                        height: 2,
                      ),
                      const Text(
                        'changepassword.subtitle',
                        style: TextStyle(fontSize: 16),
                      ).tr(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText:
                            true, // So that the text entered is only "--------".
                        decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.password)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: newPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText:
                            true, // So that the text entered is only "--------".
                        decoration: const InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.password)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 170, 245),
                              primary: Colors.white,
                              minimumSize: const Size(120, 50) //WH
                              ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              changepassword(
                                  emailController.text,
                                  passwordController.text,
                                  newPasswordController.text);
                            }
                          },
                          child: Text(('changepassword.button').tr(),
                              style: const TextStyle(
                                fontSize: 18.0,
                              ))),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  Future<void> changepassword(email, password, newpassword) async {
    try {
      final response = await http.post(Uri.parse('$globalURL/password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'Email': email,
            'Password': password,
            'NewPassword': newpassword
          }));
      if (response.statusCode == 201) {
        // Dialog box showing that the data is correct.
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertChangePasswordOk();
            });
        debugPrint('Correct user, changes made.');
      } else {
        // Dialog box indicating that the data is incorrect.
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertChangePasswordError();
            });
        debugPrint('Incorrect User');
      }
    } on TimeoutException {
      debugPrint('Process time exceeded.');
    }
  }
}
