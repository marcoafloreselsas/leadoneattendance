import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
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
  Future<EditRecord>? _futureEditRecord;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  String finaltime = '';
  String finalfinal = '';
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



//Para cuando se edita el registro.
  Future<EditRecord> createEditRecord(
      String RecordDate, int FinalRecordTypeId, String Time) async {
    final response = await http.post(
      Uri.parse('https://ecdf-45-65-152-57.ngrok.io/insertrecord/'),
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
      return EditRecord.fromJson(jsonDecode(response.body));
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
  }
//PARA OBTENER LOS DATOS Y CARGARLOS EN LA PANTALLA
  Future<FullRecorde> fetchFullRecord() async {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    var x = args['RecordDate']; //RecordDate
    var y = args['RecordTypeId'].toString();
    print(x);
    final response = await http.get(Uri.parse(
        'https://ecdf-45-65-152-57.ngrok.io/get/record/1/$x/$y'));
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
                    //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
                    ListTile(
                      title: Text((convertirFecha(snapshot.data!.RecordDate)),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24)),
                      subtitle: Text(
                        'displayrecords.recordDate'.tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),


                    // ignore: todo
                    //TIPO DE ACTIVIDAD ---- TODO FALTA COMPLEMENTAR 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(determinarActividad(y.toString()), style: const TextStyle(fontSize: 20)),
                        const Text('Type of Record')
                      ],
                    ),

                    Row(
                      children: const [
                        Text('Select Date'),
                        Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    ListTile(
                      title: Text(
                        "${(formatearAnio(snapshot.data!.RecordDate))}, ${(formatearMes(snapshot.data!.RecordDate))}, ${(formatearDia(snapshot.data!.RecordDate))}",
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
                        "${(formatearHora(snapshot.data!.EntryTime))}:${(formatearMinutos(snapshot.data!.EntryTime))}",
                        textAlign: TextAlign.center,
                      ),
                      onTap: _pickTime,
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
                          //Si el si
                          
                        },
                        child: const Text('Save and Print')),
                        
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

  determinarActividad(String s) {
  // you can adjust this values according to your accuracy requirements 
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
        finalfinal = finaltime;
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
