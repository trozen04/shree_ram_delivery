import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryController.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryScreen.dart';
import 'package:shree_ram_delivery_app/screen/wh_active_order/WHActiveOrderController.dart';
import 'package:shree_ram_delivery_app/screen/wh_active_order/WHActiveOrderScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboaredController.dart';
import '../../constant/ConstantString.dart';
import '../../constant/CustomWidget.dart';
import '../../support/app_theme.dart';

class WHOrderScreen {
  static getWHOrderScreen(BuildContext context, WMDashboaredController controller) {
    double height = CustomWidget.getHeight(context);
    double width = CustomWidget.getHeight(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Row(
          children: [
            SizedBox(width: 20,),
            Text("Today's Order",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18)),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.dailyAssignedList.length,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (BuildContext context, int index) {
              DailyAssignedOrderModel  model=controller.dailyAssignedList[index];
              return  InkWell(
                      onTap: (){
                        print('status: ${model.status}');
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
            }
          )
    )
          // child: SingleChildScrollView(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Column(
          //     children: [
          //       InkWell(
          //         onTap: (){
          //           Get.to(()=>ActiveDeliveryScreen());
          //         },
          //         child: buildDeliveryCard(context,
          //           orderId: "398375",
          //           name: "Rajesh Kumar",
          //           address:
          //           "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //           phone: "+91 9876543234",
          //           payment: "Cash - ₹400",
          //           status: "Start Loading",
          //         ),
          //       ),
          //       buildDeliveryCard(context,
          //         orderId: "398376",
          //         name: "Rajesh Kumar",
          //         address:
          //         "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //         phone: "+91 9876543234",
          //         payment: "Cash - ₹400",
          //         status: "Picked",
          //       ),
          //       buildDeliveryCard(context,
          //         orderId: "398377",
          //         name: "Rajesh Kumar",
          //         address:
          //         "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //         phone: "+91 9876543234",
          //         payment: "Cash - ₹400",
          //         status: "Out for delivery",
          //       ),
          //       buildDeliveryCard(context,
          //         orderId: "398378",
          //         name: "Rajesh Kumar",
          //         address:
          //         "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //         phone: "+91 9876543234",
          //         payment: "Cash - ₹400",
          //         status: "Delivered",
          //       ),
          //       buildDeliveryCard(context,
          //         orderId: "398379",
          //         name: "Rajesh Kumar",
          //         address:
          //         "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //         phone: "+91 9876543234",
          //         payment: "Cash - ₹400",
          //         status: "Delivery Failed",
          //       ),
          //       buildDeliveryCard(context,
          //         orderId: "398380",
          //         name: "Rajesh Kumar",
          //         address:
          //         "No – 9 Plot, Building, 2nd, 3rd and 4th Floor, Moti Nagar Rd, Delhi Industrial Area, New Delhi, Delhi 110015",
          //         phone: "+91 9876543234",
          //         payment: "Cash - ₹400",
          //         status: "Order Canceled",
          //       ),
          //     ],
          //   ),
          // ),
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
