



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardController.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/ProfileScreen.dart';

import '../../support/app_theme.dart';
import 'DaySummaryScreen.dart';
import 'HomeScreen.dart';
import 'OrderScreen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
        init: Get.put(DashboardController(context)),
        builder: (controller){
      return SafeArea(child: Scaffold(
        backgroundColor: Colors.grey.shade100,
         body: Column(
           children: [
             Expanded(child: IndexedStack(
               index: controller.selectedIndex,
               children: [
                 HomeScreen.getHomeScreen(context, controller),
                 OrderScreen.getOrderScreen(context, controller),
                 DaySummaryScreen.getDaySummaryScreen(context,controller),
                 ProfileScreen.getProfileScreen(context, controller)
               ],
             )),
             getCustomBottomNavigation(context, controller)
           ],
         ),
      ));
    });
  }


  getCustomBottomNavigation(context,DashboardController controller){
    return  Container(
      height: 70,
      decoration: BoxDecoration(
        color:Colors.transparent,
        // boxShadow: [
        //   BoxShadow(color: Colors.grey.shade200,spreadRadius: 4,blurRadius: 4)
        // ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: InkWell(
              hoverColor: Colors.white,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              onTap:(){
                FocusScope.of(context).unfocus();
                controller.selectedIndex=0;
                controller.getOrderSummary(context);
                controller.update();
              },
              child: Container(
                width: Get.width/4,
                height: 70,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/bottom/home.png",height: 22,width: 22,color: controller.selectedIndex==0?AppColor.secondary:Colors.grey),
                    Text("Home",style: TextStyle(color: controller.selectedIndex==0?AppColor.secondary:Color(0xff7D7D7D)),)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              hoverColor: Colors.white,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
              onTap:(){
                FocusScope.of(context).unfocus();
                controller.selectedIndex=1;
                controller.getTodaysOrder(context);

                controller.update();
              },
              child:  Container(
                width: Get.width/4,
                height: 70,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/bottom/deliveries.png",height: 22,width: 22,color: controller.selectedIndex==1?AppColor.secondary:null),
                    Text("Deliveries",style: TextStyle(color: controller.selectedIndex==1?AppColor.secondary:Color(0xff7D7D7D)),)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              hoverColor: Colors.white,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
              onTap:(){
                FocusScope.of(context).unfocus();
                controller.selectedIndex=2;
                controller.getTodaysOrder(context);
                controller.getTotalCoD(context);
                controller.update();
              },
              child:  Container(
                width: Get.width/4,
                height: 70,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    // if(controller.selectedIndex==4)
                    //   Image.asset("assets/setting1.png",height: 22,width: 22,),
                    // if(controller.selectedIndex!=4)
                    Image.asset("assets/bottom/summar_history.png",height: 22,width: 22,color: controller.selectedIndex==2?AppColor.secondary:null),
                    Text("Day summary",style: TextStyle(color: controller.selectedIndex==2?AppColor.secondary:Color(0xff7D7D7D)),)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              hoverColor: Colors.white,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
              onTap:(){
                FocusScope.of(context).unfocus();
                controller.selectedIndex=3;
                controller.update();
              },
              child:  Container(
                width: Get.width/4,
                height: 70,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    // // if(controller.selectedIndex==4)
                    // //   Image.asset("assets/setting1.png",height: 22,width: 22,),
                    // if(controller.selectedIndex!=4)
                    Image.asset("assets/bottom/profile.png",height: 22,width: 22,color: controller.selectedIndex==3?AppColor.secondary:null),
                    Text("Profile",style: TextStyle(color: controller.selectedIndex==3?AppColor.secondary:Color(0xff7D7D7D)),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
