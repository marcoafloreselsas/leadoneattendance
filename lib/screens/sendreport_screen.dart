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
//Esta vista envía el reporte generado.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Padding(
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
                  onPressed: () {},
                  child: const Text('sendreport.sendButton').tr())
            ],
          ),
        ));
  }
}




      //CAMPOS
      //Mail to
      //Subject
      //Message
      //Attachment
      //Send Button