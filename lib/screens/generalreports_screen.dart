import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import '../dialogs/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

String usertoken = "";

class GenerateGeneralReportsScreen extends StatefulWidget {
  const GenerateGeneralReportsScreen({Key? key}) : super(key: key);

  @override
  State<GenerateGeneralReportsScreen> createState() =>
      _GenerateGeneralReportsScreenState();
}

class _GenerateGeneralReportsScreenState
    extends State<GenerateGeneralReportsScreen> {
  DateTime pickedDateFrom = DateTime.parse('0000-00-00');
  DateTime pickedDateTo = DateTime.parse('0000-00-00');
  int selectedactivity = 0;
  String? changeDateFrom;
  String? changeDateTo;

  String dropdownvalue = 'Attendance History';
  var items = ['Attendance History', 'Modifications History'];
    readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => usertoken = prefs.getString('Token')!);
    
  }
  @override
  void initState() {
    super.initState();
    pickedDateFrom = DateTime.now();
    pickedDateTo = DateTime.now();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('generatereports.titleGeneral').tr(),
          centerTitle: true),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [Text(('generatereports.reportType').tr(),                 
            style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ))],
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
                    child: Text((items),                     
                    style: const TextStyle(
                            fontSize: 18.0,)
                    
                  ));
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
            children: [Text(('generatereports.dateRange').tr(),
              style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ))],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [Text(('generatereports.fromDate').tr(),                 
            style: const TextStyle(
                    fontSize: 18.0,
                ))],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text(
              changeDateFrom == null
              ? "${pickedDateFrom.year}-${pickedDateFrom.month}-${pickedDateFrom.day}":changeDateFrom!,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            onTap: _pickDateFrom, 
          ),
          Row(
            children: [Text(('generatereports.toDate').tr(),
                        style: const TextStyle(
                    fontSize: 18.0,
            ))],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text(
              changeDateTo == null
              ?"${pickedDateTo.year}-${pickedDateTo.month}-${pickedDateTo.day}":changeDateTo!,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            onTap: _pickDateTo,
          ),

          const SizedBox(
            height: 20,
          ),
          //SAVE CHANGES BUTTON
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  primary: Colors.white, //TEXT COLOR
                  minimumSize: const Size(120, 50) //TAMANO - WH
                  ),
              onPressed: () {
                var activity = selectedactivity + 3;
                var firstDate = DateFormat('yyyy-MM-dd').format(pickedDateFrom);
                var lastDate = DateFormat('yyyy-MM-dd').format(pickedDateTo);
                if (changeDateFrom == null || changeDateTo == null || activity == 0) {
                  showDialog(context: context, builder: (BuildContext context){ return const AlertCompleteInfo();});
                }else{
                debugPrint('te estoy mandando:' +
                    activity.toString() +
                    firstDate.toString() +
                    lastDate.toString() +
                    usertoken);
                Navigator.pushNamed(context, '/ReportViewerScreen', arguments: {
                  'activity': activity,
                  'firstDate': firstDate,
                  'lastDate': lastDate,
                  'userToken': usertoken
                });
                }
              },
              child: Text(('generatereports.applyButton').tr(),                         
              style: const TextStyle(
                    fontSize: 18.0,
            )))
        ],
      ),
    );
  }

  //FUNCTION THAT DISPLAYS THE DATE PICKER
  _pickDateFrom() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDateFrom,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        pickedDateFrom = date;
        changeDateFrom = DateFormat('yyyy-MM-dd').format(pickedDateFrom);
      });
    }
  }

  //FUNCTION DISPLAYING THE SECOND DATE PICKER
  _pickDateTo() async {
    DateTime? date2 = await showDatePicker(
        context: context,
        initialDate: pickedDateTo,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (date2 != null) {
      setState(() {
        pickedDateTo = date2;
        changeDateTo = DateFormat('yyyy-MM-dd').format(pickedDateTo);
      });
    }
  }
}
