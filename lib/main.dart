import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leadoneattendance/screens/main_screen.dart';
import 'package:leadoneattendance/services/firebase_services.dart';


void main()async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: "AIzaSyDwn_s0VbGgXZY19nwst_zR13ctmlaATG4", 
      appId: "1:397875240276:android:ff5fbda6ac5d30bd70fcc1", 
      messagingSenderId: '397875240276', 
      projectId: "lead-one-attendance",
      authDomain: "lead-one-attendance.firebaseapp.com"
      )
    );
  } on Exception catch (e) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E L S A S PRODUCCIONES',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StreamBuilder(
          stream: FirebaseServices().firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
          if(snapshot.hasData){
            return MainScreen(); 
          }
          return LoginPage();
        }
      ),
    );
  }
}
