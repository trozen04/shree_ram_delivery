




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleController.dart';
import 'package:shree_ram_delivery_app/screen/upload_doc/UploadDocumentScreen.dart';

class SelectVechicleScreen extends StatelessWidget {
  const SelectVechicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(SelectVechicleController(context)),
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
          title: Text("Select Vehicle",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = controller.vehicles[index];
                  return RadioListTile<String>(
                    title: Text(vehicle),
                    value: vehicle,
                    groupValue: controller.selectedVehicle,
                    activeColor: Colors.deepPurple,
                    controlAffinity: ListTileControlAffinity.trailing, // 👈 radio at end
                    onChanged: (value) {
                      controller.selectedVehicle = value!;
                      controller.update(); // if using GetX, refresh UI
                    },
                  );
                },
              ),
            ),
            CustomWidget.elevatedCustomButton(context, "Continue", (){
              controller.upadteProfile();
            },borderRadius: 25,width: Get.width-40),
            SizedBox(height: 20,)

          ],
        ),
      ));
    });
  }
}
