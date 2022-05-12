import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({Key? key}) : super(key: key);

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var subjectController = TextEditingController();
  var messageController = TextEditingController();

  String email = '';
  String subject = '';
  String message = '';


//Esta vista envía el reporte generado.
  @override
  Widget build(BuildContext context) {
    UserPreferences userPreferences = UserPreferences();

    return Scaffold(
      //App bar de la pantalla.
        appBar: AppBar(
            title: const Text('sendreport.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreenAdmin()));
                  },
                  icon: const Icon(Icons.send)),
            ]),
        body: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //Añadido el 3 de mayo de 2022
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: ('sendreport.to').tr(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required.';
                      }
                      String pattern = r'\w+@\w+\.\w+';
                      if (!RegExp(pattern).hasMatch(value)) {
                        return 'Invalid Email address format.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: ('sendreport.subject').tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: messageController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: ('sendreport.message').tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Botón de guardar cambios.
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          primary: Colors.white, //Color del Texto
                          minimumSize: const Size(120, 50) //Tamaño - WH
                          ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          //     builder: (context) => const MainScreenAdmin()));
                          sendReport(emailController.text, subjectController.text, messageController.text);
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             const MainScreenAdmin()),
                          //     (Route<dynamic> route) =>
                          //         route is MainScreenAdmin); 
                        }
                      },
                      child: const Text('sendreport.sendButton').tr())
                ],
              ),
            )));
  }

    Future<void> sendReport(email, subject, message) async{
    UserPreferences userPreferences = UserPreferences();
    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    // Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var activity = args['userID'];
    var userID = args['activity'].toString();
    var firstDate = args['firstDate'];
    var lastDate = args['lastDate'];

    if(activity == 1){
    final response = await http.post(Uri.parse('https://beb7-45-65-152-57.ngrok.io/send/userhoursreport/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String, String>
            {
              'Email' : email,
              'UserID': userID,
              'Date1': firstDate,
              'Date2': lastDate,
              'Subject': subject,
              'Message': message
            }));
        debugPrint('AT: '+email + userID + firstDate + lastDate);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertSendReport();
                  });
            // if(response.body != '0'){
            //   //Cuadro de diálogo que muestra que los datos son correctos.

            //   debugPrint('Usuario Correcto, cambios realizados.');
            // } else{
            //   //Cuadro de diálogo que indica que los datos son incorrectos.
            //   showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return const AlertChangePasswordError();
            //       });
            //   debugPrint('Usuario Incorrecto');
              
            // }

    }else if(activity == 2){
          final response = await http.post(Uri.parse('https://beb7-45-65-152-57.ngrok.io/send/usermodifications/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String, String>
            {
              'Email' : email,
              'UserID': userID,
              'Date1': firstDate,
              'Date2': lastDate,
              'Subject': subject,
              'Message': message
            }));
        debugPrint('MOD: '+email + userID + firstDate + lastDate);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertSendReport();
                  });
            // if(response.body != '0'){
            //   //Cuadro de diálogo que muestra que los datos son correctos.

            //   debugPrint('Usuario Correcto, cambios realizados.');
            // } else{
            //   //Cuadro de diálogo que indica que los datos son incorrectos.
            //   showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return const AlertChangePasswordError();
            //       });
            //   debugPrint('Usuario Incorrecto');
              
            // }
    }
else if(activity == 3){
          final response = await http.post(Uri.parse('https://beb7-45-65-152-57.ngrok.io/send/usershoursreport/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String, String>
            {
              'Email' : email,
              'UserID': userID,
              'Date1': firstDate,
              'Date2': lastDate,
              'Subject': subject,
              'Message': message
            }));
        debugPrint('MOD: '+email + userID + firstDate + lastDate);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertSendReport();
                  });
            // if(response.body != '0'){
            //   //Cuadro de diálogo que muestra que los datos son correctos.

            //   debugPrint('Usuario Correcto, cambios realizados.');
            // } else{
            //   //Cuadro de diálogo que indica que los datos son incorrectos.
            //   showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return const AlertChangePasswordError();
            //       });
            //   debugPrint('Usuario Incorrecto');
              
            // }
    }
    else if(activity == 4){
          final response = await http.post(Uri.parse('https://beb7-45-65-152-57.ngrok.io/send/usersmodifications/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String, String>
            {
              'Email' : email,
              'UserID': userID,
              'Date1': firstDate,
              'Date2': lastDate,
              'Subject': subject,
              'Message': message
            }));
        debugPrint('MOD: '+email + userID + firstDate + lastDate);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertSendReport();
                  });
            // if(response.body != '0'){
            //   //Cuadro de diálogo que muestra que los datos son correctos.

            //   debugPrint('Usuario Correcto, cambios realizados.');
            // } else{
            //   //Cuadro de diálogo que indica que los datos son incorrectos.
            //   showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return const AlertChangePasswordError();
            //       });
            //   debugPrint('Usuario Incorrecto');
              
            // }
    }
  }
}