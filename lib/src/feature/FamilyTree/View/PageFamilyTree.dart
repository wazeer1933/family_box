

import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTreeUsersFamily.dart';
import 'package:flutter/material.dart';

class pageFamilyTree extends StatefulWidget {
  @override
  _pageFamilyTreeState createState() => _pageFamilyTreeState();
}



class _pageFamilyTreeState extends State<pageFamilyTree> {
 

/////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading :false,
        title: Container(child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back)),
            Text('شجرة اسرة اللحيدان',style: TextStyle(color: AppColors().darkGreen),),
          ],
        ),),
      ),
      body: WidgetTreeFmailyUsers()
    );
  }
 
}
