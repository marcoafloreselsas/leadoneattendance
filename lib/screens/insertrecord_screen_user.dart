//NOTA DE EDICIÓN • MAYO 10 DE 2022
//changeTime será para validar que el usuario haya dado onTap al Time. si no, tome el valor del date.now de la vista.
//Falta implementar en el botón.

// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leadoneattendance/screens/screens.dart';
import 'dart:convert';
import '../dialogs/dialogs.dart';

class InsertRecordScreenUser extends StatefulWidget {
  const InsertRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<InsertRecordScreenUser> createState() => _InsertRecordScreenUserState();
}

class _InsertRecordScreenUserState extends State<InsertRecordScreenUser> {
  // ignore: unused_field
  Future<Future>? _futureInsertRecordEntry;
  // ignore: unused_field
  Future<Future>? _futureInsertRecordExit;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  String finaltime = '';
  String finalfinal = '';
  bool switchValue = false;
  bool isonisoff = false;
  int recordTypeId = 0;
  String? changeDate;
  String? changeTime;
  DateTime finalChangeDate = DateTime.parse('0000-00-00');

  String dropdownvalue = 'Attendance';
  // List of items in our dropdown menu
  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];

  //For when the start of an activity is marked.
  Future<Future> createEntryRecord(
      String RecordDate, int FinalRecordTypeId, String Time) async {
    UserPreferences userPreferences = UserPreferences();
    var userId = await userPreferences.getUserId();
    var userid = userId;
    final response = await http.post(
      Uri.parse('https://174e-45-65-152-57.ngrok.io/insertrecord/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "UserID": userid,
        "RecordDate": RecordDate,
        "RecordTypeID": FinalRecordTypeId,
        "EntryTime": Time
      }),
    );
    if (response.statusCode == 201) {
      return showDialog(
          context: context, builder: (_) => const AlertInsertRecordOk());
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return showDialog(
          context: context, builder: (_) => const AlertInsertRecordError());
    }
  }

//For when the end of an activity is marked.
  Future<Future> createExitRecord(
      String RecordDate, int FinalRecordTypeId, String Time) async {
    UserPreferences userPreferences = UserPreferences();
    var userId = await userPreferences.getUserId();
    var userid = userId;
    final response = await http.post(
      Uri.parse('https://174e-45-65-152-57.ngrok.io/insertrecord/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "UserID": userid,
        "RecordDate": RecordDate,
        "RecordTypeID": FinalRecordTypeId,
        "ExitTime": Time
      }),
    );

    if (response.statusCode == 201) {
      return showDialog(
          context: context, builder: (_) => const AlertInsertRecordOk());
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return showDialog(
          context: context, builder: (_) => const AlertInsertRecordError());
    }
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('insertrecord.title').tr(),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 15, 49, 114),
      ),
      body: Card(
        //Calendar to select a date.
        child: Column(
          children: [
            //LIST TILE WHERE THE DATE PICKER IS SHOWN, AND ITS ICON TO DISPLAY
            Row(
              children: [
                const Text('insertrecord.selectDate').tr(),
                const Icon(Icons.keyboard_arrow_down_outlined),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            ListTile(
              title: Text(
                changeDate == null
                ? "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}":
                    changeDate!,
                textAlign: TextAlign.center,
              ),
              onTap: _pickDate,
            ),
            //LIST TILE WHERE THE TIME PICKER IS SHOWN, AND ITS ICON TO DISPLAY
            Row(
              children: [
                const Text('insertrecord.selectTime').tr(),
                const Icon(Icons.keyboard_arrow_down_outlined),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            ListTile(
              title: Text(
                changeTime == null
                    ? "${time.hour}:${time.minute.toString().padLeft(2, '0')}"
                    : changeTime!,
                textAlign: TextAlign.center,
              ),
              onTap: _pickTime,
            ),
            //RECORD TYPE
            Row(
              children: [
                const Text('insertrecord.typeRecord').tr(),
                const Padding(padding: EdgeInsets.all(25.0)),
                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? tipoActividad) {
                    setState(() {
                      dropdownvalue = tipoActividad!;
                      recordTypeId = items.indexOf(tipoActividad);
                    });
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            //SWITCH
            Row(children: [
              const Text('insertrecord.in').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              Switch(
                  value: switchValue,
                  activeColor: Colors.red,
                  activeTrackColor: Colors.red[200],
                  inactiveThumbColor: const Color.fromARGB(255, 16, 94, 19),
                  inactiveTrackColor: Colors.green[200],
                  onChanged: (valorSwitch) => setState(() {
                        switchValue = valorSwitch;
                        isonisoff = valorSwitch;
                      })), //SWITCH WIDGET
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('insertrecord.out').tr(),
            ], mainAxisAlignment: MainAxisAlignment.center),
            const SizedBox(
              height: 20,
            ),
            //SAVE CHANGES BUTTON
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 15, 49, 114),
                    primary: Colors.white, //TEXT COLOR
                    minimumSize: const Size(120, 50) //TAMANO - WH
                    ),
                onPressed: () {
                  setState(() {});

                  // ignore: prefer_typing_uninitialized_variables
                  var Time;
                  // ignore: prefer_typing_uninitialized_variables
                  var RecordDate; //Fecha
                  var RecordTypeId2 = recordTypeId + 1;
                  var FinalRecordTypeId = RecordTypeId2; //Tipo de Actividad
                  var OnOff = isonisoff; //Switch


                  if (changeDate == null || changeTime == null) {
                    showDialog(context: context, builder: (BuildContext context){ return const AlertCompleteInfo();});
                  } else {
                    RecordDate = DateFormat('yyyy-MM-dd').format(finalChangeDate);
                    Time = finalfinal; //Hora
                                      //Si el si
                  if (OnOff == false) {
                    _futureInsertRecordEntry =
                        createEntryRecord(RecordDate, FinalRecordTypeId, Time);
                  } else if (OnOff == true) {
                    _futureInsertRecordExit =
                        createExitRecord(RecordDate, FinalRecordTypeId, Time);
                  }
                  }


                },
                child: const Text('insertrecord.saveButton').tr()),
          ],
        ),
      ),
    );
  }

//Function that displays the Date Picker.
  _pickDate() async {
    DateTime? dateRecord = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5));
    if (dateRecord != null) {
      setState(() {
        pickedDate = dateRecord;
        finalChangeDate = dateRecord;
        changeDate = DateFormat('yyyy-MM-dd').format(finalChangeDate);

      });
    }
  }

//Function displayed by the Time Picker.
  _pickTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (timeRecord != null) {
      setState(() {
        time = timeRecord;
        finaltime = '${time.hour}:${time.minute}';
        changeTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
        finalfinal = finaltime;
      });
    }
  }
}
