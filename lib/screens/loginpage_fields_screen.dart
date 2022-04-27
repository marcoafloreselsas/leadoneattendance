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

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 250),
            const Text('loginpage.title', style: TextStyle(fontSize: 27, fontStyle: FontStyle.normal),
            ).tr(),
            const Text('loginpage.subtitle',style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(height: 20),
            Image.asset('assets/leadone_logo.png', width: 300,),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email)
                  ),
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
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.password)
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(onPressed: (){}, child: const Text('loginpage.submit').tr())
              ],
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
        Navigator.push(context, MaterialPageRoute(builder: ((context) => const TestingScreenTwo())));
      } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales incorrectas.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Favor de llenar los campos correctamente.')));
    }
  }
}