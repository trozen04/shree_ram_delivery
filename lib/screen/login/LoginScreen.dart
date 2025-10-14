




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/constant/CustomWidget.dart';
import 'package:shree_ram_delivery_app/screen/select_vechicle/SelectVechicleScreen.dart';
import 'package:shree_ram_delivery_app/support/app_theme.dart';

import 'LoginController.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height=CustomWidget.getHeight(context);
    double width=CustomWidget.getWidth(context);

    return GetBuilder(
        init: Get.put(LoginController(context)),
        builder: (controller){
      return SafeArea(child: Scaffold(
           backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: [

                Container(
                  height: height,
                  width: width,
                  alignment: Alignment.topCenter,
                  color: AppColor.primary,
                  child: Container(
                    height: height*0.3,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Go ahead and Set up your account",style:  TextStyle(color:Colors.white,fontSize: 21,fontWeight: FontWeight.w500),),
                        Text("Login in for best experience",style:  TextStyle(color: Colors.grey.shade400),)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height*0.7,
                  width: width,
                  margin: EdgeInsets.only(top: height*0.3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12))
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text("Login Your Account",style:  TextStyle(color:Colors.black,fontSize: 23,fontWeight: FontWeight.w500),),
                      const SizedBox(height: 10,),
                      Text("Enter your details",style: TextStyle(color: Colors.grey,fontSize: 16),),
                      CustomWidget.textInputFiled(
                          controller.emailTextCon,
                          focusNode: controller.emailFocus,
                          textAlign: TextAlign.left,
                          rightPadding: 20,
                          leftPadding: 20,
                          bottomPadding: 15,
                          textInputType: TextInputType.emailAddress,
                          labelTextNew: "Email",
                          prefixIconWidget: Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child:Image.asset("assets/person.png") ,
                          )
                      ),
                      CustomWidget.textInputFiled(
                          controller.passwordTextCon,
                          focusNode: controller.passwordFocus,
                          textAlign: TextAlign.left,
                          rightPadding: 20,
                          topPadding: 10,
                          leftPadding: 20,
                          bottomPadding: 15,
                          passwordHide: controller.passwordHide,
                          textInputType: TextInputType.emailAddress,
                          labelTextNew: "Password",
                          maxLine: 1,
                          suffixIconWidget: IconButton(
                            icon: Icon(controller.passwordHide ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              controller.passwordHide = !controller.passwordHide;
                              controller.update();
                            },
                          ),
                          prefixIconWidget: Container(
                            width: 50,
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child:Image.asset("assets/password.png") ,
                          )
                      ),
                      SizedBox(height: 30,),
                      CustomWidget.elevatedCustomButton(context, "Login", (){
                        if(controller.validation(context)){
                          controller.postlogin();
                        }
                      },borderRadius: 30,width: Get.width-40),

                    ],
                  ),
                )
              ],
            ),
          ),
      ));
    });
  }
}
