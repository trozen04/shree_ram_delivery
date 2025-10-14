import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboaredController.dart';

import '../wh_active_order/WHActiveOrderScreen.dart';

class DispatchHistoryScreen {
  static DateTime? lastPickedDate;

  static Widget getDispatchHistoryScreen(BuildContext context,WMDashboaredController  controller ) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (lastPickedDate == null) {
      lastPickedDate = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(lastPickedDate!);
      print("First load: fetching today’s history -> $formattedDate");
      controller.getHistory(context, formattedDate);
    }
    return Column(
      children: [
        // Header
        Container(
          height: height * 0.10,
          width: width,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Center(
            child: Text(
              "Dispatch History",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // History title with calendar icon
        InkWell(
          onTap: ()async{
            DateTime now = DateTime.now();
            DateTime initialDate = lastPickedDate ?? now;
            print("Opening calendar. Initial date: $initialDate");

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: now,
            );

            if (pickedDate != null) {
              lastPickedDate = pickedDate; // Save last picked date
              print("User picked date: $pickedDate");

              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              controller.getHistory(context, formattedDate);
            } else {
              print("User canceled date picker");
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

        // History Card
        Expanded(child: ListView.builder(
          itemCount: controller.historyList.length,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (BuildContext context, int index) {
            DailyAssignedOrderModel model=controller.historyList[index];
          return  InkWell(
              onTap: (){
                if(( model.status??"").toLowerCase()=="confirmed")
                    Get.to(()=>WHActiveOrderScreen(model));
              },
              child: buildDeliveryCard(context,
                  orderId: model.sId??"",
                  name: model.userId!.name??"",
                  address:model.deliveryaddress!=null?
                  "${model.deliveryaddress!.addressline},${model.deliveryaddress!.city},${model.deliveryaddress!.state},(${model.deliveryaddress!.pin})":"",
                  phone: "+91 ${model.userId!.mobileno??""}",
                  payment: "${model.grandTotal??""}",
                  status:( model.status??"").toLowerCase()=="confirmed"?"Start Loading":"Completed"
              )
          );
        },))

      ],
    );
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
                Text(
                  "#$orderId",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
