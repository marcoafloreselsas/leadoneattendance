import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../services/firebase_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

Future<List<Record>> fetchRecord() async {
  final response = await http
      .get(Uri.parse('https://1a77-45-65-152-57.ngrok.io/get/fiverecords/1'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<dynamic, dynamic>>();

    return parsed.map<Record>((json) => Record.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

@override
class TestingScreenTwo extends StatefulWidget {
  const TestingScreenTwo({Key? key}) : super(key: key);

  @override
  State<TestingScreenTwo> createState() => _TestingScreenTwoState();
}

class _TestingScreenTwoState extends State<TestingScreenTwo> {
  DateTime now = DateTime.now();
  var isLoaded = false;
  late Future<List<Record>> futureRecord;

  @override
  void initState() {
    super.initState();
    futureRecord = fetchRecord();
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
          FutureBuilder<List<Record>>(
            future: futureRecord,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Container(       
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data![index].RecordDate,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_upward_outlined,
                          color: Colors.green,
                        ),
                        Text(
                          snapshot.data![index].EntryTime,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_downward_outlined,
                          color: Colors.red,
                        ),
                        Text(
                          snapshot.data![index].ExitTime,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                          
                        ),

                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
