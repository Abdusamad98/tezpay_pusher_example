

import 'dart:io';

class ChatMessage {
  final int id;
  final bool isAdminMessage;
  final String text;
  final bool status;
  final bool isFile;
  final String admin;
  final DateTime createdAt;
  String? year;
  File? image;

  ChatMessage({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.text,
    required this.admin,
    required this.isAdminMessage,
    required this.isFile,
    this.year,
    this.image,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    int status = json["status"] as int? ?? 0;
    DateTime dateTime = DateTime.parse(json["created_at"]);

    String date =  json['created_at'] != null
        ? "${dateTime.year}.${dateTime.month}.${dateTime.day}"
        : "${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}";

    return ChatMessage(
      id: json["id"] as int? ?? 0,
      status: status == 1 ? true : false,
      createdAt: DateTime.parse(
          json["created_at"] as String? ?? DateTime.now().toString()),
      text: json["text"] as String? ?? "",
      admin: json["admin"] as String? ?? "",
      isAdminMessage: json["is_admin_message"] as bool? ?? false,
      isFile: json["is_file"] as bool? ?? false,
      year: date,
    );
  }
}