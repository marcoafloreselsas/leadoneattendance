// To parse this JSON data, do
//
//     final queryRecord = queryRecordFromJson(jsonString);

import 'dart:convert';

List<QueryRecordAdmin> queryRecordAdminFromJson(String str) => List<QueryRecordAdmin>.from(json.decode(str).map((x) => QueryRecordAdmin.fromJson(x)));

String queryRecordAdminToJson(List<QueryRecordAdmin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueryRecordAdmin {
    QueryRecordAdmin({
        required this.name,
        required this.recordType,
        required this.recordDate,
        required this.entryTime,
        required this.exitTime,
        // required this.totalHours,
        required this.weekNumber,
    });

    String name;
    String recordType;
    String recordDate;
    String entryTime;
    String exitTime;
    // String totalHours;
    int weekNumber;

    factory QueryRecordAdmin.fromJson(Map<String, dynamic> json) => QueryRecordAdmin(
        name: json["Name"],
        recordType: json["RecordType"],
        recordDate: json["RecordDate"],
        entryTime: json["EntryTime"],
        exitTime: json["ExitTime"],
        // totalHours: json["TotalHours"],
        weekNumber: json["WeekNumber"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "RecordType": recordType,
        "RecordDate": recordDate,
        "EntryTime": entryTime,
        "ExitTime": exitTime,
        // "TotalHours": totalHours,
        "WeekNumber": weekNumber,
    };
}