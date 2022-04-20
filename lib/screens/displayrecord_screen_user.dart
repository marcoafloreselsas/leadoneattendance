import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';

class DisplayRecordScreenUser extends StatefulWidget {
  const DisplayRecordScreenUser({Key? key}) : super(key: key);

  @override
  State<DisplayRecordScreenUser> createState() => _DisplayRecordScreenUserState();
}

class _DisplayRecordScreenUserState extends State<DisplayRecordScreenUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar:
            //APP BAR 
            AppBar(
                title: const Text('l'),
                centerTitle: true,
                actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditRecordScreenUser()));
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
                title: Text("displayrecords.TRattendance".tr()),
                trailing: Wrap(
                  spacing: 12, // Espacio entre dos íconos
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              ListTile(
                title: Text("displayrecords.TRlunch".tr()),
                trailing: Wrap(
                  spacing: 12, // Espacio entre dos íconos
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              ListTile(
                title: Text("displayrecords.TRovertime".tr()),
                trailing: Wrap(
                  spacing: 12, // Espacio entre dos íconos
                  children: const <Widget>[
                    Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
                    Text('09:30', style: TextStyle(fontSize: 18),),
                    Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
                    Text('17:30', style: TextStyle(fontSize: 18),)
                  ],
                ),
              ),
              ListTile(
                title: Text("displayrecords.TRpermit".tr()),
                trailing: Wrap(
                  spacing: 12, // Espacio entre dos íconos.
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
