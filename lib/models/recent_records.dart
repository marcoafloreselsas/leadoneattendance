// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

import 'dart:ffi';

List<RecentRecords> postsFromJson(String str) => List<RecentRecords>.from(json.decode(str).map((x) => RecentRecords.fromJson(x)));

String postsToJson(List<RecentRecords> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecentRecords {
    RecentRecords({
        required this.UserID,
        required this.RecordDate,
        required this.EntryTime,
        required this.ExitTime,
    });

    int UserID;
    DateTime RecordDate;
    DateTime EntryTime;
    DateTime ExitTime;

    factory RecentRecords.fromJson(Map<String, dynamic> json) => RecentRecords(
        UserID: json["1"],
        RecordDate: json["RecordDate"],
        EntryTime: json["EntryTime"],
        ExitTime: json["ExitTime"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": UserID,
        "RecordDate": RecordDate,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime,
    };
}