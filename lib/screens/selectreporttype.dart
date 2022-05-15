import 'package:flutter/material.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectReportTypeScreen extends StatefulWidget {
  const SelectReportTypeScreen({Key? key}) : super(key: key);

  @override
  State<SelectReportTypeScreen> createState() => _SelectReportTypeScreenState();
}

class _SelectReportTypeScreenState extends State<SelectReportTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('selectreporttype.title').tr(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
                child:
                    const Icon(Icons.group, color: AppTheme.primary, size: 40),
                radius: 60,
                backgroundColor: Colors.grey[300]),
            title: const Text('selectreporttype.general',
                    style: TextStyle(fontSize: 24))
                .tr(),
            contentPadding:
                (const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0)),
            onTap: () {
              Navigator.pushNamed(context, '/GeneralReports');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
                child:
                    const Icon(Icons.person, color: AppTheme.primary, size: 50),
                radius: 60,
                backgroundColor: Colors.grey[300]),
            title: const Text('selectreporttype.individual',
                    style: TextStyle(fontSize: 24))
                .tr(),
            contentPadding:
                (const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0)),
            onTap: () {
              Navigator.pushNamed(context, '/IndividualReports');
            },
          ),
        ],
      ),
    );
  }
}
