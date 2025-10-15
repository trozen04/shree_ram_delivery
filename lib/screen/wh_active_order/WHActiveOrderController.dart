




import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/ProfileModel.dart';
import 'package:shree_ram_delivery_app/screen/wh_active_order/WHActiveOrderScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboardScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboaredController.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/DailyAssignedOrderModel.dart';
import '../../model/InChargeProfileModel.dart';
import '../../model/LoadStatusItem.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../../support/camera.dart';
import 'package:http/http.dart'  as http;

class WHActiveOrderController   extends GetxController{

  BuildContext   context;
  DailyAssignedOrderModel  model;
  WHActiveOrderController(this.context,this.model);

  TextEditingController vehicleNoController = TextEditingController();

  LoginModel  loginModel=LoginModel();
  InChargeProfileModel   profileModel=InChargeProfileModel();
  ProfileModel  driverProfileModel=ProfileModel();
  List<LoadStatusItem> loadStatusItems = [];

  String base64Profile="";

  String path="";

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
      getDriverProfile();
      update();
      getInchargeOrderLoadStatus(context, loginModel.driver!.id ?? "", model.sId ?? "");

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


  getDriverProfile(){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getProfile+"${model.driverId!=null?model.driverId!.isNotEmpty?model.driverId!.first:"":''}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      driverProfileModel=ProfileModel.fromJson(response);
      print(onValue);
      update();
    });
  }


  Future<void> navigateAndDisplaySelection(BuildContext context, int option,int type) async {
    var result;
    Get.back();
    switch (option) {
      case 1:
        List<CameraDescription>? cameras;
        await availableCameras().then((value) {
          cameras = value;
        });
        result =
        await Get.to(ImagePickerConst(cameras: cameras, type: "camera"));

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

      // imageByte =result["imageByte"];
      if(type==0) {
        base64Profile = result["image64"];
        path = result["imagePath"];
      }
      update();
    }
  }



  Future<void> updateProfile(context,String orderId) async {
    final uri = Uri.parse(ConstantString.getUploadDetails+"${orderId}/${loginModel.driver!.id}");
    print(uri);

    var request = http.MultipartRequest("PUT", uri);
    // ✅ Correct headers (removed Content-Type: application/json)
    request.headers.addAll({
      "accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    });
    // Add form fields
    // ✅ Single image upload
    //Need to UnComment and change key Name according to backend : Harsh Mishra
     request.fields['vehicleno'] = vehicleNoController.text;

    final multipartFile3 = await http.MultipartFile.fromPath('uploadproof', path,);
    request.files.add(multipartFile3);

    print('...........................................');
    print(request.fields);
    print('...........................................');

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
            Get.offAll(()=>WMDashboardScreen());
            // PreferenceManager.instance.setString(ConstantString.loginKey_2, responseBody).then((onValue){
            //
            // });
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

  Future<void> getInchargeOrderLoadStatus(
      BuildContext context, String inchargeId, String orderId) async {
    final uri = Uri.parse(
        ConstantString.getRemainingProductCount + "${orderId}/${loginModel.driver!.id}");

    print("GET URI: $uri");

    try {
      EasyLoading.show(status: "Loading...");

      final response = await http.get(
        uri,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${loginModel.driver!.token ?? ""}",
        },
      );

      EasyLoading.dismiss();

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        // ✅ Assign the data to your model
        if (responseJson['data'] != null) {
          loadStatusItems = (responseJson['data'] as List)
              .map((e) => LoadStatusItem.fromJson(e))
              .toList();
        }

        update(); // rebuild UI

        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Success",
          responseJson["message"] ?? "Data fetched successfully",
          onTapFunction: () {
            Get.back();
          },
        );
      } else {
        final responseJson = jsonDecode(response.body);
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          responseJson["message"] ?? "Something went wrong",
          onTapFunction: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Exception",
        "Oops! Something went wrong. Please try again later.",
        onTapFunction: () {
          Get.back();
        },
      );
    }
  }
}