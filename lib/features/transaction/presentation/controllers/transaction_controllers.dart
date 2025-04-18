import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/features/product/domain/usecase/product_details_interactor.dart';
import 'package:teebay_mobile/features/transaction/data/models/rental_list_model.dart';
import 'package:teebay_mobile/features/transaction/data/models/transaction_list_model.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/get_rental_interactor.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/get_transaction_interactor.dart';

import '../../../product/data/models/products_response.dart';

class TransactionControllers extends GetxController with GetSingleTickerProviderStateMixin {

  GetTransactionInteractor getTransactionInteractor;
  GetRentalInteractor getRentalInteractor;
  ProductDetailsInteractor productDetailsInteractor;
  SharedPreferences sharedPreference;
  TransactionControllers(this.getRentalInteractor, this.getTransactionInteractor, this.productDetailsInteractor, this.sharedPreference,);

  late TabController tabController;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {});
    fetchTransactionList();
    fetchRentalList();
  }

  List<TransactionResponse> transactionList = [];
  List<TransactionResponse> buyList = [];
  List<TransactionResponse> sellList = [];
  RxBool isTransactionListLoading = false.obs;
  Future<void> fetchTransactionList() async {
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/transactions/purchases/'));
    // String userId = preferences.getString("user_id") ?? "";
    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
    //   print(jsonData);
    //   transactionList = jsonData
    //       .map((item) => TransactionListModel.fromJson(item))
    //       .toList();
    //   sellList = transactionList
    //       .where((item) => (item.seller ?? -1).toString() == userId)
    //       .toList();
    //   buyList = transactionList
    //       .where((item) => (item.buyer ?? -1).toString() == userId)
    //       .toList();
    //
    //   setState(() {
    //     // data = jsonData['title'];
    //   });
    // } else {
    //   setState(() {
    //     // data = 'Error: ${response.statusCode}';
    //   });
    // }
    isTransactionListLoading.value = true;
    final result = await getTransactionInteractor.execute();
    result.fold((l) {
      final error = l.message;
      print("Failed: $error");
      Get.snackbar("Failed", error, backgroundColor: Colors.red, colorText: Colors.white,);
      isTransactionListLoading.value = false;
    }, (r) {
      transactionList = r;
      sellList = transactionList
          .where((item) => (item.seller ?? -1).toString() == sharedPreference.getString("user_id").toString()).toList();
      buyList = transactionList
          .where((item) => (item.buyer ?? -1).toString() == sharedPreference.getString("user_id").toString()).toList();
      isTransactionListLoading.value = false;
    },);
  }

  List<RentalResponse> rentalList = [];
  List<RentalResponse> borrowedList = [];
  List<RentalResponse> lentList = [];
  RxBool isRentalListLoading = false.obs;
  Future<void> fetchRentalList() async {
    // final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/transactions/rentals/'));
    // String userId = preferences.getString("user_id") ?? "";
    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
    //   print(jsonData);
    //   rentalList = jsonData
    //       .map((item) => RentalListModel.fromJson(item))
    //       .toList();
    //   borrowedList = rentalList
    //       .where((item) => (item.seller ?? -1).toString() == userId)
    //       .toList();
    //   lentList = rentalList
    //       .where((item) => (item.renter ?? -1).toString() == userId)
    //       .toList();
    //
    //   setState(() {
    //     // data = jsonData['title'];
    //   });
    // } else {
    //   setState(() {
    //     // data = 'Error: ${response.statusCode}';
    //   });
    // }
    isRentalListLoading.value = true;
    final result = await getRentalInteractor.execute();
    result.fold((l) {
      final error = l.message;
      print("Failed: $error");
      Get.snackbar("Failed", error, backgroundColor: Colors.red, colorText: Colors.white,);
      isRentalListLoading.value = false;
    }, (r) {
      rentalList = r;
        borrowedList = rentalList
            .where((item) => (item.seller ?? -1).toString() == sharedPreference.getString("user_id").toString())
            .toList();
        lentList = rentalList
            .where((item) => (item.renter ?? -1).toString() == sharedPreference.getString("user_id").toString())
            .toList();
      isRentalListLoading.value = false;
    },);
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

  // Future<void> buyProduct() async {
  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2:8000/api/transactions/purchases/'),
  //     headers: {
  //       'accept': 'application/json',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       "buyer": preferences.getString("user_id"),
  //       "product": item?.id,
  //     }),
  //   );
  //
  //   if (response.statusCode == 201) {
  //     var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
  //     print(jsonData);
  //     // Navigator.pop(context);
  //     // Navigator.pop(context);
  //     // setState(() {
  //     // data = jsonData['title'];
  //     // });
  //   } else {
  //     // setState(() {
  //     // data = 'Error: ${response.statusCode}';
  //     // });
  //   }
  // }
  //
  // DateTime startYearDate = DateTime.now();
  // TimeOfDay startTime = TimeOfDay.now();
  // String startYearDateFormated = "Pick Date Time Here";
  // String startTimeFormated = "";
  // String endYearDateFormated = "Pick Date Time Here";
  // String endTimeFormated = "";
  //
  // Future<void> rentProduct(String rentPeriodStartDate, String rentPeriodEndDate) async {
  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2:8000/api/transactions/rentals/'),
  //     headers: {
  //       'accept': 'application/json',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       "renter": preferences.getString("user_id"),
  //       "product": item?.id,
  //       "rent_option": item?.rentOption,
  //       "rent_period_start_date": rentPeriodStartDate,
  //       "rent_period_end_date": rentPeriodEndDate,
  //     }),
  //   );
  //
  //   if (response.statusCode == 201) {
  //     var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
  //     print(jsonData);
  //     // Navigator.pop(context);
  //     // setState(() {
  //     // data = jsonData['title'];
  //     // });
  //   } else {
  //     // setState(() {
  //     // data = 'Error: ${response.statusCode}';
  //     // });
  //   }
  // }
  //
  // String convertToIsoUtc(String dateStr, String timeStr) {
  //   DateTime date = DateFormat("MM/dd/yyyy").parse(dateStr);
  //   DateTime time = DateFormat.jm().parse(timeStr);
  //   DateTime combined = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     time.hour,
  //     time.minute,
  //   );
  //   return combined.toUtc().toIso8601String();
  // }

}