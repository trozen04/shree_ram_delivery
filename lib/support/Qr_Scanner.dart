
//  qr_code_scanner_plus: ^2.0.10+1

// import 'package:get/get.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:flutter/material.dart';
// class QRScannerPage extends StatefulWidget {
//   @override
//   _QRScannerPageState createState() => _QRScannerPageState();
// }
//
// class _QRScannerPageState extends State<QRScannerPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? qrController;
//   String? scannedQRCode = '';
//
//   @override
//   void dispose() {
//     qrController?.dispose();
//     super.dispose();
//   }
//
//   // Method to scan QR Code
//   void onQRViewCreated(QRViewController controller) {
//     setState(() {
//       qrController = controller;
//     });
//
//     qrController!.scannedDataStream.listen((scanData) {
//       setState(() {
//         scannedQRCode = scanData.code;
//         Get.back(result: scannedQRCode);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: onQRViewCreated,
//             ),
//           ),
//           // Expanded(
//           //   flex: 1,
//           //   child: Center(
//           //     child: Text(
//           //       scannedQRCode ?? 'Scan a QR Code',
//           //       style: TextStyle(fontSize: 18),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
