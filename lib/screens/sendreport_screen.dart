import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({Key? key}) : super(key: key);

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

//Esta vista envía el reporte generado.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App bar de la pantalla.
        appBar: AppBar(
            title: const Text('sendreport.title').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreenAdmin()));
                  },
                  icon: const Icon(Icons.send)),
            ]),
        body: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: ('sendreport.to').tr(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required.';
                      }
                      String pattern = r'\w+@\w+\.\w+';
                      if (!RegExp(pattern).hasMatch(value)) {
                        return 'Invalid Email address format.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: ('sendreport.subject').tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: ('sendreport.message').tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Botón de guardar cambios.
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          primary: Colors.white, //Color del Texto
                          minimumSize: const Size(120, 50) //Tamaño - WH
                          ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          //     builder: (context) => const MainScreenAdmin()));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MainScreenAdmin()),
                              (Route<dynamic> route) =>
                                  route is MainScreenAdmin);
                        }
                      },
                      child: const Text('sendreport.sendButton').tr())
                ],
              ),
            )));
  }
}