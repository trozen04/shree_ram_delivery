



import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../model/ProfileModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../../support/camera.dart';

import 'package:http/http.dart'  as http;

class AssignedAreaController  extends GetxController{
  BuildContext  context;
  AssignedAreaController(this.context);
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



  Future<void> navigateAndDisplaySelection(BuildContext context, int option,{bool isUPI=false}) async {
    var result;
    Get.back();
    switch (option) {
      case 1:
        List<CameraDescription>? cameras;
        await availableCameras().then((value) {
          cameras = value;
        });
        result = await Get.to(ImagePickerConst(cameras: cameras, type: "camera"));
        break;
      case 2:
        List<CameraDescription>? cameras;
        await availableCameras().then((value) {
          cameras = value;
        });
        result = await Get.to(ImagePickerConst(
          cameras: cameras,
          type: "gallery",
        ));

        break;
    }

    if (result != null) {
      base64Profile = result["image64"];
      path = result["imagePath"];
      updateProfile(context);
      update();
    }
  }



  getProfile(){
    APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getProfile+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    }).then((onValue){
      var responce=jsonDecode(onValue);
      profileModel=ProfileModel.fromJson(responce);
      update();
    });
  }



  Future<void> updateProfile(context) async {
    final uri = Uri.parse(ConstantString.updateDetails+"${loginModel.driver!.id}");
    print(uri);

    var request = http.MultipartRequest("PATCH", uri);
    // ✅ Correct headers (removed Content-Type: application/json)
    request.headers.addAll({
      "accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    });
    // Add form fields
    // ✅ Single image upload


    final multipartFile3 = await http.MultipartFile.fromPath('uploadphoto', path,);
    request.files.add(multipartFile3);

    print(request.fields);
    print(request.files.map((f) => f.filename.toString()));

    try {
      EasyLoading.show(status: "Uploading...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      print(responseBody);
      print(response.statusCode);

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ertyuiop[");
        update();
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success",
          responseJson["message"], onTapFunction: () {
            base64Profile="";
            path="";
            PreferenceManager.instance.setString(ConstantString.loginKey_2, responseBody).then((onValue){
              Get.back();
            });
          },
        );
      } else if (response.statusCode < 500) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context, "Error", responseJson["message"], onTapFunction: () {
          Get.back();
        },
        );
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Status Code : ${response.statusCode}",
          responseJson["message"],
          onTapFunction: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception",'Oops! Something went wrong. Please try again later.',
        onTapFunction: () {
          Get.back();
        },
      );
    }
  }


}