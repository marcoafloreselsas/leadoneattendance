import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leadoneattendance/services/supported_locales.dart';

void main() async {
  //Verifica que la Localización y el Framework-Fuente están inicializados correctamente.
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp(
      //Conexión con la base de datos de firebase
        options: const FirebaseOptions(
            apiKey: "AIzaSyDwn_s0VbGgXZY19nwst_zR13ctmlaATG4",
            appId: "1:397875240276:android:ff5fbda6ac5d30bd70fcc1",
            messagingSenderId: '397875240276',
            projectId: "lead-one-attendance",
            authDomain: "lead-one-attendance.firebaseapp.com"));
  //No borrar la siguiente línea
  // ignore: empty_catches
  } on Exception {}
  //Carga de la localización
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
      debugShowCheckedModeBanner: false, //Quita la cinta de 'debug' del superior derecho.
      title: 'Lead One: Attendance App',
      theme: AppTheme.lightTheme, // Tema de la aplicación, carga el App Theme de la carpeta Themes.
      home: StreamBuilder(
          stream: FirebaseServices().firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            //Si encuentra una sesión, arroja MainScreen, sino, LoginPage.
            if (snapshot.hasData) {
              //VERIFICAR: Empleado = MainScreen, Administrador = MainScreenAdmin.
              return const MainScreenAdmin();
            }
              return const LoginPage();
            }
          ),
    );
  }
}
