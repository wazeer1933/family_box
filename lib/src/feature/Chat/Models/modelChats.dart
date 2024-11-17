import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? message;
  String? senderId;
  String? senderName;
  bool? isRead;
  DateTime? timestamp;
  String? fileUrl;

  ChatModel({
    this.id,
    this.message,
    this.senderId,
    this.senderName,
    this.isRead = false,
    this.timestamp,
    this.fileUrl,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      message: map['message'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      isRead: map['isRead'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      fileUrl: map['fileUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'senderId': senderId,
      'senderName': senderName,
      'isRead': isRead,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      'fileUrl': fileUrl,
    };
  }
}
