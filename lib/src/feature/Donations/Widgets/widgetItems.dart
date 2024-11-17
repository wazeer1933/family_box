
// ignore: must_be_immutable
import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewsItem1 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String body;
void Function()? onTap;
   NewsItem1({
    Key? key,
   required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Padding(
         padding: const EdgeInsets.only(left: 20,right: 20),
        child: Container(
          // padding: const EdgeInsets.all(16),
          padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Row(textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // ignore: unnecessary_null_comparison
                    child:
                    Container(
                       width: 80,
                        height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors().grayshade300
                      ),
                      child: Image.asset(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
                SizedBox(width: 5),
                Expanded(flex: 6,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       Text(
                        title,textDirection: TextDirection.rtl,
                        style: AppTextStyles.titleStyle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        body,textDirection: TextDirection.rtl,
                        style:  TextStyle(
                          fontSize: 16,fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}