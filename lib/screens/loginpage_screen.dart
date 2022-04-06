import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
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
            SizedBox(
              height: 50,
              width: 180,
              child: SignInButton(Buttons.Google,
                  elevation: 10,
                  text: 'Sign In with Google', onPressed: () async {
                await FirebaseServices().signInWithGoogle();
              }),
            ),
          ],
        )));
  }
}