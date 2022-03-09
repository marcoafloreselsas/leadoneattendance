import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import '../services/firebase_services.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to LeadOne!'),
        centerTitle: true,
        actions: [IconButton(onPressed: () async{
          await FirebaseServices().signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        }, icon: const Icon(Icons.logout))],
      ),
    );
  }
}