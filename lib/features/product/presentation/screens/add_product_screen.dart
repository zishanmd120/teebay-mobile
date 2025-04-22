import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:teebay_mobile/core/utils/endpoints.dart';
import 'package:teebay_mobile/features/product/data/models/categories_model.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_text_field_widget.dart';

final List<Widget> pages = [
  const PageOne(),
  const PageTwo(),
  const PageThree(),
  const PageFour(),
  const PageFive(),
  const PageSummary(),
];

class AddProductScreen extends GetView<ProductController> {
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
    final controller = Get.find<ProductController>();
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

  String selectedCategory = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
  }

  final MultiSelectController<String> _controller = MultiSelectController<String>();
  List<CategoriesResponse> categoriesList = [];
  bool isLoding = false;
  Future<void> fetchCategories() async {
    setState(() {
      isLoding = true;
    });
    final response = await http.get(Uri.parse(Endpoints.categories,),);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);

      categoriesList = jsonData
          .map((item) => CategoriesResponse.fromJson(item))
          .toList();
      print(jsonData);
      setState(() {
        isLoding = false;
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        isLoding = false;
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text("Select category", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        ),
        isLoding ? const CupertinoActivityIndicator() :
        MultiDropdown<String>(
          items: categoriesList.map((category) {
            return DropdownItem(
              label: category.label ?? '',
              value: category.value ?? '',
            );
          }).toList(),
          controller: _controller,
          enabled: true,
          searchEnabled: false,
          chipDecoration: ChipDecoration(
            backgroundColor: Colors.blue.shade100,
            wrap: true,
            runSpacing: 2,
            spacing: 10,
          ),
          fieldDecoration: FieldDecoration(
            hintText: 'Categories',
            hintStyle: const TextStyle(color: Colors.black87),
            showClearIcon: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.black87),
            ),
          ),
          dropdownDecoration: const DropdownDecoration(
            marginTop: 2,
            maxHeight: 150,
          ),
          dropdownItemDecoration: DropdownItemDecoration(
            selectedIcon: const Icon(Icons.check_box, color: Colors.green),
            disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
          ),
          onSelectionChange: (selectedItems) {
            setState(() {
              controller.selectedCategoryList = selectedItems;
              print(controller.selectedCategoryList);
            });
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
    final controller = Get.find<ProductController>();
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
    final controller = Get.find<ProductController>();
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
    final controller = Get.find<ProductController>();
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
    final controller = Get.find<ProductController>();
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





