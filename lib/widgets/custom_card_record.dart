import 'package:flutter/material.dart';

/* */

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        title: Text('DATE'),
        leading: Icon(Icons.lock_open_outlined),
      ),
    );
  }
}