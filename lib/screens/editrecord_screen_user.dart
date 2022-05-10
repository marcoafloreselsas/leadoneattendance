import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditRecordScreenUser extends StatefulWidget {
  const EditRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<EditRecordScreenUser> createState() => _EditRecordScreenUserState();
}

class _EditRecordScreenUserState extends State<EditRecordScreenUser> {
  Future<FullRecorde>? futureRecord;
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
  String finalfinaldefault = '' ;
  bool switchValue = false;
  bool isonisoff = false;
  int recordTypeId = 0;
  String dropdownvalue = 'Attendance';
  
  // List of items in our dropdown menu


String? changeEntryTime;
String? changeFinalTime;
// String? firstEntryTime;

  var items = [
    'Attendance',
    'Lunch',
    'Overtime',
    'Permit',
  ];



//Para cuando se edita el registro.
  Future<Future> createEditRecord(
      String RecordDate, String RecordTypeId, String EntryTime, ExitTime) async {
    final response = await http.put(
      Uri.parse('https://c4da-45-65-152-57.ngrok.io/update/record'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "UserID": 1,
        "RecordDate": RecordDate,
        "RecordTypeID": RecordTypeId,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime
      }),
    );
    if (response.statusCode == 201) {
            return showDialog(context: context, builder:(_) => const AlertEditRecordOk());
      
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
//PARA OBTENER LOS DATOS Y CARGARLOS EN LA PANTALLA
  Future<FullRecorde> fetchFullRecord() async {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var x = args['RecordDate']; //RecordDate
    var y = args['RecordTypeId'].toString();
    final response = await http.get(Uri.parse(
        'https://c4da-45-65-152-57.ngrok.io/get/record/1/$x/$y'));
    if (response.statusCode == 200) {
      return FullRecorde.fromJson(jsonDecode(response.body)[0]);
      //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
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
            title: const Text('editrecords.title').tr(),
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
                //Calendario para seleccionar una fecha.
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
                    ListTile(
                      title: Text((convertirFecha(snapshot.data!.RecordDate)),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28)),
                      subtitle: Text(determinarActividad(y.toString()),style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
  //List Tile que carga la hora de entrada del registro consultado, al presionar, puede asignar una nueva hora.
                    Row(
                      children:const [
                        Text('Entry Time'), 
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    ListTile(
                      title: Text(
                        changeEntryTime == null?
                        "${(formatearHora(snapshot.data!.EntryTime))}:${(formatearMinutos(snapshot.data!.EntryTime))}":changeEntryTime!,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onTap: _pickEntryTime,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
  //List Tile que carga la hora de salida del registro consultado, al presionar, puede asignar una nueva hora.
                    Row(
                      children: const [
                        Text('Exit Time'),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    ListTile(
                      title: Text(
                        changeFinalTime == null?
                        "${(formatearHora(snapshot.data!.ExitTime))}:${(formatearMinutos(snapshot.data!.ExitTime))}":changeFinalTime!,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onTap: _pickExitTime,
                    ),
                    //TIPO DE REGISTRO
                    const SizedBox(
                      height: 20,
                    ),
                    //BOTON DE GUARDAR CAMBIOS
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 15, 49, 114),
                            primary: Colors.white, //TEXT COLOR
                            minimumSize: const Size(120, 50) //TAMANO - WH
                            ),
                        onPressed: () {
                          setState(() {});
                          if( changeEntryTime == null && changeFinalTime == null ){
                            //ALERT DIALOG QUE NO PERMITA ENVIAR
                            showDialog(context: context, builder:(_) => const AlertEditRecordErrorTwo());

                          } 
                          else if( changeEntryTime == null ) 
                          {
                          var RecordDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(x)); //Fecha
                          var RecordTypeId = y;
                          var EntryTime = "${(formatearHora(snapshot.data!.EntryTime))}:${(formatearMinutos(snapshot.data!.EntryTime))}";
                          var ExitTime = finalfinalexit;
                          _futureEditRecord = createEditRecord(RecordDate, RecordTypeId , EntryTime, ExitTime);
                          debugPrint('El registro del día ' + RecordDate + ' Entry: ' + EntryTime + ' Exit: ' + ExitTime);
                          } 
                          else if( changeFinalTime == null )
                          {
                          var RecordDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(x)); //Fecha
                          var RecordTypeId = y;
                          var EntryTime = finalfinalentry;
                          var ExitTime = "${(formatearHora(snapshot.data!.ExitTime))}:${(formatearMinutos(snapshot.data!.ExitTime))}";
                          _futureEditRecord = createEditRecord(RecordDate, RecordTypeId , EntryTime, ExitTime);
                          debugPrint('El registro del día ' + RecordDate + ' Entry: ' + EntryTime + ' Exit: ' + ExitTime);
                          } else {
                          var RecordDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(x)); //Fecha
                          var RecordTypeId = y;
                          var EntryTime = finalfinalentry;
                          var ExitTime = finalfinalexit;
                          _futureEditRecord = createEditRecord(RecordDate, RecordTypeId , EntryTime, ExitTime);
                          debugPrint('El registro del día ' + RecordDate + ' Entry: ' + EntryTime + ' Exit: ' + ExitTime);
                          }                        
                        // _futureEditRecord = createEditRecord(RecordDate, FinalRecordTypeId, Time);
                        },
                        child: const Text('editrecords.saveButton').tr()),
                        
                  ],
                ),
              );
              
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  formatearDia(String dia) {
    var diap = dia;
    final parsearFecha = DateTime.parse(diap);
    var fechaFinal = "${parsearFecha.day}";
    return fechaFinal;
  }
  formatearMes(String mes) {
    var mesp = mes;
    final parsearFecha = DateTime.parse(mesp);
    var fechaFinal = "${parsearFecha.month}";
    return fechaFinal;
  }
  formatearAnio(String anio) {
    var aniop = anio;
    final parsearFecha = DateTime.parse(aniop);
    var fechaFinal = "${parsearFecha.year}";
    return fechaFinal;
  }
  formatearHora(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = tiempo[0];
    //debugPrint(tiempoFinal); Imprime en consola las horas obtenidas.
    //resultado= 17:30
    return tiempoFinal;
  }
  formatearMinutos(String minutos) {
    final tiempo = minutos.split(':');
    String tiempoFinal = tiempo[1];
    //debugPrint(tiempoFinal); Imprime en consola las horas obtenidas.
    //resultado= 17:30
    return tiempoFinal;
  }

//Según el RecordTypeId que se despliegue en pantalla, es el texto que aparecerá debajo del RecordDate
  determinarActividad(String s) {
  String r  = s;
  switch (r) {
    case "1":
    return 'Attendance';
    case "2": 
    return 'Lunch';
    case "3":
    return 'Overtime';
  }
}

//Función que muestra el Time Picker para la ENTRADA.
  _pickEntryTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: entrytime,
    );
    if (timeRecord != null) {
      setState(() {
        entrytime = timeRecord;
        // DateTime newDateTime = DateTime(time.hour,time.minute);
        finaltimeentry = '${entrytime.hour}:${entrytime.minute.toString().padLeft(2,'0')}';
        changeEntryTime = '${entrytime.hour}:${entrytime.minute.toString().padLeft(2,'0')}';
        finalfinalentry = finaltimeentry;
      });
    } else{
    }
  }

//Función que muestra el Time Picker para la SALIDA.
  _pickExitTime() async {
    TimeOfDay? timeRecord = await showTimePicker(
      context: context,
      initialTime: exittime,
    );
    if (timeRecord != null) {
      setState(() {
        exittime = timeRecord;
        finaltimeexit = '${exittime.hour}:${exittime.minute.toString().padLeft(2,'0')}';
        // DateTime newDateTime = DateTime(time.hour,time.minute);
        changeFinalTime = '${exittime.hour}:${exittime.minute.toString().padLeft(2,'0')}';
        finalfinalexit = finaltimeexit;
      });
    }
  }
  
//NOTE: Método para convertir 2022-04-08T05:00:00.000Z a Abril 8, 2022
  String convertirFecha(String fecha) {
    String date = fecha;
    String? mes;
    String? fechaFinal;
    final parsearFecha = DateTime.parse(date);
    //final formatoFecha = DateFormat('MMMM dd, yyyy').format(parsearFecha);
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
    // debugPrint(fechaFinal);  Imprime en consola las fechas obtenidas.
    //resultado: Abril 8, 2022
    return fechaFinal;
  }
}
