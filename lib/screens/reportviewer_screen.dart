import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';


class ReportViewerScreen extends StatefulWidget {
  const ReportViewerScreen({Key? key}) : super(key: key);

  @override
  State<ReportViewerScreen> createState() => _ReportViewerScreenState();
}

class _ReportViewerScreenState extends State<ReportViewerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(title: const Text('reportviewer.title').tr(), centerTitle: true, actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SendReportScreen()));
            },
            icon: const Icon(Icons.description_outlined)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SendReportScreen()));
            },
            icon: const Icon(Icons.share_outlined)),
      ]),
    );
  }
}
