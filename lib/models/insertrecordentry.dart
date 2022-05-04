// To parse this JSON data, do
//
//     final insertRecord = insertRecordFromJson(jsonString);

import 'dart:convert';

InsertRecordEntry insertRecordEntryFromJson(String str) => InsertRecordEntry.fromJson(json.decode(str));


class InsertRecordEntry {
    InsertRecordEntry({
        required this.userId,
        required this.recordDate,
        required this.recordTypeId,
        required this.entryTime,
        required this.exitTime
    });

    int userId;
    String recordDate;
    int recordTypeId;
    String entryTime;
    String exitTime;

    factory InsertRecordEntry.fromJson(Map<String, dynamic> json) => InsertRecordEntry(
        userId: json["UserID"],
        recordDate: json["RecordDate"],
        recordTypeId: json["RecordTypeID"],
        entryTime: json["EntryTime"],
        exitTime: json["ExitTime"]

    );


}
