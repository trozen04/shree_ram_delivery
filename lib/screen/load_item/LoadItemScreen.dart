

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import '../../constant/ConstantString.dart';
import 'LoadItemController.dart';

class LoadItemScreen extends StatelessWidget {
  final DailyAssignedOrderModel model;
  final Items toElement;
  final int remainingQuantity;

  LoadItemScreen(this.model, this.toElement, this.remainingQuantity, {super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder(
      init: Get.put(LoadItemController(context,toElement.productId!.sId??"",model)),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: BackButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.grey)
                  ))
              ),
            ),

            toolbarHeight: 60,
            surfaceTintColor:Colors.transparent,
            backgroundColor: Colors.white,
            title: Text("Load Item",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
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

                      // Order List Section
                      const Text(
                        "Order List",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),

                      // Card UI
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
                            // Product Row
                            Row(
                              children: [
                                 CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      ConstantString.image_base_Url+(toElement.productId!=null?toElement.productId!.productimage!=null?toElement.productId!.productimage!.isNotEmpty?(toElement.productId!.productimage!.first??""):"":"":"")),
                                  radius: 20,
                                ),
                                const SizedBox(width: 12),
                                 Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(toElement.productId!=null)
                                      Text("${toElement.productId!.productname??""}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(" ${toElement.productId!.brand??""}",
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.yellow[600],
                                  child: Text(
                                    remainingQuantity.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )

                              ],
                            ),

                            const SizedBox(height: 16),

                            // Quantity Loaded
                            TextField(
                              controller: controller.quantityLoadedController,
                              keyboardType: TextInputType.number,
                              onChanged: (value){
                                if(value.isNotEmpty){
                                  // Pass remainingQuantity from constructor
                                  controller.onUpdate(remainingQuantity);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Quantity",
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Unit
                            TextField(
                              controller: controller.unitController,
                              decoration: InputDecoration(
                                hintText: "Enter Unit",
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Balance Left (Editable)
                            TextField(
                              controller: controller.balanceLeftController,
                              keyboardType: TextInputType.number,
                              readOnly: false,
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

                            // Stock Left in Godown (Editable)
                            TextField(
                              controller: controller.stockLeftController,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Stock in godown - Quantity Loaded",
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
              CustomWidget.elevatedCustomButton(context, "Submit", (){
               if(controller.validation(context)){
                 controller.loadItems(model.sId??"");
               }
              },borderRadius: 25,width: Get.width-40),
              SizedBox(height: 20,)
            ],
          ),
        );
      },
    );
  }
}