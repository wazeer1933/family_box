import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/ServiceApp/View/RequestService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRequestService extends StatefulWidget {
  const MyRequestService({super.key});

  @override
  State<MyRequestService> createState() => _MyRequestServiceState();
}

class _MyRequestServiceState extends State<MyRequestService> with  SingleTickerProviderStateMixin{
    
  late TabController _tabController;
  // final controllerAddCations controller=Get.put(controllerAddCations());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 2,length: 3, vsync: this);
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
        actions: [
           IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
        ],
        title: Text(
          'طلبات الخدمات',
          style: TextStyle(color:AppColors().darkGreen),
        ),
        centerTitle: true,
         bottom: TabBar(
          labelColor: AppColors().darkGreen,
          controller: _tabController,
          tabs: const [
            Tab(icon: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text( "معلق",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                Icon(Icons.error_outline_rounded,size: 30,),
              ],
            ),),
            Tab(icon: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("مرفوض",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                Icon(Icons.error_outlined,size: 30,),
              ],
            ),),
              Tab(icon: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("مقبول",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                Icon(Icons.gpp_good_outlined,size: 30,),
              ],
            ),),
          ],
        ),
      ),
      body:  SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('RequestsUsers')
                        .where('state', isEqualTo: 0)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا يوجد بيانات'));
                      }
                      var data=snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var data1 = data[index];
                          return WidgetCardRquestUsers(des: data1['discriptionRquest'],date: "${data1['createdAt'].toString()}",title: data1['typeRequest'],);
                        },
                      );
                    },
                  ),),
           Container(
              child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('RequestsUsers')
                        .where('state', isEqualTo: 2)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا يوجد بيانات'));
                      }
                      var data=snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var data1 = data[index];
                          return WidgetCardRquestUsers(des: data1['discriptionRquest'],date: "${data1['createdAt'].toString()}",title: data1['typeRequest'],);
                        },
                      );
                    },
                  ),),
           Container(
              child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('RequestsUsers')
                        .where('state', isEqualTo: 1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا يوجد بيانات'));
                      }
                      var data=snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var data1 = data[index];
                          return WidgetCardRquestUsers(des: data1['discriptionRquest'],date: "${data1['createdAt'].toString()}",title: data1['typeRequest'],);
                        },
                      );
                    },
                  ),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: AppColors().darkGreen,child: Icon(Icons.add_circle_outline_outlined,color: Colors.white,),onPressed: (){
        showDialog(context: context, builder: (context){
          return RequsetService();
        });
      }),
    );
  }
}




// ignore: must_be_immutable
class WidgetCardRquestUsers extends StatelessWidget {
  String? title;
  String? des;
  String? date;

   WidgetCardRquestUsers({super.key,this.date,this.des,this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        subtitle:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(child: Text("$des",style: TextStyle(color: AppColors().gray,fontSize: 14,fontWeight: FontWeight.w500),)),
        ) ,
        // leading: Text('$date',textDirection: TextDirection.rtl,),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$title',textDirection: TextDirection.rtl,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors().darkGreen,)),
            
                Text('نوع الطلب :  ',textDirection: TextDirection.rtl,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors().lighBrown,)),
              ],
            ),
        
      ),
    );
  }
}