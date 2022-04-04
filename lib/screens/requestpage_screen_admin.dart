import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

class RequestPageScreenAdmin extends StatefulWidget {
  const RequestPageScreenAdmin({Key? key}) : super(key: key);

  @override
  State<RequestPageScreenAdmin> createState() => _RequestPageScreenAdminState();
}

class _RequestPageScreenAdminState extends State<RequestPageScreenAdmin> {
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;

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
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Consulta').tr(),
            centerTitle: true,
            actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GenerateReportsScreen()));
                },
                icon: const Icon(Icons.description_outlined)),
          ]),
        body: Card(
          child: Column(
            children: [
              //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
              Row(
                children: [
                  const Text('insertpage.selectDate').tr(),
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
                  const Text('Selecciona el Empleado').tr(),
                ],
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
              const SizedBox(
                height: 50,
              ),

              Row(
                children: [
                  const Text('mainpage.subtitle',
                          style: TextStyle(fontSize: 20)).tr()
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                color: Colors.white,
                //REGISTRO 25 DE MARZO E INFERIORES
                child: ListTile(
                    title: const Text("March 25th, 2022"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: const <Widget>[
                        Icon(
                          Icons.arrow_upward_outlined,
                          color: AppTheme.green,
                        ), // icon-1
                        Text(
                          '09:30',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_downward_outlined,
                          color: AppTheme.red,
                        ), // icon-2
                        Text(
                          '17:30',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RecordPageScreen()));
                    }),
              ),
            ],
          ),
        ));
  }

  //FUNCION QUE MUESTRA EL DATE PICKER
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
}
