import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoadStatusItem.dart';
import 'LoadItemController.dart';

class LoadItemScreen extends StatelessWidget {
  final DailyAssignedOrderModel model;
  final Items toElement;
  final int remainingQuantity;
  // final String loadedUnit;

  LoadItemScreen(this.model, this.toElement, this.remainingQuantity, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> units = ['Bori', 'Bottle', 'Pack'];

    return GetBuilder(
      init: Get.put(
        LoadItemController(context, toElement.productId!.sId ?? "", model),
        tag: model.sId ?? "",
        permanent: true,
      ),
      builder: (controller) {
        controller.updateProductId(toElement.productId!.sId ?? "");
        print('LoadItemScreen built for productId=${toElement.productId!.sId}, orderId=${model.sId}');
        return WillPopScope(
          onWillPop: () async {
            print('WillPopScope triggered for LoadItemScreen');
            controller.saveToStorage();
            print('Saved items before leaving LoadItemScreen');
            return true;
          },
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
                  print('Back button pressed in LoadItemScreen');
                  controller.saveToStorage();
                  print('Saved items on back press');
                  Get.back();
                },
              ),
              toolbarHeight: 60,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: Text("Load Item", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
              centerTitle: true,
              elevation: 2,
              shadowColor: Colors.grey.shade200,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          "Order List",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: toElement.productId != null &&
                                        toElement.productId!.productimage != null &&
                                        toElement.productId!.productimage!.isNotEmpty
                                        ? NetworkImage(
                                      ConstantString.image_base_Url + (toElement.productId!.productimage!.first ?? ""),
                                    )
                                        : AssetImage("assets/placeholder.png") as ImageProvider,
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (toElement.productId != null)
                                          Text(
                                            "${toElement.productId!.productname ?? ""}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        Text(
                                          "${toElement.productId!.brand ?? ""}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.yellow[600],
                                    child: Text(
                                      remainingQuantity.toString(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: controller.quantityLoadedController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    print('Quantity changed: $value');
                                    controller.onUpdate(remainingQuantity);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Quantity (Max: $remainingQuantity)",
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: controller.unitController.text.isNotEmpty
                                    ? controller.unitController.text
                                    : null, // Set initial value if any
                                decoration: InputDecoration(
                                  hintText: 'Select Unit',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: units.map((unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.unitController.text = value;
                                    print('Unit selected: $value');
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller.balanceLeftController,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Balance Left",
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller.stockLeftController,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Stock in Godown: ${controller.stockQuantity}",
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomWidget.elevatedCustomButton(context, "Submit", () {
                  print('Submit button pressed in LoadItemScreen');
                  controller.saveLoadedItem(model.sId ?? "", remainingQuantity);
                }, borderRadius: 25, width: Get.width - 40),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}