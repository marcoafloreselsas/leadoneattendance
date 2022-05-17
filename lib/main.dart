import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/services/supported_locales.dart';

void main() async {

  //Verifica que la Localización y el Framework-Fuente están inicializados correctamente.
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
        supportedLocales: context
            .supportedLocales, // Obtiene el listado de idiomas soportados.
        locale: context.locale,
        debugShowCheckedModeBanner:
            false, //Quita la cinta de 'debug' del superior derecho.
        title: 'Lead One: Attendance App',
        theme: AppTheme
            .lightTheme, // Tema de la aplicación, carga el App Theme de la carpeta Themes.
        //ESTAS SON LAS RUTAS DE LAS PANTALLAS
        //Para que puedan añadírseles parámetros más adelante.
        routes: {
            '/': (BuildContext context) => const LoadingScreen(), //Pantalla que verifica el estado del usuario.
            '/LoginScreen': (BuildContext context) => const LoginScreen(),
            '/ChangePassword': (BuildContext context) => const ChangePasswordScreen(),
    //A D M I N
            '/MainScreenAdmin': (BuildContext context) => const MainScreenAdmin(),
            '/DisplayRecordScreenAdmin' : (BuildContext context) => const DisplayRecordScreenAdmin(),
            '/InsertRecordScreenAdmin' : (BuildContext context) => const InsertRecordScreenAdmin(),
            '/EditRecordScreenAdmin' : (BuildContext context) => const EditRecordScreenAdmin(),
            '/QueryRecordsScreenAdmin' : (BuildContext context) => const QueryRecordsScreenAdmin(),
            '/SelectReportType' : (BuildContext context) => const SelectReportTypeScreen(),
            '/GeneralReports' : (BuildContext context) => const GenerateGeneralReportsScreen(),
            '/IndividualReports': (BuildContext context) => const GenerateIndividualReportsScreen(),
            '/ReportViewerScreen' : (BuildContext context) => const ReportViewerScreen(),
            '/SendReportScreen': (BuildContext context) => const SendReportScreen(),
    //U S E R 
            '/MainScreenUser': (BuildContext context) => const MainScreenUser(),
            '/DisplayRecordScreenUser' : (BuildContext context) => const DisplayRecordScreenUser(),
            '/InsertRecordScreenUser': (BuildContext context) => const InsertRecordScreenUser(),
            '/EditRecordScreenUser' : (BuildContext context) => const EditRecordScreenUser(),
            '/QueryRecordsScreenUser' : (BuildContext context) => const QueryRecordsScreenUser(),
      },
    );
  }
}
