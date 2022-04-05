import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/recent_records.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/services/remote_services.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/themes/app_themes.dart';

@override
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime now = DateTime.now();
  List<RecentRecords>? recentRecords;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async {
    recentRecords = await RemoteService().getPosts();
    if (recentRecords != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(                                   
        title: const Text('mainpage.title').tr(),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestPageScreenAdmin()));
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
/*  BODY CON EL LIST TILE QUE MUESTRA LOS REGISTROS RECIENTES */
      body: Column(
        children: [
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
                  builder: (context) => const InsertPageScreen()));
            },
          ),
          const SizedBox(
            height: 10,
          ),
          //En caso de que la carga no esté lista, aparecerá el Circular Progress Indicator.
          Visibility(
            visible: isLoaded,
            child: ListView.builder(
                itemCount: recentRecords?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(recentRecords![index].RecordDate.toString()),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          const Icon(
                            Icons.arrow_upward_outlined,
                            color: AppTheme.green,
                          ), // icon-1
                          Text(
                            recentRecords![index].EntryTime.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_downward_outlined,
                            color: AppTheme.red,
                          ), // icon-2
                          Text(
                            recentRecords![index].ExitTime.toString(),
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      onTap: () {});
                }),
            //Círculo de espera.
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
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
