import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';

class RecordPageScreen extends StatefulWidget {
  const RecordPageScreen({Key? key}) : super(key: key);

  @override
  State<RecordPageScreen> createState() => _RecordPageScreenState();
}

class _RecordPageScreenState extends State<RecordPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar:
            //APP BAR 
            AppBar(
                title: Text(DateTime.now().toString()),
                centerTitle: true,
                actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditRecordScreen()));
                  },
                  icon: const Icon(Icons.edit_outlined))
            ]),

        //EN ESTA SECCION, COMIENZA LA INFORMACION DEL REGISTRO SELECCIONADO
        /* Para fines de acomodo, hay cuatro list tile, que son las columnas que muestran cada actividad,
          Hay un Wrap que permite añadir más de dos íconos y más de dos texto. El spacing, es el espaciado
          que habrá entre íconos, independientemente de los textos. */
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: Text("recordpage.TRattendance".tr()),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              ListTile(
                title: Text("recordpage.TRlunch".tr()),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              ListTile(
                title: Text("recordpage.TRovertime".tr()),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              //ESTE ES UN COMENTARIO
              ListTile(
                title: Text("recordpage.TRpermit".tr()),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('08:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
