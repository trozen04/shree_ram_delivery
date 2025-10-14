import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardController.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardScreen.dart';

import '../../constant/CustomWidget.dart';

class DaySummaryScreen {
  static Widget getDaySummaryScreen(BuildContext context,DashboardController controller) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Header
        Container(
          height: height * 0.10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: const Center(
            child: Text(
              "Day summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery Summary",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Review your delivery performance for today.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),

                // Total Deliveries Card
                _summaryCard(
                  title: "Total Deliveries",
                  value: controller.totalOrder.toString(),
                  icon: Icons.local_shipping_outlined,
                  iconColor: Colors.blue,
                  subtitle: "",
                ),

                _summaryCard(
                  title: "Delivered",
                  value: controller.taskSummary.delivered.toString(),
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  subtitle: "",
                ),

                _summaryCard(
                  title: "Pending",
                  value: controller.taskSummary.pending.toString(),
                  icon: Icons.timelapse,
                  iconColor: Colors.orange,
                  subtitle: "",
                ),

                _summaryCard(
                  title: "Canceled",
                  value: controller.taskSummary.cancel.toString(),
                  icon: Icons.cancel_outlined,
                  iconColor: Colors.red,
                  subtitle: "",
                ),

                const SizedBox(height: 16),

                // COD Collected
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.currency_rupee,
                          color: Colors.purple, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("Total COD Collected",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(height: 4),
                          Text(
                            "${controller.totalCollected}",
                            style: TextStyle(
                                fontSize: 13, color: Colors.green),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Feedback Section
                // Container(
                //   padding: const EdgeInsets.all(14),
                //   margin: const EdgeInsets.symmetric(vertical: 6),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.15),
                //         blurRadius: 5,
                //         offset: const Offset(0, 3),
                //       )
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: const [
                //           Icon(Icons.feedback_outlined,
                //               color: Colors.purple, size: 24),
                //           SizedBox(width: 12),
                //           Text("Feedback(Optional)",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w600, fontSize: 15)),
                //         ],
                //       ),
                //       const SizedBox(height: 12),
                //       Container(
                //         decoration: BoxDecoration(
                //           color: Colors.grey.shade100,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: const TextField(
                //           decoration: InputDecoration(
                //             border: InputBorder.none,
                //             hintText: "Type",
                //           ),
                //           maxLines: 3,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                //
                // const SizedBox(height: 30),
                //
                // // Submit Button
                // CustomWidget.elevatedCustomButton(context, "Submit",(){
                //
                // },borderRadius:25,width: Get.width)
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Reusable card method
  static Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                if (subtitle.isNotEmpty)
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: iconColor),
          ),
        ],
      ),
    );
  }
}
