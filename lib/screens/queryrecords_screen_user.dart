// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/variable.dart';
import '../dialogs/dialogs.dart';
import '../themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryRecordsScreenUser extends StatefulWidget {
  const QueryRecordsScreenUser({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreenUser> createState() => _QueryRecordsScreenUserState();
}

class _QueryRecordsScreenUserState extends State<QueryRecordsScreenUser> {
  Future<dynamic>? futureQueryRecord;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2022, 2); //As of what date does the calendar work
  final lastDate = DateTime.now(); //To what date does the calendar work
  Future<dynamic>? futureQueryRecordAdmin;
  String? changeDate;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('queryrecords.title').tr(),
          centerTitle: true,
          actions: const []),
      body: Column(
        children: [
                    const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(('queryrecords.selectDate').tr(), style: const TextStyle(
                    fontSize: 18.0,
                )),
              const Icon(Icons.keyboard_arrow_down_outlined),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text(
              changeDate == null
              ?"${pickedDate.year}-${pickedDate.month}-${pickedDate.day}":changeDate!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            onTap: _pickDate,
          ),
          const SizedBox(
            height: 10,
          ),
          //SAVE CHANGES BUTTON
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  primary: Colors.white, //TEXT COLOR
                  minimumSize: const Size(120, 50) //TAMANO - WH
                  ),
              onPressed: () {
                setState(() {
                  fetchQueryRecord;
                });
                var finalRecordTypeID = 1;
                var finalRecordDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                if(changeDate == null){
                  showDialog(context: context, builder: (BuildContext context){ return const AlertSelectDate();});
                }else{
                                  futureQueryRecord =
                    fetchQueryRecord(finalRecordDate, finalRecordTypeID);
                debugPrint(finalRecordDate + finalRecordTypeID.toString());
                }
              },
              child: const Text('queryrecords.apply').tr()),
                        const SizedBox(
            height: 20,
          ),
          const Divider(),
          const SizedBox(
            height:10,
          ),
          Row(
            children: [
              const Text('queryrecords.recentRecords',
                      style: TextStyle(fontSize: 20))
                  .tr()
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),

          const SizedBox(
            height: 10,
          ),

//This section is the listtile that loads the selected record.
          FutureBuilder<dynamic>(
            future: futureQueryRecord,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      //ListTile that shows the date and Record Date text of the consulted record.
                      ListTile(
                          title: Text((convertDate(
                              snapshot.data!.recordDate))), //date of record
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              const Icon(
                                Icons.arrow_upward_outlined,
                                color: AppTheme.green,
                              ), // icon-1
                              Text(
                                ((convertTime(snapshot.data!.entryTime))),
                                style:
                                    const TextStyle(fontSize: 18), //Entry Time
                              ),
                              const Icon(
                                Icons.arrow_downward_outlined,
                                color: AppTheme.red,
                              ), // icon-

                              Text(
                                ((convertTime(snapshot.data!.exitTime))),
                                style: const TextStyle(fontSize: 18),
                                //Exit Time
                              )
                            ],
                          ),
                          onTap: () {
                            /////////EIT
                            Navigator.pushNamed(
                              context,
                              '/DisplayRecordScreenUser',
                              arguments: convertDateArgument(
                                  snapshot.data!.recordDate),
                            );
                          })
                    ],
                  ),
                );
              } else {
                //NOTE While loading or detecting the log, this Circular Progress Indicator will appear.
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> fetchQueryRecord(
      String finalRecordDate, int finalRecordTypeID) async {
    UserPreferences userPreferences = UserPreferences();
    var userId = await userPreferences.getUserId();
    var userid = userId;
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;

//The following are the parameters used to load a record.
    var RecordTypeID = finalRecordTypeID;
    var RecordDate = finalRecordDate;
    var s = userid.toString() +
        "/" +
        RecordDate +
        "/" +
        RecordTypeID.toString() +
        "/" +
        usertoken.toString();

//http request GET
    final response = await http
        .get(Uri.parse('$globalURL/get/record/$s'));
    if (response.statusCode == 201) {
      return QueryRecord.fromJson(jsonDecode(response.body)[0]);
      //The [0], is to ignore that the json does not have a RECORD header.
    } if(response.statusCode == 400){
      showDialog(context: context, builder: (BuildContext context){
        return const AlertUnavailableRecord();
      });
    } else {
      throw Exception('Failed to load record.');
    }
  }

  //DATE PICKER
  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        pickedDate = date;
        changeDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  //NOTE: Método para convertir 17:30:00 a 17:30
  String convertTime(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //result = 17:30
    return tiempoFinal;
  }

//NOTE: Function to format the date received from the server and formatted to e.g. '2022-04-08'.
  String convertDateArgument(String fecha) {
    final parsearFecha = DateTime.parse(fecha);
    var fechafinalargumento = DateFormat('yyyy-MM-dd').format(parsearFecha);
    return fechafinalargumento;
  }

//NOTE: Method to convert 2022-04-08T05:00:00.000Z to Apr 8, 2022
  String convertDate(String fecha) {
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
    //result: Apr 8, 2022
    return fechaFinal;
  }
}
