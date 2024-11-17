import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentCountWidget extends StatelessWidget {
  const DocumentCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('isEnable',isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No documents found");
        }

        // Get the count of documents
        int docCount = snapshot.data!.docs.length;

        return Text(
                                  '$docCount',
                                  style: TextStyle(fontSize: 30,color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
      },
    );
  }
}



class CountIsActive extends StatelessWidget {
  const CountIsActive({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('isEnable',isEqualTo: true).where('isActive',isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('0',
                                  style: TextStyle(fontSize: 30,color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
        }

        // Get the count of documents
        int docCount = snapshot.data!.docs.length;

        return Text('$docCount',
                                  style: TextStyle(fontSize: 30,color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
      },
    );
  }
}




// ignore: must_be_immutable
class ActiveUsers extends StatelessWidget {
  String? uid;
   ActiveUsers({super.key,this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: uid).where('isActive',isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('');
        }
    
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
    
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('غير متصل',style: AppTextStyles.titleStyle.copyWith(color: appColors.lighBrown,fontWeight: FontWeight.w600,fontSize: 15), );
        }
    
        // Get the count of documents
        // bool docCount = snapshot.data!.docs.isNotEmpty;
    
         return Text(snapshot.data!.docs.isNotEmpty?'متصل الان': 'غير متصل',style: AppTextStyles.titleStyle.copyWith(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.blue) );
      },
    );
  }
}






// ignore: must_be_immutable
class CountUsersNew extends StatelessWidget {

   CountUsersNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .where('tree', isEqualTo: '')
                                      .where('isEnable', isEqualTo: false)
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




class CountUsersReq extends StatelessWidget {

   CountUsersReq({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
                                bottom: 0,
                                right: 0,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                           .collection('RequestsUsers')
                                        .where('state', isEqualTo: 0)
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