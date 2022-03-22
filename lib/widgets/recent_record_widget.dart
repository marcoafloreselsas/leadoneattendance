import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

/* WIDGET QUE SE MOSTRARA EN EL MAIN SCREEN DE LA APLICACION, CON LOS CINCO
REGISTROS RECIENTES*/

class RecentRecord extends StatefulWidget {
  const RecentRecord({Key? key}) : super(key: key);



  @override
  State<RecentRecord> createState() => _RecentRecordState();
}

class _RecentRecordState extends State<RecentRecord> {
  
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
        color: Colors.white,
        child: ListTile(
          title: const Text("March 22th, 2022"),
          trailing: Wrap(
            spacing: 12, // space between two icons
            children: const <Widget>[
              Icon(Icons.arrow_upward_outlined, color: AppTheme.green,), // icon-1
              Text('09:30', style: TextStyle(fontSize: 18),),
              Icon(Icons.arrow_downward_outlined, color: AppTheme.red,), // icon-2
              Text('17:30',style: TextStyle(fontSize: 18),)
            ],
          ),
        onTap: (){}
        ));
  }
}
