


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/incharge_profile/WIProfileController.dart';

class WIProfileScreen extends StatelessWidget {
  const WIProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
        init:  Get.put(WIProfileController(context)),
        builder: (controller){
         return SafeArea(
             child: Scaffold(
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
                 title: Text("Profile",style: TextStyle(
                   fontWeight: FontWeight.w700,
                   fontSize: 18,
                   color: Colors.black,
                 ),),
               ),
               backgroundColor: Colors.white,
               body: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   children: [
                     SizedBox(height: 20,),
                     if(controller.profileModel.employee!=null)
                     _buildDetailRow("Name", controller.profileModel.employee!.name??""),
                     if(controller.profileModel.employee!=null)
                     _buildDetailRow("Mobile Number", (controller.profileModel.employee!.phoneno??"").toString()),
                     if(controller.profileModel.employee!=null)
                     _buildDetailRow("Email", controller.profileModel.employee!.email??""),
                     if(controller.profileModel.employee!=null)
                     _buildDetailRow("Godown Address", controller.profileModel.employee!.areaname??""),
                   ],
                 ),
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
              label+" :",
              style: const TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
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
