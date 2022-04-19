//CLASE QUE CARGA LOS REGISTROS
class Record {
  late DateTime RecordDate;
  late DateTime EntryTime;
  late DateTime ExitTime;


  Record(
      {
      required this.RecordDate,
      required this.EntryTime,
      required this.ExitTime
      });

  Record.fromJson(Map<String, dynamic> json) {
    RecordDate = json['RecordDate'];
    EntryTime = json['EntryTime'];
    ExitTime= json['ExitTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RecordDate'] = RecordDate;
    data['EntryTime'] = EntryTime;
    data['ExitTime'] = ExitTime;
    return data;
  }
}