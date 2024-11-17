import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/PageDetilesGroups.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuUsers.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddNotfication.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDonations.dart';
import 'package:family_box/src/feature/EventsFamli/View/MenuEventsFamily.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Notfications extends StatefulWidget {
  Notfications({Key? key}) : super(key: key);



  @override
  _NotficationsState createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> {
final controllerAddNotficationImp controller=Get.put(controllerAddNotficationImp());

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_outlined), // Custom back arrow on the right
            onPressed: () {
              Navigator.pop(context); // Navigate back when pressed
            },
          ),
        ],
        title: const Center(child: Text("الاشعارات",style: AppTextStyles.titleStyle,)),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream:
       currentUserData.isNotEmpty&&currentUserData[0]['isAdmin']==false?
       FirebaseFirestore.instance.collection('Notfications').where('IdUserRecive',arrayContainsAny: ['AllUsers',currentUserId]).orderBy('date',descending: false).snapshots():
        currentUserData.isNotEmpty&&currentUserData[0]['isAdmin']==true?
       FirebaseFirestore.instance.collection('Notfications').where('IdUserRecive',arrayContainsAny: ['AllUsers',currentUserId,'isAdmin']).orderBy('date',descending: false).snapshots():
      
       FirebaseFirestore.instance.collection('Notfications').where('IdUserRecive',arrayContainsAny: ['AllUsers',currentUserId]).orderBy('date',descending: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ShimmerItem(),
              );
            },
          ),);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لايوجد اشعارات'));
        }
        var Data=snapshot.data!.docs;
        
        return ListView.builder(
          itemCount: Data.length,
          itemBuilder: (BuildContext context, int index) {
            var data=Data[index];
                    bool isRead = data['isRead'];

                    if (!isRead) {
                      controller.markMessageAsRead(data.id);
                    }
            return Card(color: Colors.white,
                child: ListTile(
                  onTap: (){
                    if(data['type']!=null){
                      if(data['type']=='حدث'||data['type']=='مناسبة')Get.to(MenuEventsFamily(index: 1,));
                      if(data['type']=='تبرع')Get.to(DonationsPage());
                      if(data['type']=='حساب')Get.to(PageUsers());

                    }
                  },
                  title: Center(child: Text(data['title'],style: AppTextStyles.titleStyle.copyWith(fontSize: 14),),),
                  trailing: Icon(Icons.notifications_active,color: appColors.primary,),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: Text(data['body'],textDirection: TextDirection.rtl,)),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(data['date'],style: AppTextStyles.titleStyle.copyWith(fontSize: 15,fontWeight: FontWeight.w700),),
                          ],
                        ),
                    
                      ],
                    ),
                  ),
                  )
                );
          },
        );
      },
    ),



    );
  }
}



