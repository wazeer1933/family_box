import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class countNotficationsNoReaded extends StatelessWidget {
   countNotficationsNoReaded({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Notfications')
                                      .where('IdUserRecive',arrayContainsAny: ['AllUsers',currentUserId])
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, messageSnapshot) {
                                    if (messageSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container());
                                          }
                                    if (!messageSnapshot.hasData ||
                                        messageSnapshot.data!.docs.isEmpty) {
                                      return const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                    }
                                    int unreadCount;
                                     unreadCount = messageSnapshot.data!.docs.length;
                                     print("=====================$unreadCount");
                                    return CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: const TextStyle(
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