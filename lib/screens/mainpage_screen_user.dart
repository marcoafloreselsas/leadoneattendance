import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/posts.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:leadoneattendance/services/remote_services.dart';
import 'package:leadoneattendance/widgets/widgets.dart';
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
    List<Posts>?  posts;
    var isLoaded = false;

    @override
    void initState() {
      super.initState();
      //fetch data from API
      getData();
    }

    getData() async{
      posts = await RemoteService().getPosts();
      if(posts != null){
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
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
              itemCount: posts?.length,
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(posts![index].title,
                      maxLines: 2,),
                      Text(posts![index].body,
                      maxLines: 3,),
                    ],
                  ),
                );
              }
            ),
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
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