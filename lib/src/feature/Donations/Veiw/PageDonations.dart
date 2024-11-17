
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WdigetCardDonations.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageClothes.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDetilesOtherDonation.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageFoods.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageHome.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageProjects.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageSecurities.dart';
import 'package:family_box/src/feature/Donations/Veiw/pageHealthy.dart';
import 'package:family_box/src/feature/Donations/Widgets/Widget_buildCategoryCardIcon.dart';
import 'package:family_box/src/feature/Donations/Widgets/widgetItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationsPage extends StatelessWidget {
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
        title: Center(
          child: Text(
            'الدعم العائلي',
            style: AppTextStyles.titleStylePageSize
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5), // Adjust spacing here to avoid overflow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Widget_buildCategoryCardIcon(
                  icon: Icons.home,
                  title: 'الإسكان',
                  onTap: () {
                    Get.to(PageHome());
                  },
                ),
                Widget_buildCategoryCardIcon(
                  icon: Icons.money,
                  title: 'الاموال',
                  onTap: () {
                    Get.to(PageMoney());
                  },
                ),
                Widget_buildCategoryCardIcon(
                  icon: Icons.favorite,
                  title: 'الصحة',
                  onTap: () {
                    Get.to(PageHealthy());
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Widget_buildCategoryCardIcon(
                  icon: Icons.lightbulb_outline,
                  title: 'المشاريع',
                  onTap: () {
                    Get.to(PageProjects());
                  },
                ),
                Widget_buildCategoryCardIcon(
                  icon: Icons.food_bank_rounded,
                  title: 'الطعام',
                  onTap: () {
                    Get.to(PageFoods());
                  },
                ),
                Widget_buildCategoryCardIcon(
                  icon: Icons.local_laundry_service,
                  title: 'الملابس',
                  onTap: () {
                    Get.to(PageClothes());
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'اخر المشاريع  التبرعات',
                    style: TextStyle(color: appColors.lighBrown,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0), // Added spacing for better layout
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              child: WidgetCardDonations(IsAll: false,itemCount: 2,show: false,physics: NeverScrollableScrollPhysics(),
              ),
            ),
            //  SizedBox(height: 0),
            const Align(alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                        'الزكاة و الاوقاف و الصدقة',
                        style: TextStyle(color: Color.fromARGB(255, 219, 181, 131),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          NewsItem1(onTap: (){
            Get.to(DetilesOtherDonation(type: 1,));
          }, imageUrl: 'assets/images/s.png', title: 'صدقة', body: 'صدقتك علئ ذي القربين أجران قربئ واحسان'),
           NewsItem1(onTap: (){
            Get.to(DetilesOtherDonation(type: 2,));
           
           }, imageUrl: 'assets/images/z.png', title: 'زكاة', body: 'أخرج زكاتك لاتبالي فاقامة يزداد مالك ان بذلت لحقه طهر '),
           NewsItem1(onTap: (){
            Get.to(DetilesOtherDonation(type: 3,));
           
           }, imageUrl: 'assets/images/w.png', title: 'وقف', body: 'أدخر لنفسك للحياة الباقية')
          ],
        ),
      ),
    );
  }
}
