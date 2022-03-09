import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import '../services/firebase_services.dart';

class MainScreenAdmin extends StatefulWidget {

  _MainScreenAdmin createState() => _MainScreenAdmin();
}

class _MainScreenAdmin extends State<MainScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Lead One A D M I N mode!'),
        centerTitle: true,
        actions: [IconButton(onPressed: () async{
          await FirebaseServices().signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
        }, icon: const Icon(Icons.logout))],
      ),
    );
  }
  }
