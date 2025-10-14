



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/InChargeProfileModel.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';

class  WIProfileController extends  GetxController{


  BuildContext   context;

  WIProfileController(this.context);

  LoginModel  loginModel=LoginModel();
  InChargeProfileModel   profileModel=InChargeProfileModel();

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
      update();
    });
  }



  getProfile(){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getInChargeProfile+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      profileModel=InChargeProfileModel.fromJson(response);
      print(onValue);
      update();
    });
  }
}