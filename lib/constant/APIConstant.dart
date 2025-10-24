
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../support/EasyLoadingConfig.dart';
import '../support/PreferenceManager.dart';
import '../support/alert_dialog_manager.dart';
import 'ConstantString.dart';


class  APIConstant{
  static Future<dynamic> gethitAPI(context,String method,String url,{bool sendInFeilds=false,var body=const {},Map<String, String> headers=const { 'Accept': 'application/json',
    'Content-Type': 'application/json'},bool showProgress=true})async{
    if(showProgress) {
      EasyLoadingConfig.show();
    }
    var responsebody=null;
    try {
      Uri baseUrl = Uri.parse(url);
      var request;
      var response;
      // Set body only for methods that allow it
      if (body != null && (method == "POST" || method == "PUT" || method == "PATCH"||method=="GET")) {
        // request.body = jsonEncode(body);
        if(sendInFeilds) {
          request = await http.MultipartRequest(method, baseUrl);

          // Set headers correctly
          request.headers.addAll(headers);
          request.fields.addAll(body);
          var streamedResponse = await http.Client().send(request);

          // Convert streamed response to standard response
          response = await http.Response.fromStream(streamedResponse);

        }else {
          print(method);
          print(baseUrl);

          request = http.Request(method, baseUrl);

          // Set body
          request.body = jsonEncode(body ?? {});

          // Set headers correctly
          request.headers.addAll(headers);

          print("Request Headers: ${request.headers}");
          print("Request Body: ${request.body}");

          // Send request
          var streamedResponse = await http.Client().send(request);
          print(">>>>>>>>>>>>>>>>>>>>>>");

          // Convert streamed response to standard response
          response = await http.Response.fromStream(streamedResponse);
          //print(response);
        }
      }
      print(url);

      // Send the request

      // Handle response

      EasyLoadingConfig.dismiss();
      if(response!=null){
        if (response.statusCode == 200 || response.statusCode == 201 ) {
          //developer.log('Response: ${response.body}');
          responsebody=response.body;
          var new_responce=jsonDecode(responsebody);
          // if(new_responce["status"]!="error") {
            return responsebody;
          // }else{
          //   if(!url.contains(ConstantString.fetch_employees)) {
          //     var responce = jsonDecode(response.body);
          //     AlertDialogManager().sendMessageAlert(
          //         context, 'Error', responce["message"]);
          //   }
          // }
        } else if(response.statusCode<500) {
          print('Error: ${response.statusCode} - ${response.reasonPhrase}');
          responsebody=null;
          var responce=jsonDecode(response.body);
          if(responce["message"].toString().toLowerCase().contains("invalid token")){
            AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, 'Error', responce["message"]??responce["error"],onTapFunction: (){
              PreferenceManager.instance.logout();
            });
          }else{
            AlertDialogManager().sendMessageAlert(context, 'Error', responce["message"]??responce["error"]);
          }
        }else{
          print('Error: ${response.statusCode} - ${response.reasonPhrase}');
          responsebody=null;
          var responce=jsonDecode(response.body);

          AlertDialogManager().sendMessageAlert(
              context, 'Error', responce["message"]);
        }
      }
    } catch (e) {
      EasyLoadingConfig.dismiss();
      // AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception",'Oops! Something went wrong. Please try again later.',onTapFunction: (){
      //   Get.back();
      // });
    }
    if(responsebody!=null) {
      return Future.value(responsebody);
    }else{
      return Future.error(responsebody??"");
    }
  }
}
