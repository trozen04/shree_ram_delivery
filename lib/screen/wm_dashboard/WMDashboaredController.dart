

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/model/InChargeProfileModel.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';

class  WMDashboaredController  extends GetxController{

  BuildContext context;
  WMDashboaredController(this.context);
  int selectedIndex=0;





  List<DailyAssignedOrderModel>  dailyAssignedList=[];
  List<DailyAssignedOrderModel>  historyList=[];

  num totalOrder=0;
  num totalPending=0;
  num totalPartiallyDispatch=0;
  num totalCancelled=0;
  num totalCompleted=0;
  List<dynamic> statusWiseData = [];

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
      getTodaytask(context);
      getDashboredData();
      getProfile();
      getHistory(context, Intl().date("yyyy-MM-dd").format(DateTime.now()));
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




  // getDashboredData(){
  //   APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getDateWiseHistory+"${loginModel.driver!.id}",headers: {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     "Authorization": "Bearer ${loginModel.driver!.token}"
  //   }).then((onValue){
  //     var response=jsonDecode(onValue);
  //     if(response!=null) {
  //       totalOrder=0;
  //       totalPending=0;
  //       totalPartiallyDispatch=0;
  //       totalCancelled=0;
  //       totalCompleted=0;
  //       totalOrder=response["totalOrders"]??0;
  //       if(response["statusWiseCount"]!=null){
  //         response["statusWiseCount"].forEach((value){
  //           if(value["_id"]=="pending"){
  //             totalPending=value["count"]??0;
  //           }else if(value["_id"]=="Complete"){
  //             totalCompleted=value["count"]??0;
  //           }else{
  //             totalPartiallyDispatch=value["count"]??0;
  //           }
  //         });
  //
  //       }
  //     }
  //     print(onValue);
  //     update();
  //   });
  // }

  getDashboredData() {
    APIConstant.gethitAPI(
      context,
      ConstantString.get,
      "${ConstantString.gettodayordersummary}${loginModel.driver!.id}",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${loginModel.driver!.token}"
      },
    ).then((onValue) {
      var response = jsonDecode(onValue);
      developer.log('Dashboard response: $response');

      // Reset counters
      totalOrder = response["totalOrders"] ?? 0;
      totalPending = 0;
      totalPartiallyDispatch = 0;
      totalCancelled = 0;
      totalCompleted = 0;
      statusWiseData = response["filteredOrders"] ?? [];

      // Parse the statusWiseCount correctly
      if (response["statusWiseCount"] != null && response["statusWiseCount"] is List) {
        for (var statusGroup in response["statusWiseCount"]) {
          final status = (statusGroup["_id"] ?? "").toString().toLowerCase();
          final count = statusGroup["count"] ?? 0;

          switch (status) {
            case "pending":
              totalPending += count;
              break;

            case "partiallydispatch":
            case "dispatch":
            case "ofd":
              totalPartiallyDispatch += count;
              break;

            case "cancelled":
            case "canceled":
              totalCancelled += count;
              break;

            case "complete":
            case "completed":
            case "delivered":
              totalCompleted += count;
              break;

            default:
              totalPending += count;
          }
        }
      }

      print("Total Orders: $totalOrder");
      print("Pending: $totalPending");
      print("Completed: $totalCompleted");
      print("Dispatch: $totalPartiallyDispatch");
      print("Cancelled: $totalCancelled");

      update();
    });
  }






  getTodaytask(BuildContext context){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getTodayInchargeTask+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      if(response["orders"]!=null){
        dailyAssignedList.clear();
        response["orders"].forEach((value){
          DailyAssignedOrderModel  model=DailyAssignedOrderModel.fromJson(value);
          dailyAssignedList.add(model);
        });
      }
      update();
    });
  }




  getHistory(BuildContext context,String date){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getDateWiseHistory+"${loginModel.driver!.id}"+"?date=$date",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      if(response["orders"]!=null){
        historyList.clear();
        response["orders"].forEach((value){
          DailyAssignedOrderModel  model=DailyAssignedOrderModel.fromJson(value);
          historyList.add(model);
        });
      }
      update();
    });
  }



}