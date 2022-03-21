import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';

class InsertPageScreen extends StatelessWidget {
  const InsertPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(DateTime.now().toString()),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditRecordScreen()));
                },
                icon: const Icon(Icons.edit_outlined)),
          ]),
      body: Card(
          //CALENDARIO PARA SELECCIONAR UNA FECHA
          child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Tap to open date picker',
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              );
            },
          ),
          Row(
            children: [
              Column(
                children: const [Text('Time'), Text('Activity')],
              ),
              Column(
                children: [],
              )
            ],
          )
        ],
      )),
    );
  }
}
