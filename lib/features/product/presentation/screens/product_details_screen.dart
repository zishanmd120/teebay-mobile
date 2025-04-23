import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teebay_mobile/features/product/presentation/controllers/product_controller.dart';

import '../../../../core/utils/format_date.dart';
import '../../../../main.dart';

class ProductDetailsPage extends GetView<ProductController> {
  const ProductDetailsPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CupertinoActivityIndicator(),)
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.item?.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                  const SizedBox(height: 20,),
                  Image.network(controller.item?.productImage ?? ""),
                  // Image.network("http://192.168.0.104:8001/media/product_images/NTisn7FckN4_1_82WH8Bc.jpg"),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Categories: "),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (controller.item?.categories ?? []).asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final capitalized = category[0].toUpperCase() + category.substring(1);
                          final isLast = index == ((controller.item?.categories ?? []).length - 1);
                          return Text("$capitalized${isLast ? '.' : ', '}");
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Price: Tk.${controller.item?.purchasePrice ?? " "} | "),
                      Text("Rent: Tk.${controller.item?.rentPrice ?? " "} / "),
                      Text(controller.item?.rentOption ?? ""),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Text(controller.item?.description ?? "",),
                  const SizedBox(height: 20,),
                  Text("Date Posted: ${FormatDate().formatDateWithSuffix(DateTime.parse(controller.item?.datePosted ?? ""))}"),
                  const SizedBox(height: 50,),
                  if(controller.item?.seller.toString() != controller.sharedPreference.getString("user_id").toString())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            child: OrderButton(title: "Rent",),
                          ),
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (child){
                                return StatefulBuilder(
                                    builder: (context, setStateBuilder) {
                                      return AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 10,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: context.width,),
                                            const Text("From", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                            const SizedBox(height: 5,),
                                            GestureDetector(
                                              child: DateTimePickerWidget(
                                                hintText: "${controller.startYearDateFormated} ${controller.startTimeFormated}",
                                                onTap: () async {
                                                  DateTime? startPicked = await showDatePicker(
                                                    context: context,
                                                    initialDate: controller.startYearDate,
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2101),
                                                    initialEntryMode: DatePickerEntryMode.calendar,
                                                    initialDatePickerMode: DatePickerMode.day,
                                                  );
                                                  if(startPicked != null) {
                                                    setStateBuilder(() {
                                                      controller.startYearDate = startPicked;
                                                      print(controller.startYearDate);
                                                      controller.startYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                    });
                                                    if(controller.item?.rentOption?.toLowerCase() == "hour"){
                                                      TimeOfDay? pickedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: controller.startTime,
                                                      );
                                                      if (pickedTime != null) {
                                                        setStateBuilder(() {
                                                          controller.startTime = pickedTime;
                                                          final now = DateTime.now();
                                                          final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                          controller.startTimeFormated = DateFormat.jm().format(dt);
                                                          print("Selected time: ${controller.startTimeFormated}");
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                              onTap: () async {
                                                DateTime? startPicked = await showDatePicker(
                                                  context: context,
                                                  initialDate: controller.startYearDate,
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2101),
                                                  initialEntryMode: DatePickerEntryMode.calendar,
                                                  initialDatePickerMode: DatePickerMode.day,
                                                );
                                                if(startPicked != null) {
                                                  setStateBuilder(() {
                                                    controller.startYearDate = startPicked;
                                                    print(controller.startYearDate);
                                                    controller.startYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                  });
                                                  if(controller.item?.rentOption?.toLowerCase() == "hour"){
                                                    TimeOfDay? pickedTime = await showTimePicker(
                                                      context: context,
                                                      initialTime: controller.startTime,
                                                    );
                                                    if (pickedTime != null) {
                                                      setStateBuilder(() {
                                                        controller.startTime = pickedTime;
                                                        final now = DateTime.now();
                                                        final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                        controller.startTimeFormated = DateFormat.jm().format(dt);
                                                        print("Selected time: ${controller.startTimeFormated}");
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 20,),
                                            const Text("To", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                            const SizedBox(height: 5,),
                                            GestureDetector(
                                              child: DateTimePickerWidget(
                                                hintText: "${controller.endYearDateFormated} ${controller.endTimeFormated}",
                                                onTap: () async {
                                                  DateTime? startPicked = await showDatePicker(
                                                    context: context,
                                                    initialDate: controller.startYearDate,
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2101),
                                                    initialEntryMode: DatePickerEntryMode.calendar,
                                                    initialDatePickerMode: DatePickerMode.day,
                                                  );
                                                  if(startPicked != null) {
                                                    setStateBuilder(() {
                                                      controller.startYearDate = startPicked;
                                                      print(controller.startYearDate);
                                                      controller.endYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                    });
                                                    if(controller.item?.rentOption?.toLowerCase() == "hour"){
                                                      TimeOfDay? pickedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: controller.startTime,
                                                      );
                                                      if (pickedTime != null) {
                                                        setStateBuilder(() {
                                                          controller.startTime = pickedTime;
                                                          final now = DateTime.now();
                                                          final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                          controller.endTimeFormated = DateFormat.jm().format(dt);
                                                          print("Selected time: ${controller.endTimeFormated}");
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                              onTap: () async {
                                                DateTime? startPicked = await showDatePicker(
                                                  context: context,
                                                  initialDate: controller.startYearDate,
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2101),
                                                  initialEntryMode: DatePickerEntryMode.calendar,
                                                  initialDatePickerMode: DatePickerMode.day,
                                                );
                                                if(startPicked != null) {
                                                  setStateBuilder(() {
                                                    controller.startYearDate = startPicked;
                                                    print(controller.startYearDate);
                                                    controller.endYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                  });
                                                  if(controller.item?.rentOption?.toLowerCase() == "hour"){
                                                    TimeOfDay? pickedTime = await showTimePicker(
                                                      context: context,
                                                      initialTime: controller.startTime,
                                                    );
                                                    if (pickedTime != null) {
                                                      setStateBuilder(() {
                                                        controller.startTime = pickedTime;
                                                        final now = DateTime.now();
                                                        final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                        controller.endTimeFormated = DateFormat.jm().format(dt);
                                                        print("Selected time: ${controller.endTimeFormated}");
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 50,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RentButton(
                                                  title: "Go Back",
                                                  color: Colors.red,
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                RentButton(
                                                  title: "Confirm Rent",
                                                  color: Colors.purple,
                                                  onTap: (){
                                                    String startIso = controller.convertToIsoUtc(controller.startYearDateFormated, controller.startTimeFormated);
                                                    String endIso = controller.convertToIsoUtc(controller.endYearDateFormated, controller.endTimeFormated);
                                                    controller.rentProduct(
                                                      controller.item?.id ?? 0,
                                                      controller.item?.rentOption ?? "",
                                                      startIso,
                                                      endIso,
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 30,),
                        GestureDetector(
                          child: OrderButton(title: "Buy",),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (child){
                                return StatefulBuilder(
                                    builder: (context, setStateBuilder) {
                                      return AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 10,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: context.width,),
                                            const Text("Are you sure you want to buy this product?",
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19,),
                                            ),
                                            const SizedBox(height: 5,),
                                            const SizedBox(height: 50,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RentButton(
                                                  title: "No",
                                                  color: Colors.red,
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                RentButton(
                                                  title: "Yes",
                                                  color: Colors.purple,
                                                  onTap: (){
                                                    controller.buyProduct(
                                                      controller.item?.id ?? 0,
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget OrderButton({required String title,}){
    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(6.0,),
      ),
      alignment: Alignment.center,
      child: Text(title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500,),
      ),
    );
  }

  Widget RentButton({required String title, required Color color, required void Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.0,),
        ),
        alignment: Alignment.center,
        child: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500,),
        ),
      ),
    );
  }

  Widget DateTimePickerWidget({
    String ? hintText,
    void Function()? onTap,
  }){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0,),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hintText ?? "", textAlign: TextAlign.start,),
          const Icon(Icons.date_range),
        ],
      ),
    );
  }

}