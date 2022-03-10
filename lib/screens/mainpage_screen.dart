import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/themes/app_themes.dart';


class MainScreen extends StatelessWidget {
  
  const MainScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //Color de fondo de la
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(('mainpage.title').tr()),
        centerTitle: true,
        actions: [IconButton(onPressed: () async{
          await FirebaseServices().signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
        }, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          // Text(('mainpage.subtitle').tr(),)
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.person, color: AppTheme.primary, size: 30,),
            title: Text(DateTime.now().toString()),
            subtitle: Text(DateTime.now().toString()),
          ),
          const SizedBox(height: 10,)
        ],
      )
    );
  }
}