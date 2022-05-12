import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<QueryRecordAdmin> fetchQueryRecordAdmin(
    int finalfinalUserID, String finalRecordDate, int finalRecordTypeID) async {
  //Los siguientes, son los parámetros utilizados para cargar un registro.
  var UserID = finalfinalUserID;
  var RecordTypeID = finalRecordTypeID;
  var RecordDate = finalRecordDate;
  var s = UserID.toString() + "/" + RecordDate + "/" + RecordTypeID.toString();
  // var s = UserID.toString() + RecordDate + RecordTypeID.toString();

//http request GET
  final response = await http
      .get(Uri.parse('https://beb7-45-65-152-57.ngrok.io/get/record/$s'));
  if (response.statusCode == 200) {
    return QueryRecordAdmin.fromJson(jsonDecode(response.body)[0]);
    //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
  } else {
    throw Exception('Failed to load record.');
  }
}

class QueryRecordsScreenAdmin extends StatefulWidget {
  const QueryRecordsScreenAdmin({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreenAdmin> createState() =>
      _QueryRecordsScreenAdminState();
}

class _QueryRecordsScreenAdminState extends State<QueryRecordsScreenAdmin> {
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  // Initial Selected Value
  List<GetUsers> users = [];
  Future<QueryRecordAdmin>? futureQueryRecordAdmin;
  GetUsers? selected;
  late int newuserid;

  Future<List<GetUsers>>? getData() async {
    const String url = 'https://beb7-45-65-152-57.ngrok.io/get/names';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json", 
        "accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<GetUsers>((json) => GetUsers.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  final myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    fetchAndShow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('queryrecords.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                     Navigator.pushNamed(context, '/SelectReportType'); 
                  },
                  icon: const Icon(Icons.description_outlined)),
            ]),
        body: Card(
          child: Column(
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
                  "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",
                  textAlign: TextAlign.center,
                ),
                onTap: _pickDate,
              ),
              Row(
                children: [
                  const Text('queryrecords.selectEmployee').tr(),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                children: [
                  DropdownButton<GetUsers?>(
                    onChanged: (GetUsers? newValue) {
                      setState(() {
                        selected = newValue!;
                      });
                    },
                    value: selected,
                    hint: const Text(
                      "Seleccione el empleado.",
                      style: TextStyle(color: Colors.black),
                    ),
                    items: users
                        .map(
                          (item) => DropdownMenuItem<GetUsers?>(
                            onTap: () {
                              setState(() {
                                //CREA UNA VARIABLE DE CLASE DEL ID
                                newuserid = item.userId;
                              });
                            },
                            child: Text(item.name),
                            value: item,
                          ),
                        )
                        .toList(),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),

              const SizedBox(
                height: 10,
              ),
              //BOTON DE GUARDAR CAMBIOS
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      primary: Colors.white, //TEXT COLOR
                      minimumSize: const Size(120, 50) //TAMANO - WH
                      ),
                  onPressed: () {
                    setState(() {
                      CircularProgressIndicator;
                      futureQueryRecordAdmin;
                    });

                    var finalUserID = newuserid;
                    var finalfinalUserID = finalUserID;
                    var finalRecordTypeID = 1;
                    var finalRecordDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    futureQueryRecordAdmin = fetchQueryRecordAdmin(
                        finalfinalUserID, finalRecordDate, finalRecordTypeID);
                    debugPrint(finalfinalUserID.toString() +
                        finalRecordDate +
                        finalRecordTypeID.toString());
                  },
                  child: const Text('queryrecords.apply').tr()),

              const SizedBox(
                height: 10,
              ),

              const Divider(),

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
              // Este contenedor sirve para cargar los registros recientes.
//NOTE Esta sección, es el listtile que carga el registro seleccionado.
              FutureBuilder<QueryRecordAdmin>(
                future: futureQueryRecordAdmin,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          //ListTile que muestra la fecha y texto Record Date del registro consultado.
                          ListTile(
                              title: Text((convertirFecha(snapshot
                                  .data!.recordDate))), //fecha del registro
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
        ));
  }

//FUNCIÓN QUE OBTIENE Y MUESTRA LOS DATOS DE LOS USUARIOS EN EL DROPDOWN LIST.
  Future<void> fetchAndShow() async {
    final users = await getData();
    final usersid = await getData();
    setState(() {
      this.users = users ?? [];
      this.users = usersid ?? [];
    });
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
