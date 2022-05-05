import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

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
                          login(emailController, passwordController);
                        });
                      },
                      child: const Text('ACCESS')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QueryRecordsScreenAdmin()));
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
//Método del login, recibe los datos del API y dependiendo del tipo de usuario, es el dato que envía,
//si no, pues hay error.
  Future<void> login(email, password) async{
    try{
      var url = 'serverurl';
      var response = await http.post(Uri.parse(url), 
      body:
        {
          'Email' : email,
          'Password' : password
        }).timeout(const Duration(seconds: 30));

        var datos = jsonDecode(response.body);
        debugPrint(datos);
        if(response.body != '0'){
          guardarDatos(datos['UserID'], datos['Role']);
          if(datos['Role'] == 'Administrator'){                                   // REVIEW REVISAR SI LLEVA datos[Role] o solo [Role]
          Navigator.pushNamed(context, '/AdminPage', arguments: {'UserID':UserId});

           } else {
          Navigator.pushNamed(context, '/UserPage', arguments: {'UserID': UserId});

          }
        } else{
          //Cuadro de diálogo que indica que los datos son incorrectos.
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertLogin();
              });
          debugPrint('Usuario Incorrecto');
          
        }
    } on TimeoutException catch(e){
      debugPrint('Tiempo de proceso excedido.');
    } on Error {
      debugPrint('Http error.');
    }
  }

  Future<void> guardarDatos(userid, role) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserID', userid);
    await prefs.setString('Role', role);

  }

  String UserId = '';
  String Role = '';

}