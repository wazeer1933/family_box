import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/View/PageAddAction.dart';
import 'package:family_box/src/feature/Dashbord/View/PageEditeActions.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/EventsFamli/View/DisplayEvents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuActions extends StatefulWidget {
  const MenuActions({Key? key}) : super(key: key);

  @override
  State<MenuActions> createState() => _MenuActionsState();
}

class _MenuActionsState extends State<MenuActions> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  final controllerAddCations controller=Get.put(controllerAddCations());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1,length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        bottom: TabBar(
          labelColor: AppColors().darkGreen,
          controller: _tabController,
          tabs: const [
            Tab(icon: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text( "المناسبات  ",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                Icon(Icons.flourescent,size: 30,),
              ],
            ),),
            Tab(icon: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("الاحداث",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                Icon(Icons.attractions_rounded,size: 30,),
              ],
            ),),
          ],
        ),
        title: const Center(
          child: Text(
            "الاحداث و المناسبات العائلية",
            style: TextStyle(color: Color(0xFF006400)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStreamBuilder("فعالية"),
          _buildStreamBuilder("حدث"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().darkGreen,
        onPressed: () {
          Get.to(() => PageAddAcations());
        },
        child: const Icon(
          Icons.add_circle_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStreamBuilder(String actionType) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('actions')
          .where('actionsType', isEqualTo: actionType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        final Set<String> uniqueDataKeys = {};
        final uniqueDocs = snapshot.data!.docs.where((doc) {
          String uniqueKey = '${doc['Year']}_${doc['nameMonth']}';
          if (uniqueDataKeys.contains(uniqueKey)) {
            return false;
          } else {
            uniqueDataKeys.add(uniqueKey);
            return true;
          }
        }).toList();

        return ListView.builder(
          itemCount: uniqueDocs.length,
          itemBuilder: (context, index) {
            var data = uniqueDocs[index];
            return CardAction(
              year: data['Year'],
              nameMonth: data['nameMonth'],
            );
          },
        );
      },
    );
  }
}

class CardAction extends StatelessWidget {
  final String? year;
  final String? nameMonth;

   CardAction({Key? key, this.year, this.nameMonth}) : super(key: key);
  final controllerAddCations controller=Get.put(controllerAddCations());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        iconColor: const Color(0xFF006400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        title: Text(
          '${year ?? ''}  ${nameMonth ?? ''}',
          style: const TextStyle(
            color: Color(0xFF006400),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('actions')
                .where('Year', isEqualTo: year)
                .where('nameMonth', isEqualTo: nameMonth)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('لايوجد بيانات'));
              }

              final data1 = snapshot.data!.docs;
              return SizedBox(
                height: 350,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data1.length,
                  itemBuilder: (context, index) {
                    var data = data1[index];
                    return Card(
                      color: AppColors().grayshade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            controllerAddAction.UidDoc = data.id;
                            Get.to(() => DisplayEvents(uidDoc: data.id));
                          },
                          trailing: const Icon(Icons.circle, color: Color(0xFF006400), size: 10),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: (context)=>AlertDialog(
                              title: Center(child: CircleAvatar(backgroundColor: Colors.red,child: Icon(Icons.question_mark_rounded,color: Colors.white
                              ,size: 30,)),),
                              content: Container(height: 50,width: double.maxFinite,child: Center(child: 
                              Text("هل تريد حذف  النشاط حقا ؟",style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.w600,fontSize: 16),)
                              ,),),
                              actions: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(width: 90,
                   child: MaterialButton(
                    minWidth: 15,
                    color: Colors.red[100],
                    onPressed: (){Get.back();},child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.error_outline_rounded,color: Colors.red,),Text("الغاء",style: TextStyle(fontWeight: FontWeight.bold))],),),
                 ),
                 Container(width: 90,
                   child: MaterialButton(
                    minWidth: 150,
                    color:AppColors().lighBrown,
                    onPressed: (){
                     controller.deleteDocument(data.id, context);
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.save,color: Colors.green,),Text("نعم",style: TextStyle(fontWeight: FontWeight.bold),)],),),
                 )
                 ],)
                              ],
                            ));
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                    controllerAddAction.actionTypeController.text=data['actionsType'];
                                     controllerAddAction.actionTitleController.text=data['title'];
                                     controllerAddAction.date='${data['nameMonth']} / ${data['Year']}/  ${data['day']} ';
                                     controllerAddAction.address.text =data['address'];
                                    controllerAddAction.  actionDescriptionController.text=data['actionsDescription'];
                                     controllerAddAction.  Year=data['Year'];
                                       controllerAddAction. Time=data['day'];
                                        controllerAddAction.nameMonth=data['nameMonth'];
                                       controllerAddAction. uIdUserReqController.text=data['actionsUserId'];
                                       controllerAddAction. EditeImageUrl=data['imageUrl'];
                                       controllerAddAction. uidUserCreated=data['uidUserCreated'];
                                       controllerAddAction. latitude=data['latitude'];
                                       controllerAddAction. longitude=data['longitude'];
                                        print("=============================");
                                        print(controllerAddAction.EditeImageUrl);
                                     controllerAddAction. UidDoc=data.id;
                                    Get.to(() => PageEditeActions());
                                      // controllerAddAction.populateFromData(data);
                                    },
                                    icon: Icon(Icons.edit_square, color: AppColors().darkGreen),
                                  ),
                                ],
                              ),
                              Text(
                                '${nameMonth} ${data['day']}',
                                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                              ),
                            ],
                          ),
                          title: Text(
                            data['title'] ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: appColors.primary),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
