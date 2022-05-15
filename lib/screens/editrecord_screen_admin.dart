// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditRecordScreenAdmin extends StatefulWidget {
  const EditRecordScreenAdmin({Key? key}) : super(key: key);

  @override
  State<EditRecordScreenAdmin> createState() => _EditRecordScreenAdminState();
}

class _EditRecordScreenAdminState extends State<EditRecordScreenAdmin> {
  Future<FullRecorde>? futureRecord;
  // ignore: unused_field
  Future<Future>? _futureEditRecord;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay entrytime;
  late TimeOfDay exittime;
  String defaultEntryDate = '';
  String finaltimeentry = '';
  String finaltimeexit = '';
  String finaltimedefault = '';
  String finalfinalentry = '';
  String finalfinalexit = '';
  String finalfinaldefault = '';
  bool switchValue = false;
  bool isonisoff = false;
  int recordTypeId = 0;
  String dropdownvalue = 'Attendance';

  // List of items in our dropdown menu
  String? changeEntryTime;
  String? changeFinalTime;

  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];

//Para cuando se edita el registro.
  Future<Future> createEditRecord(String RecordDate, String RecordTypeId,
      String EntryTime, ExitTime) async {
    UserPreferences userPreferences = UserPreferences();
    var userId = await userPreferences.getUserId();
    var userid = userId;
    final response = await http.put(
      Uri.parse(' /update/record'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "UserID": userid,
        "RecordDate": RecordDate,
        "RecordTypeID": RecordTypeId,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime
      }),
    );
    if (response.statusCode == 201) {
      return showDialog(
          context: context, builder: (_) => const AlertEditRecordOk());
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create record.');
    }
  }

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
    entrytime = TimeOfDay.now();
    exittime = TimeOfDay.now();
  }

//TO GET THE DATA AND LOAD IT ON THE SCREEN
  Future<FullRecorde> fetchFullRecord() async {
    UserPreferences userPreferences = UserPreferences();
    var userId = await userPreferences.getUserId();
    var userid = userId;
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var x = args['RecordDate']; //RecordDate
    var y = args['RecordTypeId'].toString();
    final response = await http.get(Uri.parse(' /get/record/$userid/$x/$y'));
    if (response.statusCode == 200) {
      return FullRecorde.fromJson(jsonDecode(response.body)[0]);
      //The [0], is to ignore that the json does not have a RECORD header.
    } else {
      throw Exception('Failed to load record.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var x = args['RecordDate']; //RecordDate
    var y = args['RecordTypeId'].toString();
    return Scaffold(
        appBar: AppBar(
            title: const Text('editrecord.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('alerts.alert0').tr(),
                              content: const Text('alerts.alert2').tr(),
                              actions: [
                                //Botón "Cancelar".
                                TextButton(
                                  child:
                                      const Text('alerts.alertResponse2').tr(),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                //Botón "Modificar"
                                TextButton(
                                  child:
                                      const Text('alerts.alertResponse1').tr(),
                                  onPressed: () {},
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.add_outlined)),
            ]),
        body: FutureBuilder<FullRecorde>(
          future: futureRecord,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Card(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text((convertDate(snapshot.data!.RecordDate)),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28)),
                      subtitle: Text(
                        determineActivity(y.toString()),
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //List Tile that loads the entry time of the consulted record,
                    //when pressed, you can assign a new time.
                    Row(
                      children: [
                        const Text('editrecord.entryTime').tr(),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    ListTile(
                      title: Text(
                        changeEntryTime == null
                            ? "${(formatHour(snapshot.data!.EntryTime))}:${(formatMinutes(snapshot.data!.EntryTime))}"
                            : changeEntryTime!,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onTap: _pickEntryTime,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //List Tile that loads the ExitTime of the consulted record, when pressed,
                    // you can assign a new time.
                    Row(
                      children: [
                        const Text('editrecord.exitTime').tr(),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    ListTile(
                      title: Text(
                        changeFinalTime == null
                            ? "${(formatHour(snapshot.data!.ExitTime))}:${(formatMinutes(snapshot.data!.ExitTime))}"
                            : changeFinalTime!,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onTap: _pickExitTime,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //SAVE CHANGES BUTTON
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 15, 49, 114),
                            primary: Colors.white, //TEXT COLOR
                            minimumSize: const Size(120, 50) //TAMANO - WH
                            ),
                        onPressed: () {
                          setState(() {});
                          if (changeEntryTime == null &&
                              changeFinalTime == null) {
//Alert Dialog that does not allow to send the information,
//since the information to be sent is the same that is stored.
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    const AlertEditRecordErrorTwo());
                          } else if (changeEntryTime == null) {
                            var RecordDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(x)); //Fecha
                            var RecordTypeId = y;
                            var EntryTime =
                                "${(formatHour(snapshot.data!.EntryTime))}:${(formatMinutes(snapshot.data!.EntryTime))}";
                            var ExitTime = finalfinalexit;
                            _futureEditRecord = createEditRecord(
                                RecordDate, RecordTypeId, EntryTime, ExitTime);
                          } else if (changeFinalTime == null) {
                            var RecordDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(x)); //Fecha
                            var RecordTypeId = y;
                            var EntryTime = finalfinalentry;
                            var ExitTime =
                                "${(formatHour(snapshot.data!.ExitTime))}:${(formatMinutes(snapshot.data!.ExitTime))}";
                            _futureEditRecord = createEditRecord(
                                RecordDate, RecordTypeId, EntryTime, ExitTime);
                          } else {
                            var RecordDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(x)); //Fecha
                            var RecordTypeId = y;
                            var EntryTime = finalfinalentry;
                            var ExitTime = finalfinalexit;
                            _futureEditRecord = createEditRecord(
                                RecordDate, RecordTypeId, EntryTime, ExitTime);
                          }
                        },
                        child: const Text('editrecord.saveButton').tr()),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  formatHour(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = tiempo[0];
    //result= 17:30
    return tiempoFinal;
  }

  formatMinutes(String minutos) {
    final tiempo = minutos.split(':');
    String tiempoFinal = tiempo[1];
    //result= 17:30
    return tiempoFinal;
  }

//Depending on the RecordTypeId displayed on the screen, this is the text that
//will appear under the RecordDate
  determineActivity(String s) {
    String r = s;
    switch (r) {
      case "1":
        return 'Attendance';
      case "2":
        return 'Lunch';
      case "3":
        return 'Overtime';
    }
  }

//Function that displays the Time Picker for ENTRY.
  _pickEntryTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: entrytime,
    );
    if (timeRecord != null) {
      setState(() {
        entrytime = timeRecord;
        finaltimeentry =
            '${entrytime.hour}:${entrytime.minute.toString().padLeft(2, '0')}';
        changeEntryTime =
            '${entrytime.hour}:${entrytime.minute.toString().padLeft(2, '0')}';
        finalfinalentry = finaltimeentry;
      });
    }
  }

//Function that displays the Time Picker for the EXIT.
  _pickExitTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: exittime,
    );
    if (timeRecord != null) {
      setState(() {
        exittime = timeRecord;
        finaltimeexit =
            '${exittime.hour}:${exittime.minute.toString().padLeft(2, '0')}';
        changeFinalTime =
            '${exittime.hour}:${exittime.minute.toString().padLeft(2, '0')}';
        finalfinalexit = finaltimeexit;
      });
    }
  }

//NOTE: Function to convert 2022-04-08T05:00:00:00.000Z to Apr 8, 2022
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
    //result: Abril 8, 2022
    return fechaFinal;
  }
}
