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

    // Initial Selected Value
  String dropdownvalue = 'insertpage.TRattendance'.tr();   
  
  // List of items in our dropdown menu
  var items = [    
    'insertpage.TRattendance'.tr(),
    'insertpage.TRlunch'.tr(),
    'insertpage.TRovertime'.tr(),
    'insertpage.TRpermit'.tr(),
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
          title: const Text('editpage.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditRecordScreen()));
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
              const Text('insertpage.selectDate').tr(),
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
              const Text('insertpage.selectTime').tr(),
              const Icon(Icons.keyboard_arrow_down_outlined),
            ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          ListTile(
            title: Text("${time.hour}:${time.minute}", textAlign: TextAlign.center,),
           // trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: _pickTime,
          ),
          //TIPO DE REGISTRO
          Row(
            children: [
              const Text('insertpage.typeRecord').tr(),
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
           //SWITCH
            Row(
              children: [
              const Text('insertpage.in').tr(),
              const Padding(padding: EdgeInsets.all(25.0)),
              buildSwitch(), //WIDGET DEL SWITCH
              const Padding(padding: EdgeInsets.all(25.0)),
              const Text('insertpage.out').tr(),
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
              onPressed: (){}, 
              child: const Text('insertpage.saveButton').tr())
        ],
      ),
      ),
    );
  }


//WIDGET DEL SWITCH
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


//FUNCION QUE MUESTRA EL DATE PICKER
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

//FUNCION QUE MUESTRA EL TIME PICKER
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
