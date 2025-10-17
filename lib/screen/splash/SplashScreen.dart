import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/model/ProfileModel.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardScreen.dart';
import 'package:shree_ram_delivery_app/screen/intro/IntroScreen.dart';
import 'package:shree_ram_delivery_app/screen/select_city/SelectCityScreen.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleScreen.dart';
import 'package:shree_ram_delivery_app/screen/upload_doc/UploadDocumentScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboardScreen.dart';
import 'package:shree_ram_delivery_app/support/PreferenceManager.dart';

import '../login/LoginScreen.dart';
import '../../constant/ConstantImage.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {

      PreferenceManager.instance.getUserDetails().then((onValue){
        if(onValue.driver!=null){
          if(onValue.driver!.role=="Driver"){
            PreferenceManager.instance.getTechnicianDetails().then((onValue){
              if(onValue.employee!=null){
              if(onValue.employee!.vehicle==null){
                Get.offAll(SelectVechicleScreen(),
                  transition: Transition.leftToRight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                );
              } else if(onValue.employee!.city==null){
                Get.offAll(SelectCityScreen(),
                  transition: Transition.leftToRight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                );
              } else if(onValue.employee!.uploadadhar==null|| onValue.employee!.uploadpan==null||
              onValue.employee!.uploadrc==null|| onValue.employee!.uploadphoto==null){
                Get.offAll(UploadDocumentScreen(),
                  transition: Transition.leftToRight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                );
              }else{
                Get.offAll(DashboardScreen(),
                  transition: Transition.leftToRight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                );
              }
              }else{
                Get.offAll(LoginScreen(),
                  transition: Transition.leftToRight,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                );
              }
            });

          }else{
            Get.offAll(WMDashboardScreen(),
              transition: Transition.leftToRight,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 400),
            );
          }
        }else{
          Get.off(() => const IntroScreen(),
            transition: Transition.leftToRight,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 400),
          );
        }
      });

    });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ConstantImage.splashImage, width: MediaQuery.of(context).size.width * 0.8),
            // SizedBox(height: 15,),
            Text('A venture of BL FOODS & OILS PVT LTD', style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }
}
