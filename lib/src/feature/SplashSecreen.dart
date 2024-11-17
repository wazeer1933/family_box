
// import 'package:family_box/main.dart';
import 'package:flutter/material.dart';

class splash extends StatefulWidget {
   splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      // Navigator.push(context, MaterialPageRoute(builder: (c)=>MyHomePage()));
      // usermodel.active=='true'?
      // Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      Navigator.of(context).pushNamedAndRemoveUntil('homePageApp', (route) => false);
      // :Navigator.of(context).pushNamedAndRemoveUntil('NoLogin', (route) => false);

    });
    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(width: 250,height: 250,
          padding: EdgeInsets.all(20),child: Image.asset('assets/images/IconApp.png'),),)
    );
  }
}
