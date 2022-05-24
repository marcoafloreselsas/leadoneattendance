import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:leadoneattendance/globals.dart';

class DisplayRecordScreenAdmin extends StatefulWidget {
  const DisplayRecordScreenAdmin({Key? key}) : super(key: key);

  @override
  State<DisplayRecordScreenAdmin> createState() =>
      _DisplayRecordScreenAdminState();
}

class _DisplayRecordScreenAdminState extends State<DisplayRecordScreenAdmin> {
  Future<dynamic>? futureRecord;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        //aquí
        setState(() {
          futureRecord = fetchFullRecord();
        });
      },
    );
  }

  Future<dynamic> fetchFullRecord() async {
    // ignore: await_only_futures
    UserPreferences userPreferences = await UserPreferences();
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var recorddate = args['RecordDate'];
    var userid = args['UserID'];
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;
    var s = userid.toString() +
        '/' +
        recorddate.toString() +
        '/' +
        usertoken.toString();
    debugPrint('Registro a cargar: ' +
        userid.toString() +
        ' ' +
        recorddate.toString() +
        ' ' +
        usertoken.toString());
    final response =
        await http.get(Uri.parse('$globalURL/get/fulluserrecord/$s'));
    if (response.statusCode == 200) {
      return FullRecord.fromJson(jsonDecode(response.body)[0]);
      //The [0], is to ignore that the json does not have a RECORD header.
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerError();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var recorddate = args['RecordDate'];
    var userid = args['UserID'];
    // Query the stored data and assign it to the variable userId

    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar:
            //APP BAR
            AppBar(
          title: const Text('displayrecords.displayRecord').tr(),
          centerTitle: true,
        ),

        //IN THIS SECTION, THE INFORMATION OF THE SELECTED RECORD BEGINS.
        /* For layout purposes, there are three list tiles, which are the columns that show each activity,
          There is a wrap that allows you to add more than two icons and more than two text. 
          The spacing is the spacing that there will be between icons, independently of the texts. */
        body: FutureBuilder<dynamic>(
          future: futureRecord,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //ListTile that shows the date and Record Date text of the consulted record.
                    ListTile(
                      title: Text((convertirFecha(snapshot.data!.date)),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24)),
                      subtitle: Text(
                        'displayrecords.recordDate'.tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(),
//A From here, it is a list tile containing the 3 types of activity, their icons,
// texts obtained from the backend and styles.
                    ListTile(
                      title: Text("displayrecords.TRattendance".tr()),
                      trailing: Wrap(
                        spacing: 12, // Space between icons.
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ),
                          Text(
                            convertTime(snapshot.data!.entryTime1),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ),
                          Text(
                            convertTime(snapshot.data!.exitTime1),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/EditRecordScreenAdmin',
                            arguments: {
                              'RecordDate': recorddate,
                              'RecordTypeId': 1,
                              'UserID': userid
                            });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: Text("displayrecords.TRlunch".tr()),
                      trailing: Wrap(
                        spacing: 12, // Space between icons.
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ),
                          Text(
                            convertTime(snapshot.data!.entryTime2),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ),
                          Text(
                            convertTime(snapshot.data!.exitTime2),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (convertTime(snapshot.data!.entryTime2) == "00:00") {
                          showDialog(
                              context: context,
                              builder: (_) => const AlertEditRecordErrorOne());
                        } else {
                          Navigator.pushNamed(context, '/EditRecordScreenAdmin',
                              arguments: {
                                'RecordDate': recorddate,
                                'RecordTypeId': 2,
                                'UserID': userid
                              });
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: Text("displayrecords.TRovertime".tr()),
                      trailing: Wrap(
                        spacing: 12, // Space between icons.
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ),
                          Text(
                            convertTime(snapshot.data!.entrytime3),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ),
                          Text(
                            convertTime(snapshot.data!.exitTime3),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (convertTime(snapshot.data!.entrytime3) == "00:00") {
                          showDialog(
                              context: context,
                              builder: (_) => const AlertEditRecordErrorOne());
                        } else {
                          Navigator.pushNamed(context, '/EditRecordScreenAdmin',
                              arguments: {
                                'RecordDate': recorddate,
                                'RecordTypeId': 3,
                                'UserID': userid
                              });
                        }
                      },
                    ),

//NOTE Este código, es en el caso de los PERMIT, que no está disponible por el backend.
                    // ListTile(
                    //   title: Text("displayrecords.TRpermit".tr()),
                    //   trailing: Wrap(
                    //     spacing: 12, // Espacio entre dos íconos.
                    //     children: <Widget>[
                    //       const Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    //       Text(convertirHora(snapshot.data!.entrytime4), style: TextStyle(fontSize: 18),),
                    //       const Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    //       Text('17:30', style: TextStyle(fontSize: 18),)
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  //NOTE: Function to convert 17:30:00 to 17:30
  String convertTime(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //result = 17:30
    return tiempoFinal;
  }

//NOTE: Function to convert 2022-04-08T05:00:00:00.000Z to Apr 8, 2022
  String convertirFecha(String fecha) {
    String date = fecha;
    String? mes;
    String? fechaFinal;
    final parsearFecha = DateTime.parse(date);
    switch (parsearFecha.month) {
      case 01:
        mes = 'Jan';
        break;
      case 02:
        mes = 'Feb';
        break;
      case 03:
        mes = 'Mar';
        break;
      case 04:
        mes = 'Apr';
        break;
      case 05:
        mes = 'May';
        break;
      case 06:
        mes = 'Jun';
        break;
      case 07:
        mes = 'Jul';
        break;
      case 08:
        mes = 'Aug';
        break;
      case 09:
        mes = 'Sep';
        break;
      case 10:
        mes = 'Oct';
        break;
      case 11:
        mes = 'Nov';
        break;
      case 12:
        mes = 'Dec';
        break;
      default:
    }

    fechaFinal = "$mes ${parsearFecha.day}, ${parsearFecha.year}";
    //resultado: Apr 8, 2022
    return fechaFinal;
  }
}
