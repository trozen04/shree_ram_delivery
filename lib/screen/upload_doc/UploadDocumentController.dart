




import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/ConstantString.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardScreen.dart';

import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../../support/camera.dart';

import 'package:http/http.dart'  as http;

class   UploadDocumentController extends GetxController{

  BuildContext context;
  UploadDocumentController(this.context);


  String base64Profile="";
  String base64Profile1="";
  String base64Profile2="";
  String base64Profile3="";
  String path="";
  String path1="";
  String path2="";
  String path3="";


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




  Future<void> navigateAndDisplaySelection(BuildContext context, int option,int action,{bool isUPI=false}) async {
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
      if(action==1) {
        base64Profile = result["image64"];
        path = result["imagePath"];
      }
      if(action==2) {
        base64Profile1 = result["image64"];
        path1 = result["imagePath"];
      }
      if(action==3) {
        base64Profile2 = result["image64"];
        path2 = result["imagePath"];
      }
      if(action==4) {
        base64Profile3 = result["image64"];
        path3 = result["imagePath"];
      }
      update();
    }
  }


  bool validation(context){
    if(base64Profile.isEmpty){
      AlertDialogManager.getSnackBarMsg("Message", "Upload Aadhaar image", false, context);
      return false;
    }
    if(base64Profile1.isEmpty){
      AlertDialogManager.getSnackBarMsg("Message", "Upload PAN image", false, context);
      return false;
    }
    if(base64Profile2.isEmpty){
      AlertDialogManager.getSnackBarMsg("Message", "Upload RC image", false, context);
      return false;
    }
    if(base64Profile3.isEmpty){
      AlertDialogManager.getSnackBarMsg("Message", "Upload Profile image", false, context);
      return false;
    }else{
      return true;
    }
  }



  // Future<void> updateProfile(context) async {
  //   final uri = Uri.parse(ConstantString.updateDetails+"${loginModel.driver!.id}");
  //   print(uri);
  //
  //   var request = http.MultipartRequest("PATCH", uri);
  //   print('toke: ${loginModel.driver!.token}');
  //   // ✅ Correct headers (removed Content-Type: application/json)
  //   request.headers.addAll({
  //     "accept": "application/json",
  //     // 'Content-Type': 'application/json',
  //     "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
  //   });
  //   // Add form fields
  //   // ✅ Single image upload
  //
  //   final multipartFile = await http.MultipartFile.fromPath('uploadadhar', path,);
  //   final multipartFile1 = await http.MultipartFile.fromPath('uploadpan', path1,);
  //   final multipartFile2 = await http.MultipartFile.fromPath('uploadrc', path2,);
  //   final multipartFile3 = await http.MultipartFile.fromPath('uploadphoto', path3,);
  //   request.files.add(multipartFile);
  //   request.files.add(multipartFile1);
  //   request.files.add(multipartFile2);
  //   request.files.add(multipartFile3);
  //
  //   print("Fields: ${request.fields}");
  //   print("Files: ${request.files.map((f) => f.filename)}");
  //
  //   try {
  //     EasyLoading.show(status: "Uploading...");
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //     final responseJson = jsonDecode(responseBody);
  //
  //     print(responseBody);
  //     print(response.statusCode);
  //
  //     EasyLoading.dismiss();
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("ertyuiop[");
  //       update();
  //       AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success",
  //         responseJson["message"], onTapFunction: () {
  //           base64Profile="";base64Profile1="";
  //           base64Profile2="";base64Profile3="";
  //           path="";path1="";path2="";path3="";
  //           PreferenceManager.instance.setString(ConstantString.loginKey, responseBody).then((onValue){
  //             Get.offAll(DashboardScreen());
  //           });
  //         },
  //       );
  //     } else if (response.statusCode < 500) {
  //       AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
  //         context, "Error", responseJson["message"], onTapFunction: () {
  //           Get.back();
  //         },
  //       );
  //     } else {
  //       AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
  //         context,
  //         "Status Code : ${response.statusCode}",
  //         responseJson["message"],
  //         onTapFunction: () {
  //           Get.back();
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     print(e);
  //     AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception",'Oops! Something went wrong. Please try again later.',
  //       onTapFunction: () {
  //         Get.back();
  //       },
  //     );
  //   }
  // }

  Future<void> updateProfile(BuildContext context) async {
    final uri = Uri.parse("${ConstantString.updateDetails}${loginModel.driver!.id}");
    print("API URL: $uri");

    var request = http.MultipartRequest("PATCH", uri);

    request.headers.addAll({
      "accept": "application/json",
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}",
    });

    // ✅ Add files if paths are not empty
    try {
      if (path.isNotEmpty) request.files.add(await http.MultipartFile.fromPath('uploadadhar', path));
      if (path1.isNotEmpty) request.files.add(await http.MultipartFile.fromPath('uploadpan', path1));
      if (path2.isNotEmpty) request.files.add(await http.MultipartFile.fromPath('uploadrc', path2));
      if (path3.isNotEmpty) request.files.add(await http.MultipartFile.fromPath('uploadphoto', path3));
    } catch (e) {
      print("Error adding files: $e");
      EasyLoading.dismiss();
      return;
    }

    print("Fields: ${request.fields}");
    print("Files: ${request.files.map((f) => f.filename)}");

    try {
      EasyLoading.show(status: "Uploading...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print("Status code: ${response.statusCode}");
      print("Response body: $responseBody");

      EasyLoading.dismiss();

      // Only decode if server returns JSON
      Map<String, dynamic> responseJson = {};
      if (responseBody.trim().startsWith("{")) {
        responseJson = jsonDecode(responseBody);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        update();
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Success",
          responseJson["message"] ?? "Profile updated successfully.",
          onTapFunction: () {
            base64Profile = base64Profile1 = base64Profile2 = base64Profile3 = "";
            path = path1 = path2 = path3 = "";
            PreferenceManager.instance
                .setString(ConstantString.loginKey, responseBody)
                .then((_) => Get.offAll(DashboardScreen()));
          },
        );
      } else if (response.statusCode < 500) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          responseJson["message"] ?? "Something went wrong",
          onTapFunction: Get.back,
        );
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Status Code: ${response.statusCode}",
          responseJson["message"] ?? "Server error",
          onTapFunction: Get.back,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Exception",
        "Oops! Something went wrong. Please try again later.",
        onTapFunction: Get.back,
      );
    }
  }



}