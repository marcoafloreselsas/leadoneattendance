import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../services/firebase_services.dart';
import '../themes/app_themes.dart';
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
          IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestPageScreenAdmin()));
          }, icon: const Icon(Icons.search_outlined)),
          IconButton(
              onPressed: () async {
                await FirebaseServices().signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));},
              icon: const Icon(Icons.logout))
        ],
      ),
/*  */
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
        ),
          Column(
            children: [
              // Text(('mainpage.subtitle').tr(),)
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(
                  Icons.person,
                  color: AppTheme.primary,
                  size: 80,
                ),
                title: Text(DateTime.now().toString()),
                subtitle: Text(DateTime.now().toString()),
                contentPadding: (const EdgeInsets.symmetric( vertical: 16.0, horizontal: 5.0)),
                onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InsertPageScreen()));
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),

          //R E G I S T R O S 
          //                   R E C I E N T E S 
          Row(
            children: [const Text('mainpage.subtitle', style: TextStyle(fontSize: 20)).tr()],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(
            height: 10,
          ),

          Container(
            color: Colors.white,
            //REGISTRO 25 DE MARZO E INFERIORES
            child: ListTile(
                title: const Text("March 25th, 2022"),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: AppTheme.green,
                    ), // icon-1
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: AppTheme.red,
                    ), // icon-2
                    Text(
                      '17:30',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecordPageScreen()));
                }),
          ),
          //24 de marzo
          Container(
            color: Colors.white,
            //REGISTRO 25 DE MARZO E INFERIORES
            child: ListTile(
                title: const Text("March 24th, 2022"),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: AppTheme.green,
                    ), // icon-1
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: AppTheme.red,
                    ), // icon-2
                    Text(
                      '17:30',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecordPageScreen()));
                }),
          ),
          Container(
            color: Colors.white,
            //REGISTRO 25 DE MARZO E INFERIORES
            child: ListTile(
                title: const Text("March 23th, 2022"),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: AppTheme.green,
                    ), // icon-1
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: AppTheme.red,
                    ), // icon-2
                    Text(
                      '17:30',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecordPageScreen()));
                }),
          ),
          Container(
            color: Colors.white,
            //REGISTRO 25 DE MARZO E INFERIORES
            child: ListTile(
                title: const Text("March 22th, 2022"),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: AppTheme.green,
                    ), // icon-1
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: AppTheme.red,
                    ), // icon-2
                    Text(
                      '17:30',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecordPageScreen()));
                }),
          ),
          Container(
            color: Colors.white,
            //REGISTRO 25 DE MARZO E INFERIORES
            child: ListTile(
                title: const Text("March 21th, 2022"),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: const <Widget>[
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: AppTheme.green,
                    ), // icon-1
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: AppTheme.red,
                    ), // icon-2
                    Text(
                      '17:30',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecordPageScreen()));
                }),
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
                  builder: (context) => const InsertPageScreen()));
        },
      ),
    );
  }
}
