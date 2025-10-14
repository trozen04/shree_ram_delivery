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
import '../../support/PreferenceManager.dart';
import '../../support/camera.dart';
import 'package:http/http.dart' as http;

class  ActiveDeliveryController extends GetxController{

  BuildContext  context;
  ActiveDeliveryController(this.context);



  var latestDeliveryCharge = 0.0.obs; // default

  TextEditingController   collectedAmountTextCon=TextEditingController();
  TextEditingController   noteTextCon=TextEditingController();

  List<String>  taskStatusList=["delivered".toUpperCase(),"cancelled".toUpperCase()];
  List<String>  deliveredToList=[
    "Delivery to the customer",
    "Front door",
    "neighbour",
    "other"
  ];
  List<String>  cancelReasonList=[
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

  String currentStatus="";
  String currentReason="";
  String deliveredTo="";

  FocusNode  statusNode=FocusNode();
  FocusNode  reasonNode=FocusNode();
  FocusNode  deliverNode=FocusNode();
  FocusNode  collAmtFocus=FocusNode();
  FocusNode  noteFocus=FocusNode();



  LoginModel  loginModel=LoginModel();
  ProfileModel  profileModel=ProfileModel();


  String base64Profile="";

  String path="";


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
    currentStatus=taskStatusList[0];
    currentReason=cancelReasonList[0];
    deliveredTo=deliveredToList[0];
    update();
  }

  //cancel

  getUserDetails(){
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      getProfile(context);
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

  getProfile(BuildContext context){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getProfile+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      print(onValue);
      profileModel=ProfileModel.fromJson(response);
      update();
    });
  }



  cancelOrder(BuildContext context,String orderId,String inchargeId){
    Map<String,dynamic> body={
      "orderId":orderId,
      "updatestatus":"cancel",
      "cancelReason":currentReason,
      "inchargeId":inchargeId,
    };
    APIConstant.gethitAPI(context,ConstantString.post ,ConstantString.updateStatus+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    },body: body).then((onValue){
      var response=jsonDecode(onValue);
      print(onValue);
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", response["message"],onTapFunction: (){
        Get.offAll(DashboardScreen());
      });
      update();
    });
  }


  // deliveredOrder(BuildContext context,String orderId,String inchargeId){
  //   Map<String,dynamic> body={
  //     "orderId":orderId,
  //     "updatestatus":"delivered",
  //     "deliveredto":deliveredTo,
  //     "note":noteTextCon.text,
  //     "isAmountCollected":isAmountCollected,
  //     "collectAmount":collectedAmountTextCon.text,
  //   };
  //   APIConstant.gethitAPI(context,ConstantString.post ,ConstantString.updateStatus+"${loginModel.driver!.id}",headers: {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     "Authorization": "Bearer ${loginModel.driver!.token}"
  //   },body: body).then((onValue){
  //     var response=jsonDecode(onValue);
  //     print(onValue);
  //     AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", response["message"],onTapFunction: (){
  //       Get.offAll(DashboardScreen());
  //     });
  //     update();
  //   });
  // }

  Future<bool> checkLocationPermissionAndService() async {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Disabled",
          "Please enable location services to continue");
      await Geolocator.openLocationSettings();
      return false;
    }

    // 2. Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied",
            "Location permission is required to continue");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Permanently Denied",
          "Enable location permission from app settings");
      await openAppSettings();
      return false;
    }

    return true;
  }



  Future<void> deliveredOrder(BuildContext context,String orderId,String inchargeId) async {
    await ConstantFunction.getCurrentLocation(context);

    double lat = ConstantFunction.lat;
    double lng = ConstantFunction.lng ?? 0.0;

    print("📍 Current Location: Latitude: $lat, Longitude: $lng");

    final uri = Uri.parse(ConstantString.updateStatus+"${loginModel.driver!.id}");
    print(uri);

    var request = http.MultipartRequest(ConstantString.post, uri);
    // ✅ Correct headers (removed Content-Type: application/json)
    request.headers.addAll({
      "accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
    });
    // Add form fields
    // ✅ Single image upload
    request.fields['orderId'] = orderId;
    request.fields['updatestatus'] = "delivered";
    request.fields['deliveredto'] = deliveredTo;
    request.fields['note'] = noteTextCon.text;
    request.fields['isAmountCollected'] = isAmountCollected.toString();
    if (isAmountCollected) {
      request.fields['collectAmount'] = collectedAmountTextCon.text;
    }
    final multipartFile3 = await http.MultipartFile.fromPath('deliveredImage', path,);
    request.files.add(multipartFile3);

    print(request.fields);
    print(request.files.map((f) => f.filename.toString()));

    try {
      EasyLoading.show(status: "Uploading...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      // developer.log('res: $responseBody');
      // developer.log(response.statusCode as String);

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ertyuiop[");
        update();
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success",
          responseJson["message"], onTapFunction: () {
            base64Profile="";
            path="";
            Get.offAll(()=>DashboardScreen());
            // PreferenceManager.instance.setString(ConstantString.loginKey_2, responseBody).then((onValue){
            // });
          },
        );
      } else if (response.statusCode == 400) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context, "Error", 'Please enter collected amount details.', onTapFunction: () {
          Get.back();
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
      print('error: $e');
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception",'Oops! Something went wrong. Please try again later.',
        onTapFunction: () {
          Get.back();
        },
      );
    }
  }
}