import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

/* WIDGET QUE SE MOSTRARA EN RECORD PAGE, A SUSTITUCION DEL POP UP DE LA APLICACION,
 MOSTRARA LAS HORAS DE INICIO Y TERMINO DE */

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(children: [
        //ACTIVIDADES
        Column(
          children: const [
            Text('Actividades'),
            Text('Attendance'), //ATTENDANCE •
            Text('Lunch'), //LUNCH •
            Text('Overtime'), //OVERTIME •
          ],
        ),
        //HORAS DE INICIO
        Column(
          children: const [
            Icon(Icons.arrow_upward_outlined, color: AppTheme.green),
            Text('09:00'), //ATTENDANCE •
            Text('12:30'), //LUNCH •
            Text('17:30'), //OVERTIME •
          ],
        ),
        //HORAS DE FINALIZACION
        Column(
          children: const [
            Icon(Icons.arrow_downward_outlined, color: AppTheme.red),
            Text('17:00'), //ATTENDANCE •
            Text('13:00'), //LUNCH •
            Text('18:30'), //OVERTIME •
          ],
        ),
      ]),
    );
  }
}
