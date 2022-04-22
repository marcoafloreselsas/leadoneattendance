// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Record> postFromJson(String str) => List<Record>.from(json.decode(str).map((x) => Record.fromJson(x)));

String postToJson(List<Record> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Record {
  Record({
    required this.RecordDate,
    required this.EntryTime,
    required this.ExitTime
  });

  DateTime RecordDate;
  DateTime EntryTime;
  DateTime ExitTime;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        RecordDate: json["RecordDate"],
        EntryTime: json["EntryTime"],
        ExitTime: json["ExitTime"],
      );

  Map<String, dynamic> toJson() => {
        "RecordDate": RecordDate,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime,
      };
}