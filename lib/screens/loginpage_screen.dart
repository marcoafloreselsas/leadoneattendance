import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:leadoneattendance/screens/mainpage_screen.dart';
import 'package:leadoneattendance/services/firebase_services.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SizedBox(
          height: 50,
          width: 180,
          child: SignInButton(
          Buttons.Google, 
          text: 'Sign In with Google',
          onPressed: () async{
            await FirebaseServices().signInWithGoogle();
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
          }
          ),
        ),
     )
    );
  }
}