




import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/model/ProfileModel.dart';
import 'package:shree_ram_delivery_app/model/TaskModel.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import 'package:geolocator/geolocator.dart';

class DashboardController  extends GetxController{


  BuildContext  context;
  DashboardController(this.context);

  int selectedIndex=0;




  List<TaskModel>    dailyOrderList=[];
  int totalOrder=0;
  TodayTaskSummaryModel  taskSummary=TodayTaskSummaryModel();
  HomeSummaryModel  homeSummaryModel=HomeSummaryModel();

  double  totalCollected=0.0;

  LoginModel  loginModel=LoginModel();
  ProfileModel  profileModel=ProfileModel();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }

  getUserDetails(){
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      getProfile(context);
      getOrderSummary(context);
      update();
    });
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
      getTodaysOrder(context);
      getTotalCoD(context);
      update();
    });
  }

  getTotalCoD(BuildContext context){
    // Need To Be Updated For daily COD : Harsh  Mishra
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getCollectedAmount+"/${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
       totalCollected=(response["totalCollected"]??0)+0.0;
      update();
    });
  }

  getOrderSummary(BuildContext context){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getdrivertask+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      developer.log('totalorders: $response');
      homeSummaryModel=HomeSummaryModel.fromJson(response);
      update();
    });
  }


  updateStatus(BuildContext context, String id, TaskModel taskModel) async {
    EasyLoading.show(status: "Submitting...");
    bool serviceEnabled;
    LocationPermission permission;
    Position position;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Error",
        "Location services are disabled. Please enable location.",
        onTapFunction: () => Get.back(),
      );
      return;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      EasyLoading.dismiss();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Ask again if denied
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Permission Required",
          "Location permission is needed. Please allow access.",
          onTapFunction: () {
            Get.back();
            updateStatus(context, id, taskModel); // retry
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions denied forever, open app settings
      EasyLoading.dismiss();
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Permission Required",
        "Location permissions are permanently denied. Please enable from settings.",
        onTapFunction: () {
          Get.back();
          Geolocator.openAppSettings();
        },
      );
      return;
    }

    // Permission granted, get location
    try {
      EasyLoading.show(status: "Submitting...");
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(
          "Current Location -> Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      EasyLoading.dismiss();
      print("Error getting location: $e");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Error",
        "Could not get current location.",
        onTapFunction: () => Get.back(),
      );
      return;
    }

    // Call API with pickup coordinates
    EasyLoading.show(status: "Submitting...");
    APIConstant.gethitAPI(
      context,
      ConstantString.post,
      "${ConstantString.startDelivery}${loginModel.driver!.id}/${taskModel.sId}",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${loginModel.driver!.token}"
      },
      body: {
        "orderId": id.toString(),
        "start": true,
        "pickup": {
          "lat": position.latitude,
          "lng": position.longitude,
        },
      },
    ).then((onValue) {
      EasyLoading.dismiss();
      var response = jsonDecode(onValue);
      print(onValue);
      developer.log('res: $response');
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Success",
        response["message"],
        onTapFunction: () {
          Get.back();
          getTodaysOrder(context);
        },
      );
      update();
    });
  }

  getTodaysOrder(BuildContext context){
    APIConstant.gethitAPI(context,ConstantString.get ,"${ConstantString.getTask}${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      developer.log('response of driver task: ${response}');

      totalOrder=response["totalTasks"]??0;
      taskSummary=TodayTaskSummaryModel.fromJson(response["todayTaskCounts"]);
      if(response["tasks"]!=null){
        print(">>>>>>>>>>>>>>>>>");
        dailyOrderList.clear();
        response["tasks"].forEach((value){
          TaskModel   model=TaskModel.fromJson(value);
          dailyOrderList.add(model);
        });
      }
      update();
    });
  }



}

class TodayTaskSummaryModel {
  int? delivered;
  int? pending;
  int? cancel;
  int? dispatch;

  TodayTaskSummaryModel(
      {this.delivered, this.pending, this.cancel, this.dispatch});

  TodayTaskSummaryModel.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered']??0;
    pending = json['pending']??0;
    cancel = json['cancel']??0;
    dispatch = json['dispatch']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered'] = this.delivered;
    data['pending'] = this.pending;
    data['cancel'] = this.cancel;
    data['dispatch'] = this.dispatch;
    return data;
  }
}


class HomeSummaryModel {
  String? message;
  String? driverId;
  int? totalOrders;
  TaskCounts? taskCounts;

  HomeSummaryModel(
      {this.message, this.driverId, this.totalOrders, this.taskCounts});

  HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    driverId = json['driverId'];
    totalOrders = json['count']??0;
    taskCounts = json['statusSummary'] != null
        ? new TaskCounts.fromJson(json['statusSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['driverId'] = this.driverId;
    data['totalOrders'] = this.totalOrders;
    if (this.taskCounts != null) {
      data['taskCounts'] = this.taskCounts!.toJson();
    }
    return data;
  }
}

class TaskCounts {
  int? delivered;
  int? pending;
  int? cancel;

  TaskCounts({this.delivered, this.pending, this.cancel});

  TaskCounts.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered']??0;
    pending = json['pending']??0;
    cancel = json['cancel']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered'] = this.delivered;
    data['pending'] = this.pending;
    data['cancel'] = this.cancel;
    return data;
  }
}

