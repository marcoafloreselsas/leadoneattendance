import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/loginpage_screen.dart';
import 'package:leadoneattendance/screens/mainpage_screen_usert.dart';
import 'package:leadoneattendance/services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leadoneattendance/services/supported_locales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDwn_s0VbGgXZY19nwst_zR13ctmlaATG4",
            appId: "1:397875240276:android:ff5fbda6ac5d30bd70fcc1",
            messagingSenderId: '397875240276',
            projectId: "lead-one-attendance",
            authDomain: "lead-one-attendance.firebaseapp.com"));
    // ignore: empty_catches
  } on Exception {}
  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: supportedLocales,
    fallbackLocale: english, //Idioma por defecto.
    path: 'assets/resources/langs',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales:
          context.supportedLocales, // Obtiene el listado de idiomas soportados.
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Lead One: Attendance App',
      theme: AppTheme.lightTheme,
      home: StreamBuilder(
          stream: FirebaseServices().firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            //Si encuentra una sesión, arroja MainScreen, sino, LoginPage.
            if (snapshot.hasData) {
              return const MainScreen();
            }
            return const LoginPage();
          }),
    );
  }
}
