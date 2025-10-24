import 'dart:convert';
import 'dart:developer' as developer;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardScreen.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';
import '../../constant/APIConstant.dart';
import '../../constant/ConstantFunction.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../model/ProfileModel.dart';
import '../../support/EasyLoadingConfig.dart';
import '../../support/PreferenceManager.dart';
import '../../support/camera.dart';
import 'package:http/http.dart' as http;

class ActiveDeliveryController extends GetxController {
  BuildContext context;
  ActiveDeliveryController(this.context);

  var latestDeliveryCharge = 0.0.obs; // default
  var totalGrandTotal = 0.0.obs; // default

  TextEditingController collectedAmountTextCon = TextEditingController();
  TextEditingController noteTextCon = TextEditingController();

  List<String> taskStatusList = ["DELIVERED", "CANCELLED"];
  List<String> deliveredToList = [
    "Delivery to the customer",
    "Front door",
    "neighbour",
    "other"
  ];
  List<String> cancelReasonList = [
    "Customer not available",
    "Incorrect address",
    "Customer refused to accept",
    "payment issue",
    "Product damage",
    "Out of stock",
    "Order canceled by customer",
    "Traffic/Route Issue",
    "Weather Conditions",
    "Vehicle breakdown",
    "Delivery Time Missed"
  ];
  bool isAmountCollected = false;

  void toggleAmountCollected(bool value) {
    isAmountCollected = value;
    update();
  }

  String currentStatus = "";
  String currentReason = "";
  String deliveredTo = "";

  FocusNode statusNode = FocusNode();
  FocusNode reasonNode = FocusNode();
  FocusNode deliverNode = FocusNode();
  FocusNode collAmtFocus = FocusNode();
  FocusNode noteFocus = FocusNode();

  LoginModel loginModel = LoginModel();
  ProfileModel profileModel = ProfileModel();

  String base64Profile = "";
  String path = "";

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
    currentStatus = taskStatusList[0];
    currentReason = cancelReasonList[0];
    deliveredTo = deliveredToList[0];
    update();
  }

  getUserDetails() {
    PreferenceManager.instance.getUserDetails().then((onValue) {
      loginModel = onValue;
      getProfile(context);
      update();
    });
  }

  Future<void> navigateAndDisplaySelection(BuildContext context, int option, int type) async {
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
      if (type == 0) {
        base64Profile = result["image64"];
        path = result["imagePath"];
      }
      update();
    }
  }

  getProfile(BuildContext context) {
    APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getProfile + "${loginModel.driver!.id}", headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue) {
      var response = jsonDecode(onValue);
      developer.log('Profile API Response: Status: 200, Body: $onValue');
      print(onValue);
      profileModel = ProfileModel.fromJson(response);
      update();
    });
  }

  cancelOrder(BuildContext context, String orderId, String inchargeId, String taskId, String productId) {
    EasyLoadingConfig.show();
    Map<String, dynamic> body = {
      "orderId": orderId,
      "updatestatus": "cancel",
      "cancelReason": currentReason,
      "inchargeId": inchargeId,
      "productId": productId,
    };
    APIConstant.gethitAPI(context, ConstantString.post,
        "https://shreeram.volvrit.org/api/driver/updatetaskstatus/${loginModel.driver!.id}/$taskId",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver!.token}"
        }, body: body).then((onValue) {
      EasyLoadingConfig.dismiss();
      var response = jsonDecode(onValue);
      developer.log('Cancel Order API Response: Status: 200, Body: $onValue');
      print(onValue);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", response["message"], onTapFunction: () {
        Get.offAll(DashboardScreen());
      });
      update();
    }).catchError((error) {
      EasyLoadingConfig.dismiss();

      developer.log('Cancel Order API Error: $error');
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Error", "Failed to cancel order: $error", onTapFunction: () {
        Get.back();
      });
    });
  }

  Future<void> deliveredOrder(BuildContext context, String orderId, String inchargeId, String taskId, String productId) async {
    EasyLoadingConfig.show();
    await ConstantFunction.getCurrentLocation(context);

    double lat = ConstantFunction.lat;
    double lng = ConstantFunction.lng ?? 0.0;

    print("📍 Current Location: Latitude: $lat, Longitude: $lng");

    final uri = Uri.parse("https://shreeram.volvrit.org/api/driver/updatetaskstatus/${loginModel.driver!.id}/$taskId");
    print(uri);

    var request = http.MultipartRequest(ConstantString.post, uri);
    request.headers.addAll({
      "accept": "application/json",
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    });

    // Add form fields
    request.fields['orderId'] = orderId;
    request.fields['updatestatus'] = "delivered";
    request.fields['deliveredto'] = deliveredTo;
    request.fields['note'] = noteTextCon.text;
    request.fields['isAmountCollected'] = isAmountCollected.toString();
    request.fields['inchargeId'] = inchargeId;
    request.fields['productId'] = productId;

    if (isAmountCollected) {
      request.fields['collectAmount'] = collectedAmountTextCon.text;
    }

    final multipartFile = await http.MultipartFile.fromPath('deliveredImage', path);
    request.files.add(multipartFile);

    print(request.fields);
    print(request.files.map((f) => f.filename.toString()));

    try {
      // EasyLoading.show(status: "Uploading...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      developer.log('Delivered Order API Response: Status: ${response.statusCode}, Body: $responseBody');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: Task status updated");
        update();
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success",
          responseJson["message"], onTapFunction: () {
            base64Profile = "";
            path = "";
            Get.offAll(() => DashboardScreen());
          },
        );
      } else if (response.statusCode == 400) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
            context, "Error", 'Please enter collected amount details.', onTapFunction: () {
          Get.back();
        });
      } else if (response.statusCode < 500) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
            context, "Error", responseJson["message"], onTapFunction: () {
          Get.back();
        });
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
            context, "Status Code: ${response.statusCode}", responseJson["message"], onTapFunction: () {
          Get.back();
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      developer.log('Delivered Order API Error: $e');
      print('error: $e');
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception", 'Oops! Something went wrong. Please try again later.',
          onTapFunction: () {
            Get.back();
          });
    }
  }

  Future<bool> checkLocationPermissionAndService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Disabled", "Please enable location services to continue");
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permission is required to continue");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Permanently Denied", "Enable location permission from app settings");
      await openAppSettings();
      return false;
    }

    return true;
  }
}