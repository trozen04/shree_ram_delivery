// import 'package:amit_sales/support/PreferenceManager.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   Future<void> init() async {
//     // Request permission (iOS specific)
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Get device token
//     String? token = await _fcm.getToken();
//
//     PreferenceManager.instance.setString("FCMTOKEN", (token??"").toString());
//     print('FCM Device Token: $token');
//
//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Foreground message: ${message.notification?.title}');
//     });
//
//     // Listen when app is opened from background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Notification clicked!');
//     });
//
//     // Optional: handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }
//
// // Top-level function for background handling
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Background message: ${message.notification?.title}');
// }
