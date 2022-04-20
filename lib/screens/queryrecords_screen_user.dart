import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../themes/app_themes.dart';

class QueryRecordsScreen extends StatefulWidget {
  const QueryRecordsScreen({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreen> createState() => _QueryRecordsScreenState();
}

class _QueryRecordsScreenState extends State<QueryRecordsScreen> {
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2022,2); //A partir de que fecha funciona el calendario
  final lastDate = DateTime.now(); //Hasta que fecha funciona el calendario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('queryrecords.title').tr(),
          centerTitle: true,
          actions: const []),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selectedDate, //Fecha por default, será la actual.
            firstDate: firstDate, //Desde que fecha funciona el calendario.
            lastDate: lastDate, //Hasta que fecha funciona el calendario.
            onDateChanged: (DateTime value) {}, // Si la fecha cambia.
          ),
           Row(
                children: [
                  const Text('queryrecords.recentRecords',
                          style: TextStyle(fontSize: 20)).tr()
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 10,
              ),
              // Este contenedor sirve para cargar los registros recientes.
              Container(
                color: Colors.white,
                child: ListTile(
                    title: const Text("April 19th, 2022"), //fecha del registro
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: const <Widget>[
                        Icon(
                          Icons.arrow_upward_outlined,
                          color: AppTheme.green,
                        ), // icon-1
                        Text(
                          '09:30',
                          style: TextStyle(fontSize: 18), //hora de entrada
                        ),
                        Icon(
                          Icons.arrow_downward_outlined,
                          color: AppTheme.red,
                        ), // icon-2
                        Text(
                          '17:30',
                          style: TextStyle(fontSize: 18), //hora de salida
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DisplayRecordScreenUser()));
                    }),
              ),
        ],
      ),
    );
  }
}