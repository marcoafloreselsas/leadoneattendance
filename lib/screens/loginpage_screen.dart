import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  String token = '';
  UserPreferences userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Function disabling the system "back" button
      onWillPop: _onWillPop,
      child: Scaffold(
          //Disappears the "back" button of scaffold
          resizeToAvoidBottomInset: false,
          body: Center(
              child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'loginscreen.title',
                style: TextStyle(fontSize: 34, fontStyle: FontStyle.normal),
              ).tr(),
              const Text(
                'loginscreen.subtitle.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ).tr(),
              const SizedBox(height: 20),
              Image.asset(
                'assets/leadone_logo.png',
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
//NOTE: Login text fields
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
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
                            height: 15,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText:
                                true, // So that the text entered is only "--------".
                            decoration: const InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.password)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 39, 55, 146),
                            primary: Colors.white, //TEXT COLOR
                            minimumSize: const Size(120, 50) //TAMANO - WH
                            ),
                        onPressed: () {
                          setState(() {});
                          var email = emailController.text;
                          var password = passwordController.text;
                          login(email, password);
                        },
                        child: const Text('loginscreen.submit').tr()),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ChangePassword');
                      },
                      icon: const Icon(Icons.settings, size: 18),
                      label: const Text("loginscreen.changepassword").tr(),
                    ),
                  ],
                ),
              )
            ],
          ))),
    );
  }

/* Login method, send email and password, and the server (in case it finds the information sent), 
returns the user id, the user role (administrator or employee) and a token, 
and depending on the user role, it can go to 'MainScreenAdmin', or 'MainScreenUser'. */
  Future<void> login(email, password) async {
    try {
      final response = await http.post(Uri.parse(' /login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'Email': email, 'Password': password}));
      var datos = jsonDecode(response.body);
/*
If there is a successful response from the server, it saves the received data on the device,
through Shared Preferences. 
*/
      if (response.body != '0') {
        userPreferences.saveUserId(datos['UserID']);
        userPreferences.saveRole(datos['Role']);
        userPreferences.saveToken(datos['Token']);
        if (datos['Role'] == 'Administrator') {
          Navigator.pushNamed(context, '/MainScreenAdmin');
        } else {
          Navigator.pushNamed(context, '/MainScreenUser');
        }
      } else {
// Dialog box indicating that the data is incorrect.
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertLogin();
            });
        debugPrint('Incorrect User');
      }
    } on TimeoutException {
      debugPrint('Process time exceeded.');
    }
  }
}
