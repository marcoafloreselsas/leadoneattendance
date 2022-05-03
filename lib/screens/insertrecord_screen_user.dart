import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<InsertRecordEntry> createEntryRecord(String RecordDate, FinalRecordTypeId, Time) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'UserID': '1',
      'RecordDate': RecordDate,
      'FinalRecordTypeId': FinalRecordTypeId,
      'EntryTime': Time
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return InsertRecordEntry.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create record.');
  }
}
Future<InsertRecordExit> createExitRecord(String RecordDate, FinalRecordTypeId, Time) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'UserID': '1',
      'RecordDate': RecordDate,
      'FinalRecordTypeId': FinalRecordTypeId,
      'ExitTime': Time
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return InsertRecordExit.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create record.');
  }
}

class InsertRecordScreenUser extends StatefulWidget {
  const InsertRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<InsertRecordScreenUser> createState() => _InsertRecordScreenUserState();
}

class _InsertRecordScreenUserState extends State<InsertRecordScreenUser> {
  Future<InsertRecordEntry>? _futureInsertRecordEntry;
  Future<InsertRecordExit>? _futureInsertRecordExit;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  bool switchValue = false;
  bool isonisoff = false;
  int recordTypeId = 0;
  String dropdownvalue = 'Attendance';
  // List of items in our dropdown menu
  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];



  

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
                "${time.hour}:${time.minute}",
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
                  insertRecord();
                  // ignore: non_constant_identifier_names
                  var RecordDate = DateFormat('yMd').format(pickedDate);
                  // ignore: non_constant_identifier_names
                  var RecordTypeId2 = recordTypeId + 1;
                  // ignore: non_constant_identifier_names
                  var FinalRecordTypeId = RecordTypeId2.toString();
                  // ignore: non_constant_identifier_names
                  var OnOff = isonisoff;
                  // ignore: non_constant_identifier_names
                  var Time = time.toString().substring(10, 15);

                  if(OnOff == false){
                    _futureInsertRecordEntry = createEntryRecord(RecordDate, FinalRecordTypeId, Time);
                  } else if(OnOff == true) {
                    _futureInsertRecordExit = createExitRecord(RecordDate, FinalRecordTypeId, Time);
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
      });
    }
  }
  

//Este será el método encargado de gestionar la inserción
  insertRecord() {
    // ignore: non_constant_identifier_names
    var RecordDate = DateFormat('yMd').format(pickedDate);
    // ignore: non_constant_identifier_names
    var RecordTypeId2 = recordTypeId + 1;
    // ignore: non_constant_identifier_names
    var FinalRecordTypeId = RecordTypeId2.toString();
    // ignore: non_constant_identifier_names
    var OnOff = isonisoff;
    // ignore: non_constant_identifier_names
    var Time = time.toString().substring(10, 15);
 
    if (OnOff == false) {
      debugPrint('Es un entry: ' +
          RecordDate +
          ' - ' +
          FinalRecordTypeId +
          ' - ' +
          Time.toString());


          
    } else {
      debugPrint('Es un exit: ' +
          RecordDate +
          ' - ' +
          FinalRecordTypeId +
          ' - ' +
          Time.toString());
    }
  }
}