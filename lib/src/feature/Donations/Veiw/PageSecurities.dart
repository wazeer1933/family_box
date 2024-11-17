import 'package:family_box/src/feature/Dashbord/Widgets/WdigetCardDonations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageMoney extends StatelessWidget {
  const PageMoney({super.key});

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
        title: Center(child: Text("المال"),),),
      body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
        
        child: WidgetCardDonations(IsAll: true, itemCount: 
      6, show: false,isEqualTo: 'المال',),),
    );
  }
}