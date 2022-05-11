//NOTA DE EDICIÓN • MAYO 10 DE 2022
//changeTime será para validar que el usuario haya dado onTap al Time. si no, tome el valor del date.now de la vista.
//Falta implementar en el botón.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dialogs/dialogs.dart';


class InsertRecordScreenUser extends StatefulWidget {
  const InsertRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<InsertRecordScreenUser> createState() => _InsertRecordScreenUserState();
}

class _InsertRecordScreenUserState extends State<InsertRecordScreenUser> {
  Future<Future>? _futureInsertRecordEntry;
  Future<Future>? _futureInsertRecordExit;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  String finaltime = '';
  String finalfinal = '';
  bool switchValue = false;
  bool isonisoff = false;
  int recordTypeId = 0;
  String? changeTime;

  String dropdownvalue = 'Attendance';
  // List of items in our dropdown menu
  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];
  //Para cuando se marca el inicio de una actividad.
Future<Future> createEntryRecord(String RecordDate, int FinalRecordTypeId, String Time) async {
  final response = await http.post(
    Uri.parse('https://c4da-45-65-152-57.ngrok.io/insertrecord/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
    "UserID": 1,
    "RecordDate": RecordDate,
    "RecordTypeID": FinalRecordTypeId,
    "EntryTime": Time
    }),
  );
  if (response.statusCode == 201) {
    return showDialog(context: context, builder:(_) => const AlertInsertRecordOk());

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create record.');
  }
}
//Para cuando se marca la finalización de una actividad.
Future<Future> createExitRecord(String RecordDate, int FinalRecordTypeId, String Time) async {
  final response = await http.post(
    Uri.parse('https://c4da-45-65-152-57.ngrok.io/insertrecord/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
    "UserID": 1,
    "RecordDate": RecordDate,
    "RecordTypeID": FinalRecordTypeId,
    "ExitTime": Time
    }),
  );

  if (response.statusCode == 201) { 
    return showDialog(context: context, builder:(_) => const AlertInsertRecordOk());
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create record.');
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
        title: const Text('Insertar'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 15, 49, 114),
      ),
      body: Card(
        //Calendario para seleccionar una fecha.
        child: Column(
          children: [
            //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
            Row(
              children: const [
                Text('Select Date'),
                Icon(Icons.keyboard_arrow_down_outlined),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            ListTile(
              title: Text(
                "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",
                textAlign: TextAlign.center,
              ),
              //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
              onTap: _pickDate,
            ),
            //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
            Row(
              children: const [
                Text('Select Time'),
                Icon(Icons.keyboard_arrow_down_outlined),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            ListTile(
              title: Text(
                                        //Para que se vea como 17: 0 8
                "${time.hour}:${time.minute.toString().padLeft(2,'0')}",
                
                textAlign: TextAlign.center,
              ),
              onTap: _pickTime,
            ),
            //TIPO DE REGISTRO
            Row(
              children: [
                const Text('Type Record'),
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
              const Text('In'),
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
                      })), //WIDGET DEL SWITCH
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('Out'),
            ], mainAxisAlignment: MainAxisAlignment.center),
            const SizedBox(
              height: 20,
            ),
            //BOTON DE GUARDAR CAMBIOS
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 15, 49, 114),
                    primary: Colors.white, //TEXT COLOR
                    minimumSize: const Size(120, 50) //TAMANO - WH
                    ),
                onPressed: () {
                  setState(() {});
                  var RecordDate = DateFormat('yyyy-MM-dd').format(pickedDate); //Fecha
                  var RecordTypeId2 = recordTypeId + 1; 
                  var FinalRecordTypeId = RecordTypeId2; //Tipo de Actividad
                  var OnOff = isonisoff; //Switch
                  var Time = finalfinal; //Hora 

                  //Si el si
                  if(OnOff == false){
                    _futureInsertRecordEntry = createEntryRecord(RecordDate, FinalRecordTypeId, Time);
                    debugPrint('Es un entry: ' + RecordDate.toString() + ' - ' + FinalRecordTypeId.toString() + '- ' + Time);
                  } else if(OnOff == true) {
                    _futureInsertRecordExit = createExitRecord(RecordDate, FinalRecordTypeId, Time);
                    debugPrint('Es un exit: ' + RecordDate.toString() + ' - ' + FinalRecordTypeId.toString() + '- ' + Time);

                  }
                  
                },
                child: const Text('Save and Print')),
          ],
        ),
      ),
    );
  }

//Función que muestra el Date Picker.
  _pickDate() async {
    DateTime? dateRecord = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5));
    if (dateRecord != null) {
      setState(() {
        pickedDate = dateRecord;
      });
    }
  }

//Función que muestra el Time Picker.
  _pickTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (timeRecord != null) {
      setState(() {
        time = timeRecord;
        // DateTime newDateTime = DateTime(time.hour,time.minute);
        finaltime = '${time.hour}:${time.minute}';
        changeTime = '${time.hour}:${time.minute.toString().padLeft(2,'0')}';
        finalfinal = finaltime;
      });
    }
  }
}
