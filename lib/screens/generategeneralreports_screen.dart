import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateGeneralReportsScreen extends StatefulWidget {
  const GenerateGeneralReportsScreen({Key? key}) : super(key: key);

  @override
  State<GenerateGeneralReportsScreen> createState() => _GenerateGeneralReportsScreenState();
}

class _GenerateGeneralReportsScreenState extends State<GenerateGeneralReportsScreen> {
  DateTime pickedDateFrom = DateTime.parse('0000-00-00');
  DateTime pickedDateTo = DateTime.parse('0000-00-00');
  int tipoRegistro = 0 ;

//TIPOS DE REGISTRO GENERAL
  String dropdownvalue = 'Attendance History';
  var items = [
    'Attendance History',
    'Modifications History'
  ];

  @override
  void initState() {
    super.initState();
    pickedDateFrom = DateTime.now();
    pickedDateTo = DateTime.now();
    
  }
//LISTA QUE OBTIENE LOS NOMBRE DE LOS USUARIOS
    Future<List<GetUsers>>? getData() async {
    const String url = 'https://4aa8-45-65-152-57.ngrok.io/get/names';
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
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('GENERAL'),
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
            height: 20,
          ),
                    Row(
            children: const [Text('Select Report Type')],
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
                    tipoRegistro = items.indexOf(newValue);
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

//INTERVALO DE FECHAS (FUNCIONAL)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 12),
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
                if(tipoRegistro == 0){
                  //Aquī envía a general attendance entre fechas
                  
                }else{
                  //Aquí envía a general modifications entre fechas

                }
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
