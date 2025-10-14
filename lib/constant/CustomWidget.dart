
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../support/ExpandedSection.dart';
import '../support/app_theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class CustomWidget {
  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  // showModalBottomSheet(context: context, builder: (BuildContext context) {
  //   return getBottomSheetWidget(context);
  // },isDismissible: false);

  static Widget textFormField(
    TextEditingController controller, {
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType? textInputType,
    FocusNode? focusNode,
    bool? readOnly,
    String? hintText,
    List<TextInputFormatter>? textInputFormatter,
    String? label,
    bool? bgborder = false,
    bool isMandatory = true,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? preffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: bgborder!
          ? BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/search_border.png")))
          : null,
      child: TextFormField(
        focusNode: focusNode,
        readOnly: (readOnly == null) ? false : readOnly,
        keyboardType: textInputType,
        controller: controller,
        obscureText: obscureText,
        inputFormatters: textInputFormatter,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: preffixIcon,
          fillColor: Colors.transparent,
          filled: true,
          contentPadding: const EdgeInsets.only(left: 8, right: 8),
          label: RichText(
            text: TextSpan(
                text: label,
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                      text: isMandatory ? " *" : "",
                      style: const TextStyle(color: Colors.red))
                ]),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ),
          focusedErrorBorder:OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ) ,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: !bgborder ? AppColor.secondary : Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  static Widget textInputFiled(TextEditingController? controller,
      {String hintText = "",
      String labelTextNew = "",
      Widget? suffixIconWidget,
      Widget? prefixIconWidget,
      List<TextInputFormatter>? inputFormatters,
      Widget? label,
      bool readOnlyFiled = false,
      bool fillColorFiled = false,
      Color? fillColors,
      FocusNode? focusNode,
      bool passwordHide = false,
      ValueChanged? onFieldSubmitTap,
      TextInputType? textInputType,
      int? maxLine,
      int? minLine,
      bool? enabledBox,
      FormFieldValidator<String>? validator,
      void Function()? onTapFunction,
      void Function(String)? onChanged,
      double? topPadding,
      double? radius,
      double? bottomPadding,
      double? leftPadding,
      Color? cursorColor,
      double? rightPadding,
      TextAlign? textAlign,
      EdgeInsets? contentPadding,
      bool isMandatory = false,
      bool autoFocus = false,
      bool enableBorder = true,
      TextCapitalization? textCapitalization}) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPadding ?? 0,
          right: rightPadding ?? 0,
          top: topPadding ?? 20,
          bottom: bottomPadding ?? 0),
      child: TextFormField(
        textAlign: textAlign!,

        onTap: onTapFunction,
        focusNode: focusNode,
        controller: controller,
        enabled: enabledBox,
        obscureText: passwordHide,
        onChanged: onChanged,
        cursorColor: Colors.black,
        onFieldSubmitted: onFieldSubmitTap,
        readOnly: readOnlyFiled,
        maxLines: maxLine,
        minLines: minLine ?? 1,
        autofocus: autoFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        keyboardType: textInputType,
        validator: validator,
        style: TextStyle(color: readOnlyFiled ? Colors.grey.shade500 : null),
        decoration: InputDecoration(
          fillColor: fillColors,
          filled: fillColorFiled,
          suffixIcon: suffixIconWidget,
          prefixIcon: prefixIconWidget,
          label: label ??
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: labelTextNew,
                      style: const TextStyle(
                          color: AppColor.primary, fontSize: 15)),
                  if (isMandatory)
                    const TextSpan(
                        text: " *",
                        style: TextStyle(
                            color: AppColor.negativeButton, fontSize: 16))
                ]),
              ),
          hintText: hintText,
          // helperText:hintText ,
          // h: TextStyle(color: Colors.grey.shade700),
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 5),
              borderSide: BorderSide(
                  color: enableBorder ? AppColor.secondary : Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 5),
              borderSide: BorderSide(
                  color: enableBorder ? AppColor.secondary : Colors.grey)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 5),
              borderSide: BorderSide(
                  color: enableBorder ? AppColor.secondary : Colors.grey)),
        ),
      ),
    );
  }

  static Widget outlineElevatedCustomButton(
      String? buttonName, void Function()? onTapFunction,
      {double? heightButton, double? horizontal, bool iconEnable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        height: heightButton ?? 45,
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.white.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: onTapFunction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconEnable) const Icon(Icons.file_upload_outlined),
              Text(
                buttonName!,
                style: const TextStyle(color: AppColor.primary, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static getFilePicker(bool multipleFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'JPG', 'PNG', 'png', 'JPEG'],
      allowMultiple: multipleFile,
      type: FileType.custom,
      withData: true,
    );
    return result;
  }

  static elevatedCustomButton(context, String s, Function() param1,
      {double? width,
      Color bgColor = AppColor.secondary,
      IconData? icon,
      Color? iconColor,
      Color textColor = Colors.white,
      Color borderColor = AppColor.secondary,
      double borderRadius = 8,
      FontWeight? weight = FontWeight.w400}) {
    return SizedBox(
      width: width ?? getWidth(context) * 0.4,
      height: 45,
      child: ElevatedButton.icon(
          icon: icon != null
              ? Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                )
              : Icon(
                  Icons.add,
                  color: bgColor,
                  size: 0,
                ),
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
            backgroundColor: MaterialStateProperty.all(bgColor),
            surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
            elevation: WidgetStatePropertyAll(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius))),
          ),
          onPressed: param1,
          label: FittedBox(
            child: Text(
              "$s",
              style:
                  TextStyle(color: textColor, fontSize: 16, fontWeight: weight),
            ),
          )),
    );
  }

  void getBottomSheetForProfile(
      BuildContext context, Function() onTapCamera, Function() onTapGallery) {
    showModalBottomSheet(
      backgroundColor: Colors.blue.shade100,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    "Choose Image from",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Divider(thickness: 1, height: 1, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onTapCamera,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.blue.shade800,
                              size: 28,
                            ),
                            const Text(
                              "Camera",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTapGallery,
                        child: Column(
                          children: [
                            Icon(Icons.image_rounded,
                                color: Colors.blue.shade800, size: 28),
                            const Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget autoComplete(
      BuildContext context,
      GetxController getxController,
      TextEditingController controller,
      String hint,
      List<String> list, {
        bool enable = true,
        FocusNode? focusNode,
        bool isRequired = false,
        EdgeInsets? scrollPadding,
        List<TextInputFormatter>? textInputFormatter,
        TextInputType textInputType = TextInputType.text,
        Function(dynamic d)? onSelectFunction,
        Function(dynamic d)? onSubmit,
        Function(String s)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: SizedBox(
        height: 45,
        child: TypeAheadField<String>(
          suggestionsCallback: (pattern) {
            return list.where((dynamic option) {
              return option
                  .toString()
                  .toLowerCase()
                  .contains(pattern.toLowerCase());
            }).toList();
          },
          builder: (context, textFieldController, node) {
            // Ensure outer controller stays in sync
            textFieldController.text = controller.text;
            textFieldController.selection = controller.selection;

            return TextField(
              controller: textFieldController,
              focusNode: focusNode ?? node,
              enabled: enable,
              inputFormatters: textInputFormatter ?? [],
              keyboardType: textInputType,
              scrollPadding: scrollPadding ??
                  EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 100.0),
              onChanged: (val) {
                controller.text = val;
                controller.selection = textFieldController.selection;
                if (onChanged != null) onChanged(val);
              },
              onSubmitted: (val) {
                if (onSubmit != null) onSubmit(val);
              },
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: hint,
                    style: const TextStyle(color: Colors.black),
                    children: [
                      if (isRequired)
                        const TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.only(top: 0, left: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(width: 1, color: Colors.black), // AppColor.primary
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(width: 1, color: Colors.black), // AppColor.secondary
                  borderRadius: BorderRadius.circular(5),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            );
          },
          itemBuilder: (context, dynamic suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
            );
          },
          onSelected: onSelectFunction ??
                  (dynamic suggestion) {
                controller.text = suggestion.toString();
                getxController.update();
              },
        ),
      ),
    );
  }

  Widget getSectionWiseBox(
      GetxController controller,
      context,
      String sectionName,
      List<Widget> widgetList,
      bool isExpanded,
      Function() _onChange) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          GestureDetector(
            onTap: _onChange,
            child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                width: CustomWidget.getWidth(context),
                decoration: BoxDecoration(
                    color: AppColor.mainColor.shade100,
                    border: const Border(
                        top: BorderSide(color: Colors.blue, width: 2)),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sectionName,
                            style: const TextStyle(
                                color: AppColor.primary, fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: AppColor.primary, size: 26)
                      ],
                    ),
                  ],
                )),
          ),
          ExpandedSection(
            expand: isExpanded,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: widgetList,
              ),
            ),
          )
        ],
      ),
    );
  }

  // static Widget modelServiceDropDown(ServiceData value, List<ServiceData> itemList, void Function(dynamic?)? onChange,
  //     {Function()? onTap, Color? colorDropDown,double? marginTop,String label="",bool isMandatory=false,EdgeInsets? margin,Color  boderColor=AppColor.secondary}) {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: 48,
  //         margin: margin??EdgeInsets.symmetric(vertical: 8.0),
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  //         decoration: BoxDecoration(
  //           color: colorDropDown,
  //           border: Border.all(
  //             color: boderColor,
  //           ),
  //           borderRadius: BorderRadius.circular(5),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<ServiceData>(
  //             value: value,
  //             onTap: onTap,
  //             isExpanded: true,
  //             icon: const Icon(Icons.keyboard_arrow_down),
  //             items: itemList.map<DropdownMenuItem<ServiceData>>((ServiceData items) {
  //               return DropdownMenuItem<ServiceData>(
  //                 value: items,
  //                 child: Text(items.serviceName??""),
  //               );
  //             }).toList(),
  //             onChanged: onChange,
  //           ),
  //         ),
  //       ),
  //       if(label!="")
  //       Positioned(
  //           left: 20,
  //           top: 0,
  //           child: Container(
  //               color:Colors.white,
  //               alignment: Alignment.topCenter,
  //               child: Row(
  //                 children: [
  //                   Text(" $label ",style: TextStyle(fontSize: 12),),
  //                   isMandatory
  //                       ?Text("*",style: TextStyle(fontSize: 12,color: Colors.red),)
  //                       :Text(""),
  //                 ],
  //               )
  //           )
  //       ),
  //     ],
  //   );
  // }

  static pickDateAndTime(BuildContext context,
      {required String backDate,
      required String type,
      DateTime? firstDate,
      DateTime? lastDate}) async {
    TimeOfDay? time = TimeOfDay.now();
    DateTime? picked = DateTime.now();
    picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            // Set the initial date
            firstDate: firstDate ?? DateTime(2000),
            // The minimum date
            lastDate: lastDate ?? DateTime(2100),
            // The maximum date
            initialDatePickerMode: DatePickerMode.day)
        .then((onValue) async {
      if (onValue != null) {
        time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          return onValue.copyWith(hour: time!.hour, minute: time!.minute);
        } else {
          return onValue.copyWith(
              hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
        }
      } else {
        return DateTime.now();
      }
    });

    if (time != null) {
      return Intl().date("dd-MMM-yyyy hh:mm a").format(picked);
    } else {
      return Intl().date("dd-MMM-yyyy hh:mm a").format(picked);
    }
  }

  Future<String> selectTime(BuildContext context,
      {bool? isTFhour = false}) async {
    TimeOfDay currentTime = TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: currentTime,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget? child_1) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(alwaysUse24HourFormat: isTFhour),
              child: child_1!);
        });
    if (isTFhour!) {
      if (timeOfDay != null) {
        return "${timeOfDay.hour.toString().length == 1 ? "0${timeOfDay.hour}" : timeOfDay.hour}:${timeOfDay.minute.toString().length == 1 ? "0${timeOfDay.minute}" : timeOfDay.minute}";
      } else {
        return "${currentTime.hour.toString().length == 1 ? "0${currentTime.hour}" : currentTime.hour}:${currentTime.minute.toString().length == 1 ? "0${currentTime.minute}" : currentTime.minute}";
      }
    }
    if (timeOfDay != null) {
      currentTime = timeOfDay;
      return currentTime.format(context);
    } else {
      return "";
    }
  }

  static Future<DateTimeRange> pickDateRange(BuildContext context,
      {required String backDate,
      DateTime? firstDate,
      DateTime? lastDate}) async {
    DateTimeRange? picked =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
          start: DateTime.now(), end: DateTime.now()), // Set the initial date
      firstDate: firstDate ?? DateTime(2000), // The minimum date
      lastDate: lastDate ?? DateTime(2100), // The maximum date
    ).then((onValue) async {
      if (onValue != null) {
        picked = onValue;
        return onValue;
      } else {
        return picked!;
      }
    });
    return picked!;
  }

  static Future<String>  pickDate(BuildContext context,
      {required String backDate,
      DateTime? firstDate,
      DateTime? lastDate}) async {
    DateTime? picked = DateTime.now();
    picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            // Set the initial date
            firstDate: firstDate ?? DateTime(2000),
            // The minimum date
            lastDate: lastDate ?? DateTime(2100),
            // The maximum date
            initialDatePickerMode: DatePickerMode.day)
        .then((onValue) async {
      if (onValue != null) {
        return onValue;
      } else {
        return DateTime.now();
      }
    });

    return  Intl().date("yyyy-MM-dd").format(picked);;
  }

  static Widget stringTypeDropDown(String value, List<String> itemList,
      void Function(String?)? onChange, FocusNode? focusNode,
      {Color? colorDropDown,
      String label = "",
      isMandatory = false,
      applyFitted = true,
      BuildContext? context,
      bool hideLabel = false,
      bool hideBorder = false}) {
    return Stack(
      children: [
        Container(
          height: 48,
          margin: const EdgeInsets.only(
            top: 9,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colorDropDown ?? Colors.white,
            border: Border.all(
              color: hideBorder
                  ? colorDropDown ?? Colors.white
                  : AppColor.secondary,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              focusNode: focusNode,
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColor.secondary,
              ),
              items: itemList.map((String? items) {
                return DropdownMenuItem(
                  value: items,
                  child: applyFitted
                      ? FittedBox(
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                Text(
                                  items!,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          items!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                );
              }).toList(),
              onChanged: onChange,
            ),
          ),
        ),
        if (!hideLabel)
          Positioned(
              left: 20,
              top: 0,
              child: Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      Text(
                        " $label ",
                        style: const TextStyle(fontSize: 12),
                      ),
                      isMandatory
                          ? const Text(
                              "*",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : const Text(""),
                    ],
                  ))),
      ],
    );
  }

  getCustomDataTable(
      BuildContext context,
      List<String> headerValue,
      List<String> actionList,
      List<String> headerkeys,
      List<Map<String, dynamic>> data,
      Function(int index) actionView) {
    return DataTable(
      headingRowHeight: 30,
      columnSpacing: 5,
      dataRowHeight: 50,
      horizontalMargin: 4,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          color: Colors.white),
      headingRowColor:
          WidgetStateColor.resolveWith((states) => AppColor.secondary),
      columns: List.generate((headerkeys.length * 2) - 1, (index) {
        if (index % 2 == 0) {
          print((index + 1) / 2);
          int i = ((index) / 2).toInt();
          //Column Name List
          return DataColumn(label: dataColumnWidget(headerkeys[i]));
        } else {
          return DataColumn(label: verWhiteDiv());
        }
      }),
      rows: List.generate(data.length, (index_1) {
        Map<String, dynamic> rowData = data[index_1];
        return DataRow(
          cells: List.generate((headerkeys.length * 2) - 1, (index) {
            if (index % 2 == 0) {
              print((index) / 2);
              int i = ((index) / 2).toInt();

              //Key for data fetch
              String cellkey = headerValue[i];
              if (cellkey == "Action") {
                return DataCell(actionView(index_1));
              } else {
                return DataCell(Container(
                    width: 160,
                    child: Text(
                      rowData[cellkey] ?? "",
                      style: const TextStyle(
                          color: Colors.black, overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    )));
              }
            } else {
              return DataCell(verBlackDiv());
            }
          }),
        );
      }),
    );
  }

  getCustomDataTableType2(
      BuildContext context,
      List<String> headerValue,
      List<String> actionList,
      List<String> headerkeys,
      List<Map<String, dynamic>> data) {
    print(">>>>>>>>" + headerValue.toString());
    print(">>>>>>>>2" + headerkeys.toString());
    return DataTable(
      headingRowHeight: 0,
      columnSpacing: 5,
      dataRowHeight: 50,
      horizontalMargin: 4,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          color: Colors.white),
      headingRowColor:
          MaterialStateColor.resolveWith((states) => AppColor.secondary),
      columns: [
        const DataColumn(label: Text("")),
        DataColumn(label: verWhiteDiv()),
        const DataColumn(label: Text("")),
      ],
      rows: List.generate(headerValue.length, (index) {
        Map<String, dynamic> rowData = data[0];

        return DataRow(cells: [
          DataCell(Row(
            children: [
              Expanded(
                  child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      color: AppColor.secondary.withOpacity(0.5),
                      child: Text(
                        headerValue[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
            ],
          )),
          DataCell(verBlackDiv()),
          DataCell(Row(
            children: [
              Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      alignment: Alignment.center,
                      child: Text(
                        rowData[headerValue[index]],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ))),
            ],
          )),
        ]);
      }),
    );
  }

  static Widget verBlackDiv() {
    return Container(height: double.maxFinite, width: 0.7, color: Colors.grey);
  }

  static Widget verWhiteDiv() {
    return Container(height: 30, width: 1, color: Colors.white);
  }

  static Widget dataColumnWidget(String title, {double? widthSize = null}) {
    return SizedBox(
      width: widthSize,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static getFilterRow(Widget first, Widget second) {
    return Row(
      children: [
        Expanded(child: first),
        Expanded(flex: 2, child: second),
      ],
    );
  }

  static getCustomTextField(
      TextEditingController controller,
      FocusNode? focus,
      String label,
      bool isMantory,
      String? unit,
      List<TextInputFormatter> inputFormatters,
      Function(String value) onChange,
      {bool? readOnly = false,
      bool labelOnTop = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: FittedBox(
              child: Text(
            "$label${isMantory ? "*" : ""}",
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
            maxLines: 1,
          )),
        ),
        Container(
          height: 40,
          width: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
              color: Colors.white),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: readOnly! ? Colors.grey.shade200 : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: controller,
                  onChanged: onChange,
                  keyboardType: TextInputType.number,
                  inputFormatters: inputFormatters,
                  readOnly: readOnly,
                  maxLines: 1,
                  focusNode: labelOnTop ? focus : null,
                  // autofocus: !labelOnTop,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2),
                    hintText: "0.00",

                    // labelText:labelOnTop?null:label,
                  ),
                ),
              )),
              if (unit != null)
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8)),
                      border: const BorderDirectional(
                          start: BorderSide(color: Colors.black)),
                      color: Colors.grey.shade200),
                  child: Text(
                    "$unit",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
