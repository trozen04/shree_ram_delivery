



import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/DailyAssignedOrderModel.dart';
import '../../model/InChargeProfileModel.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';

class   LoadItemController  extends  GetxController{

  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController quantityLoadedController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController balanceLeftController = TextEditingController();
  TextEditingController stockLeftController = TextEditingController();

  // Example initial stock

  BuildContext   context;
  String id;
  DailyAssignedOrderModel  model;
  LoadItemController(this.context,this.id,this.model);


  LoginModel  loginModel=LoginModel();
  InChargeProfileModel   profileModel=InChargeProfileModel();

  int stockQuantity=0;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }

  getUserDetails(){
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      getProfile();
      getStock();
      update();
    });
  }



  // onUpdate(int productQuatity){
  //    int quatity=int.parse(quantityLoadedController.text??"0");
  //    if(quatity>0){
  //      balanceLeftController.text=(productQuatity-quatity).toString();
  //      stockLeftController.text=(stockQuantity-quatity).toString();
  //      update();
  //    }
  // }

  void onUpdate(int initialRemainingQuantity){
    int loaded = int.tryParse(quantityLoadedController.text) ?? 0;

    // Remaining quantity = initial remaining - loaded
    int remaining = initialRemainingQuantity - loaded;
    remaining = remaining < 0 ? 0 : remaining;

    balanceLeftController.text = remaining.toString();

    // Stock left = total stock - loaded
    int stockLeft = stockQuantity - loaded;
    stockLeft = stockLeft < 0 ? 0 : stockLeft;
    stockLeftController.text = stockLeft.toString();

    update();
  }


  getProfile() {
    APIConstant.gethitAPI(context, ConstantString.get,
        ConstantString.getInChargeProfile + "${loginModel.driver!.id}",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver!.token}"
        }).then((onValue) {
      var response = jsonDecode(onValue);
      profileModel = InChargeProfileModel.fromJson(response);
      getProduct();
      print(onValue);
      update();
    });
  }



    validation(context){
     if(quantityLoadedController.text.isEmpty){
       AlertDialogManager.getSnackBarMsg("Message", "Quantity can't be Empty", false, context);
       return false;
     }else if(unitController.text.isEmpty){
       AlertDialogManager.getSnackBarMsg("Message", "Unit can't be Empty", false, context);
       return false;
     }else{
      return true;
     }
    }


  getProduct(){
    APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getProductById+"$id",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    }).then((onValue){
      var responce=jsonDecode(onValue);
      if(responce!=null) {
        update();
      }
    });
  }



  getStock(){
    APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getStock+"${id}/${model.warehouseId}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    }).then((onValue){
      var responce=jsonDecode(onValue);
      developer.log('load Response: ${responce}');

      if(responce!=null) {
        stockQuantity=responce["availableQuantity"]??0;
        update();
      }
    });
  }




  loadItems(String orderId){
    Map<String,dynamic>  map={
      "loadQty":quantityLoadedController.text,
      "unit":unitController.text,
      "remainingQty":balanceLeftController.text,
    };
    APIConstant.gethitAPI(context,ConstantString.post ,ConstantString.getLoadOrder+"${orderId}/${id}/${profileModel.employee!.sId??""}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    },body: map).then((onValue){
      var response=jsonDecode(onValue);
       AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", "Loaded Successfully",onTapFunction: (){
         Get.back();
         Get.back();
       });
      update();
    });
  }






}