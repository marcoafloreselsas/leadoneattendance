// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:leadoneattendance/variable.dart';

UserPreferences userPreferences = UserPreferences();


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
  Future<dynamic>? futureQueryRecordAdmin;
  GetUsers? selected;
  int newuserid = 0;
  String? changeDate;

  Future<bool> _onWillPop() async {
    return false;
  }

  Future<dynamic>? getData() async {
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken.toString();
    String url = '$globalURL/get/names/$usertoken';
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
          const SizedBox(
            height:20,
          ),
              Row(
                children: [
                  Text(('queryrecords.selectDate').tr(), 
                  style: const TextStyle(
                        fontSize: 18.0,
                    )),                  
                const Icon(Icons.keyboard_arrow_down_outlined),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              ListTile(
                title: Text(
                  changeDate == null
                  ? "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}" :changeDate!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                onTap: _pickDate,
              ),
              const SizedBox(
            height:20,
          ),
              Row(
                children: [
                  Text(('queryrecords.selectEmployee').tr(),               
                  style: const TextStyle(fontSize: 18)),
                  const Icon(Icons.keyboard_arrow_down_outlined),

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
                      "Select Employee",
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
                      // futureQueryRecordAdmin;
                                          var finalUserID = newuserid;
                    var finalfinalUserID = finalUserID;
                    var finalRecordTypeID = 1;

                    if(finalUserID == 0 ){
                      showDialog(context: context, builder: (BuildContext context){ return const AlertSelectEmployee();});
                    }if(changeDate == null){
                      showDialog(context: context, builder: (BuildContext context){ return const AlertSelectDate();});
                    }
                    if (finalUserID !=0 || changeDate != null){
                      var finalRecordDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    futureQueryRecordAdmin = fetchQueryRecordAdmin(
                        finalfinalUserID, finalRecordDate, finalRecordTypeID);
                    debugPrint(finalfinalUserID.toString() +
                        finalRecordDate +
                        finalRecordTypeID.toString());
                    }
                    });

                  },
                  child: Text(('queryrecords.apply').tr(),                      style: const TextStyle(
                            fontSize: 18.0,
                ))),
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
              FutureBuilder<dynamic>(
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

                                Navigator.pushNamed(
                                    context, '/DisplayRecordScreenAdmin',
                                    arguments: {'RecordDate': convertDateArgument(
                                        snapshot.data!.recordDate), 'UserID':newuserid});
                                }

                              )
                        ],
                      ),
                    );
                  } else {
//NOTE While loading or detecting the log, this Circular Progress Indicator will appear.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ));
        
  }
Future<dynamic> fetchQueryRecordAdmin(
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
      .get(Uri.parse('$globalURL/get/record/$s'));
  if (response.statusCode == 201) {
    return QueryRecordAdmin.fromJson(jsonDecode(response.body)[0]);
  } 
  if(response.statusCode == 400){
      showDialog(context: context, builder: (BuildContext context){
        return const AlertUnavailableRecord();
      });
    } 
  else {
    throw Exception('Failed to load record.');
  }
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

  String convertDateArgument(String fecha) {
    final parsearFecha = DateTime.parse(fecha);
    var fechafinalargumento =
        DateFormat('yyyy-MM-dd').format(parsearFecha); //Fecha
    return fechafinalargumento;
  }

  //FUNCTION THAT DISPLAYS THE DATE PICKER
  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        pickedDate = date;
        changeDate = DateFormat('yyyy-MM-dd').format(pickedDate);
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
