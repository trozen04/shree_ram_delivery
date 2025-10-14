





import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/ConstantString.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/screen/active_delivery/ActiveDeliveryController.dart';
import 'package:shree_ram_delivery_app/screen/load_item/LoadItemScreen.dart';

import 'WHActiveOrderController.dart';

class WHActiveOrderScreen extends StatelessWidget {
  DailyAssignedOrderModel  model;
  WHActiveOrderScreen(this.model,{super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GetBuilder(
        init: Get.put(WHActiveOrderController(context,model)),
        builder: (controller){
          return SafeArea(child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // Header
                AppBar(
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
                  title: Text("Active Order",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                  centerTitle: true,
                  elevation: 3,
                  shadowColor: Colors.grey,
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
                              //   "Order Id - ${model.sId??""}",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w600, fontSize: 16),
                              // ),
                              // const SizedBox(height: 6),
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
                              // const SizedBox(height: 16),

                              // Map Placeholder
                              // Container(
                              //   height: height * 0.2,
                              //   width: width,
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey.shade300,
                              //     borderRadius: BorderRadius.circular(16),
                              //   ),
                              //   child: const Center(
                              //     child: Text("Navigation with map",
                              //         style: TextStyle(color: Colors.black54)),
                              //   ),
                              // ),
                              // const SizedBox(height: 12),

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
                              // const SizedBox(height: 16),

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
                                      children:  [
                                        Text("Order Id - ${model.sId??""}",
                                            style:
                                            TextStyle(fontWeight: FontWeight.w500)),
                                        // Text("3.2 km",
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.w500,
                                        //         color: Colors.blue)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if(model.userId!=null)
                                    Text("${model.userId!.name??""}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    if(model.deliveryaddress!=null)
                                    Text(
                                      model.deliveryaddress!=null?
                                      "${model.deliveryaddress!.addressline},${model.deliveryaddress!.city},${model.deliveryaddress!.state},(${model.deliveryaddress!.pin})":"",
                                      style:
                                      TextStyle(color: Colors.black54, fontSize: 13),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children:  [
                                        Icon(Icons.phone,
                                            color: Colors.purple, size: 16),
                                        SizedBox(width: 6),
                                        if(model.userId!=null)
                                        Text("+91 ${model.userId!.mobileno}"),
                                        Spacer(),
                                        Icon(Icons.call, color: Colors.green),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children:  [
                                        Icon(Icons.currency_rupee,
                                            color: Colors.purple, size: 16),
                                        SizedBox(width: 6),
                                        Text("₹${model.grandTotal??"0"}"),
                                      ],
                                    ),
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
                              Text("Driver Details", style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                              const Divider(),
                              if(controller.driverProfileModel.employee!=null)
                                Text("Name : ${controller.driverProfileModel.employee!.name??""}", style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600)),
                              if(controller.driverProfileModel.employee!=null)
                              Text("Mobile Number : ${controller.driverProfileModel.employee!.phoneno??""}"),
                              if(controller.driverProfileModel.employee!=null)
                              Text("Email : ${controller.driverProfileModel.employee!.email??""}"),
                              const Divider(),
                              const SizedBox(height: 20),

                              // Order Items
                              Text("Order Items (${model.items!=null?model.items!.length:0})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 16)),
                              const SizedBox(height: 10),
                             if(model.items!=null)
                             if(model.items!=[])
                             Column(
                               children: model.items!.map((toElement){
                                 return  InkWell(
                                     onTap: (){

                                       Get.to(LoadItemScreen(model,toElement));
                                     },
                                     child: _orderItem(toElement));
                               }).toList(),
                             ),

                              const SizedBox(height: 10),
                               Text("Sub Total          : ₹${model.subtotal??"0"}"),
                               Text("Delivery Fee     : ₹${model.deliverycharge??"0"}"),
                               Text("Labour Charge : ₹${model.totalLabourCharge??"0"}"),
                               Divider(),
                               Text("Total Amount  : ₹${model.grandTotal??"0"}",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                                onTap: (){
                                  CustomWidget().getBottomSheetForProfile(context, () {
                                    controller.navigateAndDisplaySelection(context, 1,0);
                                  }, () {
                                    controller.navigateAndDisplaySelection(context, 2,0);
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
                                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile)))
                                  ),
                                  child: Image.asset("assets/cam_img.png",height: 30,width: 30,),
                                ),
                              ),
                                const SizedBox(height: 20,),
                              // Buttons
                               CustomWidget.elevatedCustomButton(context, "Loading Finished", (){
                                 if(controller.base64Profile.isNotEmpty){
                                   controller.updateProfile(context, model.sId??"");
                                 }
                               },width: Get.width-30,borderRadius: 25)
                            ],
                          ),
                        ),
                        const SizedBox(height:20 ,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }



  static Widget _orderItem(Items  model) {

    ProductId  data=model.productId??ProductId();
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
                borderRadius: BorderRadius.circular(9)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                ConstantString.image_base_Url+(data.productimage!=null?data.productimage!.isNotEmpty?(data.productimage!.first??""):"":""),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text("${data.productname??""}",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text("${data.description}",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                Text("Price Per Unit : ₹${model.pricePerUnit}"),
                // Text("Loaded Quantity:${model.}"),
                // Text("Left Quantity: 1"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.amber),
            child:  Text("${model.quantity??""}",
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ],
      ),
    );
  }
}
