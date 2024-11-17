import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/EventsFamli/View/DisplayEvents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MenuEventsFamily extends StatefulWidget {
  int index=1;
   MenuEventsFamily({Key? key,required this.index}) : super(key: key);

  @override
  State<MenuEventsFamily> createState() => _MenuEventsFamilyState();
}

class _MenuEventsFamilyState extends State<MenuEventsFamily> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  final controllerAddCations controller=Get.put(controllerAddCations());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,initialIndex:widget.index);
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
                Text( "المناسبات",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
            style:AppTextStyles.titleStyle,
          ),
        ),
        actions: [
          IconButton(
            onPressed: ()=>Get.back(),
            icon: Icon(
              Icons.arrow_forward_ios_sharp,
              size: 30,
              color: AppColors().darkGreen,
            ),
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

  const CardAction({Key? key, this.year, this.nameMonth}) : super(key: key);

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
                height: 320,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data1.length,
                  itemBuilder: (context, index) {
                    var data = data1[index];
                    return Card(
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            controllerAddAction.UidDoc = data.id;
                            Get.to(() => DisplayEvents(uidDoc: data.id));
                          },
                          trailing: const Icon(Icons.circle, color: Color(0xFF006400), size: 10),
                          subtitle: 
                          Row(
                            children: [

                      
                          Text('${year}',style: const TextStyle(fontSize: 14.0, color: Colors.grey),),SizedBox(width: 5,),
                              Text('${nameMonth}',style: const TextStyle(fontSize: 14.0, color: Colors.grey),),SizedBox(width: 5,),
                             
                              Text('${data['day']}',style: const TextStyle(fontSize: 14.0, color: Colors.grey),),SizedBox(width: 5,),
                           
                            ],
                          ),
                          title: Text(
                            data['title'] ?? '',
                            textAlign: TextAlign.right,
                            style:  TextStyle(color: AppColors().darkGreen,fontSize: 15.0, fontWeight: FontWeight.bold),
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
