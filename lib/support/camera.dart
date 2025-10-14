import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class ImagePickerConst extends StatefulWidget {
  final List<CameraDescription>? cameras;
  String? type = "";
  ImagePickerConst({this.cameras, this.type, Key? key}) : super(key: key);

  @override
  _ImagePickerConstState createState() => _ImagePickerConstState();
}

class _ImagePickerConstState extends State<ImagePickerConst> {
  CameraController? controller;
  File? _file;
  XFile? takeImage;
  String _img64 = "", imageB64 = "", imageExt = "", imageName = "";
  final picker = ImagePicker();
  var filePath, imageData, extension = "", Docname = "";
  List<CameraDescription> cameras = [];
  int sizeInBytes = 0;
  double sizeInMb = 0.0;
  Uint8List? data;

  FlashMode flashMode = FlashMode.off;
  bool cameraChanger = true;

  @override
  void initState() {
    super.initState();
    if (widget.type == "camera") {
      controller = CameraController(widget.cameras![0], ResolutionPreset.veryHigh, enableAudio: false);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraChanger = true;
        });
      }).catchError((error) {
        Get.back();
      });
    } else {
      getImageOption();
    }
  }

  getImageOption() async {
    var sample;
    var filePath;
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxHeight: 1920, maxWidth: 1080);
      filePath = File(pickedImage!.path);
      setState(() {
        _file = filePath;
      });
      _handleSaveButtonPressed(_file!);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _handleSaveButtonPressed(File file) async {
    Uint8List compressedFile = await getCompressedFile(file);
    imageName = file.path.split('/').last;
    imageExt = file.path.split('.').last;
    Map map = {
      "image64": base64Encode(compressedFile),
      "imageByte": compressedFile,
      "imageName": imageName,
      "imageExt": imageExt,
      "size": sizeInMb.toString(),
      "imagePath": file.path,
    };
    if (context.mounted) {
      Navigator.pop(context, map);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                // AspectRatio(
                //     // height: MediaQuery.of(context).size.height,
                //     // width: MediaQuery.of(context).size.width,
                //     aspectRatio: 0.6,
                //     child: widget.type == "camera" ? CameraPreview(controller!) : Text("")),

                SafeArea(
                    child: widget.type == "camera" ? CameraPreview(controller!) : const Text("")),
                // Transform.scale(
                //   scale: controller!.value.aspectRatio / deviceRatio,
                //   child: Center(
                //     child: AspectRatio(
                //       aspectRatio: controller!.value.aspectRatio,
                //         child: widget.type == "camera" ? CameraPreview(controller!) : Text("")),
                //     ),
                //   ),


             
                Container(
                    height: 35,
                    width: 35,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
                      color: Colors.black,
                      onPressed: () {
                        Get.back();
                      },
                    ))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    changeCamera();
                  },
                  child: Icon(
                    cameraChanger == true ? Icons.rotate_left : Icons.camera,
                     size :30,color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue.shade800,
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 25),
                    onPressed: () async {
                      takeImage = await controller!.takePicture();
                      Uint8List compressedFile = await getCompressedFile(File(takeImage!.path));
                        String path = takeImage!.path;
                        _img64 = base64Encode(compressedFile);
                        imageName = path.split('/').last;
                        imageExt = path.split('.').last;
                        Map map = {
                          "imageExt": imageExt,
                          "imageName": imageName,
                          "imageByte": await takeImage!.readAsBytes(),
                          "image64": _img64.toString(),
                          "size": sizeInMb.toString(),
                          "imagePath": path
                        };
                        Get.back(result: map);
                      setState(() { });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (flashMode == FlashMode.off) {
                        controller!.setFlashMode(FlashMode.always);
                        flashMode = FlashMode.always;
                      } else {
                        controller!.setFlashMode(FlashMode.off);
                        flashMode = FlashMode.off;
                      }
                    });
                  },
                  child: Icon(flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on, color: Colors.blue.shade800, size: 25),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  changeCamera() {
    if (cameraChanger == true) {
      controller = CameraController(
        widget.cameras![1],
        enableAudio: false,
        ResolutionPreset.veryHigh,
      );
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraChanger = false;
        });
      });
    } else if (cameraChanger == false) {
      controller = CameraController(widget.cameras![0], ResolutionPreset.max, enableAudio: false);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraChanger = true;
        });
      });
    }
  }

  Future<Uint8List> getCompressedFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(file.absolute.path, minWidth: 640, minHeight: 1136, quality: 100, inSampleSize: 1);
    return result!;
  }
}
