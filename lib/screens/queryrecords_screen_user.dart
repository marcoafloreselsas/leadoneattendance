import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<QueryRecord> fetchQueryRecord() async {
  //REVIEW Estos son los posibles parámetros para las consultas, agregados el 27 de abril, revisar.
  final queryParameters = {
    'param1': 'one',
    'param2': 'two',
  };

//http request GET
  final response = await http.get(Uri.parse(
      'https://e5ac-45-65-152-57.ngrok.io/get/record/1/2022-02-11/1'));
  if (response.statusCode == 200) {
    return QueryRecord.fromJson(jsonDecode(response.body)[0]);
    //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
  } else {
    throw Exception('Failed to load record.');
  }
}

class QueryRecordsScreen extends StatefulWidget {
  const QueryRecordsScreen({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreen> createState() => _QueryRecordsScreenState();
}

class _QueryRecordsScreenState extends State<QueryRecordsScreen> {
  late Future<QueryRecord> futureQueryRecord;
  DateTime selectedDate = DateTime.now();
  final firstDate =
      DateTime(2022, 2); //A partir de que fecha funciona el calendario
  final lastDate = DateTime.now(); //Hasta que fecha funciona el calendario

  @override
  void initState() {
    super.initState();
    futureQueryRecord = fetchQueryRecord();
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
          CalendarDatePicker(
            initialDate: selectedDate, //Fecha por default, será la actual.
            firstDate: firstDate, //Desde que fecha funciona el calendario.
            lastDate: lastDate, //Hasta que fecha funciona el calendario.
            onDateChanged: (DateTime value) {}, // Si la fecha cambia.
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

//NOTE Esta sección, es el listtile que carga el registro seleccionado.
          FutureBuilder<QueryRecord>(
            future: futureQueryRecord,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      //ListTile que muestra la fecha y texto Record Date del registro consultado.
                      ListTile(
                          title: Text((convertirFecha(
                              snapshot.data!.recordDate))), //fecha del registro
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              const Icon(
                                Icons.arrow_upward_outlined,
                                color: AppTheme.green,
                              ), // icon-1
                              Text(
                                ((convertirHora(snapshot.data!.entryTime))),
                                style: const TextStyle(
                                    fontSize: 18), //hora de entrada
                              ),
                              const Icon(
                                Icons.arrow_downward_outlined,
                                color: AppTheme.red,
                              ), // icon-2
                              Text(
                                ((convertirHora(snapshot.data!.exitTime))),
                                style: const TextStyle(
                                    fontSize: 18), //hora de salida
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayRecordScreenUser()));
                          })
                    ],
                  ),
                );
              } else {
                //NOTE En lo que carga o detecta el registro, aparecerá este Circular Progress Indicator.
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

//ANCHOR METODOS Y OTRAS COSAS
  //NOTE: Método para convertir 17:30:00 a 17:30
  String convertirHora(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //debugPrint(tiempoFinal); Imprime en consola las horas obtenidas.
    //resultado= 17:30
    return tiempoFinal;
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
