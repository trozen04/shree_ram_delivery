




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../model/ProfileModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';

class EditAreaController extends GetxController{


  BuildContext  context;
  EditAreaController(this.context);


  TextEditingController    nameTextCon=TextEditingController();
  TextEditingController    mobileTextCon=TextEditingController();
  TextEditingController    assignedTextCon=TextEditingController();


  FocusNode   nameFocus=FocusNode();
  FocusNode   mobileFocus=FocusNode();
  FocusNode   assignedFocus=FocusNode();



  LoginModel loginModel=LoginModel();
  ProfileModel profileModel=ProfileModel();

  String  base64Profile="";
  String  path="";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserTokenId();
    update();
  }


  getUserTokenId(){
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      update();
      getProfile();
      update();
    });
  }



  getProfile(){
    APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getProfile+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    }).then((onValue){
      var responce=jsonDecode(onValue);
      profileModel=ProfileModel.fromJson(responce);
      if(profileModel.employee!=null){
        nameTextCon.text=profileModel.employee!.name??"";
        mobileTextCon.text=(profileModel.employee!.phoneno??"").toString();
        assignedTextCon.text=profileModel.employee!.city??"";
      }
      update();
    });
  }



  validation(context){
    if(nameTextCon.text.isEmpty){

    } else if(mobileTextCon.text.isEmpty){

    } else if(assignedTextCon.text.isEmpty){

    }
  }



  upadteProfile()async{
    await APIConstant.gethitAPI(context, ConstantString.patch, ConstantString.updateDetails+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token??""}"
    },body: {
      "name":nameTextCon.text,
      "phoneNo":mobileTextCon.text,
      "city":assignedTextCon.text,
    }).then((onValue){
      var data=jsonDecode(onValue);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", data["message"],onTapFunction: (){
        Get.back();
      });
      update();
    });

  }

}