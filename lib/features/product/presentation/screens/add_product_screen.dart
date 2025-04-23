import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';
import '../widgets/category_selector_widget.dart';
import '../widgets/product_text_field_widget.dart';

final List<Widget> pages = [
  const PageOne(),
  const PageTwo(),
  const PageThree(),
  const PageFour(),
  const PageFive(),
  const PageSummary(),
];

class AddProductScreen extends GetView<AddProductController> {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: Obx(() => Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  // controller.currentPage.value = index;
                  controller.onPageChanged(index);
                },
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.currentPage.value != 0)
                    ElevatedButton(
                      onPressed: controller.previousPage,
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80), // spacer

                  ElevatedButton(
                    onPressed: (){
                      controller.isLastPage.value ? controller.addProduct(context) : controller.nextPage();
                    },
                    child: Text(controller.isLastPage.value ? 'Submit' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0,),
          child: Text("Select title for your product", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        ),
        ProductTextFieldWidget(
          controller: controller.titleEditingController,
          focusNode: controller.titleFocusNode,
        ),
      ],
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({super.key,});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text("Select category", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        ),
        CategorySelectorWidget(
          totalCategories: controller.categoriesList,
          selectedCategories: controller.selectedCategoryList,
          onSelectionChanged: (selectedValue) {
            controller.selectedCategoryList = selectedValue;
          },
        ),
      ],
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0,),
          child: Text("Write Description", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        ),
        ProductTextFieldWidget(
          controller: controller.descriptionEditingController,
          maxLines: 5,
          minLines: 5,
          focusNode: controller.desFocusNode,
        ),
      ],
    );
  }
}

class PageFour extends StatefulWidget {
  const PageFour({super.key,});

  @override
  State<PageFour> createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Upload Product Picture", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: controller.imageFile.value != null
                      ? FileImage(File((controller.imageFile.value?.path ?? "")))
                      : const NetworkImage(
                    "https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              // child: D,
            ),),
          ],
        ),
        const SizedBox(height: 20,),
        GestureDetector(
          child: CaptureButton(title: "Take Picture using Camera",),
          onTap: (){
            controller.openCamera();
          },
        ),
        const SizedBox(height: 15,),
        GestureDetector(
          child: CaptureButton(title: "Upload Picture from Device",),
          onTap: (){
            controller.pickImage(context);
          },
        ),
      ],
    );
  }

  Widget CaptureButton({required String title}){
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(6.0,),
      ),
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15,),),
    );
  }
}

class PageFive extends StatefulWidget {
  const PageFive({super.key,});

  @override
  State<PageFive> createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Define Pricing", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 30,),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text("Purchase Price", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
        ),
        ProductTextFieldWidget(
          controller: controller.ppEditingController,
          focusNode: controller.ppFocusNode,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text("Rent Price", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
        ),
        ProductTextFieldWidget(
          controller: controller.rpEditingController,
          focusNode: controller.rpFocusNode,
        ),
        const SizedBox(height: 30,),
        DropdownMenu<String>(
          width: MediaQuery.of(context).size.width * 0.925,
          initialSelection: controller.selectedOption,
          menuHeight: 150,
          hintText: "Options",
          onSelected: (String? value) {
            setState(() {
              controller.selectedOption = value ?? "";
            });
            FocusManager.instance.primaryFocus?.unfocus();
          },
          dropdownMenuEntries: controller.optionTypes.map((String division) {
            return DropdownMenuEntry(value: division, label: division);
          }).toList(),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: BoxConstraints.tight(const Size.fromHeight(45)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}

class PageSummary extends StatelessWidget {
  const PageSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 30,),
        Text("Title: ${controller.titleEditingController.text}",
          style: const TextStyle(fontSize: 17,),
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            const Text("Categories: ",
              style: TextStyle(fontSize: 17,),
            ),
            for(int i = 0; i < controller.selectedCategoryList.length; i++)
              Text("${controller.selectedCategoryList[i]}, ",
                style: const TextStyle(fontSize: 17,),
              ),
          ],
        ),
        const SizedBox(height: 10,),
        Text("Description: ${controller.descriptionEditingController.text}",
          style: const TextStyle(fontSize: 17, ),
        ),
        const SizedBox(height: 10,),
        Text("Purchase Price: ${controller.descriptionEditingController.text}",
          style: const TextStyle(fontSize: 17,),
        ),
        const SizedBox(height: 10,),
        Text("Rent Price: ${controller.rpEditingController.text} / ${controller.selectedOption}",
          style: const TextStyle(fontSize: 17,),
        ),
      ],
    );
  }
}





