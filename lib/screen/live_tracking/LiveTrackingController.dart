import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as lat;
import '../../constant/APIConstant.dart';
import '../../constant/ConstantFunction.dart';
import '../../constant/ConstantString.dart';
import '../../model/LoginModel.dart';
import '../../model/ProfileModel.dart';
import '../../model/TaskModel.dart';
import '../../support/PreferenceManager.dart';

class LiveTrackingController extends GetxController {
  BuildContext context;
  TaskModel  model;
  double dlat = 0.0;
  double dlng = 0.0;
  LiveTrackingController(this.context,this.model,this.dlat,this.dlng);

  GoogleMapController? mapController;
  LatLng currentPosition = LatLng(0.0, 0.0);
  double zoomLevel = 13.0;
  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};
  Set<Polygon> polygons = <Polygon>{}; // Added for delivery zone
  double latestDeliveryCharge = 0.0; // add this as a controller property

  String mapError = "";
  Timer? timer;
  final RxBool isOnline = true.obs;
  String currentStep = "Accept";
  final String _googleApiKey = "AIzaSyD2tRzmlcKVdffKJh6YQMnFYQEoZtcJxag";
  String address = "";
  LoginModel  loginModel=LoginModel();
  ProfileModel  profileModel=ProfileModel();


  String distanceText = ""; // e.g. "12.3 km"
  double distanceValue = 0; // in meters
  String durationText = ""; // e.g. "18 mins"
  int durationValue = 0;

  @override
  void onInit() {
    super.onInit();

    getUserDetails();
  }

  getUserDetails(){
    startTimer();
    PreferenceManager.instance.getUserDetails().then((onValue){
      loginModel=onValue;
      getProfile(context);
      update();
    });
  }

  getProfile(BuildContext context){
    APIConstant.gethitAPI(context,ConstantString.get ,ConstantString.getProfile+"${loginModel.driver!.id}",headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${loginModel.driver!.token}"
    }).then((onValue){
      var response=jsonDecode(onValue);
      print(onValue);
      profileModel=ProfileModel.fromJson(response);
      update();
    });
  }



  updateLiveTracking(BuildContext context) async {
    // 🛑 Check if currentPosition or its lat/long is invalid
    if (currentPosition.latitude == 0.0 ||
        currentPosition.longitude == 0.0 ||
        currentPosition.latitude.isNaN ||
        currentPosition.longitude.isNaN) {
      print("⚠️ Skipping live tracking update — invalid location data.");
      return;
    }

    final url = ConstantString.updateliveTracking +
        "${model.orderid!.sId}/${loginModel.driver!.id}";

    // ✅ Encode the body as JSON string
    final body = {
      "lat": currentPosition.latitude.toString(),
      "lng": currentPosition.longitude.toString(),
    };

    print("📍 Sending location: $body");

    try {
      final response = await APIConstant.gethitAPI(
        context,
        ConstantString.post,
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${loginModel.driver!.token}",
        },
        body: body,
        showProgress: false,
      );

      print("✅ Live tracking response: $response");
      final decoded = jsonDecode(response);
      profileModel = ProfileModel.fromJson(decoded);
      latestDeliveryCharge = decoded["deliveryCharge"] != null
          ? double.tryParse(decoded["deliveryCharge"].toString()) ?? 0.0
          : 0.0;
      update();
    } catch (e) {
      print("❌ Error in live tracking update: $e");
    }
  }


  getCurrentAddress() async {
    address = await ConstantFunction.getCurrentLocation(context) ?? "";
    print("========>$address");
    update();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await ConstantFunction.getCurrentLocation(context);
      currentPosition = LatLng(
        ConstantFunction.lat,
        ConstantFunction.lng,
      );
      // refresh markers & polylines with new location
      updateMarkersAndPolyline();
      updateLiveTracking(context);
      update();
    });
  }

  double calculateDisplacement(
      double lat1, double lng1, double lat2, double lng2) {
    final lat.Distance distance = lat.Distance();
    final double meters = distance(
      lat.LatLng(lat1, lng1),
      lat.LatLng(lat2, lng2),
    );
    return meters;
  }

  void setCurrentPosition(LatLng newPosition) {
    currentPosition = newPosition;
  }

  void zoomIn() {
    zoomLevel += 1;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: zoomLevel),
      ),
    );
    update();
  }

  void zoomOut() {
    zoomLevel -= 1;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: zoomLevel),
      ),
    );
    update();
  }

  void recenter() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  void _animateCameraToCurrentPosition() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _animateCameraToCurrentPosition();
    updateMarkersAndPolyline();
    update();
  }

  void updateMarkersAndPolyline() async {
    await ConstantFunction.getCurrentLocation(context);
    currentPosition = LatLng(ConstantFunction.lat, ConstantFunction.lng!);
    print("======>$currentPosition");

    markers.clear();
    polylines.clear();
    polygons.clear();

    // Current location marker
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentPosition,
        infoWindow: InfoWindow(
          title: 'My Location',
          snippet: address.isEmpty ? "Loading..." : address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    LatLng orderLocation =  LatLng(dlat, dlng);
    // Destination marker
    markers.add(
      Marker(
        markerId: const MarkerId('orderDestination'),
        position: orderLocation,
        infoWindow: const InfoWindow(
          title: 'Delivery Location',
          snippet: 'Order destination',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Delivery zone polygon
    _createDeliveryZone(orderLocation);

    // Fetch main route
    final routePoints = await fetchRoute(currentPosition, orderLocation);
    if (routePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('deliveryRoute'),
          color: const Color(0xFF1565C0),
          width: 6,
          points: routePoints,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }

    // Fetch alternative route (dashed)
    final altRoutePoints = await _fetchAlternativeRoute(currentPosition, orderLocation);
    if (altRoutePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('alternativeRoute'),
          color: Colors.grey.withOpacity(0.7),
          width: 4,
          points: altRoutePoints,
          geodesic: true,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    update();
  }

  // Fetch main route with detailed steps (curved)
  Future<List<LatLng>> fetchRoute(LatLng origin, LatLng destination) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=driving&'
          'key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          List<LatLng> routePoints = [];

          final leg = data['routes'][0]['legs'][0];

          // ✅ Distance & Duration
          distanceText = leg['distance']['text']; // e.g. "12.3 km"
          distanceValue = leg['distance']['value']/1000; // in meters
          durationText = leg['duration']['text']; // e.g. "18 mins"
          durationValue = leg['duration']['value'];

          final steps = data['routes'][0]['legs'][0]['steps'];
          for (var step in steps) {
            String polyline = step['polyline']['points'];
            routePoints.addAll(decodePolyline(polyline));
          }
          return routePoints;
        } else {
          print("Directions API error: ${data['status']}");
        }
      }
    } catch (e) {
      print("Error fetching route: $e");
    }

    // fallback = straight line
    return [origin, destination];
  }

  // Fetch alternative route
  Future<List<LatLng>> _fetchAlternativeRoute(LatLng origin, LatLng destination) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=driving&'
          'alternatives=true&'
          'key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].length > 1) {
          List<LatLng> altRoutePoints = [];
          final steps = data['routes'][1]['legs'][0]['steps'];
          for (var step in steps) {
            String polyline = step['polyline']['points'];
            altRoutePoints.addAll(decodePolyline(polyline));
          }
          return altRoutePoints;
        }
      }
    } catch (e) {
      print("Error fetching alternative route: $e");
    }
    return [];
  }

  void _createDeliveryZone(LatLng center) {
    const double radiusInMeters = 100.0;
    const int numberOfPoints = 20;
    List<LatLng> polygonPoints = [];

    for (int i = 0; i < numberOfPoints; i++) {
      double angle = (i * 360 / numberOfPoints) * (pi / 180);

      double latOffset = (radiusInMeters / 111320) * cos(angle);
      double lngOffset = (radiusInMeters / (111320 * cos(center.latitude * (pi / 180)))) * sin(angle);

      polygonPoints.add(LatLng(
        center.latitude + latOffset,
        center.longitude + lngOffset,
      ));
    }

    polygons.add(
      Polygon(
        polygonId: const PolygonId('deliveryZone'),
        points: polygonPoints,
        strokeColor: Colors.red.withOpacity(0.8),
        strokeWidth: 2,
        fillColor: Colors.red.withOpacity(0.2),
        geodesic: true,
      ),
    );
  }

  void clearCurrentOrder() {
    markers.clear();
    polylines.clear();
    polygons.clear();
    timer?.cancel();
    timer = null;
    updateMarkersAndPolyline();
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
}
