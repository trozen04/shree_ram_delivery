import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class EasyLoadingConfig {
  /// Initialize EasyLoading with custom styles
  static void init() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..indicatorColor = AppColor.secondary
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.5)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..progressColor = Colors.blueAccent
      ..boxShadow=[
        BoxShadow(color: Colors.grey.shade300,blurStyle: BlurStyle.outer,blurRadius: 4,spreadRadius: 3)
      ]
      ..textStyle=TextStyle(color: AppColor.secondary)
      ..dismissOnTap = false
      ..animationStyle = EasyLoadingAnimationStyle.opacity;
  }

  /// Show loading indicator with optional message
  static void show({String message = "Loading..."}) {
    EasyLoading.show(status: message);
  }

  /// Show progress indicator
  static void showProgress(double value) {
    EasyLoading.showProgress(value, status: '${(value * 100).toStringAsFixed(0)}%');
  }

  /// Show success message
  static void showSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  /// Show error message
  static void showError(String message) {
    EasyLoading.showError(message);
  }

  /// Show info message
  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  /// Dismiss loading indicator
  static void dismiss() {
    EasyLoading.dismiss();
  }
}
