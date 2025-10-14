

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/screen/intro/IntroController.dart';
import 'package:shree_ram_delivery_app/screen/login/LoginScreen.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboardScreen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
        init: Get.put(IntroController()),
        builder: (controller){
      return SafeArea(child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(color: Colors.grey)
              ))
            ),
          ),
          toolbarHeight: 70,
          surfaceTintColor:Colors.transparent,
          backgroundColor: Colors.white,
          title: Text("Start Delivering",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Spacer(),
            Image.asset("assets/intro_bg.png"),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
              child: Text("Join the journey to deliver faster and smarter – every order, every time.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
            ),
            Spacer(),
            CustomWidget.elevatedCustomButton(context, "Continue", (){
              Get.to(() => const LoginScreen(),
                    transition: Transition.leftToRight,
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 400),
                  );
              // Get.to(() => const WMDashboardScreen(),
              //   transition: Transition.leftToRight,
              //   curve: Curves.ease,
              //   duration: const Duration(milliseconds: 400),
              // );
              },borderRadius: 30,width: Get.width-40),
            SizedBox(height: 20,)
          ],
        ),
      ));
    });
  }
}
