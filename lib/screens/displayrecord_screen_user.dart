import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayRecordScreenUser extends StatefulWidget {
  const DisplayRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<DisplayRecordScreenUser> createState() =>
      _DisplayRecordScreenUserState();
}

class _DisplayRecordScreenUserState extends State<DisplayRecordScreenUser> {
  Future<FullRecord>? futureRecord;
  String s = "";
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

  Future<FullRecord> fetchFullRecord() async {
    var args = ModalRoute.of(context)!.settings.arguments;
    var s = args; //RecordDate

    final response = await http.get(Uri.parse(
        'https://c4da-45-65-152-57.ngrok.io/get/fulluserrecord/1/$s'));
    if (response.statusCode == 200) {
      return FullRecord.fromJson(jsonDecode(response.body)[0]);
      //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
    } else {
      throw Exception('Failed to load record.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    var recordDate = args;
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar:
            //APP BAR
            AppBar(
          title: const Text('displayrecords.displayRecord').tr(),
          centerTitle: true,
        ),

        //EN ESTA SECCION, COMIENZA LA INFORMACION DEL REGISTRO SELECCIONADO
        /* Para fines de acomodo, hay cuatro list tile, que son las columnas que muestran cada actividad,
          Hay un Wrap que permite añadir más de dos íconos y más de dos texto. El spacing, es el espaciado
          que habrá entre íconos, independientemente de los textos. */
        body: FutureBuilder<FullRecord>(
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
                    //ListTile que muestra la fecha y texto Record Date del registro consultado.
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

//A partir de aquī, es un list tile que contiene los 4 tipos de actividad, sus íconos, textos obtenidos de backend y estilos.
                    ListTile(
                      title: Text("displayrecords.TRattendance".tr()),
                      trailing: Wrap(
                        spacing: 12, // Espacio entre dos íconos
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ), // icon-1
                          Text(
                            convertirHora(snapshot.data!.entryTime1),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ), // icon-2
                          Text(
                            convertirHora(snapshot.data!.exitTime1),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/EditRecordScreenUser',
                            arguments: {
                              'RecordDate': recordDate,
                              'RecordTypeId': 1
                            });
                      },
                    ),
                    const Divider(),

                    ListTile(
                      title: Text("displayrecords.TRlunch".tr()),
                      trailing: Wrap(
                        spacing: 12, // Espacio entre dos íconos
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ), // icon-1
                          Text(
                            convertirHora(snapshot.data!.entryTime2),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ), // icon-2
                          Text(
                            convertirHora(snapshot.data!.exitTime2),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        if(convertirHora(snapshot.data!.entryTime2) == "00:00"){
                          showDialog(context: context, builder:(_) => const AlertEditRecordErrorTwo());
                          print('Se cumplió el if');
                        } else{
                          Navigator.pushNamed(context, '/EditRecordScreenUser',
                            arguments: {
                              'RecordDate': recordDate,
                              'RecordTypeId': 2
                            });
                        }
                      },
                    ),
                    const Divider(),

                    ListTile(
                      title: Text("displayrecords.TRovertime".tr()),
                      trailing: Wrap(
                        spacing: 12, // Espacio entre dos íconos
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ), // icon-1
                          Text(
                            convertirHora(snapshot.data!.entrytime3),
                            style: TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ), // icon-2
                          Text(
                            convertirHora(snapshot.data!.exitTime3),
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        if(convertirHora(snapshot.data!.entrytime3) == "00:00"){
                          showDialog(context: context, builder:(_) => const AlertEditRecordErrorTwo());
                          print('Se cumplió el if');
                        } else{
                          Navigator.pushNamed(context, '/EditRecordScreenUser',
                            arguments: {
                              'RecordDate': recordDate,
                              'RecordTypeId': 3
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
              return const CircularProgressIndicator();
            }
            // By default, show a loading spinner.
          },
        ));
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
