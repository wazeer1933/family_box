import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class pagePrivacy extends StatelessWidget {
  const pagePrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
         automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_forward_ios_sharp))
        ],
        title: Center(child: Text('سيـاسـة الـخـصـوصيـة',style: AppTextStyles.titleStyle,),),),
        body:  ///////////////////////////////////////////////////////////////////////////////////////////////
                SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('setings').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                          
                              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text(" لاتتوفر  سيـاسـة الـخـصـوصيـة"));
                              }
                          
                              // Assuming phone number is stored in the first document
                              var privacy = snapshot.data!.docs.first['privacy'] ?? " لاتتوفر  سيـاسـة الـخـصـوصيـة";
                             
                          
                          
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('$privacy',style: AppTextStyles.subtitleStyle.copyWith(fontSize: 17),textDirection: TextDirection.rtl,),
                              );
                            },
                          ),
                ),
                ///////////////////////////////////////////////////////////////////////////////////////////////////////      

    );
  }
}