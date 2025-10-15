import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/model/TaskModel.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryController.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryScreen.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';

import '../../constant/ConstantString.dart';
import '../../constant/CustomWidget.dart';
import '../../support/app_theme.dart';
import 'DashboardController.dart';

class OrderScreen {
  static getOrderScreen(BuildContext context, DashboardController controller) {
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
                "Assigned Orders",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                padding: EdgeInsets.symmetric(horizontal: 20),
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 2,
                children: [
                  _statusCard(
                    count: controller.totalOrder.toString(),
                    label: "Total Order",
                    color: Colors.blue,
                    textColor: Colors.blue,
                    onTap: () {},
                  ),
                  _statusCard(
                    count: controller.taskSummary.delivered.toString(),
                    label: "Completed Order",
                    color: Colors.green,
                    textColor: Colors.green,
                    onTap: () {},
                  ),
                  _statusCard(
                    count: controller.taskSummary.dispatch.toString(),
                    label: "Pending Order",
                    color: Colors.red,
                    textColor: Colors.red,
                    onTap: () {},
                  ),
                  _statusCard(
                    count: controller.taskSummary.cancel.toString(),
                    label: "Canceled Order",
                    color: Colors.yellow,
                    textColor: Colors.orange,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20,),
              Expanded(
                  child: ListView.builder(
                    itemCount: controller.dailyOrderList.length,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (BuildContext context, int index) {
                      TaskModel  task=controller.dailyOrderList[index];
                      Orderid  model=task.orderid??Orderid();
                      return InkWell(
                                onTap: (){
                                  if(model.status=="dispatch"){
                                    controller.updateStatus(context, task.orderid!.sId??"");
                                  }else if(model.status=="confirmed"){
                                    AlertDialogManager.getSnackBarMsg("Message", "The Product Item Not Dispatched by Warehouse Incharge Yet", false, context);
                                  }else {
                                    Get.to(() => ActiveDeliveryScreen(task));
                                  }
                                },
                                child: buildDeliveryCard(context,
                                  orderId:model.sId??"",
                                  name:model.userId!=null? model.userId!.name??"":"",
                                  address:
                                      "${model.deliveryaddress!=null?"${(model.deliveryaddress!.addressline??"")+","+(model.deliveryaddress!.city??"")+","+(model.deliveryaddress!.state??"")+","+(model.deliveryaddress!.pin??"").toString()+","}":""}",
                                  phone: "+91 ${model.userId!=null?model.userId!.mobileno??"":""}",
                                  payment: model.paymentmethod=="cod"?"Cash - ₹${model.grandTotal??""}":"${model.paymentmethod=="paylater"?"Paylater - ₹${model.grandTotal??""}":""}",
                                  status: model.status??"",
                                  onActionTap: () {
                                    // Same logic here
                                    if(model.status=="dispatch"){
                                      controller.updateStatus(context, task.orderid!.sId??"");
                                    } else if(model.status=="confirmed"){
                                      AlertDialogManager.getSnackBarMsg(
                                          "Message",
                                          "The Product Item Not Dispatched by Warehouse Incharge Yet",
                                          false, context
                                      );
                                    } else {
                                      Get.to(() => ActiveDeliveryScreen(task));
                                    }
                                  },
                                ),
                              );
                    },))
            ],
          ),
        )
      ],
    );
  }

  static Widget _statusCard({
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
            border: Border.all(color: color)),
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

  static Widget buildDeliveryCard(context,{
    required String orderId,
    required String name,
    required String address,
    required String phone,
    required String payment,
    required String status,
    VoidCallback? onActionTap, // new parameter
  }) {
    Color statusColor;
    String actionText;
    Color actionColor;

    switch (status) {
      case "dispatch":
        statusColor = Colors.blue;
        actionText = "Start Delivery";
        actionColor = Colors.blue;
        break;
      case "confirmed":
        statusColor = Colors.grey;
        actionText = "Not Dispatched";
        actionColor = Colors.grey;
        break;
      case "OFD":
        statusColor = Colors.teal;
        actionText = "Navigate";
        actionColor = Colors.green;
        break;
      case "delivered":
        statusColor = Colors.green;
        actionText = "Completed";
        actionColor = Colors.green;
        break;
      // case "Delivery Failed":
      //   statusColor = Colors.red;
      //   actionText = "Failed";
      //   actionColor = Colors.red;
      //   break;
      case "cancelled":
        statusColor = Colors.red;
        actionText = "Canceled";
        actionColor = Colors.red;
        break;
      default:
        statusColor = Colors.black54;
        actionText = "Update";
        actionColor = Colors.black54;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "#$orderId",
                //   style: const TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Customer Info
            Text(name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(address,
                style: const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(phone,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 6),
            Text("Payment $payment",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 35,
                  child:  CustomWidget.elevatedCustomButton(context, actionText,
                      onActionTap ?? () {
                        print('action: $actionText'); // fallback
                      },
                      bgColor: statusColor.withOpacity(0.1),borderColor: statusColor,borderRadius: 25,textColor: statusColor),
                )

              ],
            )

          ],
        ),
      ),
    );
  }
}
