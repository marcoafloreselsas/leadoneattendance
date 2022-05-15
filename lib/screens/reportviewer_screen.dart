import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
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
    Future<String?> obtenerToken() async {
      UserPreferences userPreferences = UserPreferences();
      var userToken = await userPreferences.getUserToken();
      return userToken;
    }

    var tokenInicial = obtenerToken.toString();

    convertirToken(String tokenInicial) {
      String tokenFinal = tokenInicial;
      return tokenFinal;
    }

    String miToken = convertirToken(tokenInicial);

    determinarRuta() {
      Map args = ModalRoute.of(context)!.settings.arguments as Map;
      // var usertoken = miToken;
      var activity = args['activity'].toString();
      var userID = args['userID'].toString();
      var firstDate = args['firstDate'];
      var lastDate = args['lastDate'];
      var usertoken = miToken;
      debugPrint('Estoy recibiendo:' +
          userID.toString() +
          activity.toString() +
          firstDate.toString() +
          lastDate.toString());
      if (activity == '1') {
        var s = userID + "/" + firstDate + "/" + lastDate;
        //Cuando la actividad es: INDIVIDUAL Attendance History
        debugPrint('Determinar ruta: INDIVIDUAL USER MODIFICATIONS');
        var ruta =
            'https://docs.google.com/viewer?url=https://f6a1-45-65-152-57.ngrok.io/pdf/userhoursreport/$s';
        return ruta;
      } else if (activity == '2') {
        var s = userID + "/" + firstDate + "/" + lastDate;

        //Cuando la actividad es: INDIVIDUAL User Modifications
        debugPrint('Determinar ruta: INDIVIDUAL USER MODIFICATIONS');
        var ruta =
            'https://docs.google.com/viewer?url=https://f6a1-45-65-152-57.ngrok.io/pdf/usermodifications/$s';
        return ruta;
      } else if (activity == '3') {
        var s = firstDate + "/" + lastDate;
        //Cuando la actividad es: GENERAL Attendance History
        debugPrint('Determinar ruta: GENERAL ATTENDANCE HISTORY');
        var ruta =
            'https://docs.google.com/viewer?url=https://f6a1-45-65-152-57.ngrok.io/pdf/usershoursreport/$s';
        return ruta;
      } else {
        var s = firstDate + "/" + lastDate;
        //Cuando la actividad es: GENERAL User Modifications
        debugPrint('Determinar ruta: GENERAL USER MODIFICATIONS');
        var ruta =
            'https://docs.google.com/viewer?url=https://f6a1-45-65-152-57.ngrok.io/pdf/usersmodifications/$s';
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
                    Map args =
                        ModalRoute.of(context)!.settings.arguments as Map;

                    var activity = args['userID'].toString();
                    var userID = args['activity'].toString();
                    var firstDate = args['firstDate'];
                    var lastDate = args['lastDate'];
                    debugPrint(
                        'REPORT:' + userID + activity + firstDate + lastDate);
                    Navigator.pushNamed(context, '/SendReportScreen',
                        arguments: {
                          'userID': userID,
                          'activity': activity,
                          'firstDate': firstDate,
                          'lastDate': lastDate
                        });
                  },
                  icon: const Icon(Icons.share_outlined)),
            ]),
        body: SafeArea(
            child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          // initialUrl: 'https://docs.google.com/viewer?url=https://beb7-45-65-152-57.ngrok.io/pdf/userhoursreport/1/2022-04-04/2022-04-08/',
          initialUrl: determinarRuta(),
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
        )));
  }
}
