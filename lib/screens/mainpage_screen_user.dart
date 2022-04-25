import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';

@override
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime now = DateTime.now();
  var isLoaded = false;
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(                                   
        title: const Text('mainpage.title').tr(),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QueryRecordsScreen()));
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





/*  BODY  */
      body: Column(
        children: [
          //ListTile de Bienvenida, para insertar registro.
          ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
                child:
                    const Icon(Icons.person, color: AppTheme.primary, size: 50),
                radius: 60,
                backgroundColor: Colors.grey[300]),
            title: Text(DateFormat('MMMMEEEEd').format(now),
                style: const TextStyle(fontSize: 24)),
            subtitle: Text(
              DateFormat('Hm').format(now),
              style: const TextStyle(fontSize: 18),
            ),
            contentPadding:
                (const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const InsertRecordScreenUser()));
            },
          ),
          const SizedBox(
            height: 10,
          ),
//List View que carga los cinco registros recientes. 
          // ListView.builder(
          //     itemCount: Record.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //           title: Text(Record![index].RecordDate.toString()),
          //           onTap: () {});
          //     }),

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
                  builder: (context) => const InsertRecordScreenUser()));
        },
      ),
    );
  }
}
