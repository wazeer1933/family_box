import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/View/PageAddDonations.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WdigetCardDonations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuDonations extends StatefulWidget {
  const MenuDonations({super.key});

  @override
  State<MenuDonations> createState() => _MenuDonationsState();
}

 final List<Item> items = [
    Item(name: 'الكل', icon: Icons.align_horizontal_left_rounded, status: 'الكل', date: '2023-10-06'),
    Item(name: 'الصحة', icon: Icons.favorite_border_outlined, status: 'الصحة', date: '2023-10-01'),
    Item(name: 'المال', icon: Icons.money, status: 'الاموال', date: '2023-10-02'),
    Item(name: 'الاسكان', icon: Icons.home, status: 'الاسكان', date: '2023-10-03'),
    Item(name: 'الملابس', icon: Icons.local_laundry_service, status: 'الملابس', date: '2023-10-04'),
    Item(name: 'الطعام', icon: Icons.food_bank_rounded, status: 'الطعام', date: '2023-10-04'),
    Item(name: 'المشاريع', icon: Icons.lightbulb_outline, status: 'المشاريع', date: '2023-10-04'),


  ];

class _MenuDonationsState extends State<MenuDonations> {
  String? selectedName="الكل";
  int?selectedIndex=0;
  String?dateSelected="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "التبرعات",
            style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF006400)),
          ),
        ),
        actions: [
         
          IconButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (context) => AlertDialog(actionsPadding: EdgeInsets.all(5),
    contentPadding: EdgeInsets.all(10),
      title: Align(alignment: Alignment.centerRight,child: Text(" فرز حسب المشاريع",style: TextStyle(fontStyle: FontStyle.italic,color: AppColors().darkGreen,fontWeight: FontWeight.w700),)),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item =items[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                selectedName=item.name;
                Get.back();
                  print(selectedName);
                });
              },
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color:selectedIndex == index ? AppColors().darkGreen : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: Colors.black),
                    SizedBox(width: 10),
                    Text(item.name,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w700)),
                    // Spacer(),
                    SizedBox(height: 45,)
                    // TextButton(onPressed:(){}, child:  Text(dateSelected!, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("الغاء",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen)),
          ),
        ),
      ],
    ),
            );
            },
            icon: Icon(Icons.filter_alt_outlined, size: 30, color: AppColors().darkGreen),
          ),


            IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
      ),
      body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
      
        child: WidgetCardDonations(isEqualTo: selectedIndex==0?null:selectedName ,IsAll: true, itemCount: 6, show: true, physics: ScrollPhysics(),)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().darkGreen,
        onPressed: () {
          Get.to(PageAddDonations());
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
      ),
    );
  }
}



class ShimmerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (
      BuildContext context,int index){
      return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: 0.5,
                duration: Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [AppColors().darkGreenForms, Colors.grey, AppColors().lighBrown],
                      stops: [0.1, 0.5, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    });
  }
}

Color _getProgressColor(double percent) {
  if (percent < 50) {
    return Colors.yellow;
  } else if (percent < 80) {
    return Colors.blueAccent;
  } else if (percent < 90) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

class Item {
  final String name;
  final IconData icon;
  final String status;
  final String date;

  Item({
    required this.name,
    required this.icon,
    required this.status,
    required this.date,
  });
}