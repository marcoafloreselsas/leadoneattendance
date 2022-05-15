import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.change_circle_outlined,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

//Function that verifies the type of user that is entering the application, based on the information stored in the device with Shared Preferences, if there is no information, Login is required.
Future isLogged(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: non_constant_identifier_names
  String? Role = prefs.getString('Role');
  if (Role == 'Administrator') {
    Navigator.of(context).pushNamed('/MainScreenAdmin');
    debugPrint('The user is Administrator.');
  } else if (Role == 'Employee') {
    Navigator.of(context).pushNamed('/MainScreenUser');
    debugPrint('The user is an employee.');
  } else {
    Navigator.of(context).pushNamed('/LoginScreen');
    debugPrint('Login required.');
  }
}
