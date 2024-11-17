import 'package:flutter/material.dart';



// ignore: must_be_immutable, camel_case_types
class buildProjectCard extends StatelessWidget {
  String? title; String? imagePath; int? currentAmount;
      int? targetAmount; Color? barColor;void Function()? onTap;
   buildProjectCard({Key? key,this.title,this.imagePath,this.currentAmount,this.targetAmount,this.barColor,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
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
                      child: Image.asset(
                        imagePath!,
                        width: 60,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: currentAmount! / targetAmount!,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(barColor!),
                          minHeight: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("ريال"),
                                Text(' $currentAmount',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.grey,),),
                              ],
                            ),
                            Row(
                              children: [
                                Text("ريال",style: TextStyle(color: Colors.blue),),
                                Text(' $currentAmount',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.blue,),),
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



