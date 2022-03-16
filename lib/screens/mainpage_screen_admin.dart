import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';


class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);


  @override
  _MainScreenAdmin createState() => _MainScreenAdmin();
}

class _MainScreenAdmin extends State<MainScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("title")),
        centerTitle: true,
        actions: [IconButton(onPressed: () async{
          await FirebaseServices().signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
        }, icon: const Icon(Icons.logout))],
      ),
      body: Card(
        child: Column(
          children: [
           Text(tr("subtitle",)
        ,),
        ])
        )
    );
  }
  }
