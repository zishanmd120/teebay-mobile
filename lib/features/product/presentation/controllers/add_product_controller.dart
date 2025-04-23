import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teebay_mobile/features/product/data/models/categories_model.dart';
import 'package:teebay_mobile/features/product/data/models/products_response.dart';

import '../../../../main/routes/app_routes.dart';
import '../../domain/usecase/add_product_interactor.dart';
import '../screens/add_product_screen.dart';
import 'product_controller.dart';

class AddProductController extends GetxController {

  AddProductInteractor addProductInteractor;
  AddProductController(this.addProductInteractor,);

  late List<CategoriesResponse> categoriesList;

  @override
  void onInit() {
    super.onInit();
    categoriesList = List<CategoriesResponse>.from(Get.arguments);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  List<String> selectedCategoryList = [];
  String selectedCategory = '';

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController ppEditingController = TextEditingController();
  TextEditingController rpEditingController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode desFocusNode = FocusNode();
  FocusNode ppFocusNode = FocusNode();
  FocusNode rpFocusNode = FocusNode();

  PageController pageController = PageController();

  RxInt currentPage = 0.obs;
  RxBool isLastPage = false.obs;

  void nextPage() {
    if (pageController.hasClients &&
        pageController.positions.length == 1 &&
        currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint('PageController not ready. Retrying...');
      Future.delayed(const Duration(milliseconds: 100), nextPage);
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
  Rx<File?> imageFile = Rx<File?>(null);
  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (context.mounted) {
        if (pickedFile != null) {
          imageFile.value = File(pickedFile.path);
        }
      }
    } catch (e) {
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


  RxBool isProductAdding = false.obs;
  refreshTextEditingControllers(){
    currentPage.value = 0;
    isLastPage.value = false;
    titleEditingController.clear();
    descriptionEditingController.clear();
    ppEditingController.clear();
    rpEditingController.clear();
    selectedOption = "";
    selectedCategoryList.clear();
    imageFile.value = null;
  }

  addProduct(BuildContext context) async {
    isProductAdding.value = true;
    addProductInteractor.execute(
      titleEditingController.text,
      descriptionEditingController.text,
      ppEditingController.text,
      rpEditingController.text,
      selectedOption.toLowerCase().contains("hour") ? "hour" : "day",
      selectedCategoryList,
      imageFile.value?.path ?? "",
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isProductAdding.value = false;
      } else {
        isProductAdding.value = false;
        Get.snackbar("Success", "Product Added Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
        Get.delete<AddProductController>();
        var controller = Get.find<ProductController>();
        controller.fetchProduct();
        Get.toNamed(AppRoutes.allProducts);
      }
    });
  }
}