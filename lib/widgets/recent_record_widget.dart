import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

/* WIDGET QUE SE MOSTRARA EN EL MAIN SCREEN DE LA APLICACION, CON LOS CINCO
REGISTROS RECIENTES*/

class RecentRecord extends StatelessWidget {
  const RecentRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //COLUMNA QUE CORRESPONDE A LA FECHA DEL REGISTRO
          Column(
            children: const [
              Icon(Icons.date_range_outlined, color: AppTheme.primary),
              Text('March 21th'),
            ],
          ),
          //COLUMNA QUE CORRESPONDE A LA HORA DE ENTRADA
          Column(
            children: const [
              Icon(Icons.arrow_upward_outlined, color: AppTheme.green),
              Text('09:00'),
            ],
          ),
          //COLUMNA QUE CORRESPONDE A LA HORA DE SALIDA
          Column(
            children: const [
              Icon(Icons.arrow_downward_outlined, color: AppTheme.red),
              Text('18:00'),
            ],
          ),
        ],
      ),
    );
  }
}
