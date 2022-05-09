// To parse this JSON data, do
//
//     final insertRecord = insertRecordFromJson(jsonString);

import 'dart:convert';

EditRecord editRecordEntryFromJson(String str) => EditRecord.fromJson(json.decode(str));


class EditRecord {
    EditRecord({
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

    factory EditRecord.fromJson(Map<String, dynamic> json) => EditRecord(
        userId: json["UserID"],
        recordDate: json["RecordDate"],
        recordTypeId: json["RecordTypeID"],
        entryTime: json["EntryTime"],
        exitTime: json["ExitTime"]
    );
}
