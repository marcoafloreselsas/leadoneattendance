// To parse this JSON data, do
//
//     final insertRecord = insertRecordFromJson(jsonString);

import 'dart:convert';

InsertRecordExit insertRecordExitFromJson(String str) => InsertRecordExit.fromJson(json.decode(str));


class InsertRecordExit {
    InsertRecordExit({
        required this.userId,
        required this.recordDate,
        required this.recordTypeId,
        required this.exitTime,
    });

    int userId;
    String recordDate;
    int recordTypeId;
    String exitTime;

    factory InsertRecordExit.fromJson(Map<String, dynamic> json) => InsertRecordExit(
        userId: json["UserID"],
        recordDate: json["RecordDate"],
        recordTypeId: json["RecordTypeID"],
        exitTime: json["ExitTime"],
    );


}
