// To parse this JSON data, do
//
//     final queryRecord = queryRecordFromJson(jsonString);

import 'dart:convert';

List<QueryRecord> queryRecordFromJson(String str) => List<QueryRecord>.from(json.decode(str).map((x) => QueryRecord.fromJson(x)));

String queryRecordToJson(List<QueryRecord> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueryRecord {
    QueryRecord({
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

    factory QueryRecord.fromJson(Map<String, dynamic> json) => QueryRecord(
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