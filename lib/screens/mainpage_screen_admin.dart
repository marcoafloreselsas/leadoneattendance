import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../services/firebase_services.dart';
import '../themes/app_themes.dart';
import '../widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  _MainScreenAdmin createState() => _MainScreenAdmin();
}

class _MainScreenAdmin extends State<MainScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('mainpage.title').tr(),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          IconButton(
              onPressed: () async {
                await FirebaseServices().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Card(
          child: Column(children: [
        Card(
          child: ListTile(
            tileColor: Colors.white,
            leading: const Icon(
              Icons.person,
              color: AppTheme.primary,
              size: 30,
            ),
            title: Text(DateTime.now().toString()),
          ),
        ),
        RecentRecord(),
        RecentRecord(),
        RecentRecord(),
      ])),

      //Botón secundario para añadir un nuevo registro.
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InsertPageScreen()));
        },
      ),
    );
  }
}
