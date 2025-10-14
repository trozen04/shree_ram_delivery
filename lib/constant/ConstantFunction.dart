


import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'ConstantString.dart';

class ConstantFunction{


  static double lat=0.0;
  static double lng=0.0;

  static Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      // Get the placemarks from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        // Extract the first placemark
        Placemark place = placemarks.first;

        // Format the address
        String address =
            '${place.subLocality}-${place.postalCode}-${place.administrativeArea}-${place.country}';
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return null;
    }
  }


  static Future<String?> getCurrentLocation(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showEnableLocationDialog(context);
      print('Location services are disabled.');
      return null;
    }

    // If all checks pass, get the current position.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      lat=position.latitude;
      lng=position.longitude;
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      String address =await getAddressFromCoordinates(position.latitude,position.longitude)??"";
      return " ${position.latitude},${position.longitude} --| $address";
    } catch (e) {
      print('Failed to get location: $e');
      return null;
    }
  }


  static showEnableLocationDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text("Enable Location Services"),
          content:const Text("Location services are disabled. Please enable them to use the app."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child:const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(Get.overlayContext!).pop(); // Close dialog
                await Geolocator.openLocationSettings().then((onValue){
                });
                // Open location settings
              },
              child:const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}


// requestLocationPermission() async {
//     EasyLoadingConfig.show();
//     PermissionStatus status = await Permission.location.request();
//     if (status.isGranted) {
//       await ConstantFunction.getCurrentLocation(context).then((onValue){
//         EasyLoadingConfig.dismiss();
//         update();
//       },onError: (e){
//         EasyLoadingConfig.dismiss();
//         update();
//       });
//
//       status_msg = "Location permission granted!";
//     } else if (status.isDenied) {
//       requestLocationPermission();
//       status_msg = "Location permission denied.";
//       requestLocationPermission();
//     } else if (status.isPermanentlyDenied) {
//       EasyLoading.dismiss();
//       status_msg = "Location permission permanently denied. Please enable it from settings.";
//       openAppSettings(); // Opens app settings for the user to manually enable permissions
//     }
//   }