import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/model/TaskModel.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryController.dart';
import 'package:shree_ram_delivery_app/screen/live_tracking/LiveTrackingScreen.dart';

import '../../constant/ConstantString.dart';
import '../load_item/LoadItemScreen.dart';

class ActiveDeliveryScreen extends StatelessWidget {
  TaskModel model;
  ActiveDeliveryScreen(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GetBuilder(
        init: Get.put(ActiveDeliveryController(context)),
        builder: (controller) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      const BackButton(),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Active Delivery",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Order Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //  Text(
                              //   "Order Id -${model.orderid!.sId??""}",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600, fontSize: 16),
                              // ),
                              const SizedBox(height: 6),
                              // Row(
                              //   children: const [
                              //     Icon(Icons.access_time, size: 16, color: Colors.grey),
                              //     SizedBox(width: 4),
                              //     Text("Started 2min ago"),
                              //     SizedBox(width: 16),
                              //     Icon(Icons.location_on,
                              //         size: 16, color: Colors.grey),
                              //     SizedBox(width: 4),
                              //     Text("3.2 km"),
                              //   ],
                              // ),
                              const SizedBox(height: 16),

                              // Map Placeholder
                              if (model.orderid!.status == "OFD")
                                InkWell(
                                  overlayColor: WidgetStatePropertyAll(
                                      Colors.transparent),
                                  // onTap: ()async{
                                  //   print('nav tapped');
                                  //   if(model.orderid!=null) {
                                  //     if (model.orderid!.deliveryaddress != null) {
                                  //       if (model.orderid!.deliveryaddress!.location != null) {
                                  //         if (model.orderid!.deliveryaddress!.location!
                                  //             .coordinates != null) {
                                  //           if (model.orderid!.deliveryaddress!.location!
                                  //               .coordinates!.isNotEmpty) {
                                  //
                                  //
                                  //             double lat = model.orderid!.deliveryaddress!.location!.coordinates![0];
                                  //             double lng = model.orderid!.deliveryaddress!.location!.coordinates![1];
                                  //
                                  //             bool granted = await controller.checkLocationPermissionAndService();
                                  //             if (granted) {
                                  //               final latestCharge = await Get.to(() => LiveTrackingScreen(model, lat, lng));
                                  //               if (latestCharge != null) {
                                  //                 developer.log('latest charge: $latestCharge');
                                  //                 controller.latestDeliveryCharge.value = latestCharge;
                                  //                 controller.update(); // refresh UI if needed
                                  //               }
                                  //             }
                                  //           }
                                  //         }
                                  //       }
                                  //     }
                                  //   }
                                  // },

                                  onTap: () async {
                                    print('nav tapped');

                                    List<double>? coordinates = model
                                        .orderid
                                        ?.deliveryaddress
                                        ?.location
                                        ?.coordinates;

                                    // If coordinates are null or empty, fetch current device location
                                    if (coordinates == null ||
                                        coordinates.isEmpty) {
                                      bool serviceEnabled = await Geolocator
                                          .isLocationServiceEnabled();
                                      if (!serviceEnabled) {
                                        print(
                                            'Location services are disabled.');
                                        return;
                                      }

                                      LocationPermission permission =
                                          await Geolocator.checkPermission();
                                      if (permission ==
                                          LocationPermission.denied) {
                                        permission = await Geolocator
                                            .requestPermission();
                                        if (permission ==
                                            LocationPermission.denied) {
                                          print('Location permission denied');
                                          return;
                                        }
                                      }

                                      if (permission ==
                                          LocationPermission.deniedForever) {
                                        print(
                                            'Location permission permanently denied.');
                                        return;
                                      }

                                      Position position =
                                          await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high,
                                      );

                                      coordinates = [
                                        position.latitude,
                                        position.longitude
                                      ];
                                      print(
                                          'Fetched device coordinates: $coordinates');
                                    }

                                    double lat = coordinates[0];
                                    double lng = coordinates[1];

                                    bool granted = await controller
                                        .checkLocationPermissionAndService();
                                    if (granted) {
                                      final latestCharge = await Get.to(() =>
                                          LiveTrackingScreen(model, lat, lng));
                                      if (latestCharge != null) {
                                        developer.log(
                                            'latest charge: $latestCharge');
                                        controller.latestDeliveryCharge.value =
                                            latestCharge;
                                        controller
                                            .update(); // refresh UI if needed
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: height * 0.2,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Text("Navigation with map",
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: const [
                              //     Text("3.2 Total km",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.green)),
                              //     Text("12 Minutes",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.orange)),
                              //   ],
                              // ),
                              const SizedBox(height: 16),

                              // Address Card
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2))
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text("Order Id - ${model.orderid!.sId??""}",
                                        //     style:
                                        //     TextStyle(fontWeight: FontWeight.w500)),
                                        // Text("3.2 km",
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.w500,
                                        //         color: Colors.blue)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if (model.orderid != null)
                                      if (model.orderid!.userId != null)
                                        Text(
                                            "${model.orderid!.userId!.name ?? ""}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                    if (model.orderid != null)
                                      if (model.orderid!.deliveryaddress !=
                                          null)
                                        Text(
                                          model.orderid!.deliveryaddress != null
                                              ? "${model.orderid!.deliveryaddress!.addressline},${model.orderid!.deliveryaddress!.city},${model.orderid!.deliveryaddress!.state},(${model.orderid!.deliveryaddress!.pin})"
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13),
                                        ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: Colors.purple, size: 16),
                                        SizedBox(width: 6),
                                        if (model.orderid != null)
                                          if (model.orderid!.userId != null)
                                            Text(
                                                "+91 ${model.orderid!.userId!.mobileno}"),
                                        Spacer(),
                                        Icon(Icons.call, color: Colors.green),
                                      ],
                                    ),
                                    // const SizedBox(height: 6),
                                    // Row(
                                    //   children:  [
                                    //     Icon(Icons.currency_rupee,
                                    //         color: Colors.purple, size: 16),
                                    //     SizedBox(width: 6),
                                    //     Text("${model.orderid.??""}"),
                                    //   ],
                                    // ),
                                    const SizedBox(height: 8),
                                    // Container(
                                    //   padding: const EdgeInsets.all(8),
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.yellow.shade100,
                                    //       borderRadius: BorderRadius.circular(8)),
                                    //   child: const Text(
                                    //     "Special Instructions\nRing doorbell twice. Building gate code: #1234.\nContactless delivery preferred. Leave at door if no answer.",
                                    //     style: TextStyle(
                                    //         fontSize: 12, color: Colors.black87),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Order Items
                              const Text("Order Items",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              const SizedBox(height: 10),
                              if (model.orderid!.items != null)
                                if (model.orderid!.items != [])
                                  Column(
                                    children:
                                        model.orderid!.items!.map((toElement) {
                                      return _orderItem(toElement, model);
                                    }).toList(),
                                  ),

                              const SizedBox(height: 10),
                              if (model.orderid != null)
                                Text(
                                    "Sub Total : ₹${model.orderid!.subtotal ?? "0"}"),
                              // if(model.orderid!=null)
                              // Text("Delivery Fee     : ₹${model.orderid!.deliverycharge??"0"}"),
                              Obx(() => Text(
                                    "Delivery Fee : ₹${controller.latestDeliveryCharge.value != 0 ? controller.latestDeliveryCharge.value : model.orderid!.deliverycharge ?? "0"}",
                                  )),
                              if (model.orderid != null)
                                Text(
                                    "Labour Charge : ₹${model.orderid!.totalLabourCharge ?? "0"}"),
                              Divider(),
                              if (model.orderid != null)
                                // Text("Total Amount  : ₹${model.orderid!.grandTotal??"0"}",
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                Obx(() {
                                  // Safely parse numeric values
                                  final double grandTotal = double.tryParse(
                                          "${model.orderid?.grandTotal ?? 0}") ??
                                      0;
                                  final double deliveryFee = controller
                                              .latestDeliveryCharge.value !=
                                          0
                                      ? controller.latestDeliveryCharge.value
                                          .toDouble()
                                      : double.tryParse(
                                              "${model.orderid?.deliverycharge ?? 0}") ??
                                          0;

                                  final double totalAmount =
                                      grandTotal + deliveryFee;

                                  return Text(
                                    "Amount To Be Collected : ₹$totalAmount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                }),

                              SizedBox(
                                height: 20,
                              ),
                              if (model.orderid != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Payment Method - ${model.orderid!.paymentmethod ?? ""}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              if (model.orderid != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Order Status - ${model.orderid!.status ?? ""}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),

                              const SizedBox(height: 40),
                              if (model.orderid!.status == "OFD")
                                CustomWidget.stringTypeDropDown(
                                    controller.currentStatus,
                                    controller.taskStatusList, (value) {
                                  controller.currentStatus = value!;
                                  controller.update();
                                }, controller.statusNode, hideLabel: true),
                              SizedBox(
                                height: 10,
                              ),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[0])
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Delivered To",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[1])
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Cancel Reason",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[0])
                                  CustomWidget.stringTypeDropDown(
                                      controller.deliveredTo,
                                      controller.deliveredToList, (value) {
                                    controller.deliveredTo = value!;
                                    controller.update();
                                  }, controller.deliverNode, hideLabel: true),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[1])
                                  CustomWidget.stringTypeDropDown(
                                      controller.currentReason,
                                      controller.cancelReasonList, (value) {
                                    controller.currentReason = value!;
                                    controller.update();
                                  }, controller.reasonNode, hideLabel: true),
                              // Buttons
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[0])
                                  CustomWidget.textInputFiled(
                                    controller.noteTextCon,
                                    focusNode: controller.noteFocus,
                                    textAlign: TextAlign.left,
                                    topPadding: 10,
                                    // rightPadding: 20,
                                    // leftPadding: 20,
                                    bottomPadding: 5,
                                    maxLine: 1,
                                    textInputType: TextInputType.text,
                                    labelTextNew: "Note",
                                  ),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                    controller.taskStatusList[0])
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "Is Amount Collected",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Spacer(),
                                      Transform.scale(
                                        scale:
                                            0.8, // reduce size (0.5 = half, 1.0 = normal, >1 = bigger)
                                        child: Switch(
                                          value: controller.isAmountCollected,
                                          activeColor: Colors.green,
                                          onChanged: (value) {
                                            controller
                                                .toggleAmountCollected(value);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                              if (model.orderid!.status == "OFD")
                                if (controller.currentStatus ==
                                        controller.taskStatusList[0] &&
                                    controller.isAmountCollected)
                                  CustomWidget.textInputFiled(
                                    controller.collectedAmountTextCon,
                                    focusNode: controller.collAmtFocus,
                                    textAlign: TextAlign.left,
                                    topPadding: 0,
                                    // rightPadding: 20,
                                    // leftPadding: 20,
                                    bottomPadding: 15,
                                    maxLine: 1,
                                    textInputType: TextInputType.number,
                                    labelTextNew: "Collected Amount",
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                  ),
                              if (model.orderid!.status == "OFD")
                                SizedBox(
                                  height: 20,
                                ),
                              if (model.orderid!.status == "OFD")
                                InkWell(
                                  overlayColor: WidgetStatePropertyAll(
                                      Colors.transparent),
                                  onTap: () {
                                    CustomWidget()
                                        .getBottomSheetForProfile(context, () {
                                      controller.navigateAndDisplaySelection(
                                          context, 1, 0);
                                    }, () {
                                      controller.navigateAndDisplaySelection(
                                          context, 2, 0);
                                    });
                                  },
                                  child: Container(
                                    height: 120,
                                    width: Get.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            image: MemoryImage(base64Decode(
                                                controller.base64Profile)))),
                                    child: Image.asset(
                                      "assets/cam_img.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (model.orderid!.status == "OFD")
                                Row(
                                  children: [
                                    Expanded(
                                        child:
                                            CustomWidget.elevatedCustomButton(
                                                context, "Submit", () {
                                      if (controller.currentStatus ==
                                          controller.taskStatusList[1]) {
                                        controller.cancelOrder(
                                            context,
                                            model.orderid!.sId ?? "",
                                            model.orderid!.godownInchargeId ??
                                                "",
                                            model.sId ?? "", // taskId
                                            model.orderid!.items?.first
                                                    .productId?.sId ??
                                                "");
                                      } else {
                                        controller.deliveredOrder(
                                            context,
                                            model.orderid!.sId ?? "",
                                            model.orderid!.godownInchargeId ??
                                                "",
                                            model.sId ?? "", // taskId
                                            model.orderid!.items?.first
                                                    .productId?.sId ??
                                                ""); // productId
                                      }
                                    }, borderRadius: 25)),
                                    // const SizedBox(width: 12),
                                    // Expanded(
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //         backgroundColor: Colors.grey.shade300,
                                    //         padding: const EdgeInsets.symmetric(
                                    //             vertical: 14)),
                                    //     onPressed: () {},
                                    //     child: const Text("Not Delivered",
                                    //         style: TextStyle(color: Colors.black)),
                                    //   ),
                                    // ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  static Widget _orderItem(Items model, TaskModel taskModel) {
    ProductId data = model.productId ?? ProductId();

    // Find the matching product in taskModel.products based on productId
    Product? matchingProduct;
    if (taskModel.products != null && taskModel.products!.isNotEmpty) {
      matchingProduct = taskModel.products!.firstWhere(
        (product) => product.productid == data.sId,
        orElse: () => Product(quantity: 0), // Fallback if no match is found
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                ConstantString.image_base_Url +
                    (data.productimage != null
                        ? data.productimage!.isNotEmpty
                            ? (data.productimage!.first ?? "")
                            : ""
                        : ""),
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.productname ?? ""}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("Price Per Unit: ₹${model.pricePerUnit ?? 0}"),
                Text(
                  "Ordered Quantity: ${model.quantity ?? 0}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "Assigned Quantity: ${matchingProduct?.quantity ?? 0}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "Left Quantity: ${matchingProduct?.leftquantity ?? 0}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
            child: Text(
              "${matchingProduct?.quantity ?? ""}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
