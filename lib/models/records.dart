// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

//NOTE MODELO DE OBTENER CINCO REGISTROS RECIENTES.
import 'dart:convert';

Welcome welcomeFromMap(String str) => Welcome.fromMap(json.decode(str));

String welcomeToMap(Welcome data) => json.encode(data.toMap());

class Welcome {
    Welcome({
        required this.records,
    });

    List<Record> records;

    factory Welcome.fromMap(Map<dynamic, dynamic> json) => Welcome(
        records: List<Record>.from(json["Records"].map((x) => Record.fromMap(x))),
    );

    Map<dynamic, dynamic> toMap() => {
        "Records": List<dynamic>.from(records.map((x) => x.toMap())),
    };
}

class Record {
    Record({
        required this.RecordDate,
        required this.EntryTime,
        required this.ExitTime,
    });

    String RecordDate;
    String EntryTime;
    String ExitTime;

    factory Record.fromMap(Map<dynamic, dynamic> json) => Record(
        RecordDate: json["RecordDate"],
        EntryTime: json["EntryTime"],
        ExitTime: json["ExitTime"],
    );

    Map<dynamic, dynamic> toMap() => {
        "RecordDate": RecordDate,
        "EntryTime": EntryTime,
        "ExitTime": ExitTime,
    };
}

