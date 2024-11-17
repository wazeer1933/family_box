import 'package:family_box/src/feature/Donations/Widgets/Widget_buildProjectCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class PageProjectsDonations extends StatelessWidget {
  const PageProjectsDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        title: Center(child: Text("المشاريع الصحية"),),),
      body: Padding(padding: EdgeInsets.all(0.0),child: Column(children: [
        buildProjectCard(title:'مشروع اطعام 10 أسرة',imagePath:'assets/images/IconApp.jpg',currentAmount:2200,targetAmount:3000,barColor:Colors.orange,),
        buildProjectCard(title:'مشروع اطعام 10 أسرة',imagePath:'assets/images/IconApp.jpg',currentAmount:2200,targetAmount:3000,barColor:Colors.orange,),
        buildProjectCard(title:'مشروع اطعام 10 أسرة',imagePath:'assets/images/IconApp.jpg',currentAmount:2200,targetAmount:3000,barColor:Colors.orange,),
        buildProjectCard(title:'مشروع اطعام 10 أسرة',imagePath:'assets/images/IconApp.jpg',currentAmount:2200,targetAmount:3000,barColor:Colors.orange,),

      ],
      ),
      ),
    );
  }
}
