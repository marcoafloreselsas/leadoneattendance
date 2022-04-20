import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({Key? key}) : super(key: key);

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  DateTime pickedDateFrom = DateTime.parse('0000-00-00');
  DateTime pickedDateTo = DateTime.parse('0000-00-00');

//Rango de fechas
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  String dropdownvalue = 'ALL EMPLOYEES';
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
    final start = dateRange.start;
    final end = dateRange.end;

    return Scaffold(
      appBar: AppBar(
          title: const Text('generatereports.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportViewerScreen()));
                },
                icon: const Icon(Icons.add))
          ]),
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
          // ListTile(
          //   title: Text(
          //     "${pickedDateFrom.year}, ${pickedDateFrom.month}, ${pickedDateFrom.day}",
          //     textAlign: TextAlign.center,
          //   ),
          //   //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
          //   onTap: _pickDateFrom,
          // ),
          Row(
            children: [
              Expanded(            
                  child: ElevatedButton(
                      onPressed: _pickDateRange,
                      child: Text('${start.year}, ${start.month}, ${start.day}'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppTheme.primary),
                      ),
                )
              ),
            ],
          ),
          Row(
            children: [const Text('generatereports.toDate').tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          // ListTile(
          //   title: Text(
          //     "${pickedDateTo.year}, ${pickedDateTo.month}, ${pickedDateTo.day}",
          //     textAlign: TextAlign.center,
          //   ),
          //   //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
          //   onTap: _pickDateTo,
          // ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: _pickDateRange,
                    child: Text('${end.year}, ${end.month}, ${end.day}'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppTheme.primary),
                      )),
              ),
            ],
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
//INTERVALO DE FECHAS (FUNCIONAL)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //BOTON DE GUARDAR CAMBIOS
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  primary: Colors.white, //TEXT COLOR
                  minimumSize: const Size(120, 50) //TAMANO - WH
                  ),
              onPressed: () {
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

//METODO QUE OBTIENE EL INTERVALO DE FECHAS
  Future _pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime(2027),
    );
    if (newDateRange == null) return; // si el usuario presiona X
    setState(() => dateRange = newDateRange); // si el usuario presiona 'save'
  }
}
