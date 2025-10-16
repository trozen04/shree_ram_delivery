



import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_delivery_app/screen/status_wise_order/StatusWiseOrderController.dart';

import '../../model/DailyAssignedOrderModel.dart';
import '../../support/alert_dialog_manager.dart';
import '../wh_active_order/WHActiveOrderScreen.dart';

class StatusWiseOrderScreen extends StatelessWidget {

  String status;
  StatusWiseOrderScreen(this.status,{super.key});

  @override
  Widget build(BuildContext context) {
    print('status : $status');
    return GetBuilder<StatusWiseOrderController>(
        tag: status,
        init: StatusWiseOrderController(context, status),
    builder: (controller){
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.grey)
                ))
            ),
          ),
          toolbarHeight: 70,
          surfaceTintColor:Colors.transparent,
          backgroundColor: Colors.white,
          title: Text("${status} Order",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                DateTimeRange? pickedRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );

                if (pickedRange != null) {
                  String start = DateFormat('yyyy-MM-dd').format(pickedRange.start);
                  String end = DateFormat('yyyy-MM-dd').format(pickedRange.end);
                  controller.getHistory(context, startDate: start, endDate: end);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "History",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_month, color: Colors.purple),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            controller.historyList.isEmpty
            ? Container(
              padding: EdgeInsets.only(top: 200),
              child: Text(
                'No history data available for the selected date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            )

                : Expanded(child: ListView.builder(
              itemCount: controller.historyList.length,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (BuildContext context, int index) {

                DailyAssignedOrderModel model=controller.historyList[index];

                return  InkWell(
                    onTap: status == 'Complete' || model.inchargeStatus == 'Complete'?
                        (){
                          AlertDialogManager().sendMessageAlert(context, 'Error', 'This order has been completed.');
                    } : (){
                      print('status: $status \n incharge status: ${model.inchargeStatus}');
                      Get.to(()=>WHActiveOrderScreen(model));
                    },
                    child: buildDeliveryCard(context,
                        orderId: model.sId??"",
                        name: model.userId!.name??"",
                        address:model.deliveryaddress!=null?
                        "${model.deliveryaddress!.addressline},${model.deliveryaddress!.city},${model.deliveryaddress!.state},(${model.deliveryaddress!.pin})":"",
                        phone: "+91 ${model.userId!.mobileno??""}",
                        payment: "${model.grandTotal??""}",
                        // status:( model.status??"").toLowerCase()=="Confirmed"?"Start Loading":"Confirmed"
                        status:( model.status??"")
                    )
                );
              },))
          ],
        ),
      ));
    });
  }


  static Widget buildDeliveryCard(context,{
    required String orderId,
    required String name,
    required String address,
    required String phone,
    required String payment,
    required String status,
  }) {
    Color statusColor;
    String actionText;
    Color actionColor;

    switch (status) {
      case "Start Loading":
        statusColor = Colors.blue;
        actionText = "Start Loading";
        actionColor = Colors.blue;
        break;
      case "Completed":
        statusColor = Colors.green;
        actionText = "Complete";
        actionColor = Colors.green;
        break;
      case "Out for delivery":
        statusColor = Colors.teal;
        actionText = "Navigate";
        actionColor = Colors.green;
        break;
      case "Delivered":
        statusColor = Colors.green;
        actionText = "Completed";
        actionColor = Colors.green;
        break;
      case "Delivery Failed":
        statusColor = Colors.red;
        actionText = "Failed";
        actionColor = Colors.red;
        break;
      case "Order Canceled":
        statusColor = Colors.grey;
        actionText = "Canceled";
        actionColor = Colors.grey;
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
                  status[0].toUpperCase() + status.substring(1),
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
            Text("Payment: $payment",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Text("Order Status:  $status",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            // Action Button
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     SizedBox(
            //       height: 35,
            //       child:  CustomWidget.elevatedCustomButton(context, actionText, (){
            //          // Get.to(()=>WHActiveOrderScreen());
            //       },bgColor: statusColor.withOpacity(0.1),borderColor: statusColor,borderRadius: 25,textColor: statusColor),
            //     )
            //
            //   ],
            // )

          ],
        ),
      ),
    );
  }
}
