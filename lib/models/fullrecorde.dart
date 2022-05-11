// To parse this JSON data, do
//
//     final fullRecord = fullRecordFromMap(jsonString);


//NOTE MODELO DE OBTENER UN REGISTRO COMPLETO. 
//NOTE ESTE SE USA EN EDIT RECORD SCREEN.
class FullRecorde{
    FullRecorde({
        required this.RecordDate,
        required this.EntryTime,
        required this.ExitTime,
    });

    String RecordDate;
    String EntryTime;
    String ExitTime;

    factory FullRecorde.fromJson(Map<dynamic, dynamic> json) => FullRecorde(
        RecordDate: json["RecordDate"],
        EntryTime: json["EntryTime"],
        ExitTime: json["ExitTime"],
    );

    Map<dynamic, dynamic> toJson() => {
        "RecordDate": RecordDate,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime,
    };
}
