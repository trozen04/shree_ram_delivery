



import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/DailyAssignedOrderModel.dart';
import '../../model/InChargeProfileModel.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';

class StatusWiseOrderController extends  GetxController{
  BuildContext context;
  String status;
  StatusWiseOrderController(this.context,this.status);


  List<DailyAssignedOrderModel>  historyList=[];

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
     // getHistory(context, Intl().date("yyyy-MM-dd").format(DateTime.now()));
      getHistory(context); // don’t send date by default
      update();
    });
  }



  // need to be  update  according to status : Harsh Mishra
  // getHistory(BuildContext context,String date){
  //   APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getDateWiseHistory+"${loginModel.driver!.id}"+"?date=$date",
  //       headers: {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     "Authorization": "Bearer ${loginModel.driver!.token}"
  //   }).then((onValue){
  //     var response=jsonDecode(onValue);
  //     if(response["orders"]!=null){
  //       historyList.clear();
  //       response["orders"].forEach((value){
  //         DailyAssignedOrderModel  model=DailyAssignedOrderModel.fromJson(value);
  //         historyList.add(model);
  //       });
  //     }
  //     update();
  //   });
  // }

  // Future<void> getHistory(BuildContext context, String date) async {
  //   try {
  //     // Clear old data first so UI can update immediately
  //     historyList.clear();
  //     update(); // triggers UI rebuild with empty list
  //
  //     // Build API URL
  //     // String url = ConstantString.gettodayordersummary + "${loginModel.driver!.id}?status=$status?date=$date";
  //     String url = ConstantString.getDateWiseHistory + "${loginModel.driver!.id}?date=$date&status=$status";
  //     print('url: $url');
  //
  //     // Make API call and wait for response
  //     final onValue = await APIConstant.gethitAPI(
  //       context,
  //       ConstantString.get,
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         "Authorization": "Bearer ${loginModel.driver!.token}"
  //       },
  //     );
  //
  //     // Decode JSON
  //     var response = jsonDecode(onValue);
  //     developer.log('get hit: ${response}');
  //
  //     // Log full response safely (works for large JSON)
  //     const int chunkSize = 800;
  //     String jsonString = jsonEncode(response);
  //     for (var i = 0; i < jsonString.length; i += chunkSize) {
  //       developer.log(jsonString.substring(i, i + chunkSize > jsonString.length ? jsonString.length : i + chunkSize));
  //     }
  //
  //     // Populate history list
  //     historyList.clear(); // clear again just in case
  //     var orders = response["orders"] ?? response["todayOrders"] ?? response["filteredOrders"] ?? [];
  //     for (var value in orders) {
  //       historyList.add(DailyAssignedOrderModel.fromJson(value));
  //     }
  //     update();
  //
  //   } catch (error) {
  //     print("Error fetching history: $error");
  //     update(); // update UI even on error
  //   }
  // }


  Future<void> getHistory(
      BuildContext context, {
        String? startDate,
        String? endDate,
      }) async {
    try {
      historyList.clear();
      update(); // immediately show empty/loading state

      // Default to today if not provided
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      startDate ??= today;
      endDate ??= today;

      String baseUrl = ConstantString.inchargeordersummary + "${loginModel.driver!.id}";
      List<String> params = [];

      params.add("startDate=$startDate");
      params.add("endDate=$endDate");

      if (status.isNotEmpty && status.toLowerCase() != 'total') {
        params.add("status=$status");
      }

      String url = "$baseUrl?${params.join('&')}";

      print('📦 Final URL: $url');

      final onValue = await APIConstant.gethitAPI(
        context,
        ConstantString.get,
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver!.token}"
        },
      );

      var response = jsonDecode(onValue);
      developer.log('📜 Response: ${response.toString()}');

      historyList.clear();
      if (response["statusWiseData"] != null && response["statusWiseData"].isNotEmpty) {
        for (var statusData in response["statusWiseData"]) {
          var orders = statusData["orders"] ?? [];
          for (var value in orders) {
            historyList.add(DailyAssignedOrderModel.fromJson(value));
          }
        }
      }
      update();
    } catch (error) {
      print("❌ Error fetching history: $error");
      update();
    }
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