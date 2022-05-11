// To parse this JSON data, do
//
//     final fullRecord = fullRecordFromMap(jsonString);


//NOTE MODELO DE OBTENER UN REGISTRO COMPLETO.

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<dynamic, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class FullRecord {
    FullRecord({
        required this.date,
        required this.name,
        required this.recordType1,
        required this.entryTime1,
        required this.exitTime1,
        required this.recordType2,
        required this.entryTime2,
        required this.exitTime2,
        required this.recordType3,
        required this.entrytime3,
        required this.exitTime3,
    });

    String date;
    String name;
    String recordType1;
    String entryTime1;
    String exitTime1;
    String recordType2;
    String entryTime2;
    String exitTime2;
    String recordType3;
    String entrytime3;
    String exitTime3;

    factory FullRecord.fromJson(Map<dynamic, dynamic> json) => FullRecord(
        date: json["Date"],
        name: json["Name"],
        recordType1: json["RecordType1"],
        entryTime1: json["EntryTime1"],
        exitTime1: json["ExitTime1"],
        recordType2: json["RecordType2"],
        entryTime2: json["EntryTime2"],
        exitTime2: json["ExitTime2"],
        recordType3: json["RecordType3"],
        entrytime3: json["Entrytime3"],
        exitTime3: json["ExitTime3"],
    );
}
