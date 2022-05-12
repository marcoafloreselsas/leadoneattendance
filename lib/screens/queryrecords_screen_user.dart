import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryRecordsScreenUser extends StatefulWidget {
  const QueryRecordsScreenUser({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreenUser> createState() => _QueryRecordsScreenUserState();
}

class _QueryRecordsScreenUserState extends State<QueryRecordsScreenUser> {
  Future<QueryRecord>? futureQueryRecord;
  DateTime pickedDate = DateTime.parse('0000-00-00');
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2022, 2); //A partir de que fecha funciona el calendario
  final lastDate = DateTime.now(); //Hasta que fecha funciona el calendario
  Future<QueryRecordAdmin>? futureQueryRecordAdmin;


  @override
  void initState() {
    super.initState();
        pickedDate = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
      Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      int userid = args!["UserID"];

    return Scaffold(
      appBar: AppBar(
          title: const Text('queryrecords.title').tr(),
          centerTitle: true,
          actions: const []),
      body: Column(
        children: [
              //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
              Row(
                children: [
                  const Text('queryrecords.selectDate').tr(),
                  const Icon(Icons.keyboard_arrow_down_outlined),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
                                      ListTile(
                title: Text(
                  "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                onTap: _pickDate,
              ),

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
                  setState(() {
                      fetchQueryRecord;
                  });
                  // var newRecordDate = DateFormat('yyyy-MM-dd').format(valueRegistro);
                    var finalRecordTypeID = 1;
                    var finalRecordDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    futureQueryRecord = fetchQueryRecord(finalRecordDate, finalRecordTypeID);
                    debugPrint(
                        finalRecordDate +
                        finalRecordTypeID.toString());
                },
                child: const Text('Save and Print')),
                
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
                              ), // icon-
                              
                              Text(
                                ((convertirHora(snapshot.data!.exitTime))),
                                style: const TextStyle(
                                    fontSize: 18), 
                                    //hora de salida
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
                                  debugPrint('El usuario es: ' + userid.toString());

                return const CircularProgressIndicator();
                
              }
            },
          )
        ],  
      ),   
    );
  }

Future<QueryRecord> fetchQueryRecord(String finalRecordDate, int finalRecordTypeID) async {
  UserPreferences userPreferences = UserPreferences();
  var userId = await userPreferences.getUserId();
  var userid = userId;
  var userToken = await userPreferences.getUserToken();
  var usertoken = userToken;
  // final userid = ModalRoute.of(context)!.settings.arguments;
  //Los siguientes, son los parámetros utilizados para cargar un registro.
  var RecordTypeID = finalRecordTypeID;
  var RecordDate = finalRecordDate;
  var s = usertoken.toString()+ "/"+ userid.toString() + "/" + RecordDate + "/" + RecordTypeID.toString();

//http request GET
  final response = await http.get(Uri.parse('https://beb7-45-65-152-57.ngrok.io/get/record/$s'));
  if (response.statusCode == 200) {
    return QueryRecord.fromJson(jsonDecode(response.body)[0]);
    //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
  } else {
    throw Exception('Failed to load record.');
  }
}
  //FUNCION QUE MUESTRA EL DATE PICKER
  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
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