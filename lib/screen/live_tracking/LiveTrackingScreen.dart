import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shree_ram_delivery_app/constant/ConstantFunction.dart';
import 'package:shree_ram_delivery_app/model/TaskModel.dart';
import 'package:shree_ram_delivery_app/screen/live_tracking/LiveTrackingController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/ConstantString.dart';


class LiveTrackingScreen extends StatelessWidget {
  TaskModel  model;
  double lat = 0.0;
  double lng = 0.0;
  LiveTrackingScreen(this.model,this.lat,this.lng,{super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder(
        init: Get.put(LiveTrackingController(context,model,lat,lng)),
        builder: (controller){
          return WillPopScope(
            onWillPop: () async {
              // Return latest delivery charge when system back button is pressed
              Get.back(result: controller.latestDeliveryCharge);
              return false; // Prevent default pop since we already handled it
            },
            child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      //onPressed: () => Get.back(),
                      onPressed: () {
                        // Get the controller
                        final controller = Get.find<LiveTrackingController>();
                        // Return latest delivery charge
                        Get.back(result: controller.latestDeliveryCharge);
                      },
                    ),
                    title: const Text(
                      "View Location",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    centerTitle: true,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  body: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: controller.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            ConstantFunction.lat ?? 12.0,
                            ConstantFunction.lng ?? 0.0,
                          ),
                          zoom: controller.zoomLevel,
                        ),
                        markers: controller.markers,
                        polylines: controller.polylines,
                        polygons: controller.polygons, // Added this line
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal, // Added for better road visibility
                        trafficEnabled: true, // Added to show traffic
                      ),
                      Positioned(
                        right: 12,
                        bottom: 300,
                        child: Column(
                          children: [
                            zoomIcon(icon: Icons.add, onTap: controller.zoomIn),
                            SizedBox(height: 10,),
                            zoomIcon(
                              icon: Icons.remove,
                              onTap: controller.zoomOut,
                            ),
                            SizedBox(height: 10,),
                            // Added recenter button
                            zoomIcon(
                              icon: Icons.my_location,
                              onTap: controller.recenter,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 220,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.shade400,spreadRadius: 3,blurRadius: 4)
                                ]
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Distance",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                                        Text(controller.distanceValue.toString(),style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                                      ],
                                    )),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Time",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                                        Text(controller.durationText,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                                      ],
                                    )),
                                  ],
                                ),
                                Spacer(),
                                Text("Contact Information",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w500),),
                                Row(
                                  children: [

                                    CircleAvatar(
                                      backgroundImage: NetworkImage(ConstantString.image_base_Url+(model.orderid!=null?model.orderid!.userId!=null?(model.orderid!.userId!.photo??""):"":"")),
                                      radius: 30,
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(model.orderid!=null)
                                        if(model.orderid!.userId!=null)
                                        Text((model.orderid!.userId!.name??""),style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                                        if(model.orderid!=null)
                                        if(model.orderid!.userId!=null)
                                        Text((model.orderid!.userId!.email??""),style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                                      ],
                                    )),
                                    if(model.orderid!=null)
                                      if(model.orderid!.userId!=null)
                                    InkWell(
                                      onTap: ()async{
                                        final Uri dialUri = Uri(
                                          scheme: 'tel',
                                          path:(model.orderid!.userId!.mobileno??"").toString(),
                                        );

                                        if (await canLaunchUrl(dialUri)) {
                                          await launchUrl(dialUri);
                                        } else {
                                          throw 'Could not launch ${(model.orderid!.userId!.mobileno??"")}';
                                        }

                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey.shade200,
                                        radius: 20,
                                        child: Icon(Icons.call,size: 30,color: Colors.green,),
                                      ),
                                    ),
                                    SizedBox(height: 70,)
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                          ))
                    ],
                  ),
                )),
          );
        });
  }

  Widget zoomIcon({IconData? icon, String? imagePath, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: icon != null ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: icon != null ? null : BorderRadius.circular(5),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(10),
        child: icon != null
            ? Icon(icon, size: 20)
            : Image.asset(
          imagePath!,
          width: 25,
          height: 25,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}