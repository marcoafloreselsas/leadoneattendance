import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// You can put the logo of your app
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.change_circle_outlined,
        ),
      ),
    );
  }
}
//Función que verifica el tipo de usuario que está entrando a la aplicación (y envía el User ID que está guardado), 
//si no hay dato, lo manda al LoginScreen()
Future isLogged(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  String? Role = prefs.getString('Role');
    if (Role == 'Administrator') {
      /// If the user is an admin
    Navigator.of(context).pushNamed('/MainScreenAdmin');
    debugPrint('Es Administrador el vato');
    // Navigator.push(context,MaterialPageRoute(builder: (context) => const MainScreenAdmin()));
    } else if (Role == 'Employee') {
      /// If the user is not an admin
    Navigator.of(context).pushNamed('/MainScreenUser');
    debugPrint('Es empleado el vato');
    } else {
    Navigator.push(context,MaterialPageRoute(builder: (context) => const LoginScreen()));
    debugPrint('paso por aqui');
    }
}