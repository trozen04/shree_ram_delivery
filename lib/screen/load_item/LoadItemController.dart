import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shree_ram_delivery_app/support/alert_dialog_manager.dart';
import '../../constant/APIConstant.dart';
import '../../constant/ConstantString.dart';
import '../../model/DailyAssignedOrderModel.dart';
import '../../model/InChargeProfileModel.dart';
import '../../model/LoginModel.dart';
import '../../support/PreferenceManager.dart';

class LoadItemController extends GetxController {
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController quantityLoadedController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController balanceLeftController = TextEditingController();
  TextEditingController stockLeftController = TextEditingController();

  BuildContext context;
  String id; // productId
  DailyAssignedOrderModel model;
  String? loadedUnit;
  LoginModel loginModel = LoginModel();
  InChargeProfileModel profileModel = InChargeProfileModel();
  int stockQuantity = 0;
  final storage = GetStorage();

  var loadedItems = <Map<String, dynamic>>[].obs;
  bool isOutOfStock = false;
  LoadItemController(this.context, this.id, this.model, {this.loadedUnit});

  @override
  void onInit() {
    super.onInit();
    print('LoadItemController initialized for productId=$id, orderId=${model.sId}');
    getUserDetails();

    loadFromStorage();
   // checkOutOfStock();
  }

  void checkOutOfStock() async {
    final productId = id;
    if (productId.isEmpty) return;

    final url = "https://shreeram.volvrit.org/api/stock/isproductoutofstock/$productId";

    try {
      final response = await APIConstant.gethitAPI(
        context,
        ConstantString.get,
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver?.token ?? ""}"
        },
      );

      final data = jsonDecode(response);
      if (data["inStock"] == false) {
        print("Product is out of stock");
        AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
          context,
          "Out of Stock",
          data["message"] ?? "This product is out of stock",
          onTapFunction: () {
            Get.back(); // optional: go back to previous screen
          },
        );
      }
    } catch (e) {
      print("Error checking out of stock: $e");
    }
  }



  void updateProductId(String newId) {
    // Check karein ki ID alag hai ya nahi
    if (id != newId) {
      print('Updating controller to new productId: $newId');
      id = newId; // ID ko update karein

      // Purani details clear karein
      quantityLoadedController.clear();
      unitController.clear(); // Unit ko bhi clear karein
      balanceLeftController.clear();
      stockLeftController.clear();

      // Naye product ka stock fetch karein
      getStock();
      update();
    }
  }

  void loadFromStorage() {
    print('Loading items from storage for order ${model.sId}');
    final storedItems = storage.read('loadedItems_${model.sId}');
    if (storedItems != null) {
      loadedItems.value = List<Map<String, dynamic>>.from(storedItems);
      print('Loaded from storage: ${jsonEncode(loadedItems)} (Count: ${loadedItems.length})');
    } else {
      print('No items found in storage for order ${model.sId}');
    }
  }

  void saveToStorage() {
    print('Saving items to storage for order ${model.sId}');
    storage.write('loadedItems_${model.sId}', loadedItems.toList());
    print('Saved to storage: ${jsonEncode(loadedItems)} (Count: ${loadedItems.length})');
  }

  getUserDetails() {
    print('Fetching user details');
    PreferenceManager.instance.getUserDetails().then((onValue) {
      loginModel = onValue;
      print('User details fetched: driverId=${loginModel.driver?.id}');
      getProfile();
      getStock();
      checkOutOfStock();
      update();
    }).catchError((e) {
      print('Error getting user details: $e');
    });
  }

  void onUpdate(int initialRemainingQuantity) {
    print('Updating quantities: initialRemainingQuantity=$initialRemainingQuantity');
    int loaded = int.tryParse(quantityLoadedController.text) ?? 0;
    int remaining = initialRemainingQuantity - loaded;
    remaining = remaining < 0 ? 0 : remaining;
    balanceLeftController.text = remaining.toString();
    int stockLeft = stockQuantity - loaded;
    stockLeft = stockLeft < 0 ? 0 : stockLeft;
    stockLeftController.text = stockLeft.toString();
    print('Updated: loaded=$loaded, remaining=$remaining, stockLeft=$stockLeft');
    update();
  }

  getProfile() {
    print('Fetching profile for driverId=${loginModel.driver!.id}');
    APIConstant.gethitAPI(
      context,
      ConstantString.get,
      ConstantString.getInChargeProfile + "${loginModel.driver!.id}",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${loginModel.driver!.token}"
      },
    ).then((onValue) {
      var response = jsonDecode(onValue);
      profileModel = InChargeProfileModel.fromJson(response);
      print('Profile fetched: ${profileModel.toJson()}');
      getProduct();
      update();
    }).catchError((e) {
      print('Error getting profile: $e');
    });
  }

  bool validation(BuildContext context, int remainingQuantity) {
    print('Validating input: quantity=${quantityLoadedController.text}, unit=${unitController.text}, remainingQuantity=$remainingQuantity, stockQuantity=$stockQuantity');
    if (quantityLoadedController.text.isEmpty) {
      print('Validation failed: Quantity is empty');
      AlertDialogManager.getSnackBarMsg("Error", "Quantity can't be empty", false, context);
      return false;
    }
    if (unitController.text.isEmpty) {
      print('Validation failed: Unit is empty');
      AlertDialogManager.getSnackBarMsg("Error", "Unit can't be empty", false, context);
      return false;
    }
    if (int.tryParse(quantityLoadedController.text) == null) {
      print('Validation failed: Quantity is not a number');
      AlertDialogManager.getSnackBarMsg("Error", "Quantity must be a number", false, context);
      return false;
    }
    int loadQty = int.parse(quantityLoadedController.text);
    if (loadQty <= 0) {
      print('Validation failed: Quantity is not positive');
      AlertDialogManager.getSnackBarMsg("Error", "Quantity must be greater than 0", false, context);
      return false;
    }
    if (loadQty > remainingQuantity) {
      print('Validation failed: Quantity exceeds remaining ($remainingQuantity)');
      AlertDialogManager.getSnackBarMsg("Error", "Quantity cannot exceed remaining ($remainingQuantity)", false, context);
      return false;
    }
    if (loadQty > stockQuantity) {
      print('Validation failed: Quantity exceeds stock ($stockQuantity)');
      AlertDialogManager.getSnackBarMsg("Error", "Quantity cannot exceed stock ($stockQuantity)", false, context);
      return false;
    }
    print('Validation passed');
    return true;
  }

  getProduct() {
    print('Fetching product for productId=$id');
    APIConstant.gethitAPI(
      context,
      ConstantString.get,
      ConstantString.getProductById + "$id",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
      },
    ).then((onValue) {
      var response = jsonDecode(onValue);
      print('Product fetched: $response');
      update();
    }).catchError((e) {
      print('Error getting product: $e');
    });
  }

  getStock() {
    print('Fetching stock for productId=$id, warehouseId=${model.warehouseId}');
    APIConstant.gethitAPI(
      context,
      ConstantString.get,
      ConstantString.getStock + "${id}/${model.warehouseId}",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${loginModel.driver!.token ?? ""}"
      },
    ).then((onValue) {
      var response = jsonDecode(onValue);
      stockQuantity = response["availableQuantity"] ?? 0;
      print('Stock quantity fetched: $stockQuantity');
      update();
    }).catchError((e) {
      print('Error getting stock: $e');
    });
  }

  void saveLoadedItem(String orderId, int remainingQuantity) {
    print('saveLoadedItem called for orderId=$orderId, productId=$id');
    if (validation(context, remainingQuantity)) {
      final itemData = {
        "productId": id,
        "loadQty": int.parse(quantityLoadedController.text),
        "unit": unitController.text,
        "remainingQty": int.parse(balanceLeftController.text),
      };
      print('Item to save: ${jsonEncode(itemData)}');

      int existingIndex = loadedItems.indexWhere((item) => item["productId"] == id);
      if (existingIndex != -1) {
        print('Updating existing item at index $existingIndex');
        loadedItems[existingIndex] = itemData;
      } else {
        print('Adding new item');
        loadedItems.add(itemData);
      }

      saveToStorage();
      print('All loaded items: ${jsonEncode(loadedItems)} (Count: ${loadedItems.length})');

      AlertDialogManager().isErrorAndSuccessAlertDialogMessage(
        context,
        "Success",
        "Item saved successfully",
        onTapFunction: () {
          print('Navigating back after successful save');
          Get.back();
        },
      );
    } else {
      print('Validation failed. Current items: ${jsonEncode(loadedItems)} (Count: ${loadedItems.length})');
    }
  }

  void clearLoadedItems() {
    print('Clearing loaded items for order ${model.sId}');
    loadedItems.clear();
    storage.remove('loadedItems_${model.sId}');
    print('Cleared items: ${jsonEncode(loadedItems)} (Count: ${loadedItems.length})');
    update();
  }
}