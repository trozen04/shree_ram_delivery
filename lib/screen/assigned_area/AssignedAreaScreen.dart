



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/assigned_area/AssignedAreaController.dart';
import 'package:shree_ram_delivery_app/screen/edit_area/EditAreaScreen.dart';

import '../../constant/ConstantString.dart';
import '../../constant/CustomWidget.dart';
import '../../support/app_theme.dart';

class AssignedAreaScreen extends StatelessWidget {
  const AssignedAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
        init: Get.put(AssignedAreaController(context)),
        builder: (controller){
        return SafeArea(child: Scaffold(
          backgroundColor: Colors.grey.shade100,
           body:  Column(
             children: [
               // Header bar with back button and title
               AppBar(
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
                 title: Text("Personal Information",style: TextStyle(
                   fontWeight: FontWeight.w700,
                   fontSize: 18,
                   color: Colors.black,
                 ),),
               ),

               const SizedBox(height: 30),

               // Profile section with image, camera icon & coin badge
               // Profile section with image, camera icon & coin badge
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Stack(
                     clipBehavior: Clip.none,
                     children: [
                       controller.profileModel.employee!=null?
                       CircleAvatar(
                         radius: 60,
                         backgroundImage: controller.base64Profile.isEmpty?NetworkImage(ConstantString.image_base_Url+"/"+(controller.profileModel.employee!.uploadphoto??"")):
                         MemoryImage(base64Decode(controller.base64Profile)),
                       ): CircleAvatar(
                         radius: 60,
                         backgroundColor: Colors.grey.shade200,
                         backgroundImage: controller.base64Profile.isNotEmpty?MemoryImage(base64Decode(controller.base64Profile)):null,
                       ),

                       // Camera icon overlay
                       Positioned(
                         bottom: 5,
                         right: 5,
                         child: InkWell(
                           overlayColor: WidgetStatePropertyAll(Colors.transparent),
                           onTap: (){
                             CustomWidget().getBottomSheetForProfile(context, () {
                               controller.navigateAndDisplaySelection(context, 1);
                             }, () {
                               controller.navigateAndDisplaySelection(context, 2);
                             });
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               color: AppColor.primary.withOpacity(0.4),
                               shape: BoxShape.circle,
                             ),
                             padding: const EdgeInsets.all(8),
                             child: const Icon(
                               Icons.camera_alt_outlined,
                               color: Colors.white,
                               size: 20,
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),

               const SizedBox(height: 30),

               // Your Details header with edit icon
               InkWell(
                 overlayColor: WidgetStatePropertyAll(Colors.transparent),
                 onTap: ()async{
                   await  Get.to(EditAreaScreen());
                   controller.getProfile();
                 },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24),
                   child: Row(
                     children: [
                       const Text(
                         "Your Details",
                         style: TextStyle(
                           fontWeight: FontWeight.w700,
                           fontSize: 16,
                           color: Colors.black,
                         ),
                       ),
                       const SizedBox(width: 8),
                       Icon(
                         Icons.edit,
                         color: AppColor.primary,
                         size: 20,
                       )
                     ],
                   ),
                 ),
               ),

               const SizedBox(height: 16),

               // Details list
               Expanded(
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 24),
                   decoration: const BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                   ),
                   child: ListView(
                     children: [
                       if( controller.profileModel.employee!=null)
                         _buildDetailRow("Company Name", "${controller.profileModel.employee!.name??""}"),
                       Divider(color: Colors.grey.shade300, height: 1),
                       if( controller.profileModel.employee!=null)
                         _buildDetailRow("Mobile Number", "+91 ${controller.profileModel.employee!.phoneno??""}"),
                       Divider(color: Colors.grey.shade300, height: 1),
                       if( controller.profileModel.employee!=null)
                         _buildDetailRow("Assigned Area", "${controller.profileModel.employee!.city??""}"),
                     ],
                   ),
                 ),
               ),
             ],
           ),
        ));
    });
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
