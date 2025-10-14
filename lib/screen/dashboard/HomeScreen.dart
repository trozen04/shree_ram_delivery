




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/ConstantString.dart';
import '../../constant/CustomWidget.dart';
import '../../support/app_theme.dart';
import 'DashboardController.dart';

class HomeScreen{


  static getHomeScreen(BuildContext context,DashboardController controller){
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
                      children:  [
                        if(controller.profileModel.employee!=null)
                        Text("Hello, ${controller.profileModel.employee!.name}",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),),
                         SizedBox(height: 8,),
                        Text("Ready to hit the road? Your deliveries await.",style:TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 12),),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: controller.profileModel.employee!=null?DecorationImage(image: NetworkImage(
                          ConstantString.image_base_Url+"/"+(controller.profileModel.employee!.uploadphoto??""),
                        ),fit: BoxFit.cover):null
                    ),
                  )
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
                      count: controller.homeSummaryModel.totalOrders.toString(),
                      label: "Total",
                      color: Colors.blue,
                      textColor: Colors.blue,
                      onTap: (){

                      },
                    ),
                    _statusCard(
                      count:controller.homeSummaryModel.taskCounts!=null? controller.homeSummaryModel.taskCounts!.delivered.toString():"0",
                      label: "Completed",
                      color: Colors.green,
                      textColor: Colors.green,
                      onTap: (){

                      },
                    ),
                    _statusCard(
                      count: controller.homeSummaryModel.taskCounts!=null? controller.homeSummaryModel.taskCounts!.pending.toString():"0",
                      label: "Pending",
                      color: Colors.red,
                      textColor: Colors.red,
                      onTap: (){

                      },
                    ),
                    _statusCard(
                      count: controller.homeSummaryModel.taskCounts!=null? controller.homeSummaryModel.taskCounts!.cancel.toString():"0",
                      label: "Canceled",
                      color: Colors.yellow,
                      textColor: Colors.orange,
                      onTap: (){

                      },
                    ),
                  ],
                )
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