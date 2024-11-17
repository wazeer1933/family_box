import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/contollers/contollerChat.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditeNameGroups extends StatelessWidget {
  String chatId;
  String? name;

  EditeNameGroups({super.key,required this.chatId,this.name});
  final _keyForm = GlobalKey<FormState>();
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        actionsPadding: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 20),
        backgroundColor: AppColors().white,
        title: Center(
          child: Text(
            '  $name',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors().darkGreen,
            ),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 100,
          child: Form(
            key: _keyForm,
            child: ListView(
              children: [
             WidgetTextfiledDash(
                    controller: controller.NewNameGroup,
                    maxLines: 1,
                    label: 'اسم المجموعة',
                    widget: SizedBox(),
                    // widget: Obx((){
                    //   return controller.selectedImage.value==null?
                    //   TextButton(onPressed: (){
                    //    controller.pickImage(ImageSource.gallery);
                    // },
                    //  child: CircleAvatar(child: Icon(Icons.add_a_photo_outlined),)):
                    //  TextButton(onPressed: (){
                    //    controller.pickImage(ImageSource.gallery);
                    // },
                    //  child: CircleAvatar(backgroundImage: FileImage(controller.selectedImage.value!),child: Icon(Icons.add_a_photo_outlined),));
                    // }),
                    Labelvlaue: 'اسم المجموعة',
                     validator: (value) {
                      if (value == null || value.isEmpty || value.length<10) {
                        return "برجي ادخال  اسم لايقل عن 5 حرف ";
                      }
                      return null;
                    },
                  )
              ]
            )
          ),
        ),
        actions: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState?.validate() ?? false) {
                      controller.editeNameGroups(chatId);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.save, textDirection: TextDirection.rtl, size: 20),
                      SizedBox(width: 5),
                      Text('حفظ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.error_outline, textDirection: TextDirection.rtl, size: 20),
                      SizedBox(width: 5),
                      Text('الغاء', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}