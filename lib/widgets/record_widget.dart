import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

/* WIDGET QUE SE MOSTRARA EN RECORD PAGE, A SUSTITUCION DEL POP UP DE LA APLICACION,
 MOSTRARA LAS HORAS DE INICIO Y TERMINO DE */

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: Text("displayrecords.TRattendance".tr()),
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
                title: Text("displayrecords.TRlunch".tr()),
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
    );
  }
}
