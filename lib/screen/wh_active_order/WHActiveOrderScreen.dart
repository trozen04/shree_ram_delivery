import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/ConstantString.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/screen/load_item/LoadItemScreen.dart';

import '../../model/LoadStatusItem.dart';
import '../../support/alert_dialog_manager.dart';
import '../load_item/LoadItemController.dart';
import 'WHActiveOrderController.dart';

class WHActiveOrderScreen extends StatelessWidget {
  DailyAssignedOrderModel model;
  WHActiveOrderScreen(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GetBuilder(
      init: Get.put(WHActiveOrderController(context, model)),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            try {
              final loadItemController = Get.find<LoadItemController>(tag: model.sId);
              loadItemController.clearLoadedItems();
            } catch (e) {
              print("No LoadItemController found to clear: $e");
            }
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: BackButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.grey),
                    )),
                  ),
                  onPressed: () {
                    try {
                      final loadItemController = Get.find<LoadItemController>(tag: model.sId);
                      loadItemController.clearLoadedItems();
                    } catch (e) {
                      print("No LoadItemController found to clear: $e");
                    }
                    Get.back();
                  },
                ),
                toolbarHeight: 70,
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.white,
                title: Text("Active Order", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                centerTitle: true,
                elevation: 3,
                shadowColor: Colors.grey,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [],
                                      ),
                                      const SizedBox(height: 6),
                                      if (model.userId != null)
                                        Text(
                                          "${model.userId!.name ?? ""}",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      if (model.deliveryaddress != null)
                                        Text(
                                          "${model.deliveryaddress!.addressline},${model.deliveryaddress!.city},${model.deliveryaddress!.state},(${model.deliveryaddress!.pin})",
                                          style: TextStyle(color: Colors.black54, fontSize: 13),
                                        ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.phone, color: Colors.purple, size: 16),
                                          SizedBox(width: 6),
                                          if (model.userId != null) Text("+91 ${model.userId!.mobileno}"),
                                          Spacer(),
                                          Icon(Icons.call, color: Colors.green),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.currency_rupee, color: Colors.purple, size: 16),
                                          SizedBox(width: 6),
                                          Text("${model.grandTotal ?? "0"}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text("Driver Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const Divider(),
                                if (controller.driverProfileModel.employee != null)
                                  Text("Name : ${controller.driverProfileModel.employee!.name ?? ""}",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                if (controller.driverProfileModel.employee != null)
                                  Text("Mobile Number : ${controller.driverProfileModel.employee!.phoneno ?? ""}"),
                                if (controller.driverProfileModel.employee != null)
                                  Text("Email : ${controller.driverProfileModel.employee!.email ?? ""}"),
                                const Divider(),
                                const SizedBox(height: 20),
                                Text("Order Items (${model.items != null ? model.items!.length : 0})",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                const SizedBox(height: 10),
                                if (model.items != null)
                                  if (model.items!.isNotEmpty)
                                    Column(
                                      children: model.items!
                                          .where((item) {
                                        final loadItem = controller.loadStatusItems.firstWhere(
                                              (e) => e.productId == item.productId!.sId,
                                          orElse: () => LoadStatusItem(
                                            productId: item.productId!.sId ?? "",
                                            orderedQuantity: item.quantity ?? 0,
                                            loadedQuantity: 0,
                                            remainingQuantity: item.quantity ?? 0,
                                            status: "",
                                          ),
                                        );
                                        return loadItem.remainingQuantity > 0;
                                      })
                                          .map((toElement) {
                                        final loadItem = controller.loadStatusItems.firstWhere(
                                              (e) => e.productId == toElement.productId!.sId,
                                          orElse: () => LoadStatusItem(
                                            productId: toElement.productId!.sId ?? "",
                                            orderedQuantity: toElement.quantity ?? 0,
                                            loadedQuantity: 0,
                                            remainingQuantity: toElement.quantity ?? 0,
                                            status: "",
                                          ),
                                        );

                                        return Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(
                                                LoadItemScreen(
                                                  model,
                                                  toElement,
                                                  loadItem.remainingQuantity,
                                                  //loadedUnit: toElement.unit ?? "",
                                                ),
                                              );
                                            },
                                            child: _orderItem(toElement, controller),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                const SizedBox(height: 10),
                                Text("Sub Total          : ₹ ${model.subtotal ?? "0"}"),
                                Text("Delivery Fee     : ₹ ${model.deliverycharge ?? "0"}"),
                                Text("Labour Charge : ₹ ${model.totalLabourCharge ?? "0"}"),
                                Divider(),
                                Text("Total Amount  : ₹ ${model.grandTotal ?? "0"}", style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                const Divider(),
                                const Text(
                                  "Vehicle No.",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller.vehicleNoController,
                                  decoration: InputDecoration(
                                    hintText: "Enter Vehicle No.",
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                  onTap: () {
                                    CustomWidget().getBottomSheetForProfile(context, () {
                                      controller.navigateAndDisplaySelection(context, 1, 0);
                                    }, () {
                                      controller.navigateAndDisplaySelection(context, 2, 0);
                                    });
                                  },
                                  child: Container(
                                    height: 120,
                                    width: Get.width,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                      image: controller.base64Profile.isNotEmpty
                                          ? DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile)))
                                          : null,
                                    ),
                                    child: Image.asset("assets/cam_img.png", height: 30, width: 30),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomWidget.elevatedCustomButton(context, "Loading Finished", () {
                                  if (controller.vehicleNoController.text.isEmpty) {
                                    AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
                                      context,
                                      "Error",
                                      "Please enter a vehicle number.",
                                      onTapFunction: () => Get.back(),
                                    );
                                    return;
                                  }
                                  if (controller.base64Profile.isEmpty) {
                                    AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
                                      context,
                                      "Error",
                                      "Please upload a proof image.",
                                      onTapFunction: () => Get.back(),
                                    );
                                    return;
                                  }
                                  controller.updateProfile(context, model.sId ?? "");
                                }, width: Get.width - 30, borderRadius: 25),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _orderItem(Items model, WHActiveOrderController controller) {
    ProductId data = model.productId ?? ProductId();

    final loadItem = controller.loadStatusItems.firstWhere(
          (e) => e.productId == data.sId,
      orElse: () => LoadStatusItem(
        productId: data.sId ?? "",
        orderedQuantity: model.quantity ?? 0,
        loadedQuantity: 0,
        remainingQuantity: model.quantity ?? 0,
        status: "",
      ),
    );

    //print("Selected LoadItem: ProductId: ${loadItem.productId}, Status: ${loadItem.status}, Remaining: ${loadItem.remainingQuantity}");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                ConstantString.image_base_Url +
                    ((data.productimage != null && data.productimage!.isNotEmpty) ? (data.productimage!.first ?? "") : "placeholder.png"),
                fit: BoxFit.cover,
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
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("${data.productname ?? ""}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text("${data.description}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.black54)),
                  Text("Price Per Unit : ₹ ${model.pricePerUnit}"),
                  if (loadItem.status == "Total" || loadItem.status.toLowerCase() == "partiallydispatch") ...[
                    Text(
                      "Remaining Quantity: ${loadItem.remainingQuantity}",
                      style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Loaded Quantity: ${loadItem.loadedQuantity}",
                      style: TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
            child: Text("${loadItem.remainingQuantity}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}