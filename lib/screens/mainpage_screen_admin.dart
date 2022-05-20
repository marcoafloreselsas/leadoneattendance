// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

int userid = 0;

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  _MainScreenAdmin createState() => _MainScreenAdmin();
}

class _MainScreenAdmin extends State<MainScreenAdmin> {
  DateTime now = DateTime.now();
  var isLoaded = false;
  late Future<dynamic> futureRecord;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
    futureRecord = fetchRecord();
    readData();
  }

  void _update() {
    setState(() {
      now = DateTime.now(); //Para actualizar la hora en el ListTile
    });
  }

//Para obtener el UserID, y enviarlo como argumento en el Record Seleccionado.
  void readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('UserID') == null) {
      setState(() => userid = 0);
    } else {
      setState(() => userid = prefs.getInt('UserID')!);
    }
  }

//Deshabilita el botón back de la pantalla principal.
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('mainscreen.title').tr(),
          // backgroundColor: Color.fromARGB(255, 15, 114, 36),
          centerTitle: true,
          //Deshabilita el botón back del appbar.
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/QueryRecordsScreenAdmin');
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () async {
                  return showDialog(
                      context: context, builder: (_) => const AlertLogout());
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                  child: const Icon(Icons.supervisor_account_sharp,
                      color: AppTheme.primary, size: 50),
                  radius: 60,
                  backgroundColor: Colors.grey[300]),
              title: Text(DateFormat('MMMMEEEEd').format(now),
                  style: const TextStyle(fontSize: 24)),
              subtitle: Row(
                children: [
                  Text(
                    DateFormat('Hm').format(now),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text((' • ADMIN'), style: TextStyle(fontSize: 18))
                ],
              ),
              contentPadding:
                  (const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0)),
              onTap: () {
                Navigator.pushNamed(context, '/InsertRecordScreenAdmin');
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Text('mainscreen.subtitle',
                        style: TextStyle(fontSize: 24))
                    .tr()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        CircularProgressIndicator;
                        futureRecord = fetchRecord();
                      });
                    },
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(primary: AppTheme.primary),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        CircularProgressIndicator;
                        futureRecord = fetchRecordLunch();
                      });
                    },
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.restaurant,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(primary: AppTheme.primary),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        CircularProgressIndicator;
                        futureRecord = fetchRecordOvertime();
                      });
                    },
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.more_time,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(primary: AppTheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<dynamic>(
              future: futureRecord,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/DisplayRecordScreenAdmin',
                              arguments: {
                                'RecordDate': convertDateArgument(
                                    snapshot.data![index].RecordDate),
                                'UserID': userid
                              },
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    convertDate(
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
                                    convertTime(
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
                                    convertTime(snapshot.data![index].ExitTime),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/InsertRecordScreenAdmin');
          },
        ),
      ),
    );
  }

//NOTE: Function for converting 17:30:00 to 17:30
  String convertTime(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //result = 17:30
    return tiempoFinal;
  }

  String convertDateArgument(String fecha) {
    final parsearFecha = DateTime.parse(fecha);
    var fechafinalargumento =
        DateFormat('yyyy-MM-dd').format(parsearFecha); //Fecha
    return fechafinalargumento;
  }

//NOTE:Function to convert 2022-04-08T05:00:00.000Z to Apr 8, 2022
  String convertDate(String fecha) {
    String date = fecha;
    String? mes;
    String? fechaFinal;
    final parsearFecha = DateTime.parse(date);
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
    //result: Abril 8, 2022
    return fechaFinal;
  }

  //HTTP Request
  Future<dynamic> fetchRecord() async {
    UserPreferences userPreferences = UserPreferences();
    // Query the stored data and assign it to the variable userId
    var userId = await userPreferences.getUserId();
    var userid = userId;
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;
    var s = userid.toString() + '/' + usertoken.toString();
    final response = await http.get(Uri.parse('$globalURL/get/fiverecords/$s'));
    try {
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();
        return parsed.map<Record>((json) => Record.fromMap(json)).toList();
      }
      if (response.statusCode == 400) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertNoRecords();
            });
      }
      if (response.statusCode == 401) {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: _onWillPop, child: const Alert401());
            });
      }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerError();
          });
    }
  }

  //HTTP Request
  Future<dynamic> fetchRecordLunch() async {
    UserPreferences userPreferences = UserPreferences();
    // Query the stored data and assign it to the variable userId
    var userId = await userPreferences.getUserId();
    var userid = userId;
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;
    var s = userid.toString() + '/' + usertoken.toString();
    final response =
        await http.get(Uri.parse('$globalURL/get/fiverecordslunch/$s'));
    try {
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();
        return parsed.map<Record>((json) => Record.fromMap(json)).toList();
      }
      if (response.statusCode == 400) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertNoRecords();
            });
      }
      if (response.statusCode == 401) {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: _onWillPop, child: const Alert401());
            });
      }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerError();
          });
    }
  }

  //HTTP Request
  Future<dynamic> fetchRecordOvertime() async {
    UserPreferences userPreferences = UserPreferences();
    // Query the stored data and assign it to the variable userId
    var userId = await userPreferences.getUserId();
    var userid = userId;
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;
    var s = userid.toString() + '/' + usertoken.toString();
    final response =
        await http.get(Uri.parse('$globalURL/get/fiverecordsovertime/$s'));
    try {
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();
        return parsed.map<Record>((json) => Record.fromMap(json)).toList();
      }
      if (response.statusCode == 400) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertNoRecords();
            });
      }
      if (response.statusCode == 401) {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: _onWillPop, child: const Alert401());
            });
      }
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            debugPrint('Wrong Connection!');
            return const AlertServerError();
          });
    }
  }
}
