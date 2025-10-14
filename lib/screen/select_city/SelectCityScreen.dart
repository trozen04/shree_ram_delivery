




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleController.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleScreen.dart';

import '../../constant/CustomWidget.dart';
import 'SelectCityController.dart';

class SelectCityScreen extends StatelessWidget {
  const SelectCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(SelectCityController(context)),
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
              title: Text("Select City",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: Colors.grey.shade50,
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.city.length,
                    itemBuilder: (context, index) {
                      final vehicle = controller.city[index];
                      return RadioListTile<String>(
                        title: Text(vehicle),
                        value: vehicle,
                        groupValue: controller.selectedcity,
                        activeColor: Colors.deepPurple,
                        controlAffinity: ListTileControlAffinity.trailing, // 👈 radio at end
                        onChanged: (value) {
                          controller.selectedcity = value!;
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
