import 'package:flutter/material.dart';

class AppColors{
  Color blueshade600=Colors.blue.shade600;
  Color blue=Colors.blue;
  Color yellow=Colors.yellow.shade600;
  Color grayshade300=Colors.grey.shade300;
  Color gray=Colors.grey;
  Color orange=Colors.orange.shade300;
  Color white=Colors.white;
       Color darkGreenForms=  Color.fromARGB(255, 240, 248, 240);
  Color darkGreen=Color(0xFF006400);
  Color lighBrown=Color(0XFFD2B48C);
  Color nextBrown=Color.fromARGB(255, 240, 217, 209);







}

class appColors {
  static const Color primary = Color(0xFF006400); // Customize as per image
  static const Color accent = Color(0xFF4CAF50); // WhatsApp color
  static const Color background = Colors.white;
  static const Color darkText = Color(0xFF4A4A4A);
    static const Color lighBrown=Color(0XFFD2B48C);
  static const Color white = Colors.white;


}

class AppTextStyles {
  static const titleStyle = TextStyle(color: appColors.primary,fontSize: 16, fontWeight: FontWeight.bold);
  static const titleStylePageSize = TextStyle(color: appColors.primary,fontSize: 20, fontWeight: FontWeight.bold);

  static const subtitleStyle = TextStyle(fontSize: 14, color: appColors.darkText);
  static const bodyStyle = TextStyle(fontSize: 12, color: appColors.darkText);
}