




import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/LoginModel.dart';
import 'package:shree_ram_delivery_app/screen/select_city/SelectCityScreen.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleScreen.dart';
import 'package:shree_ram_delivery_app/screen/upload_doc/UploadDocumentScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboardScreen.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../dashboard/DashboardScreen.dart';

class LoginController extends GetxController{

   BuildContext context;
   LoginController(this.context);

   TextEditingController emailTextCon=TextEditingController();
   TextEditingController passwordTextCon=TextEditingController();
   FocusNode emailFocus=FocusNode();
   FocusNode passwordFocus=FocusNode();

   bool passwordHide=true;



   validation(BuildContext context){
      developer.log('validation');
      if(emailTextCon.text.isEmpty){
         FocusScope.of(context).requestFocus(emailFocus);
         AlertDialogManager.getSnackBarMsg("Message", "Email can't be empty", false, context);
         return false;
      }
      else if(passwordTextCon.text.isEmpty){
         FocusScope.of(context).requestFocus(passwordFocus);
         AlertDialogManager.getSnackBarMsg("Message", "Password can't be empty", false, context);
         return false;
      }
      else{
         developer.log('true');

         return true;
      }

   }
  //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4YWZlOWY5MTM5NjhhNzkxOGNiNmVkMCIsImVtYWlsIjoiYWRtaW5zaHJlZXJhbUBleGFtcGxlLmNvbSIsInJvbGUiOiJBZG1pbiIsImlhdCI6MTc1ODQzNjk2NSwiZXhwIjoxNzU5MDQxNzY1fQ.QnKRvaRwlExCRxcFJ6usN97jCatAxJLPJdWTaaGzKqA

   postlogin() async {
      developer.log('postlogin');

      String fcmToken = await PreferenceManager.instance.getString("fcm_token");
      developer.log('fcmToken: $fcmToken');

      Map<String,String> body={
         "email":emailTextCon.text,
         "password":passwordTextCon.text,
      };
      if (fcmToken.isNotEmpty) {
         body["fcmToken"] = fcmToken;
      }
      developer.log('body: $body');
      APIConstant.gethitAPI(context,ConstantString.post ,ConstantString.login,body: body,headers: {
         'Accept': 'application/json',
         'Content-Type': 'application/json',
      }).then((onValue){
         var response=jsonDecode(onValue);
         developer.log(onValue);
         AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", response["message"],onTapFunction: (){
            PreferenceManager.instance.setString(ConstantString.loginKey, onValue).then((onValue){
               if(response["driver"]["role"]=="Driver") {
                  // if(!response["driver"].keys.toList().contains("vehicle")) {
                  //    developer.log(">>>>>>>>>>>>>>>${response["driver"].keys.toList().contains("vehicle")}");
                  //    Get.offAll(() => SelectVechicleScreen());
                  // }else if(response["driver"].keys.toList().contains("vehicle") && (!response["driver"].keys.toList().contains("city"))){
                  //    developer.log(">>>>>>>>>>>>>>>${response["driver"].keys.toList().contains("vehicle")}");
                  //    developer.log(">>>>>>>>>>>>>>>${response["driver"].keys.toList().contains("city")}");
                  //    Get.offAll(()=>SelectCityScreen());
                  // }else if((!response["driver"].keys.toList().contains("city"))||(!response["driver"].keys.toList().contains("city"))
                  //     ||(!response["driver"].keys.toList().contains("city")) ||(!response["driver"].keys.toList().contains("city"))){
                  //    Get.offAll(()=>UploadDocumentScreen());
                  // }else{
                  //    Get.offAll(DashboardScreen());
                  // }

                  getProfile(context,response["driver"]["id"]??"",response["driver"]["token"]);
                  Get.back();
               }else{
                  Get.to(() => WMDashboardScreen());
               }
            });
         });
      });
   }



   getProfile(BuildContext context,String id,String token){
      APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getProfile+"$id",headers: {
         'Accept': 'application/json',
         'Content-Type': 'application/json',
         "Authorization": "Bearer ${token}"
      }).then((onValue){
         var response=jsonDecode(onValue);
         developer.log(onValue);
         AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Success", response["message"],onTapFunction: (){
            PreferenceManager.instance.setString(ConstantString.loginKey_2, onValue).then((onValue){
               if(response["employee"]["role"]=="Driver") {
                  Map<String,dynamic>  data=response["employee"];
                  developer.log(jsonEncode(data)+"??????????????");
                  if(!data.keys.toList().contains("vehicle")) {
                     developer.log(">>>>>>>>>>>>>>>${response["employee"].keys.toList().contains("vehicle")}");
                     Get.offAll(() => SelectVechicleScreen());
                  }else if(data.keys.toList().contains("vehicle") && (!data.keys.toList().contains("city"))){
                     developer.log(">>>>>>>>>>>>>>>${data.keys.toList().contains("vehicle")}");
                     developer.log(">>>>>>>>>>>>>>>${data.keys.toList().contains("city")}");
                     Get.offAll(()=>SelectCityScreen());
                  }else if((!data.keys.toList().contains("uploadadhar"))||(!data.keys.toList().contains("uploadpan"))
                      ||(!data.keys.toList().contains("uploadrc")) ||(!data.keys.toList().contains("uploadphoto"))){
                     Get.offAll(()=>UploadDocumentScreen());
                  }else{
                     Get.offAll(DashboardScreen());
                  }
               }else{
                  Get.to(() => WMDashboardScreen());
               }
            });
         });
      });
   }



}