

    import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:family_box/main.dart';
import 'package:flutter/material.dart';




// ignore: must_be_immutable
class CounUnReadMess extends StatelessWidget {
  String? chatId;
String?frindId;
   CounUnReadMess({super.key,this.chatId,this.frindId});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Cahts')
                                      .doc(chatId)
                                      .collection('messages')
                                      .where('senderId', isEqualTo: frindId)
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, messageSnapshot) {
                                    if (messageSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container());
                                          }
                                    if (!messageSnapshot.hasData ||
                                        messageSnapshot.data!.docs.isEmpty) {
                                      return SizedBox();
                                    }
                                    int unreadCount;
                                     unreadCount = messageSnapshot.data!.docs.length;
                                    return CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
  }
}


// ignore: must_be_immutable
class CounUnReadMessGr extends StatelessWidget {
  String? chatId;
List? frindId;
   CounUnReadMessGr({super.key,this.chatId,this.frindId});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Cahts')
                                      .doc(chatId)
                                      .collection('messages')
                                      .where('senderId', whereIn: frindId)
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, messageSnapshot) {
                                    if (messageSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container());
                                          }
                                    if (!messageSnapshot.hasData ||
                                        messageSnapshot.data!.docs.isEmpty) {
                                      return SizedBox();
                                    }
                                    int unreadCount;
                                     unreadCount = messageSnapshot.data!.docs.length;
                                    return CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
  }
}







// ignore: must_be_immutable
class CounUnReadMessConn extends StatelessWidget {
  String? chatId;
String? frindId;
   CounUnReadMessConn({super.key,this.chatId,this.frindId});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('ChatConnet')
                                      .doc(chatId)
                                      .collection('messages')
                                      .where('uidUser', whereIn: [frindId])
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, messageSnapshot) {
                                    if (messageSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container());
                                          }
                                    if (!messageSnapshot.hasData ||
                                        messageSnapshot.data!.docs.isEmpty) {
                                      return SizedBox();
                                    }
                                    int unreadCount;
                                     unreadCount = messageSnapshot.data!.docs.length;
                                    return CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
  }
}





// ignore: must_be_immutable
class CounUnReadMessConnUser extends StatelessWidget {
  String? chatId;
String? frindId;
   CounUnReadMessConnUser({super.key,this.chatId,this.frindId});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('ChatConnet')
                                      .doc(chatId!.replaceAll(' ', ''))
                                      .collection('messages')
                                      .where('uidUser', whereNotIn: [frindId])
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, messageSnapshot) {
                                    
                                    if (messageSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container());
                                          }
                                    if (messageSnapshot.hasData) {
                                      return SizedBox();
                                    }
                                    int unreadCount;
                                     unreadCount = messageSnapshot.data!.docs.length;
                                    return CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
  }
}