import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


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
          title: const Text('Consulta').tr(),
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
        ],
      ),
    );
  }
}