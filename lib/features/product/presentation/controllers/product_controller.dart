import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/buy_product_interactor.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/rent_product_interactor.dart';
import 'package:teebay_mobile/features/product/data/models/categories_model.dart';
import 'package:teebay_mobile/features/product/data/models/products_response.dart';
import 'package:teebay_mobile/features/product/domain/usecase/categories_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/delete_product_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/product_details_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/update_product_interactor.dart';

import '../../../../main/routes/app_routes.dart';
import '../../domain/usecase/add_product_interactor.dart';
import '../../domain/usecase/get_products_interactor.dart';
import '../screens/add_product_screen.dart';

class ProductController extends GetxController {

  AddProductInteractor addProductInteractor;
  GetProductsInteractor getProductsInteractor;
  ProductDetailsInteractor productDetailsInteractor;
  CategoriesInteractor categoriesInteractor;
  UpdateProductInteractor updateProductInteractor;
  DeleteProductInteractor deleteProductInteractor;
  BuyProductInteractor buyProductInteractor;
  RentProductInteractor rentProductInteractor;
  SharedPreferences sharedPreference;
  ProductController(this.addProductInteractor, this.getProductsInteractor,
      this.productDetailsInteractor,
      this.categoriesInteractor,
      this.updateProductInteractor,
      this.deleteProductInteractor,
      this.buyProductInteractor,
      this.rentProductInteractor,
      this.sharedPreference,);

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
    fetchCategories();
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
      Future.delayed(const Duration(milliseconds: 100), nextPage); // Retry after a short delay
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

  RxList<ProductsResponse> productsList = <ProductsResponse>[].obs;
  List<ProductsResponse> myProductsList = [];
  RxBool isProductLoading = false.obs;
  fetchProduct() async {
    isProductLoading.value = true;
    final result = await getProductsInteractor.execute();

    result.fold((l) {
        final error = l.message;
        print("Failed: $error");
        Get.snackbar("Failed", error, backgroundColor: Colors.red, colorText: Colors.white,);
        isProductLoading.value = false;
      }, (r) {
        productsList.value = r;
        myProductsList = r
            .where((item) => (item.seller ?? -1).toString() == sharedPreference.getString("user_id").toString()).toList();
        isProductLoading.value = false;
      },
    );
  }

  ProductsResponse? item;
  RxBool isLoading = false.obs;
  fetchSingleProduct(int productId) async {
    isLoading.value = true;
    final result = await productDetailsInteractor.execute(productId);

    result.fold((l) {
      final error = l.message;
      print("Failed: $error");
      Get.snackbar("Failed", error, backgroundColor: Colors.red, colorText: Colors.white,);
      isLoading.value = false;
    }, (r) {
      item = r;
      isLoading.value = false;
    },
    );
  }

  /// update product
  TextEditingController titleEditingControllerUp = TextEditingController();
  TextEditingController desEditingControllerUp = TextEditingController();
  TextEditingController ppEditingControllerUp = TextEditingController();
  TextEditingController rpEditingControllerUp = TextEditingController();

  RxBool isCatSet = false.obs;
  int updateProductId = 0;
  productEditDataSet(ProductsResponse productsModel) {
    updateProductId = productsModel.id ?? 0;
    titleEditingControllerUp.text = productsModel.title ?? "";
    desEditingControllerUp.text = productsModel.description ?? "";
    ppEditingControllerUp.text = productsModel.purchasePrice ?? "";
    rpEditingControllerUp.text = productsModel.rentPrice ?? "";
    selectedOption = productsModel.rentOption == "hour" ? optionTypes[0] : optionTypes[1];
    selectedCategoryList = productsModel.categories ?? [];
    print("++$selectedCategoryList");
  }

  List<CategoriesResponse> categoriesList = [];
  RxBool isCategoryLoading = false.obs;
  Future<void> fetchCategories() async {
    isCategoryLoading.value = true;
    final result = await categoriesInteractor.execute();

    result.fold((l) {
      final error = l.message;
      print("Failed: $error");
      Get.snackbar("Failed", error, backgroundColor: Colors.red, colorText: Colors.white,);
      isProductLoading.value = false;
    }, (r) {
      categoriesList = r;
      isProductLoading.value = false;
    },);
  }

  RxBool isUpdateProductLoading = false.obs;
  Future<void> updateProductData() async {
    isUpdateProductLoading.value = true;
    updateProductInteractor.execute(
      updateProductId,
      titleEditingControllerUp.text,
      desEditingControllerUp.text,
      ppEditingControllerUp.text,
      rpEditingControllerUp.text,
      selectedOption.toLowerCase().contains("hour") ? "hour" : "day",
      selectedCategoryList
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        print("Failed: $error");
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isUpdateProductLoading.value = false;
      } else {
        print("Success");
        isUpdateProductLoading.value = false;
        Get.back();
        Get.snackbar("Success", "Product Updated Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
        fetchProduct();
        selectedCategoryList.clear();
      }
    });
  }

  RxBool isDeleteProductLoading = false.obs;
  Future<void> deleteProduct(int productId) async {
    isDeleteProductLoading.value = true;
    deleteProductInteractor.execute(
      productId,
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        print("Failed: $error");
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isDeleteProductLoading.value = false;
      } else {
        isDeleteProductLoading.value = false;
        Get.snackbar("Success", "Product Deleted Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
        fetchProduct();
      }
    });
  }
  
  ///
  RxBool isBuyProductLoading = false.obs;
  Future<void> buyProduct(int productId) async {
    isBuyProductLoading.value = true;
    buyProductInteractor.execute(
      productId,
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        print("Failed: $error");
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isBuyProductLoading.value = false;
      } else {
        Get.back();
        Get.back();
        isBuyProductLoading.value = false;
        Get.snackbar("Success", "Product Bought Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
      }
    });
  }

  DateTime startYearDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  String startYearDateFormated = "Pick Date Time Here";
  String startTimeFormated = "";
  String endYearDateFormated = "Pick Date Time Here";
  String endTimeFormated = "";

  Future<void> rentProduct(int productId, String rentOption, String rentPeriodStartDate, String rentPeriodEndDate) async {
    isBuyProductLoading.value = true;
    rentProductInteractor.execute(
      productId,
      rentOption,
      rentPeriodStartDate,
      rentPeriodEndDate,
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        print("Failed: $error");
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isBuyProductLoading.value = false;
      } else {
        Get.back();
        Get.back();
        isBuyProductLoading.value = false;
        Get.snackbar("Success", "Product Rent Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
      }
    });
  }

  String convertToIsoUtc(String dateStr, String timeStr) {
    DateTime date = DateFormat("MM/dd/yyyy").parse(dateStr);
    DateTime time = DateFormat.jm().parse(timeStr);
    DateTime combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combined.toUtc().toIso8601String();
  }

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
        print("Failed: $error");
        Get.snackbar("Failed", error ?? "Failed", backgroundColor: Colors.red, colorText: Colors.white,);
        isProductAdding.value = false;
      } else {
        isProductAdding.value = false;
        Get.snackbar("Success", "Product Added Successfully.", backgroundColor: Colors.green, colorText: Colors.white,);
        Get.toNamed(AppRoutes.allProducts);
        fetchProduct();
      }
    });
  }

  /// biometric auth
  final LocalAuthentication auth = LocalAuthentication();
  RxBool biometricAuthentication = false.obs;
  isDeviceSupported() async {
    return await auth.isDeviceSupported();
  }

}