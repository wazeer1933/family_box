import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';

SnackbarNointernet(context){
    
    
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.red,
        content: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text('!  غير متصل بالانترنت ',style: AppTextStyles.titleStyle),
            ),Icon(Icons.wifi_off_sharp,size: 30,color: Colors.white,)
          ],
        ),
        duration: Duration(days: 2),
      ),
    );
}
SnackbarFounfinternet(context){
   return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: appColors.primary,
        content: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text('  تم استعادة الاتصال بالانترنت ',style: AppTextStyles.titleStyle,),
            ),Icon(Icons.wifi_rounded,size: 30,color: Colors.white,)
          ],
        ),
        duration: Duration(days: 2),
      ),
    );
}