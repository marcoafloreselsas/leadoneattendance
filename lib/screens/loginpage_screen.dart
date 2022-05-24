import 'package:flutter/material.dart';
import 'package:leadoneattendance/globals.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
final Uri _url = Uri.parse('http://45.65.152.57:3012/forgotpassword');

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    final bottom = MediaQuery.of(context)
        .viewInsets
        .bottom; //Empuja el contenido hacia arriba cuando aparece el teclado.
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus
          ?.unfocus(), //Se oculta el teclado cuando detecta algun gesto en cualquier lugar de la pantalla
      child: WillPopScope(
        //Function disabling the system "back" button
        onWillPop: () async {
          _onWillPop();
          return false;
        },
        child: Scaffold(
            //Disappears the "back" button of scaffold
            resizeToAvoidBottomInset:
                false, //No rediseña los widgets cuando aparece el teclado
            body: SingleChildScrollView(
              //SCROLL
              reverse: true,
              padding: EdgeInsets.only(bottom: bottom),
              child: Center(
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required.';
                                    }
                                    return null;
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                primary: Colors.white, //TEXT COLOR
                                minimumSize: const Size(120, 50) //TAMANO - WH
                                ),
                            onPressed: () {
                              setState(() {});

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var email = emailController.text;
                                var password = passwordController.text;
                                login(email, password);
                              }
                            },
                            child: Text(('loginscreen.submit').tr(),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ))),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/ChangePassword');
                          },
                          icon: const Icon(Icons.settings, size: 18),
                          label: Text(("loginscreen.changepassword").tr(),
                              style: const TextStyle(
                                fontSize: 18.0,
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            launchUrl(_url);
                          },
                          child: const Text(("Forgot Password?"),
                              style: TextStyle(
                                fontSize: 18.0,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            )),
      ),
    );
  }

/* Login method, send email and password, and the server (in case it finds the information sent), 
returns the user id, the user role (administrator or employee) and a token, 
and depending on the user role, it can go to 'MainScreenAdmin', or 'MainScreenUser'. */
  Future<void> login(email, password) async {
    try {
      final response = await http.post(Uri.parse('$globalURL/login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'Email': email, 'Password': password}));

      var datos = jsonDecode(response.body);
/*
If there is a successful response from the server, it saves the re5ceived data on the device,
through Shared Preferences. 
*/
      if (response.statusCode == 200) {
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
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerErrorLogin();
          });
    }
  }
}
