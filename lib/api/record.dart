class Record {
  int RecordId;
  int UserId;
  int RecordTypeId;
  DateTime RecordDate;

//CONSTRUCTOR DE LA CLASE Registro
  Record({
    required this.RecordId,
    required this.UserId,
    required this.RecordTypeId,
    required this.RecordDate
  });
  //metodo estatico FromJson 
  static Record fromJson(Map<String, dynamic> json){
    return Record(
      RecordId: json['RecordId'] as int, 
      UserId: json['UserId'] as int, 
      RecordTypeId: json['RecordTypeId'] as int, 
      RecordDate: json['RecordDate'] as DateTime
    );
  }
}