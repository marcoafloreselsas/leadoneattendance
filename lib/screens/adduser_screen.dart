import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

final _formKey = GlobalKey<FormState>();
var emailController = TextEditingController();
var passwordController = TextEditingController();
var newPasswordController = TextEditingController();

String dropdownvalue = 'Admin';
// List of items in our dropdown menu
var items = ['Admin', 'User'];

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add New User'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                icon: const Icon(Icons.person_add)),
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
                'Add New User',
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Type Record'),
                const Padding(padding: EdgeInsets.all(25.0)),
                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? tipoActividad) {
                    setState(() {
                      dropdownvalue = tipoActividad!;
                      //           UserType = items.indexOf(tipoActividad);
                    });
                  },
                ),
              ]),
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
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Save Changes')),
            ], //MARTHA TIENE UN MARCAPASOS QUE LE ALEGRA EL CORAZON NO TIENE QUE DARLE VUELTA ES AUTOMATICO
          ),
        )));
  }

  registrarUsuario() {}
}
