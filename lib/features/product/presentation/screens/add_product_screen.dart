import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:teebay_mobile/features/product/presentation/controllers/add_product_controller.dart';

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
                children: controller.pages,
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
                      controller.isLastPage.value ? controller.submitButton(context) : controller.nextPage();
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
  List<CategoriesModel> categoriesList = [];
  bool isLoding = false;
  Future<void> fetchCategories() async {
    setState(() {
      isLoding = true;
    });
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/categories/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);

      categoriesList = jsonData
          .map((item) => CategoriesModel.fromJson(item))
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
    final controller = Get.find<AddProductController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text("Select category", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
        ),
        // DropdownMenu<String>(
        //   width: MediaQuery.of(context).size.width * 0.925,
        //   initialSelection: selectedCategory,
        //   menuHeight: 150,
        //   hintText: "Category",
        //   onSelected: (String? value) {
        //     setState(() {
        //       selectedCategory = value ?? "";
        //     });
        //     FocusManager.instance.primaryFocus?.unfocus();
        //   },
        //   dropdownMenuEntries: categoriesList.map((category) {
        //     return DropdownMenuEntry(
        //       value: category.value ?? '',
        //       label: category.label ?? '',
        //     );
        //   }).toList(),
        //   inputDecorationTheme: InputDecorationTheme(
        //     isDense: true,
        //     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        //     constraints: BoxConstraints.tight(const Size.fromHeight(45)),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //   ),
        // ),
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
  final TextEditingController? ppController;
  final TextEditingController? rpController;
  const PageFive({super.key,
    required this.ppController,
    required this.rpController,
  });

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
          controller: widget.ppController,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text("Rent Price", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
        ),
        ProductTextFieldWidget(
          controller: widget.rpController,
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

class CategoriesModel {
  String? value;
  String? label;

  CategoriesModel({this.value, this.label});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}

class ProductTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget ? prefix;
  final Widget ? prefixIcon;
  final Widget ? suffix;
  final Widget ? suffixIcon;
  final ValueChanged<String>? onTextChange;
  final ValueChanged<String>? onTextSubmitted;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final String? fromValue;
  final bool autocorrect;
  final TextDirection textDirection;
  final bool readOnly;
  final List<String>? autofillHints;
  final void Function(PointerDownEvent)? onTapOutside;

  const ProductTextFieldWidget({
    super.key,
    this.cursorColor = Colors.black,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.autocorrect = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.textStyle = const TextStyle(color: Colors.black,),
    this.textDirection = TextDirection.ltr,
    this.textInputAction,
    this.decoration,
    this.maxLines = 1,
    this.minLines = 1,
    this.controller,
    this.keyboardType,
    this.focusNode,
    this.fromValue,
    this.autofillHints,
    this.onTap,
    this.onTextChange,
    this.onTextSubmitted,
    this.onTapOutside,
  });

  @override
  State<ProductTextFieldWidget> createState() => _ProductTextFieldWidgetState();
}

class _ProductTextFieldWidgetState extends State<ProductTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      autocorrect: widget.autocorrect,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        suffixIcon: widget.suffixIcon,
        suffix: widget.suffix,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffC4C4C4),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      style: widget.textStyle,
      keyboardType: widget.keyboardType,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      autofillHints: widget.autofillHints,
      onTap: widget.onTap,
      onTapOutside: (PointerDownEvent event){
        widget.focusNode?.unfocus();
      },
      onChanged: (value) {
        widget.onTextChange?.call(value);
        if (value.isNotEmpty) {

        }
      },
    );
  }
}

