import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for the text fields
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                // TODO: Implement back functionality
              },
              child: const Text(
                "رجوع",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: 30,left: 40,right: 40),
          child: Column(
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   SizedBox(height: 32.0),
                   Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Row(
                         children: [
                           Text(
                             "5",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               // fontSize: 32.0,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Text("/"),
                           Text(
                             "1",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Colors.deepOrange,
                               // fontSize: 32.0,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       ),
                       Text(
                        "تسجيل عضوية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                                     ),

                     ],
                   ),
                  const SizedBox(height: 48.0),
                  _buildTextField("الاسم الاول", _firstNameController),
                  const SizedBox(height: 16.0),
                  _buildTextField("اسم الأب", _middleNameController),
                  const SizedBox(height: 16.0),
                  _buildTextField("اسم العائلة", _lastNameController),
                  const SizedBox(height: 32.0),

                  Row(textDirection: TextDirection.ltr,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement sign up functionality
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 45),
                          backgroundColor: Colors.green.shade400, // Background color
                          // padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 18.0),
                        ),
                        child: const Text("التالي"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                ],
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [

                  Text(
                    "امتلك حساب بالفعل؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child:  Text(
                      " قم بتسجيل الدخول",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                ],
              ),
            ],

          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,textAlign: TextAlign.right,
      decoration: InputDecoration(

        suffixIcon: Icon(Icons.person,color: Colors.grey,),
        hintTextDirection: TextDirection.rtl,
        hintText: label,
        contentPadding: EdgeInsets.all(10),
        filled: true,fillColor: Colors.grey.shade200,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),

    );
  }
}