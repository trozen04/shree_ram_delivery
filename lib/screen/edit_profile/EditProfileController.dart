



import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../model/ProfileModel.dart';
import '../../support/PreferenceManager.dart';
import '../../support/alert_dialog_manager.dart';
import '../../support/camera.dart';

import 'package:http/http.dart'  as http;


class EditProfileController extends GetxController{




    BuildContext   context;
    EditProfileController(this.context);
    TextEditingController    nameTextCon=TextEditingController();
    TextEditingController    mobileTextCon=TextEditingController();
    TextEditingController    emailTextCon=TextEditingController();
    TextEditingController    vechileNoTextCon=TextEditingController();


    FocusNode   nameFocus=FocusNode();
    FocusNode   mobileFocus=FocusNode();
    FocusNode   emailFocus=FocusNode();
    FocusNode   vehicleNoFocus=FocusNode();

    LoginModel loginModel=LoginModel();
    ProfileModel profileModel=ProfileModel();


    String base64Profile="";
    String base64Profile2="";
    String base64Profile3="";

    String path="";
    String path2="";
    String path3="";



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


    getProfile(){
        APIConstant.gethitAPI(context, ConstantString.get, ConstantString.getProfile+"${loginModel.driver!.id}",headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
        }).then((onValue){
            var responce=jsonDecode(onValue);
            profileModel=ProfileModel.fromJson(responce);
            if(profileModel.employee!=null) {
                nameTextCon.text =profileModel.employee!.name??"";
                mobileTextCon.text =profileModel.employee!.phoneno??"";
                emailTextCon.text =profileModel.employee!.email??"";
                vechileNoTextCon.text =profileModel.employee!.vehicle??"";

            }
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
            }else if(type==1){
                base64Profile2 = result["image64"];
                path2 = result["imagePath"];
            }else if(type==2){
                base64Profile3 = result["image64"];
                path3 = result["imagePath"];
            }

            update();
        }
    }


    bool validation(context){


        if(nameTextCon.text.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", " Name can't be Empty", false, context);
            return false;
        }
        else if(mobileTextCon.text.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", "Mobile Number can't be Empty ", false, context);
            return false;
        }
        else if(vechileNoTextCon.text.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", "Vehicle Number can't be Empty ", false, context);
            return false;
        }
        else if(base64Profile.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", "Upload Aadhaar image", false, context);
            return false;
        }
        else if(base64Profile2.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", "Upload PAN image", false, context);
            return false;
        }
        else if(base64Profile3.isEmpty){
            AlertDialogManager.getSnackBarMsg("Message", "Upload RC image", false, context);
            return false;
        }else{
            return true;
        }
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

        request.fields['name'] = nameTextCon.text;
        // request.fields[''] = mobileTextCon.text;
        // request.fields['email'] = emailTextCon.text;
        request.fields['vehicleno'] = vechileNoTextCon.text;

        final multipartFile = await http.MultipartFile.fromPath('uploadadhar', path,);
        final multipartFile1 = await http.MultipartFile.fromPath('uploadpan', path2,);
        final multipartFile2 = await http.MultipartFile.fromPath('uploadrc', path3,);
        request.files.add(multipartFile);
        request.files.add(multipartFile1);
        request.files.add(multipartFile2);
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
                        base64Profile2="";base64Profile3="";
                        path="";path2="";path3="";
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
            print(e);
            AlertDialogManager().isErrorAndSuccessAlertDialogMessage(context, "Exception",'Oops! Something went wrong. Please try again later.',
                onTapFunction: () {
                    Get.back();
                },
            );
        }
    }



}