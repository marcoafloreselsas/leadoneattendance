import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../themes/app_themes.dart';

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({Key? key}) : super(key: key);

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  DateTime pickedDateFrom = DateTime.parse('0000-00-00');
  DateTime pickedDateTo = DateTime.parse('0000-00-00');

  // Initial Selected Value
  String dropdownvalue = 'ALL EMPLOYEES';

  // List of items in our dropdown menu
  var items = [
    'ALL EMPLOYEES',
    'JOHAN GARCIA',
    'MARCO FLORES',
    'ARI PEREZ',
    'GIOVANNI ARRAZOLA'
  ];

  @override
  void initState() {
    super.initState();
    pickedDateFrom = DateTime.now();
    pickedDateTo = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('generatereports.title').tr(),
          centerTitle: true,
          actions: const []),
      body: Column(
        children: [
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
            //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
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
            //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: _pickDateTo,
          ),
          Row(
            children: [const Text('generatereports.employeeLabel').tr()],
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
                  });
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
            const SizedBox(height: 20,),
            //BOTON DE GUARDAR CAMBIOS
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                primary: Colors.white, //TEXT COLOR
                minimumSize: const Size(120, 50) //TAMANO - WH
              ),
              onPressed: (){
                 Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ReportViewerScreen()));
              }, 
              child: const Text('generatereports.applyButton').tr())
        ],
      ),
    );
  }

  //FUNCION QUE MUESTRA EL DATE PICKER
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

  //FUNCION QUE MUESTRA EL DATE PICKER
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
