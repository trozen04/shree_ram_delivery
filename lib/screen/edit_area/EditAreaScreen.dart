



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/edit_area/EditAreaController.dart';

import '../../constant/CustomWidget.dart';

class EditAreaScreen extends StatelessWidget {
  const EditAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
        init: Get.put(EditAreaController(context)),
        builder: (controller){
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Colors.black)
                ))
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 3,
          shadowColor: Colors.grey.shade100,
          title: Text("Edit Assigned Area/City",style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),),
        ),
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 20,),
                Text("Name",style: TextStyle(color: Colors.black,fontSize: 16),)
              ],
            ),
            CustomWidget.textInputFiled(
                controller.nameTextCon,
                focusNode: controller.nameFocus,
                textAlign: TextAlign.left,
                topPadding: 0,
                rightPadding: 20,
                leftPadding: 20,
                bottomPadding: 15,
                enableBorder: false,
                textInputType: TextInputType.text,
                hintText: "Name",
                fillColorFiled: true,
                fillColors: Colors.grey.shade100
            ),
            Row(
              children: [
                SizedBox(width: 20,),
                Text("Mobile Number",style: TextStyle(color: Colors.black,fontSize: 16),)
              ],
            ),
            CustomWidget.textInputFiled(
                controller.mobileTextCon,
                focusNode: controller.mobileFocus,
                textAlign: TextAlign.left,
                topPadding: 0,
                rightPadding: 20,
                leftPadding: 20,
                bottomPadding: 15,
                enableBorder: false,
                textInputType: TextInputType.number,
                hintText: "1234567890",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                fillColorFiled: true,
                fillColors: Colors.grey.shade100,
                prefixIconWidget: Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    child: Text("+91",style: TextStyle(color: Colors.black,fontSize: 20),))
            ),
            Row(
              children: [
                SizedBox(width: 20,),
                Text("Assigned Area",style: TextStyle(color: Colors.black,fontSize: 16),)
              ],
            ),
            CustomWidget.textInputFiled(
                controller.assignedTextCon,
                focusNode: controller.assignedFocus,
                textAlign: TextAlign.left,
                topPadding: 0,
                rightPadding: 20,
                leftPadding: 20,
                bottomPadding: 15,
                enableBorder: false,
                textInputType: TextInputType.emailAddress,
                hintText: "Area",
                fillColorFiled: true,
                fillColors: Colors.grey.shade100
            ),
            Spacer(),
             CustomWidget.elevatedCustomButton(context, "Submit", (){

             },borderRadius: 25,width: Get.width-40),
            SizedBox(height: 20,)
          ],
        ),
      ));
    });
  }
}
