// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportViewerScreen extends StatefulWidget {
  const ReportViewerScreen({Key? key}) : super(key: key);

  @override
  State<ReportViewerScreen> createState() => ReportViewerScreenState();
}

class ReportViewerScreenState extends State<ReportViewerScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    
  }


  @override
  Widget build(BuildContext context) {
    determinarRuta() {
      Map args = ModalRoute.of(context)!.settings.arguments as Map;
      // var usertoken = miToken;
      var activity = args['activity'].toString();
      var userID = args['userID'].toString();
      var firstDate = args['firstDate'];
      var lastDate = args['lastDate'];
      var usertoken = args['userToken'];
      debugPrint('Estoy recibiendo:' +
          userID.toString() +
          activity.toString() +
          firstDate.toString() +
          lastDate.toString() +
          usertoken.toString());
      if (activity == '1') {
        var s = userID.toString() + "/" + firstDate.toString() + "/" + lastDate.toString() + "/" + usertoken.toString();
        //Cuando la actividad es: INDIVIDUAL Attendance History
        debugPrint('Determinar ruta: INDIVIDUAL ATTENDANCE');
        // debugPrint('REPORT 1:' + userID + activity + firstDate + lastDate + usertoken);
        var ruta =
            'https://docs.google.com/viewer?url=$globalURL/pdf/userhoursreport/$s';
        debugPrint(ruta);
        return ruta;
        
      } if (activity == '2') {
        var s = userID.toString() + "/" + firstDate.toString() + "/" + lastDate.toString() + "/" + usertoken.toString();

        //Cuando la actividad es: INDIVIDUAL User Modifications
        debugPrint('Determinar ruta: INDIVIDUAL USER MODIFICATIONS');
        debugPrint('REPORT 2:' + userID + activity + firstDate + lastDate + usertoken);

        var ruta =
            'https://docs.google.com/viewer?url=$globalURL/pdf/usermodifications/$s';
        debugPrint(ruta);
        return ruta;
      } if (activity == '3') {
        var s = firstDate.toString() + "/" + lastDate.toString() + "/" + usertoken.toString();
        //Cuando la actividad es: GENERAL Attendance History
        debugPrint('Determinar ruta: GENERAL ATTENDANCE HISTORY');
        debugPrint('REPORT 3:' + userID + activity + firstDate + lastDate + usertoken);

        var ruta =
            'https://docs.google.com/viewer?url=$globalURL/pdf/usershoursreport/$s';
                    debugPrint(ruta);

        return ruta;
      } if (activity == '4') {
        var s = firstDate.toString() + "/" + lastDate.toString() + "/" + usertoken.toString();
        //Cuando la actividad es: GENERAL User Modifications
        debugPrint('Determinar ruta: GENERAL USER MODIFICATIONS');
        debugPrint('REPORT 4:' + userID + activity + firstDate + lastDate + usertoken);

        var ruta =
            'https://docs.google.com/viewer?url=$globalURL/pdf/usersmodifications/$s';
                debugPrint(ruta);

        return ruta;
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('reportviewer.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Map args = ModalRoute.of(context)!.settings.arguments as Map;
                    var userID = args['userID'].toString();
                    var activity = args['activity'].toString();
                    var firstDate = args['firstDate'];
                    var lastDate = args['lastDate'];
                    var userToken = args['userToken'];
                    debugPrint(
                        'REPORT:' + userID + activity + firstDate + lastDate);
                    Navigator.pushNamed(context, '/SendReportScreen',
                        arguments: {
                          'userID': userID,
                          'activity': activity,
                          'firstDate': firstDate,
                          'lastDate': lastDate,
                          'userToken':userToken
                        });
                  },
                  icon: const Icon(Icons.share_outlined)),
            ]),
        body: SafeArea(
            child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: determinarRuta(),
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
        ),      
      )
    );
  }
}
