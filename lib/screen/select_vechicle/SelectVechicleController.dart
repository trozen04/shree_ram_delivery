




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/LoginModel.dart';
import 'package:shree_ram_delivery_app/screen/select_city/SelectCityScreen.dart';
import 'package:shree_ram_delivery_app/support/PreferenceManager.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../support/alert_dialog_manager.dart';
import '../upload_doc/UploadDocumentScreen.dart';

class SelectVechicleController  extends GetxController{

  BuildContext context;
  SelectVechicleController(this.context);
  String selectedVehicle = "Bike";

  /// Vehicle list
  final vehicles = ["Bike", "Scooter", "Mini Van", "Tempo", "Truck"];

  LoginModel  loginModel=LoginModel();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }



  getUserDetails(){
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      update();
    });
  }


  upadteProfile()async{
    await APIConstant.gethitAPI(context, ConstantString.patch, ConstantString.updateDetails+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token??""}"
    },body: {
      "vehicle":selectedVehicle,
    }).then((onValue){
      var data=jsonDecode(onValue);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", data["message"],onTapFunction: (){
        Get.back();
        Get.to(()=>SelectCityScreen());
      });
      update();
    });

  }

}