import 'package:flutter/material.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    futureRecord = fetchRecord();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }
    void _update() {
    setState(() {
      now = DateTime.now(); //Para actualizar la hora en el ListTile
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Disables the 'back' button of the system.
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('mainscreen.title').tr(),
          centerTitle: true,
          //Disables the 'back' button of the appbar.
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/QueryRecordsScreenUser');
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () async {
                  //This instruction clears the instance stored in the device and logs out.
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  Navigator.of(context).pushNamed('/LoginScreen');
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          //Note: SizedBoxes are used to place space between widgets.
          children: [
            /*This ListTile is used to display the current time and date, 
            when tapped, it leads to the Insert Record view*/
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                  child: const Icon(Icons.person,
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
                  const Text((' • USER'), style: TextStyle(fontSize: 18))
                ],
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
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.primary
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        CircularProgressIndicator;
                        futureRecord =fetchRecordLunch();
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
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.primary
                    ),
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
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.primary
                    ),
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
                  /* The FutureBuilder below loads the five recent records of the logged in user,
                 displays 'RecordDate', 'EntryTime' and 'ExitTime', use functions that format the data, 
                 when clicking on any object in the list, takes it to the 'DisplayRecordScreenUser' 
                 view where it sends the 'RecordDate' as an argument. */
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/DisplayRecordScreenUser',
                              arguments: convertDateArgument(
                                  snapshot.data![index].RecordDate),
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
                  //While loading the information, display this circular progress indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
        // Secondary button to add a new record.
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

//NOTE: Function for formatting 17:30:00 to 17:30
  String convertTime(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //resultado= 17:30
    return tiempoFinal;
  }

//NOTE: Function to format the date received from the server and formatted to e.g. '2022-04-08'.
  String convertDateArgument(String fecha) {
    final parsearFecha = DateTime.parse(fecha);
    var fechafinalargumento =
        DateFormat('yyyy-MM-dd').format(parsearFecha); //Fecha
    return fechafinalargumento;
  }

//NOTE: Function to convert 2022-04-08T05:00:00.00.000Z to Apr 8, 2022
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
    //result: Apr 8, 2022
    return fechaFinal;
  }

//Function that obtains the five recent records of a user from the server.
  Future<dynamic> fetchRecord() async {
    UserPreferences userPreferences = UserPreferences();
    //Consultas el dato almacenado y la asignas a la variable userId
    var userId = await userPreferences.getUserId();
    var userid = userId;
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken;
    var s = userid.toString() + '/' + usertoken.toString();

    try{
    //Server link
    final response = await http.get(Uri.parse('$globalURL/get/fiverecords/$s'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();
      return parsed.map<Record>((json) => Record.fromMap(json)).toList();
/*If the connection is successful (Code 200), it gets the information and displays it on the screen,
if the code is error (401), it means that the user token has expired,
and the user needs to log in again. */
    } if (response.statusCode == 401) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(onWillPop: _onWillPop, child: const Alert401());
          });
    }
    if(response.statusCode == 400){
      return showDialog(context: context, builder: (BuildContext context){
        return const AlertNoRecords();
      });
    }}catch(e){
            return showDialog(
            context: context,
            builder: (BuildContext context) {
              debugPrint('Wrong Connection!');
              return const AlertServerError();
            });
    }
    throw Exception('Failed to load records.');
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
    final response = await http.get(Uri.parse('$globalURL/get/fiverecordslunch/$s'));
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
    final response = await http.get(Uri.parse('$globalURL/get/fiverecordsovertime/$s'));
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
