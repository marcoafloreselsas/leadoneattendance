import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_themes.dart';
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
  late int selectedactivity;

  String dropdownvalue = 'Attendance History';
  var items = ['Attendance History', 'Modifications History'];

  @override
  void initState() {
    super.initState();
    pickedDateFrom = DateTime.now();
    pickedDateTo = DateTime.now();
    readData();
  }
    void readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => usertoken = prefs.getString('Token')!);
    
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
                debugPrint('te estoy mandando:' +
                    activity.toString() +
                    firstDate.toString() +
                    lastDate.toString());
                Navigator.pushNamed(context, '/ReportViewerScreen', arguments: {
                  'activity': activity,
                  'firstDate': firstDate,
                  'lastDate': lastDate,
                  'userToken': usertoken
                });
              },
              child: const Text('generatereports.applyButton').tr())
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
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        pickedDateFrom = date;
      });
    }
  }

  //FUNCTION DISPLAYING THE SECOND DATE PICKER
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
