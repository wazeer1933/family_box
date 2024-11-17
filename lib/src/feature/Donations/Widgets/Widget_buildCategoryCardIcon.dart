import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
// ignore: camel_case_types, must_be_immutable
class Widget_buildCategoryCardIcon extends StatelessWidget {
  IconData? icon; String? title;void Function()? onTap;
   Widget_buildCategoryCardIcon({Key? key,this.icon,this.title,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors().lighBrown,
            ),
            SizedBox(height: 10),
            Text(
              title!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, color: AppColors().darkGreen
              ),
            ),
          ],
        ),
      ),
    );
  }
}
