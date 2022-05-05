// To parse this JSON data, do
//
//     final getUsers = getUsersFromJson(jsonString);

import 'dart:convert';

List<GetUsers> getUsersFromJson(String str) => List<GetUsers>.from(json.decode(str).map((x) => GetUsers.fromJson(x)));

String getUsersToJson(List<GetUsers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsers {
    GetUsers({
        required this.userId,
        required this.name,
    });

    int userId;
    String name;

    factory GetUsers.fromJson(Map<String, dynamic> json) => GetUsers(
        userId: json["UserID"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Name": name,
    };
}
