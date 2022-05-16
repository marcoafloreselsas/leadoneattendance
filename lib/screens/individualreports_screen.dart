import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leadoneattendance/dialogs/dialogs.dart';
String userToken = "";

class GenerateIndividualReportsScreen extends StatefulWidget {
  const GenerateIndividualReportsScreen({Key? key}) : super(key: key);

  @override
  State<GenerateIndividualReportsScreen> createState() =>
      _GenerateIndividualReportsScreenState();
}

class _GenerateIndividualReportsScreenState
    extends State<GenerateIndividualReportsScreen> {
  DateTime pickedDateFrom = DateTime.parse('0000-00-00');
  DateTime pickedDateTo = DateTime.parse('0000-00-00');
  List<GetUsers> users = [];
  GetUsers? selected;
  late int newuserid;
  late int selectedactivity;

  String dropdownvalue = 'Attendance History';
  var items = ['Attendance History', 'Modifications History'];

  @override
  void initState() {
    super.initState();
    pickedDateFrom = DateTime.now();
    pickedDateTo = DateTime.now();
    fetchAndShow();
    readData();

  }
    void readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => userToken = prefs.getString('Token')!);
    
  }
  Future<bool> _onWillPop() async {
    return false;
  }

  Future<dynamic>? getData() async {
    var userToken = await userPreferences.getUserToken();
    var usertoken = userToken.toString();
    String url = 'https://174e-45-65-152-57.ngrok.io/get/names/$usertoken';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('generatereports.titleIndividual').tr(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [const Text('generatereports.reportType').tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: [
              DropdownButton(
                // Initial Value
                value: dropdownvalue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    selectedactivity = items.indexOf(newValue);
                  });
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [const Text('generatereports.dateRange').tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [const Text('generatereports.fromDate').tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text(
              "${pickedDateFrom.year}, ${pickedDateFrom.month}, ${pickedDateFrom.day}",
              textAlign: TextAlign.center,
            ),
            onTap: _pickDateFrom,
          ),
          Row(
            children: [const Text('generatereports.toDate').tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text(
              "${pickedDateTo.year}, ${pickedDateTo.month}, ${pickedDateTo.day}",
              textAlign: TextAlign.center,
            ),
            onTap: _pickDateTo,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 12),
            ],
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
                  "generatereports.employeeLabel",
                  style: TextStyle(color: Colors.black),
                ).tr(),
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
            height: 20,
          ),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  primary: Colors.white, //TEXT COLOR
                  minimumSize: const Size(120, 50) //TAMANO - WH
                  ),
              onPressed: () {
                var activity = selectedactivity + 1;
                var userID = newuserid;
                var firstDate = DateFormat('yyyy-MM-dd').format(pickedDateFrom);
                var lastDate = DateFormat('yyyy-MM-dd').format(pickedDateTo);
                debugPrint('te estoy mandando:' +
                    userID.toString() +
                    activity.toString() +
                    firstDate.toString() +
                    lastDate.toString());
                Navigator.pushNamed(context, '/ReportViewerScreen', arguments: {
                  'userID': userID,
                  'activity': activity,
                  'firstDate': firstDate,
                  'lastDate': lastDate,
                  'userToken': userToken
                });
              },
              child: const Text('generatereports.applyButton').tr())
        ],
      ),
    );
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
  _pickDateFrom() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDateFrom,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        pickedDateFrom = date;
      });
    }
  }

  //FUNCTION THAT DISPLAYS THE SECOND DATE PICKER
  _pickDateTo() async {
    DateTime? date2 = await showDatePicker(
        context: context,
        initialDate: pickedDateTo,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date2 != null) {
      setState(() {
        pickedDateTo = date2;
      });
    }
  }
}
