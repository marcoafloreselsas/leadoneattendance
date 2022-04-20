import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';

class InsertRecordScreenAdmin extends StatefulWidget {
  const InsertRecordScreenAdmin({Key? key}) : super(key: key);

  @override
  State<InsertRecordScreenAdmin> createState() => _InsertRecordScreenAdminState();
}

class _InsertRecordScreenAdminState extends State<InsertRecordScreenAdmin> {
  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  bool value = true;

    // Initial Selected Value
  String dropdownvalue = 'insertrecords.TRattendance'.tr();   
  
  // List of items in our dropdown menu
  var items = [    
    'insertrecords.TRattendance'.tr(),
    'insertrecords.TRlunch'.tr(),
    'insertrecords.TRovertime'.tr(),
    'insertrecords.TRpermit'.tr(),
  ];

//Sobreescritura de la clase y del widget
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
          title: const Text('insertrecords.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreenAdmin()));
                },
                icon: const Icon(Icons.add_outlined)),
          ]),
      body: Card(
          //Calendario para seleccionar una fecha.
        child: Column(
        children: [
          //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
          Row(
            children: [
              const Text('insertrecords.selectDate').tr(),
              const Icon(Icons.keyboard_arrow_down_outlined),
            ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text("${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}", textAlign: TextAlign.center,),
          //  trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: _pickDate,
          ),
          //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
          Row(
            children: [
              const Text('insertrecords.selectTime').tr(),
              const Icon(Icons.keyboard_arrow_down_outlined),
            ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text("${time.hour}:${time.minute}", textAlign: TextAlign.center,),
            onTap: _pickTime,
          ),
          //TIPO DE REGISTRO
          Row(
            children: [
              const Text('insertrecords.typeRecord').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              DropdownButton(
              value: dropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down_outlined),    
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            ],                          
            mainAxisAlignment: MainAxisAlignment.center,
          ),
           //SWITCH
            Row(
              children: [
              const Text('insertrecords.in').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              buildSwitch(), //WIDGET DEL SWITCH
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('insertrecords.out').tr(),
            ],
              mainAxisAlignment: MainAxisAlignment.center
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
                Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const MainScreenAdmin()));
              }, 
              child: const Text('insertrecords.saveButton').tr())
        ],
      ),
      ),
    );
  }
//Widget del Switch
Widget buildSwitch() => Transform.scale(
  scale: 2,
  child: Switch.adaptive(
    activeColor: AppTheme.red,
    activeTrackColor: Colors.red[200],
    inactiveThumbColor: AppTheme.green,
    inactiveTrackColor: Colors.green[200],
    value: value, 
    onChanged: (value) => setState(() => this.value = value)),
);


//Función que muestra el Date Picker.
_pickDate() async {
  DateTime? date = await showDatePicker(
    context: context,
    initialDate: pickedDate,
    firstDate: DateTime(DateTime.now().year-1),
    lastDate: DateTime(DateTime.now().year+5)
  );
  if(date != null){
    setState(() {
      pickedDate = date;
    });
  }
}

//Función que muestra el Time Picker.
_pickTime() async{
    TimeOfDay? t = await showTimePicker(
    context: context,
    initialTime: time,

  );
  if(t != null){
    setState(() {
      time = t;
    });
  }
  }
}
