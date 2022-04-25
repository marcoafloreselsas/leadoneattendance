import 'package:flutter/material.dart';
import '../themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  _MainScreenAdmin createState() => _MainScreenAdmin();
}

class _MainScreenAdmin extends State<MainScreenAdmin> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        //Sección del AppBar
        title: const Text('mainpage.title').tr(),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QueryRecordsScreenAdmin()));
              },
              icon: const Icon(Icons.search_outlined)),
          IconButton(
              onPressed: () async {
                await FirebaseServices().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),

      body: Column(
        children: [
          Column(
            children: [
              //Tarjeta de cabecera de Bienvenida(Sirve para Insertar Registro)
              ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                    child: const Icon(Icons.person,
                        color: AppTheme.primary, size: 50),
                    radius: 60,
                    backgroundColor: Colors.grey[300]),
                title: Text(DateFormat('MMMMEEEEd').format(now),
                    style: const TextStyle(fontSize: 24)),
                subtitle: Text(
                  DateFormat('Hm').format(now),
                  style: const TextStyle(fontSize: 18),
                ),
                contentPadding: (const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 5.0)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InsertRecordScreenAdmin()));
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),

          //Text de Registros Recientes
          Row(
            children: [
              const Text('mainpage.subtitle', style: TextStyle(fontSize: 20))
                  .tr()
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),

          //LOS SIZEDBOX EN SU MAYORĪA, SON ESPACIOS SOLAMENTE.
          const SizedBox(
            height: 10,
          ),

        ],
      ),

      //Botón secundario para añadir un nuevo registro.
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InsertRecordScreenAdmin()));
        },
      ),
    );
  }
}
