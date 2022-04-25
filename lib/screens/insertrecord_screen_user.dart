import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertRecordScreenUser extends StatefulWidget {
  const InsertRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<InsertRecordScreenUser> createState() => _InsertRecordScreenUserState();
}

class _InsertRecordScreenUserState extends State<InsertRecordScreenUser> {
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  bool switchValue = true;

  getUsers() async {
    http.Response response = await http.get(Uri.parse('https://eb95-45-65-152-57.ngrok.io/get/fiverecords/1'));
    debugPrint(response.body);
  }

  // Initial Selected Value
  // String dropdownvalue = 'insertrecords.TRattendance'.tr();

  // // List of items in our dropdown menu
  // var items = [
  //   'insertrecords.TRattendance'.tr(),
  //   'insertrecords.TRlunch'.tr(),
  //   'insertrecords.TRovertime'.tr(),
  //   'insertrecords.TRpermit'.tr(),
  // ];
  String dropdownvalue = 'Attendance';

  // List of items in our dropdown menu
  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];
//Sobreescritura de la clase y del widget
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('insertrecords.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                },
                icon: const Icon(Icons.add_outlined)),
          ]),
      body: Card(
        //Calendario para seleccionar una fecha.
        child: Column(
          children: [
            //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
            Row(
              children: [
                const Text('insertrecords.selectDate').tr(),
                const Icon(Icons.keyboard_arrow_down_outlined),
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
              children: [
                const Text('insertrecords.selectTime').tr(),
                const Icon(Icons.keyboard_arrow_down_outlined),
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
                const Text('insertrecords.typeRecord').tr(),
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
                    });
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            //SWITCH
            Row(children: [
              const Text('insertrecords.in').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              buildSwitch(), //WIDGET DEL SWITCH
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('insertrecords.out').tr(),
            ], mainAxisAlignment: MainAxisAlignment.center),
            const SizedBox(
              height: 20,
            ),
            //BOTON DE GUARDAR CAMBIOS
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    primary: Colors.white, //TEXT COLOR
                    minimumSize: const Size(120, 50) //TAMANO - WH
                    ),
                onPressed: () {
                  insertRecord;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                },
                child: const Text('insertrecords.saveButton').tr())
          ],
        ),
      ),
    );
  }

//Widget del Switch
  Widget buildSwitch() => Transform.scale(
        scale: 2,
        child: Switch.adaptive(
            activeColor: AppTheme.red,
            activeTrackColor: Colors.red[200],
            inactiveThumbColor: AppTheme.green,
            inactiveTrackColor: Colors.green[200],
            value: switchValue,
            onChanged: (valorSwitch) => setState(() => switchValue = valorSwitch)),
      );

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

//Abril 25 de 2022
//Método para insertar registro.
  insertRecord(DateTime dateRecord, timeRecord, String tipoActividad, bool valorSwitch) async {
    DateTime RecordDate = dateRecord; //Fecha del Registro
    DateTime EntryTime = timeRecord; //Hora de Inicio
    DateTime ExitTime = timeRecord; //Hora de Términoi
    String RecordType = tipoActividad; //Tipo de Registro
    bool switchInOut = valorSwitch; //In - Out Switch - Si el switch está en false, es IN.
    //                - Si el switch está en true, es OUT.
    switch (tipoActividad) {
      case 'Attendance':
          if (switchInOut == false) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/insertrecord'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserID" : 1,
                  "RecordDate" : dateRecord,
                  "EntryTime" : timeRecord,
                  "ExitTime" : '17:30',
                  "RecordTypeID" : 1 
                }));
                debugPrint('holamundo');
            //RecordDate
            //Entry Time
          } else if (switchInOut == true) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/insertrecord'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord ,
                  "ExitTime" : timeRecord,
                  "RecordTypeId" : 1
                }));
            //RecordDate
            //ExitTime
          
        }
        break;
      case 'Lunch':
          if (switchInOut == false) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord,
                  "EntryTime" : timeRecord,
                  "RecordTypeId" : 2 
                }));

            //RecordDate
            //Entry Time
          } else if (switchInOut == true) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord ,
                  "ExitTime" : timeRecord,
                  "RecordTypeId" : 2
                }));
            //RecordDate
            //ExitTime
        }
        break;
      case 'Overtime':
          if (switchInOut == false) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord,
                  "EntryTime" : timeRecord,
                  "RecordTypeId" : 3
                }));
            //RecordDate
            //Entry Time
          } else if (switchInOut == true) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord ,
                  "ExitTime" : timeRecord,
                  "RecordTypeId" : 3
                }));
            //RecordDate
            //ExitTime
        }
        break;
      case 'Permit':
          if (switchInOut == false) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord,
                  "EntryTime" : timeRecord,
                  "RecordTypeId" : 4 
                }));
            //RecordDate
            //Entry Time
          } else if (switchInOut == true) {
            final response = await http.post(
                Uri.parse('https://7a40-45-65-152-57.ngrok.io/Records'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "UserId" : 1,
                  "RecordDate" : dateRecord ,
                  "ExitTime" : timeRecord,
                  "RecordTypeId" : 4
                }));
            //RecordDate
            //ExitTime
        }
        break;
      default:
    }
  }
}
