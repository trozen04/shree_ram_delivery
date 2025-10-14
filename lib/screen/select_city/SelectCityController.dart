




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../upload_doc/UploadDocumentScreen.dart';

class SelectCityController extends GetxController{


  BuildContext  context;
  SelectCityController(this.context);
  String selectedcity = "Mumbai";

  /// Vehicle list
  final city = [ "Mumbai", "Delhi", "Bengaluru", "Hyderabad", "Chennai", "Kolkata", "Pune", "Ahmedabad", "Jaipur", "Surat", "Lucknow"];



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
      "city":selectedcity,
    }).then((onValue){
      var data=jsonDecode(onValue);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", data["message"],onTapFunction: (){
        Get.back();
        Get.to(()=>UploadDocumentScreen());
      });
      update();
    });

  }



}