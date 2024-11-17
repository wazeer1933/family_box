import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable, camel_case_types
class buildProjectCard1 extends StatelessWidget {
  String? title; String? imagePath; int? currentAmount;
      int? targetAmount; Color? barColor;void Function()? onTap;Widget? edite;Widget? delete;double? value;
   buildProjectCard1({Key? key,this.title,this.imagePath,this.currentAmount,this.targetAmount,this.value,this.barColor,this.onTap,this.edite,this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(textDirection: TextDirection.rtl,
                children: [
                  Expanded(flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                         width: 60,
                          height: 70,
                        color: AppColors().grayshade300,
                        child: Image.network(
                          imagePath!,
                          width: 60,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(flex: 7,
                    child: Column(
                      children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Row(children: [
                           delete!,
                           edite!

                          ],),
                            Text(
                              title!,
                              style: TextStyle(
                                fontSize: 13,color: AppColors().darkGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        LinearProgressIndicator(
                          value:value,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(barColor!),
                          minHeight: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("ريال",style: TextStyle(color: AppColors().lighBrown)),
                                Text(' $targetAmount',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: AppColors().lighBrown,),),
                              ],
                            ),
                            Row(
                              children: [
                                Text("ريال",style: TextStyle(color: AppColors().darkGreen),),
                                Text(' $currentAmount',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: AppColors().darkGreen,),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }
}



