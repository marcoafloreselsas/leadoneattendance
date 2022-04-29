import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:leadoneattendance/screens/testing_screen_two.dart';

class LoginFieldsPage extends StatefulWidget {
  const LoginFieldsPage({Key? key}) : super(key: key);

  @override
  State<LoginFieldsPage> createState() => _LoginFieldsPageState();
}

class _LoginFieldsPageState extends State<LoginFieldsPage> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 34, fontStyle: FontStyle.normal),
            ),
            const Text(
              'Please, Sign in.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                  //NOTE Campos de texto de inicio de sesión
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
                              true, // Para que el texto introducido solo sean "••••••••"
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
                        setState(() {
                          // _futureInsertRecord = createRecord(); //parametros a insertar
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()));
                      },
                      child: const Text('ACCESS')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePassword()));
                    },
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text("Change Password"),
                  ),
                ],
              ),
            )
          ],
        )));
  }

  Future<void> login() async{
    if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
      var response = await http.post(Uri.parse('https://e41c-45-65-152-57.ngrok.io'), body: ({
        'email':emailController.text,
        'password':passwordController.text
      }));
      if(response.statusCode == 200){
        //Aquí puede ir un if, donde compare el rol del usuario, después de mandar el email y contraseña
        Navigator.push(context, MaterialPageRoute(builder: ((context) => const TestingScreenTwo())));
      } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales incorrectas.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Favor de llenar los campos correctamente.')));
    }
  }
}