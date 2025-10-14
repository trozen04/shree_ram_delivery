




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/status_wise_order/StatusWiseOrderScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboaredController.dart';

import '../../constant/ConstantString.dart';
import '../../constant/CustomWidget.dart';
import '../../support/app_theme.dart';
class WHHomeScreen{


  static getWHHomeScreen(BuildContext context,WMDashboaredController controller){
    double height=CustomWidget.getHeight(context);
    double width=CustomWidget.getHeight(context);
    return Column(
      children: [
        Container(
          height: height*0.13,
          width: width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        if(controller.profileModel.employee!=null)
                        Text("Hello, ${controller.profileModel.employee!.name??""}",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),),
                        SizedBox(height: 8,),
                        Text("Ready to hit the road? Your deliveries await.",style:TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 12),),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 45,
                  //   width: 45,
                  //   padding: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey,
                  //       shape: BoxShape.circle
                  //
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  mainAxisSpacing: 12,
                  childAspectRatio: 3/2,
                  children: [
                    _statusCard(
                      count: controller.totalOrder.toString(),
                      label: "Total",
                      color: Colors.blue,
                      textColor: Colors.blue,
                      onTap: (){
                        Get.to(StatusWiseOrderScreen("Total"));

                      },
                    ),
                    _statusCard(
                      count: controller.totalPending.toString(),
                      label: "Pending orders",
                      color: Colors.blue,
                      textColor: Colors.blue,
                      onTap: (){
                          Get.to(StatusWiseOrderScreen("Pending"));
                      },
                    ),
                    _statusCard(
                      count: controller.totalPartiallyDispatch.toString(),
                      label: "Partially Dispatched",
                      color: Colors.green,
                      textColor: Colors.green,
                      onTap: (){
                        Get.to(StatusWiseOrderScreen("Partiallydispatch"));
                        //Get.to(StatusWiseOrderScreen("dispatch"));
                      },
                    ),
                    _statusCard(
                      count: controller.totalCompleted.toString(),
                      label: "Complete Orders",
                      color: Colors.red,
                      textColor: Colors.red,
                      onTap: (){
                        Get.to(StatusWiseOrderScreen("Complete"));
                      },
                    ),
                  ],
                ),
                // SizedBox(height: 20,),
                // InkWell(
                //   onTap: (){
                //     Get.to(StatusWiseOrderScreen("Complete"));
                //   },
                //   child: Container(
                //     width: Get.width-40,
                //     decoration: BoxDecoration(
                //         color: Colors.red.withOpacity(0.1),
                //         borderRadius: BorderRadius.circular(12),
                //         border: Border.all(color: Colors.red)
                //     ),
                //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           controller.totalCompleted.toString(),
                //           style: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.red,
                //           ),
                //         ),
                //         const SizedBox(height: 6),
                //         Text(
                //           "Complete Orders",
                //           textAlign: TextAlign.center,
                //           style: const TextStyle(
                //             fontSize: 14,
                //             color: Colors.black87,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
                // _statusCard(
                //   count: controller.totalCompleted.toString(),
                //   label: "Complete Orders",
                //   color: Colors.red,
                //   textColor: Colors.red,
                //   onTap: (){
                //
                //   },
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }



  static  Widget _statusCard({
    required String count,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color)
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }




}