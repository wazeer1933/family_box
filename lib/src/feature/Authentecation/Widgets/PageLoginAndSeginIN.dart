import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Screens/login/login.dart';
import 'package:family_box/src/feature/Authentecation/Screens/register/register.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/PhotoAlbumsScreen.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/connect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageLoginAndSeginin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Define responsive padding and sizes
    double horizontalPadding = screenWidth > 600 ? 40.0 : 20.0;
    double iconSize = screenWidth > 600 ? 60.0 : 50.0;
    double buttonHeight = screenWidth > 600 ? 60.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: screenWidth > 600 ? 250 : 150,
                        child: Image.asset(
                          'assets/images/IconApp.png', // Replace with your decorative lines asset
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            
                    // Logo and Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.family_restroom, size: iconSize, color: appColors.primary), // Replace with your logo
                        SizedBox(width: 10,),
                        Text(
                          'شؤون عائلة اللحيدان',
                          style: TextStyle(
                            fontSize: screenWidth > 600 ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: appColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth > 600 ? 50 : 30),
            
                    // Icon buttons grid
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                       GestureDetector(
                          onTap: () => Get.to(ContactPage()),
                          child: IconButtonWidget(icon: Icons.phone, label: 'اتصل بنا'),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(PhotoAlbumsScreen()),
                          child: IconButtonWidget(icon: Icons.photo_library, label: 'معرض الصور'),
                        ),
                    ],),
                    SizedBox(height: screenWidth > 600 ? 50 : 30),
            
                    // Login and Register buttons
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(LoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.primary, // Button color
                            minimumSize: Size(double.infinity, buttonHeight),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: AppTextStyles.titleStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {
                            Get.to(RegisterScreen());
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, buttonHeight),
                            side: BorderSide(color: appColors.primary),
                          ),
                          child: Text(
                            'تسجيل',
                            style: AppTextStyles.titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth > 600 ? 40 : 30;
    double padding = screenWidth > 600 ? 16.0 : 12.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(padding),
          child: Icon(icon, color: appColors.primary, size: iconSize),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: appColors.primary)),
      ],
    );
  }
}
