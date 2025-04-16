import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:teebay_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:teebay_mobile/main/routes/app_routes.dart';

import '../../../../main.dart';
import '../screens/add_product_screen.dart';

class AddProductController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pages = [
      PageOne(),
      PageTwo(),
      PageThree(),
      PageFour(),
      PageFive(
        ppController: ppEditingController,
        rpController: rpEditingController,
      ),
      const PageSummary(),
    ];
  }

  List<String> selectedCategoryList = [];
  String selectedCategory = '';

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController ppEditingController = TextEditingController();
  TextEditingController rpEditingController = TextEditingController();

  final PageController pageController = PageController();

  late final List<Widget> pages;
  RxInt currentPage = 0.obs;
  RxBool isLastPage = false.obs;

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == pages.length - 1;
  }

  final ImagePicker picker = ImagePicker();
  // File? imageFile;
  Rx<File?> imageFile = Rx<File?>(null);
  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        // imageQuality: 85, // Optional: compress quality (0-100)
      );

      if (context.mounted) {
        if (pickedFile != null) {
          imageFile.value = File(pickedFile.path);
          // setState(() {});
          // profileUpdate(); // if needed
        } else {
          // User canceled the picker
        }
      }
    } catch (e) {
      // Handle any errors here
      print("Error picking image: $e");
    }
  }

  Future<void> openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      imageFile.value = File(photo.path);
    }
  }

  String selectedOption = '';
  List<String> optionTypes = ['Per Hour', 'Per Day',];

  void submitButton(BuildContext context) async {

    try {
      var headers = {
        'accept': 'application/json',
      };

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:8000/api/products/')
      );

      request.fields.addAll({
        "seller": preferences.getString("user_id") ?? "",
        "title": titleEditingController.text,
        "description": descriptionEditingController.text,
        "purchase_price": ppEditingController.text,
        "rent_price": rpEditingController.text,
        "rent_option": selectedOption.toLowerCase().contains("hour") ? "hour" : "day",
      });

      for (var category in selectedCategoryList) {
        request.files.add(
          http.MultipartFile.fromString('categories', category),
        );
      }

      request.files.add(await http.MultipartFile.fromPath(
        'product_image',
        imageFile.value?.path ?? "",
      ));

      request.headers.addAll(headers);

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(response.statusCode);
      print(respStr);

      if (response.statusCode == 201) {
        // Get.toNamed(AppRoutes.home);
        Get.snackbar("Success", "Product created successfully!");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen(),),
              (Route<dynamic> route) => false,
        );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: ${response.statusCode} - $respStr')),
        // );
        Get.snackbar("Failed", respStr,);
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString(),);
    }
  }

}