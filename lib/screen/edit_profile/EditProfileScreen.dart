




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/edit_profile/EditProfileController.dart';

import '../../constant/CustomWidget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(EditProfileController(context)),
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
          title: Text("Personal Information",style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),),
        ),
        backgroundColor: Colors.grey.shade50,
        body:SingleChildScrollView(
          child: Column(
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
                  readOnlyFiled: true,
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
                  Text("Email",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
              CustomWidget.textInputFiled(
                  controller.emailTextCon,
                  focusNode: controller.emailFocus,
                  textAlign: TextAlign.left,
                  topPadding: 0,
                  rightPadding: 20,
                  leftPadding: 20,
                  bottomPadding: 15,
                  enableBorder: false,
                  textInputType: TextInputType.emailAddress,
                  hintText: "Email",
                  readOnlyFiled: true,
                  onChanged: (value){
                    controller.emailTextCon.text=value.toLowerCase();
                  },
                  fillColorFiled: true,
                  fillColors: Colors.grey.shade100
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Vehicle Number",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
              CustomWidget.textInputFiled(
                  controller.vechileNoTextCon,
                  focusNode: controller.vehicleNoFocus,
                  textAlign: TextAlign.left,
                  topPadding: 0,
                  rightPadding: 20,
                  leftPadding: 20,
                  bottomPadding: 15,
                  enableBorder: false,
                  textInputType: TextInputType.number,
                  hintText: "Vehicle",
                  fillColorFiled: true,
                  fillColors: Colors.grey.shade100
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Aadhaar",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
              InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: (){
                  CustomWidget().getBottomSheetForProfile(context, () {
                    controller.navigateAndDisplaySelection(context, 1,0);
                  }, () {
                    controller.navigateAndDisplaySelection(context, 2,0);
                  });
                },
                child: Container(
                  height: 120,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile)))
                   ),
                  child: Image.asset("assets/cam_img.png",height: 30,width: 30,),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("PAN card",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
              InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: (){
                  CustomWidget().getBottomSheetForProfile(context, () {
                    controller.navigateAndDisplaySelection(context, 1,1);
                  }, () {
                    controller.navigateAndDisplaySelection(context, 2,1);
                  });
                },
                child: Container(
                  height: 120,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile2)))

                  ),
                  child: Image.asset("assets/cam_img.png",height: 30,width: 30,),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("RC",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
              InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: (){
                  CustomWidget().getBottomSheetForProfile(context, () {
                    controller.navigateAndDisplaySelection(context, 1,2);
                  }, () {
                    controller.navigateAndDisplaySelection(context, 2,2);
                  });
                },
                child: Container(
                  height: 120,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile3)))
                  ),
                  child: Image.asset("assets/cam_img.png",height: 20,width: 20,),
                ),
              ),
              SizedBox(height: 20,),
              CustomWidget.elevatedCustomButton(context, "Submit", (){
                if(controller.validation(context)){
                  controller.updateProfile(context);
                }
              },borderRadius: 25,width: Get.width-30),
              SizedBox(height: 20,),
            ],
          ),
        ) ,
      ));
    });
  }
}
