// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

UserPreferences userPreferences = UserPreferences();
Future<QueryRecordAdmin> fetchQueryRecordAdmin(
    int finalfinalUserID, String finalRecordDate, int finalRecordTypeID) async {
  var userToken = await userPreferences.getUserToken();
  var usertoken = userToken;

  var UserID = finalfinalUserID;
  var RecordTypeID = finalRecordTypeID;
  var RecordDate = finalRecordDate;
  var s = UserID.toString() +
      "/" +
      RecordDate +
      "/" +
      RecordTypeID.toString() +
      "/" +
      usertoken.toString();

//http request GET
  final response = await http
      .get(Uri.parse('https://f6a1-45-65-152-57.ngrok.io/get/record/$s'));
  if (response.statusCode == 200) {
    return QueryRecordAdmin.fromJson(jsonDecode(response.body)[0]);
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
  Future<bool> _onWillPop() async {
    return false;
  }

  Future<dynamic>? getData() async {
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken.toString();
    String url = 'https://f6a1-45-65-152-57.ngrok.io/get/names/$usertoken';
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
    } else if (response.statusCode == 401) {
      debugPrint(response.statusCode.toString());
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(onWillPop: _onWillPop, child: const Alert401());
          });
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
                      "Select Employee.",
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
              FutureBuilder<QueryRecordAdmin>(
                future: futureQueryRecordAdmin,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                              title: Text((convertDate(snapshot
                                  .data!.recordDate))), //fecha del registro
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  const Icon(
                                    Icons.arrow_upward_outlined,
                                    color: AppTheme.green,
                                  ), // icon-1
                                  Text(
                                    ((convertTime(snapshot.data!.entryTime))),
                                    style: const TextStyle(
                                        fontSize: 18), //hora de entrada
                                  ),
                                  const Icon(
                                    Icons.arrow_downward_outlined,
                                    color: AppTheme.red,
                                  ), // icon-2
                                  Text(
                                    ((convertTime(snapshot.data!.exitTime))),
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
//NOTE While loading or detecting the log, this Circular Progress Indicator will appear.
                    return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ));
  }

//FUNCTION THAT FETCHES AND DISPLAYS USER DATA IN THE DROPDOWN LIST.
  Future<void> fetchAndShow() async {
    final users = await getData();
    final usersid = await getData();
    setState(() {
      this.users = users ?? [];
      this.users = usersid ?? [];
    });
  }

  //FUNCTION THAT DISPLAYS THE DATE PICKER
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

  //NOTE: Function for converting 17:30:00 to 17:30
  String convertTime(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //result = 17:30
    return tiempoFinal;
  }

//NOTE: Function to convert 2022-04-08T05:00:00:00.000Z to Apr 8, 2022
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
    //result = Apr 8, 2022
    return fechaFinal;
  }
}
