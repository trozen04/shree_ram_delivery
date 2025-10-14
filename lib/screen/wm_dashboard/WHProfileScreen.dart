import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/assigned_area/AssignedAreaScreen.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardController.dart';
import 'package:shree_ram_delivery_app/screen/incharge_profile/WIProfileScreen.dart';
import 'package:shree_ram_delivery_app/screen/personal_info/ViewPersonalInfoScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboaredController.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';

import '../../constant/CustomWidget.dart';

class WHProfileScreen {
  static getWHProfileScreen(
      BuildContext context, WMDashboaredController controller) {
    double height = CustomWidget.getHeight(context);
    double width = CustomWidget.getHeight(context);
    return Column(
      children: [
        Container(
          height: height * 0.10,
          width: width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            onTap: (){
              Get.to(()=>WIProfileScreen());
            },
            child: getRow("assets/person.png", "User Profile")),
        // getRow("assets/profile/stats.png", "Performance Stats"),
        // InkWell(
        //     overlayColor: WidgetStatePropertyAll(Colors.transparent),
        //     onTap: (){
        //       Get.to(()=>AssignedAreaScreen());
        //     },
        //     child: getRow("assets/profile/location.png", "Assigned Area/City")),
        InkWell(
          onTap: (){
            AlertDialogManager().logoutDialog(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(width: 20,),
                Image.asset("assets/profile/logout.png", height: 25, width: 25, color: Colors.red,),
                SizedBox(width: 20,),
                Expanded(child: Text("Logout", style: TextStyle(color: Colors.red,fontSize: 15),)),
                Icon(CupertinoIcons.forward, size: 25, color: Colors.red,),
                SizedBox(width: 20,)
              ],
            ),
          ),
        )
      ],
    );
  }

  static Widget getRow(String assets,String  name) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 20,),
          Image.asset(assets, height: 25, width: 25, color: Colors.grey,),
          const SizedBox(width: 20,),
          Expanded(child: Text(name, style: TextStyle(color: Colors.black,fontSize: 14),)),
          Icon(CupertinoIcons.forward, size: 25, color: Colors.black,),
          SizedBox(width: 20,)
        ],
      ),
    );
  }
}
