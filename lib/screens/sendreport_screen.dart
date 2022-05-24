// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/globals.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SendReportScreen extends StatefulWidget {
  const SendReportScreen({Key? key}) : super(key: key);

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

Future<bool> _onWillPop() async {
  return false;
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
    final bottom = MediaQuery.of(context)
        .viewInsets
        .bottom; //Empuja el contenido hacia arriba cuando aparece el teclado.

    return Scaffold(
        appBar: AppBar(
          title: const Text('sendreport.title').tr(),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus
              ?.unfocus(), //Se oculta el teclado cuando detecta algun gesto en cualquier lugar de la pantalla
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(bottom: bottom),
            child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: ('sendreport.subject').tr(),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required.';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: messageController,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: ('sendreport.message').tr(),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required.';
                            }
                            return null;
                          }),
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

                              sendReport(
                                  emailController.text,
                                  subjectController.text,
                                  messageController.text);
                            }
                          },
                          child: const Text('sendreport.sendButton').tr())
                    ],
                  ),
                )),
          ),
        ));
  }

  Future<void> sendReport(email, subject, message) async {
    try {
      UserPreferences userPreferences = UserPreferences();
      Map args = ModalRoute.of(context)!.settings.arguments as Map;
      var activity = args['activity'].toString();
      var finalAct = activity;
      var userId = args['userID'];
      var userid = userId.toString();
      var userToken = args['userToken'];
      var usertoken = userToken.toString();
      var firstDate = args['firstDate'];
      var lastDate = args['lastDate'];
      debugPrint('entro a esta parte' + finalAct + userid);
      if (finalAct == '1') {
        final response =
            await http.post(Uri.parse('$globalURL/send/userhoursreport/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'Email': email,
                  'UserID': userid,
                  'Date1': firstDate,
                  'Date2': lastDate,
                  'Subject': subject,
                  'Message': message,
                  'Token': usertoken
                }));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const WillPopScope(
                  onWillPop: _onWillPop, child: AlertSendReport());
            });
      }
      if (finalAct == '2') {
        final response =
            await http.post(Uri.parse('$globalURL/send/usermodifications/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'Email': email,
                  'UserID': userid,
                  'Date1': firstDate,
                  'Date2': lastDate,
                  'Subject': subject,
                  'Message': message,
                  'Token': usertoken
                }));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const WillPopScope(
                  onWillPop: _onWillPop, child: AlertSendReport());
            });
      }
      if (finalAct == '3') {
        final response =
            await http.post(Uri.parse('$globalURL/send/usershoursreport/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'Email': email,
                  'Date1': firstDate,
                  'Date2': lastDate,
                  'Subject': subject,
                  'Message': message,
                  'Token': usertoken
                }));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const WillPopScope(
                  onWillPop: _onWillPop, child: AlertSendReport());
            });
      }
      if (finalAct == '4') {
        final response =
            await http.post(Uri.parse('$globalURL/send/usersmodifications/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'Email': email,
                  'Date1': firstDate,
                  'Date2': lastDate,
                  'Subject': subject,
                  'Message': message,
                  'Token': usertoken
                }));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const WillPopScope(
                  onWillPop: _onWillPop, child: AlertSendReport());
            });
      }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerError();
          });
    }
  }
}
