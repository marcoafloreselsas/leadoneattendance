import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/widgets/widgets.dart';

class RecordPageScreen extends StatelessWidget {
  const RecordPageScreen({Key? key}) : super(key: key);

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
      body: Card(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [Record()],
        ),
      ),
    );
  }
}
