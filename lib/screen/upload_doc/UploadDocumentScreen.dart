



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shree_ram_delivery_app/screen/dashboard/DashboardScreen.dart';

import '../../constant/CustomWidget.dart';
import 'UploadDocumentController.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Get.put(UploadDocumentController(context)),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Upload Documents",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 10), child: Text("Upload Aadhar",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,)),),
                      Container(
                        width: double.infinity,
                        padding:
                        EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            if (controller.base64Profile.isNotEmpty)
                              Stack(children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile),))),
                                ),
                                Positioned(
                                    top: 3,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        controller.base64Profile = "";
                                        controller.path = "";
                                        controller.update();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius:
                                              BorderRadius.circular(2),
                                              border: Border.all(color: Colors.white),
                                              color: Colors.white),
                                          child: Icon(Icons.close, size: 25, color: Colors.black,)),
                                    ))
                              ]),
                            if (controller.base64Profile.isEmpty)
                              Icon(Icons.upload_file,
                                  size: 40,
                                  color: Colors.grey.shade400),
                            if (controller.base64Profile.isEmpty)
                              const SizedBox(height: 10),
                            if (controller.base64Profile.isEmpty)
                              Text(
                                  "Choose a file or drag & drop it here",
                                  style: TextStyle(
                                      color:
                                      Colors.grey.shade600)),
                            if (controller.base64Profile.isEmpty)
                              const SizedBox(height: 4),
                            if (controller.base64Profile.isEmpty)
                              Text(
                                  "JPEG, PNG formats, up to 50MB",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12)),
                            const SizedBox(height: 12),

                            CustomWidget.elevatedCustomButton(
                                context, "Browse File", () {
                              CustomWidget()
                                  .getBottomSheetForProfile(context, () {
                                controller.navigateAndDisplaySelection(context, 1,1);
                              }, () {
                                controller.navigateAndDisplaySelection(context, 2,1);
                              });
                              controller.base64Profile;
                            },
                                textColor: Colors.grey,
                                borderColor: Colors.grey,
                                bgColor: Colors.white),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 10), child: Text("Upload PAN",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,)),),
                      Container(
                        width: double.infinity,
                        padding:
                        EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            if (controller.base64Profile1.isNotEmpty)
                              Stack(children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile1),))),
                                ),
                                Positioned(
                                    top: 3,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        controller.base64Profile1 = "";
                                        controller.path1 = "";
                                        controller.update();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius:
                                          BorderRadius.circular(2),
                                              border: Border.all(color: Colors.white),
                                              color: Colors.white),
                                          child: Icon(Icons.close, size: 25, color: Colors.black,)),
                                    ))
                              ]),
                            if (controller.base64Profile1.isEmpty)
                              Icon(Icons.upload_file,
                                  size: 40,
                                  color: Colors.grey.shade400),
                            if (controller.base64Profile1.isEmpty)
                              const SizedBox(height: 10),
                            if (controller.base64Profile1.isEmpty)
                              Text(
                                  "Choose a file or drag & drop it here",
                                  style: TextStyle(
                                      color:
                                      Colors.grey.shade600)),
                            if (controller.base64Profile1.isEmpty)
                              const SizedBox(height: 4),
                            if (controller.base64Profile1.isEmpty)
                              Text(
                                  "JPEG, PNG formats, up to 50MB",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12)),
                            const SizedBox(height: 12),

                            CustomWidget.elevatedCustomButton(
                                context, "Browse File", () {
                              CustomWidget()
                                  .getBottomSheetForProfile(context, () {
                                controller.navigateAndDisplaySelection(context, 1,2);
                              }, () {
                                controller.navigateAndDisplaySelection(context, 2,2);
                              });
                              controller.base64Profile1;
                            },
                                textColor: Colors.grey,
                                borderColor: Colors.grey,
                                bgColor: Colors.white),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 10), child: Text("Upload RC",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,)),),
                      Container(
                        width: double.infinity,
                        padding:
                        EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            if (controller.base64Profile2.isNotEmpty)
                              Stack(children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile2),))),
                                ),
                                Positioned(
                                    top: 3,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        controller.base64Profile2 = "";
                                        controller.path2 = "";
                                        controller.update();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius:
                                          BorderRadius.circular(2),
                                              border: Border.all(color: Colors.white),
                                              color: Colors.white),
                                          child: Icon(Icons.close, size: 25, color: Colors.black,)),
                                    ))
                              ]),
                            if (controller.base64Profile2.isEmpty)
                              Icon(Icons.upload_file,
                                  size: 40,
                                  color: Colors.grey.shade400),
                            if (controller.base64Profile2.isEmpty)
                              const SizedBox(height: 10),
                            if (controller.base64Profile2.isEmpty)
                              Text(
                                  "Choose a file or drag & drop it here",
                                  style: TextStyle(
                                      color:
                                      Colors.grey.shade600)),
                            if (controller.base64Profile2.isEmpty)
                              const SizedBox(height: 4),
                            if (controller.base64Profile2.isEmpty)
                              Text(
                                  "JPEG, PNG formats, up to 50MB",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12)),
                            const SizedBox(height: 12),

                            CustomWidget.elevatedCustomButton(
                                context, "Browse File", () {
                              CustomWidget()
                                  .getBottomSheetForProfile(context, () {
                                controller.navigateAndDisplaySelection(context, 1,3);
                              }, () {
                                controller.navigateAndDisplaySelection(context, 2,3);
                              });
                              controller.base64Profile2;
                            },
                                textColor: Colors.grey,
                                borderColor: Colors.grey,
                                bgColor: Colors.white),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 10), child: Text("Upload PHOTO",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,)),),
                      Container(
                        width: double.infinity,
                        padding:
                        EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            if (controller.base64Profile3.isNotEmpty)
                              Stack(children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(image: MemoryImage(base64Decode(controller.base64Profile3),))),
                                ),
                                Positioned(
                                    top: 3,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        controller.base64Profile3 = "";
                                        controller.path3 = "";
                                        controller.update();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius:
                                          BorderRadius.circular(2),
                                              border: Border.all(color: Colors.white),
                                              color: Colors.white),
                                          child: Icon(Icons.close, size: 25, color: Colors.black,)),
                                    ))
                              ]),
                            if (controller.base64Profile3.isEmpty)
                              Icon(Icons.upload_file,
                                  size: 40,
                                  color: Colors.grey.shade400),
                            if (controller.base64Profile3.isEmpty)
                              const SizedBox(height: 10),
                            if (controller.base64Profile3.isEmpty)
                              Text(
                                  "Choose a file or drag & drop it here",
                                  style: TextStyle(
                                      color:
                                      Colors.grey.shade600)),
                            if (controller.base64Profile3.isEmpty)
                              const SizedBox(height: 4),
                            if (controller.base64Profile3.isEmpty)
                              Text(
                                  "JPEG, PNG formats, up to 50MB",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12)),
                            const SizedBox(height: 12),

                            CustomWidget.elevatedCustomButton(
                                context, "Browse File", () {
                              CustomWidget().getBottomSheetForProfile(context, () {
                                controller.navigateAndDisplaySelection(context, 1,4);
                              }, () {
                                controller.navigateAndDisplaySelection(context, 2,4);
                              });
                              controller.base64Profile3;
                            },
                                textColor: Colors.grey,
                                borderColor: Colors.grey,
                                bgColor: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                )),
                const SizedBox(height: 20,),
                CustomWidget.elevatedCustomButton(context, "Continue", (){

                  if(controller.validation(context)){
                    controller.updateProfile(context);
                  }

                },borderRadius: 25,width: Get.width-40),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _uploadBox(String title, String? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined,
                    color: Colors.grey, size: 40),
                const SizedBox(height: 8),
                Text(
                  file != null ? "File Selected: $file" : "Click to upload your image",
                  style: TextStyle(
                    fontSize: 14,
                    color: file != null ? Colors.green : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("JPEG, PNG, PDF",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}