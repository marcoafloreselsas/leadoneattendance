import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';

class EditRecordScreen extends StatefulWidget {
  const EditRecordScreen({Key? key}) : super(key: key);

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {

  DateTime pickedDate = DateTime.parse('0000-00-00');
  late TimeOfDay time;
  bool value = true;

    // Valor inicial de Dropdown Value
  String dropdownvalue = 'editrecords.TRattendance'.tr();   
  
  // Lista de Articulos de Dropdown value
  var items = [    
    'editrecords.TRattendance'.tr(),
    'editrecords.TRlunch'.tr(),
    'editrecords.TRovertime'.tr(),
    'editrecords.TRpermit'.tr(),
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
          title: const Text('editrecords.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditRecordScreen()));
                          showDialog(context: context, builder: (context) => const AlertDialog(title: Text('') , content: Text(''), actions: [],));
                },
                icon: const Icon(Icons.add_outlined)),
          ]),
      body: Card(
          //CALENDARIO PARA SELECCIONAR UNA FECHA
          child: Column(
        children: [
          //LIST TILE DONDE SE MUESTRA EL DATE PICKER, Y SU ICONO PARA DESPLEGAR
          Row(
            children: [
              const Text('editrecords.selectDate').tr(),
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
              const Text('editrecords.selectTime').tr(),
              const Icon(Icons.keyboard_arrow_down_outlined),
            ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text("${time.hour}:${time.minute}", textAlign: TextAlign.center,),
           // trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: _pickTime,
          ),
          //Tipo de registro
          Row(
            children: [
              const Text('editrecords.typeRecord').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
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
           //Switch
            Row(
              children: [
              const Text('editrecords.in').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              buildSwitch(), //Manda llamar el switch.
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('editrecords.out').tr(),
            ],
              mainAxisAlignment: MainAxisAlignment.center
            ),
            const SizedBox(height: 20,),
            //Botón de guardar cambios.
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                primary: Colors.white, //Color del Texto
                minimumSize: const Size(120, 50) //Tamaño - WH
              ),
              onPressed: (){}, 
              child: const Text('editrecords.saveButton').tr())
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
