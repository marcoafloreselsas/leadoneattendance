// To parse this JSON data, do
//
//     final insertRecord = insertRecordFromJson(jsonString);

import 'dart:convert';

InsertRecord insertRecordFromJson(String str) => InsertRecord.fromJson(json.decode(str));


class InsertRecord {
    InsertRecord({
        required this.userId,
        required this.recordDate,
        required this.recordTypeId,
        required this.entryTime,
        required this.exitTime,
    });

    int userId;
    String recordDate;
    int recordTypeId;
    String entryTime;
    String exitTime;

    factory InsertRecord.fromJson(Map<String, dynamic> json) => InsertRecord(
        userId: json["UserID"],
        recordDate: json["RecordDate"],
        recordTypeId: json["RecordTypeID"],
        entryTime: json["EntryTime"],
        exitTime: json["ExitTime"],
    );


}
