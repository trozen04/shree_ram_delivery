import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shree_ram_delivery_app/constant/APIConstant.dart';
import 'package:shree_ram_delivery_app/constant/ConstantString.dart';
import 'package:shree_ram_delivery_app/model/DailyAssignedOrderModel.dart';
import 'package:shree_ram_delivery_app/model/InChargeProfileModel.dart';
import 'package:shree_ram_delivery_app/model/LoadStatusItem.dart';
import 'package:shree_ram_delivery_app/model/LoginModel.dart';
import 'package:shree_ram_delivery_app/model/ProfileModel.dart';
import 'package:shree_ram_delivery_app/screen/wm_dashboard/WMDashboardScreen.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';
import 'package:shree_ram_delivery_app/support/camera.dart';
import '../../support/PreferenceManager.dart';
import '../load_item/LoadItemController.dart';

class WHActiveOrderController extends GetxController {
  BuildContext context;
  DailyAssignedOrderModel model;
  WHActiveOrderController(this.context, this.model);

  TextEditingController vehicleNoController = TextEditingController();
  LoginModel loginModel = LoginModel();
  InChargeProfileModel profileModel = InChargeProfileModel();
  ProfileModel driverProfileModel = ProfileModel();
  List<LoadStatusItem> loadStatusItems = [];
  String base64Profile = "";
  String path = "";

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  @override
  void onClose() {
    // Automatically clear related controller when this one is disposed
    try {
      final loadItemController = Get.find<LoadItemController>(tag: model.sId);
      loadItemController.clearLoadedItems();
      Get.delete<LoadItemController>(tag: model.sId, force: true);
    } catch (_) {}
    super.onClose();
  }


  Future<void> getUserDetails() async {
    try {
      loginModel = await PreferenceManager.instance.getUserDetails();
      await Future.wait([
        getProfile(),

        getDriverProfile(),
        getInchargeOrderLoadStatus(context, loginModel.driver?.id ?? "", model.sId ?? ""),
      ]);
      if (model.sId != null && model.sId!.isNotEmpty) {
        await fetchUnits(model.sId!);
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          "Order ID is missing. Please try again.",
          onTapFunction: () => Get.back(),
        );
      }
      update();
    } catch (e) {
      print("Error in getUserDetails: $e");
    }
  }

  Future<void> fetchUnits(String sid) async {
    if (sid.isEmpty) {
      print("Error: sId is empty in fetchUnits");
      return;
    }
    final uri = Uri.parse(ConstantString.getDrivers + sid);
    try {
      EasyLoading.show(status: "Loading units...");
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${loginModel.driver?.token ?? ""}",
        },
      );
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null) {
          for (var item in model.items ?? []) {
            final matchedItem = data['items'].firstWhere(
                  (e) => e['productId'] == item.productId?.sId,
              orElse: () => null,
            );
            item.unit = matchedItem?['units']?.toString() ?? "";
          }
          update();
        }
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          "Failed to load units: ${response.statusCode}",
          onTapFunction: () => Get.back(),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error fetching units: $e");
    }
  }

  Future<void> getProfile() async {
    try {
      final response = await APIConstant.gethitAPI(
        context,
        ConstantString.get,
        ConstantString.getInChargeProfile + "${loginModel.driver!.id}",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver!.token}",
        },
      );
      profileModel = InChargeProfileModel.fromJson(jsonDecode(response));
      update();
    } catch (e) {
      print("Error in getProfile: $e");
    }
  }


  Future<void> getDriverProfile() async {
    print('getDriverProfile called');
    try {
      if (model.driverId == null) {
        print('model.driverId is null');
        return;
      }
      if (model.driverId!.isEmpty) {
        print('model.driverId is empty');
        return;
      }

      var driverData = model.driverId!.first;
      print('driverData raw: $driverData');

      String driverProfileIdString = "";
      if (driverData is DriverId) {
        driverProfileIdString = driverData.id ?? "";
        print('DriverId object: $driverProfileIdString');
      } else if (driverData is Map) {
        driverProfileIdString = driverData['_id']?.toString() ?? "";
        print('DriverId map: $driverProfileIdString');
      } else if (driverData is String) {
        driverProfileIdString = driverData;
        print('DriverId string: $driverProfileIdString');
      } else {
        print('Unexpected driverData type: ${driverData.runtimeType}');
      }

      if (driverProfileIdString.isEmpty) {
        print('driverProfileIdString is empty, skipping API call');
        return;
      }

      final response = await APIConstant.gethitAPI(
        context,
        ConstantString.get,
        ConstantString.getProfile + driverProfileIdString,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${loginModel.driver?.token ?? ""}",
        },
      );

      driverProfileModel = ProfileModel.fromJson(jsonDecode(response));
      print('Driver profile fetched: ${driverProfileModel.employee?.name}');
      update();
    } catch (e) {
      print("Error in getDriverProfile: $e");
    }
  }


  Future<void> navigateAndDisplaySelection(BuildContext context, int option, int type) async {
    var result;
    Get.back();
    switch (option) {
      case 1:
        List<CameraDescription>? cameras = await availableCameras();
        result = await Get.to(ImagePickerConst(cameras: cameras, type: "camera"));
        break;
      case 2:
        List<CameraDescription>? cameras = await availableCameras();
        result = await Get.to(ImagePickerConst(cameras: cameras, type: "gallery"));
        break;
    }
    if (result != null) {
      if (type == 0) {
        base64Profile = result["image64"];
        path = result["imagePath"];
      }
      update();
    }
  }

  Future<void> updateProfile(BuildContext context, String orderId) async {
    LoadItemController? loadItemController;
    try {
      loadItemController = Get.find<LoadItemController>(tag: orderId);
      print("LoadItemController found. Loaded items: ${jsonEncode(loadItemController.loadedItems)} (Count: ${loadItemController.loadedItems.length})");
    } catch (e) {
      print("Error finding LoadItemController: $e");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Error",
        "No items loaded. Please load at least one item.",
        onTapFunction: () => Get.back(),
      );
      return;
    }

    final loadedItems = loadItemController.loadedItems;
    if (loadedItems.isEmpty) {
      print("No loaded items found for order $orderId");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Error",
        "No items loaded. Please load at least one item.",
        onTapFunction: () => Get.back(),
      );
      return;
    }

    // Extract driverId
    String driverIdString = "";
    if (model.driverId != null && model.driverId!.isNotEmpty) {

      var driverData = model.driverId!.first;
      print('getLoadOrder driverData: $driverData');

      if (driverData is Map) {
        driverIdString = driverData['_id']?.toString() ?? "";
      } else {
        driverIdString = driverData.toString();
      }
    }

    final uri = Uri.parse("${ConstantString.getLoadOrder}$orderId/${loginModel.driver!.id}");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll({
      "accept": "application/json",
      "Authorization": "Bearer ${loginModel.driver!.token ?? ""}",
    });
    print('getLoadOrder data: init');

    request.fields['vehicleno'] = vehicleNoController.text;
    request.fields['driverId'] = driverIdString;
    request.fields['products'] = jsonEncode(loadedItems);

    // Debug print request data
    print("=== Sending Load Order Request ===");
    print("URL: $uri");
    print("Fields: ${request.fields}");
    if (path.isNotEmpty) print("File attached: $path");
    print("================================");

    if (path.isNotEmpty) {
      final multipartFile = await http.MultipartFile.fromPath('uploadproof', path);
      request.files.add(multipartFile);
    }

    try {
      EasyLoading.show(status: "Submitting...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Print the response
      print("=== Load Order Response ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");
      print("===========================");

      final responseJson = jsonDecode(responseBody);

      EasyLoading.dismiss();
      if (response.statusCode == 200 || response.statusCode == 201) {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Success",
          responseJson["message"] ?? "Load order submitted successfully",
          onTapFunction: () {
            base64Profile = "";
            path = "";
            loadItemController?.clearLoadedItems();
            Get.delete<LoadItemController>(tag: orderId);
            Get.offAll(() => WMDashboardScreen());
          },
        );
      } else {
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          responseJson["message"] ?? "Failed to submit load order",
          onTapFunction: () => Get.back(),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in loadorder: $e");
      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Exception",
        "Oops! Something went wrong. Please try again later.",
        onTapFunction: () => Get.back(),
      );
    }
  }

  Future<void> getInchargeOrderLoadStatus(BuildContext context, String inchargeId, String orderId) async {
    final uri = Uri.parse(ConstantString.getRemainingProductCount + "$orderId/$inchargeId");
    print('GET');
    print(uri);
    try {

      EasyLoading.show(status: "Loading...");
      final response = await http.get(
        uri,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${loginModel.driver!.token ?? ""}",
        },
      );
      EasyLoading.dismiss();
      print('getInchargeOrderLoadStatus: ${response.body}');
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['data'] != null) {
          loadStatusItems = (responseJson['data'] as List).map((e) => LoadStatusItem.fromJson(e)).toList();
        }
        update();
      } else {
        final responseJson = jsonDecode(response.body);
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Error",
          responseJson["message"] ?? "Failed to fetch load status",
          onTapFunction: () => Get.back(),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in getInchargeOrderLoadStatus: $e");
    }
  }
}