import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/ServiceApp/controllers/controllersSedRquests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequsetUsers extends StatefulWidget {
  const RequsetUsers({super.key});

  @override
  State<RequsetUsers> createState() => _RequsetUsersState();
}

class _RequsetUsersState extends State<RequsetUsers> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 2, length: 3, vsync: this);
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
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
        title: Text(
          'طلابات المستخدمين',
          style: TextStyle(color: AppColors().darkGreen),
        ),
        centerTitle: true,
        bottom: TabBar(
          labelColor: AppColors().darkGreen,
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("معلق", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Icon(Icons.error_outline_rounded, size: 30),
                ],
              ),
            ),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("مقبول", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Icon(Icons.gpp_good_outlined, size: 30),
                ],
              ),
            ),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("مرفوض", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Icon(Icons.error_outlined, size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Repeat the same logic in each tab with a different state value (0, 2, 1)
            buildRequestListView(0),
            buildRequestListView(2),
            buildRequestListView(1),
          ],
        ),
      ),
    );
  }

  Widget buildRequestListView(int state) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('RequestsUsers')
          .where('state', isEqualTo: state)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لا يوجد بيانات'));
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var data1 = data[index];
            return WidgetCardRquestUsers(
              date: "${data1['createdAt'].toString()}",
              title: data1['typeRequest'],
              des: data1['discriptionRquest'],
              docId: data1.id,
              uiduser: data1['idUserRqu'], // Pass uid to widget
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class WidgetCardRquestUsers extends StatelessWidget {
  final String? date;
  final String? title;
  final String? des;
  final String? docId;
  final String? uiduser;

  WidgetCardRquestUsers({super.key, this.title, this.date, this.des, this.docId, this.uiduser});
  final controllerSendRequset controller = Get.put(controllerSendRequset());

  Future<String> getUserName() async {
    if (uiduser == null) return 'Unknown';
    var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uiduser).get();
    return userSnapshot.exists ? userSnapshot['name'] : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder<String>(
              future: getUserName(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.connectionState == ConnectionState.waiting
                      ? '...انتظر'
                      : 'اسم المقدم / ${snapshot.data}' ,
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                );
              },
            ),
            Text('وصف الطلب / $des'),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildStatusButton(context, "مقبول", Colors.green, 'قبول'),
                buildStatusButton(context, "مرفوض", Colors.red, 'رفوض'),
                buildStatusButton(context, "معلق", Colors.grey, 'تعليق'),
              ],
            ),
          ],
        ),
       
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(' $date', textDirection: TextDirection.rtl),
            Text('نوع الطلب / $title', textDirection: TextDirection.rtl, style: TextStyle(fontWeight: FontWeight.w400,color: AppColors().darkGreen)),
          ],
        ),
      ),
    );
  }

  TextButton buildStatusButton(BuildContext context, String label, Color color, String title) {
    return TextButton(
      onPressed: () {
        controller.uidDoc = docId;
        showDialog(context: context, builder: (context) => _buildJoinConfirmationDialog(title, context));
      },
      child: Text(label, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w700)),
    );
  }

  AlertDialog _buildJoinConfirmationDialog(String title, BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        height: 70,
        child: Center(
          child: Text(
            "هل تريد $title الطلب فعلا",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors().darkGreen,
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildDialogButton(context, "الغاء", Colors.red),
            buildDialogButton(context, "نعم", AppColors().darkGreen, onPressed: () {
              controller.UpdateRequestUsers(context, title == 'قبول' ? 2 : title == 'رفوض' ? 1 : 0);
            }),
          ],
        ),
      ],
    );
  }

  MaterialButton buildDialogButton(BuildContext context, String label, Color color, {void Function()? onPressed}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minWidth: 70,
      height: 40,
      color: color,
      onPressed: onPressed ?? () => Get.back(),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
