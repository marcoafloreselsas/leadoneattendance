import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestPageScreenAdmin extends StatefulWidget {
  const RequestPageScreenAdmin({Key? key}) : super(key: key);

  @override
  State<RequestPageScreenAdmin> createState() => _RequestPageScreenAdminState();
}

class _RequestPageScreenAdminState extends State<RequestPageScreenAdmin> {

  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2022,2);
  final lastDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Consulta').tr(),
          centerTitle: true,
          actions: const []),
      body: Container(
        child: Column(
          children: [
            CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateChanged: (DateTime value) {},
            ),
          ],
        ),
      ),
    );
  }
}
