import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/PageDetilesGroups.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddNotfication.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageNewNotfications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MenuNotfications extends StatefulWidget {
  MenuNotfications({Key? key}) : super(key: key);



  @override
  _MenuNotficationsState createState() => _MenuNotficationsState();
}

class _MenuNotficationsState extends State<MenuNotfications> {
//   void addIfTreeNotFound(String treeValue) {
//   bool treeExists = userController.userList.any((item) => item.value.tree == treeValue);
//   if (!treeExists) {
//     userController.userList.add(ValueItem(
//       label: 'كل المستخدمين',
//       value: User(image: '', uid: 'AllUsers', tree: treeValue),
//     ));
//   }
// }



final controllerAddNotficationImp controller=Get.put(controllerAddNotficationImp());
@override
void initState() {
  super.initState();
  print("object");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
            IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
        ],
        title: const Center(child: Text("الاشعارات",style: AppTextStyles.titleStyle,)),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Notfications')
          // .where('title', isGreaterThan: '') // Example of an inequality condition
      .orderBy('date')
      // .orderBy('date', descending: false)

          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: ListView.builder(
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return ShimmerItem();
            },
          ),);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found'));
        }
        var Data=snapshot.data!.docs;
        return ListView.builder(
          itemCount: Data.length,
          itemBuilder: (BuildContext context, int index) {
            var data=Data[index];
            return Card(color: Colors.white,
                child: ListTile(
                  title: Center(child: Text(data['title'],style: AppTextStyles.titleStyle.copyWith(fontSize: 14),),),
                  trailing: Icon(Icons.notifications_active,color: appColors.primary,),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: Text(data['body'],textDirection: TextDirection.rtl,)),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                     IconButton(onPressed: (){
                      controller.deleteDocument(data.id, context);
                     }, icon: Icon(Icons.delete,color: Colors.red,)),
                            Text(data['date'],style: AppTextStyles.titleStyle.copyWith(fontSize: 15,fontWeight: FontWeight.normal),),
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


        floatingActionButton: FloatingActionButton(
  backgroundColor: appColors.primary,
  onPressed: () {
    controller.date.text="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  
    Get.to(PageNewNotficatons());},
  child: Icon(Icons.add_circle_outline, color: Colors.white),
),

    );
  }
}



