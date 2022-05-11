// To parse this JSON data, do
//
//     final insertRecord = insertRecordFromJson(jsonString);
// EditRecord editRecordEntryToJson(String str) => EditRecord.toJson(json.decode(str));


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

    // factory EditRecord.toJson(Map<String, dynamic> json) => EditRecord(
    //     recordDate: json["RecordDate"],
    //     recordTypeId: json["RecordTypeID"],
    //     entryTime: json["EntryTime"],
    //     exitTime: json["ExitTime"]
    // );
}
