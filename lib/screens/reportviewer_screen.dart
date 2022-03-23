import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/screens.dart';

class ReportViewerScreen extends StatelessWidget {
  const ReportViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Sample Text'), centerTitle: true, actions: [
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
