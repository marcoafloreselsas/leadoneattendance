import 'package:flutter/material.dart';
import 'package:leadoneattendance/dialogs/alert_401_error.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@override
class MainScreenUser extends StatefulWidget {
  const MainScreenUser({Key? key}) : super(key: key);

  @override
  State<MainScreenUser> createState() => _MainScreenUserState();
}

class _MainScreenUserState extends State<MainScreenUser> {
  DateTime now = DateTime.now();
  var isLoaded = false;
  late Future<dynamic> futureRecord;

  @override
  void initState() {
    super.initState();
    futureRecord = fetchRecord();
  }
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Deshabilita el botón de regresar del sistema
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('mainpage.title').tr(),
          centerTitle: true,
          //Deshabilita el botón de regresar del appbar
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
            Navigator.pushNamed(context, '/QueryRecordsScreenUser', arguments: {'UserID': 1}); 
    
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () async {
                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  //sharedPreferences.remove('UserID'); Para borrar el puro ID
                  sharedPreferences.clear(); //Para borrar T O D O.
                  Navigator.of(context).pushNamed('/LoginScreen');
                },
                icon: const Icon(Icons.logout))
          ],
        ),
    /*  BODY  */
        body: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                  child:
                      const Icon(Icons.person, color: AppTheme.primary, size: 50),
                  radius: 60,
                  backgroundColor: Colors.grey[300]),
              title: Text(DateFormat('MMMMEEEEd').format(now),
                  style: const TextStyle(fontSize: 24)),
              subtitle: Text(
                DateFormat('Hm').format(now),
                style: const TextStyle(fontSize: 18),
              ),
              contentPadding:
                  (const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0)),
              onTap: () {
                Navigator.pushNamed(context, '/InsertRecordScreenUser');
              },
            ),
            const SizedBox(
              height: 16,
            ),
            //Text de Registros Recientes
            Row(
              children: [
                const Text('mainpage.subtitle', style: TextStyle(fontSize: 24))
                    .tr()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            //LOS SIZEDBOX EN SU MAYORĪA, SON ESPACIOS SOLAMENTE.
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<dynamic>(
              future: futureRecord,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
    //LIST BUILDER QUE CARGA LOS CINCO REGISTROS RECIENTES
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => GestureDetector(
                            onTap: () =>   Navigator.pushNamed(context, '/DisplayRecordScreenUser', arguments: convertirFechaArgumento(snapshot.data![index].RecordDate),),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    convertirFecha(
                                        snapshot.data![index].RecordDate),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_upward_outlined,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    convertirHora(
                                        snapshot.data![index].EntryTime),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_downward_outlined,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    convertirHora(snapshot.data![index].ExitTime),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
        // Botón secundario para añadir un nuevo registro.
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/InsertRecordScreenUser');
          },
        ),
      ),
    );
  }
//NOTE: Método para convertir 17:30:00 a 17:30
  String convertirHora(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //debugPrint(tiempoFinal); Imprime en consola las horas obtenidas.
    //resultado= 17:30
    return tiempoFinal;
  }

  String convertirFechaArgumento(String fecha){
    final parsearFecha = DateTime.parse(fecha);
    var fechafinalargumento = DateFormat('yyyy-MM-dd').format(parsearFecha); //Fecha

    return fechafinalargumento;
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
  }  //HTTP Request
  //HTTP Request
Future<dynamic> fetchRecord() async {
  //LA LINEA COMENTADA ABAJO, ES PARA CARGAR EL USER ID DE LA PANTALLA ANTERIOR
  // final userid = ModalRoute.of(context)!.settings.arguments;
  UserPreferences userPreferences = UserPreferences();
        //Consultas el dato almacenado y la asignas a la variable userId
  var userId = await userPreferences.getUserId();
  var userid = userId;
  var userToken = await userPreferences.getUserToken();
  var usertoken = userToken;
  var s = userid.toString() + '/' + usertoken.toString();
  print('esta es una prueba user' + s);
  //final response = await http.get(Uri.parse('https://e5ac-45-65-152-57.ngrok.io/get/fiverecords/1'));
  final response = await http
      .get(Uri.parse('https://f6a1-45-65-152-57.ngrok.io/get/fiverecords/$s'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();

    return parsed.map<Record>((json) => Record.fromMap(json)).toList();
  } else if (response.statusCode == 401) {
    print(response.statusCode.toString());
     return showDialog(
        barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context){
                    return WillPopScope(onWillPop: _onWillPop,child: const Alert401());
      }
    );
      }
  throw Exception('Failed to load records.');
  }
}
