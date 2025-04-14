import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:teebay_mobile/features/home/presentation/screens/add_product_screen.dart';
import 'package:teebay_mobile/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _checkTextOverflow());
    fetchProducts();
  }

  List<ProductsModel> productsList = [];
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      productsList = jsonData
          .map((item) => ProductsModel.fromJson(item))
          .toList();
      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  bool selectedMaxLines = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                child: Text("My Data",),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfileScreen(),),);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productsList.length,
            itemBuilder: (context, index){
              var item = productsList[index];
              return GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0,),
                  margin: const EdgeInsets.only(bottom: 10.0,),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (item.categories ?? []).asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final capitalized = category[0].toUpperCase() + category.substring(1);
                          final isLast = index == (item.categories!.length - 1);
                          return Text("$capitalized${isLast ? '.' : ', '}");
                        }).toList(),
                      ),
                      Row(
                        children: [
                          Text(item.purchasePrice ?? ""),
                          Text(item.rentPrice ?? ""),
                          Text(item.rentOption ?? ""),
                        ],
                      ),
                      Text(item.description ?? "",
                        maxLines: selectedMaxLines ? null : 3,
                        overflow: selectedMaxLines ? null : TextOverflow.ellipsis,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            selectedMaxLines = !selectedMaxLines;
                            setState(() {});
                          },
                          child: const Text("see more", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.orange,),),
                        ),
                      ),
                      Text(item.datePosted ?? ""),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: item.id ?? 0),),);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 40,),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen(),),);
        },
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  const ProductDetailsPage({super.key, required this.productId,});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSingleProduct();
  }

  ProductsModel? item;
  bool isLoading = false;
  Future<void> fetchSingleProduct() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/${widget.productId}/'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      item = ProductsModel.fromJson(jsonData);
      setState(() {
        isLoading = false;
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        isLoading = false;
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  Future<void> buyProduct() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/transactions/purchases/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "buyer": preferences.getString("user_id"),
        "product": item?.id,
      }),
    );

    if (response.statusCode == 201) {
      var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  DateTime startYearDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  String startYearDateFormated = "Pick Date Time Here";
  String startTimeFormated = "";
  String endYearDateFormated = "Pick Date Time Here";
  String endTimeFormated = "";

  Future<void> rentProduct(String rentPeriodStartDate, String rentPeriodEndDate) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/transactions/rentals/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "renter": preferences.getString("user_id"),
        "product": item?.id,
        "rent_option": item?.rentOption,
        "rent_period_start_date": rentPeriodStartDate,
        "rent_period_end_date": rentPeriodEndDate,
      }),
    );

    if (response.statusCode == 201) {
      var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      Navigator.pop(context);
      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: isLoading ? const Center(child: CupertinoActivityIndicator(),) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item?.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
              Image.network(item?.productImage ?? ""),
              // Image.network((item?.productImage ?? "").replaceAll("http://10.0.2.2:8000", "http://127.0.0.1:8000")),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (item?.categories ?? []).asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  final capitalized = category[0].toUpperCase() + category.substring(1);
                  final isLast = index == ((item?.categories ?? []).length - 1);
                  return Text("$capitalized${isLast ? '.' : ', '}");
                }).toList(),
              ),
              Row(
                children: [
                  Text(item?.purchasePrice ?? ""),
                  Text(item?.rentPrice ?? ""),
                  Text(item?.rentOption ?? ""),
                ],
              ),
              Text(item?.description ?? "",),
              Text(item?.datePosted ?? ""),
              const SizedBox(height: 30,),
              if(item?.seller.toString() != preferences.getString("user_id").toString())
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
                                            hintText: "$startYearDateFormated $startTimeFormated",
                                            onTap: () async {
                                              DateTime? startPicked = await showDatePicker(
                                                context: context,
                                                initialDate: startYearDate,
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2101),
                                                initialEntryMode: DatePickerEntryMode.calendar,
                                                initialDatePickerMode: DatePickerMode.day,
                                              );
                                              if(startPicked != null) {
                                                setStateBuilder(() {
                                                  startYearDate = startPicked;
                                                  print(startYearDate);
                                                  startYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                });
                                                if(item?.rentOption?.toLowerCase() == "hour"){
                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: startTime,
                                                  );
                                                  if (pickedTime != null) {
                                                    setStateBuilder(() {
                                                      startTime = pickedTime;
                                                      final now = DateTime.now();
                                                      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                      startTimeFormated = DateFormat.jm().format(dt);
                                                      print("Selected time: $startTimeFormated");
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                          onTap: () async {
                                            DateTime? startPicked = await showDatePicker(
                                              context: context,
                                              initialDate: startYearDate,
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime(2101),
                                              initialEntryMode: DatePickerEntryMode.calendar,
                                              initialDatePickerMode: DatePickerMode.day,
                                            );
                                            if(startPicked != null) {
                                              setStateBuilder(() {
                                                startYearDate = startPicked;
                                                print(startYearDate);
                                                startYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                              });
                                              if(item?.rentOption?.toLowerCase() == "hour"){
                                                TimeOfDay? pickedTime = await showTimePicker(
                                                  context: context,
                                                  initialTime: startTime,
                                                );
                                                if (pickedTime != null) {
                                                  setStateBuilder(() {
                                                    startTime = pickedTime;
                                                    final now = DateTime.now();
                                                    final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                    startTimeFormated = DateFormat.jm().format(dt);
                                                    print("Selected time: $startTimeFormated");
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
                                            hintText: "$endYearDateFormated $endTimeFormated",
                                            onTap: () async {
                                              DateTime? startPicked = await showDatePicker(
                                                context: context,
                                                initialDate: startYearDate,
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2101),
                                                initialEntryMode: DatePickerEntryMode.calendar,
                                                initialDatePickerMode: DatePickerMode.day,
                                              );
                                              if(startPicked != null) {
                                                setStateBuilder(() {
                                                  startYearDate = startPicked;
                                                  print(startYearDate);
                                                  endYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                                });
                                                if(item?.rentOption?.toLowerCase() == "hour"){
                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: startTime,
                                                  );
                                                  if (pickedTime != null) {
                                                    setStateBuilder(() {
                                                      startTime = pickedTime;
                                                      final now = DateTime.now();
                                                      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                      endTimeFormated = DateFormat.jm().format(dt);
                                                      print("Selected time: $endTimeFormated");
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                          onTap: () async {
                                            DateTime? startPicked = await showDatePicker(
                                              context: context,
                                              initialDate: startYearDate,
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime(2101),
                                              initialEntryMode: DatePickerEntryMode.calendar,
                                              initialDatePickerMode: DatePickerMode.day,
                                            );
                                            if(startPicked != null) {
                                              setStateBuilder(() {
                                                startYearDate = startPicked;
                                                print(startYearDate);
                                                endYearDateFormated = DateFormat('MM/dd/yyyy').format(startPicked);
                                              });
                                              if(item?.rentOption?.toLowerCase() == "hour"){
                                                TimeOfDay? pickedTime = await showTimePicker(
                                                  context: context,
                                                  initialTime: startTime,
                                                );
                                                if (pickedTime != null) {
                                                  setStateBuilder(() {
                                                    startTime = pickedTime;
                                                    final now = DateTime.now();
                                                    final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                                    endTimeFormated = DateFormat.jm().format(dt);
                                                    print("Selected time: $endTimeFormated");
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
                                                String startIso = convertToIsoUtc(startYearDateFormated, startTimeFormated);
                                                String endIso = convertToIsoUtc(endYearDateFormated, endTimeFormated);
                                                rentProduct(
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
                                                buyProduct();
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


class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    fetchTransactionList();
    fetchRentalList();
    super.initState();
  }

  List<TransactionListModel> transactionList = [];
  List<TransactionListModel> buyList = [];
  List<TransactionListModel> sellList = [];
  Future<void> fetchTransactionList() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/transactions/purchases/'));
    String userId = preferences.getString("user_id") ?? "";
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      transactionList = jsonData
          .map((item) => TransactionListModel.fromJson(item))
          .toList();
      sellList = transactionList
          .where((item) => (item.seller ?? -1).toString() == userId)
          .toList();
      buyList = transactionList
          .where((item) => (item.buyer ?? -1).toString() == userId)
          .toList();

      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  List<RentalListModel> rentalList = [];
  List<RentalListModel> borrowedList = [];
  List<RentalListModel> lentList = [];
  Future<void> fetchRentalList() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/transactions/rentals/'));
    String userId = preferences.getString("user_id") ?? "";
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      rentalList = jsonData
          .map((item) => RentalListModel.fromJson(item))
          .toList();
      borrowedList = rentalList
          .where((item) => (item.seller ?? -1).toString() == userId)
          .toList();
      lentList = rentalList
          .where((item) => (item.renter ?? -1).toString() == userId)
          .toList();

      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0,),
            child: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyStoreScreen(),),);
              },
              icon: const Icon(Icons.storefront_outlined,),
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: "Bought",
            ),
            Tab(
              text: "Sold",
            ),
            Tab(
              text: "Borrowed",
            ),
            Tab(
              text: "Lent",
            ),
          ],
        ),
      ),
      body: TabBarView(controller: tabController, children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyList.length,
          itemBuilder: (context, index){
            var item = buyList[index];
            return ProductLoadDataCard(productId: item.product ?? 0);
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: sellList.length,
          itemBuilder: (context, index){
            var item = sellList[index];
            return ProductLoadDataCard(productId: item.product ?? 0);
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: borrowedList.length,
          itemBuilder: (context, index){
            var item = borrowedList[index];
            return ProductLoadDataCard(productId: item.product ?? 0);
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: lentList.length,
          itemBuilder: (context, index){
            var item = lentList[index];
            return ProductLoadDataCard(productId: item.product ?? 0);
          },
        ),
      ]),
    );
  }
}

class ProductLoadDataCard extends StatefulWidget {
  final int productId;
  const ProductLoadDataCard({super.key, required this.productId,});

  @override
  State<ProductLoadDataCard> createState() => _ProductLoadDataCardState();
}

class _ProductLoadDataCardState extends State<ProductLoadDataCard> {

  bool selectedMaxLines = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSingleProduct();
  }

  ProductsModel? item;
  bool isLoading = false;
  Future<void> fetchSingleProduct() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/${widget.productId}/'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      item = ProductsModel.fromJson(jsonData);
      setState(() {
        isLoading = false;
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        isLoading = false;
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0,),
        margin: const EdgeInsets.only(bottom: 10.0,),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item?.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (item?.categories ?? []).asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final capitalized = category[0].toUpperCase() + category.substring(1);
                final isLast = index == ((item?.categories ?? []).length - 1);
                return Text("$capitalized${isLast ? '.' : ', '}");
              }).toList(),
            ),
            Row(
              children: [
                Text(item?.purchasePrice ?? ""),
                Text(item?.rentPrice ?? ""),
                Text(item?.rentOption ?? ""),
              ],
            ),
            Text(item?.description ?? "",
              maxLines: selectedMaxLines ? null : 3,
              overflow: selectedMaxLines ? null : TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){
                  selectedMaxLines = !selectedMaxLines;
                  setState(() {});
                },
                child: const Text("see more", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.orange,),),
              ),
            ),
            Text(item?.datePosted ?? ""),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: item?.id ?? -1),),);
      },
    );
  }
}

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {

  bool selectedMaxLines = false;

  @override
  void initState() {
    fetchProductsList();
    super.initState();
  }

  List<ProductsModel> productsList = [];
  List<ProductsModel> myProductsList = [];
  Future<void> fetchProductsList() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/'));
    String userId = preferences.getString("user_id") ?? "";
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);
      print(jsonData);
      productsList = jsonData
          .map((item) => ProductsModel.fromJson(item))
          .toList();
      myProductsList = productsList
          .where((item) => (item.seller ?? -1).toString() == userId)
          .toList();

      setState(() {
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8000/api/products/$productId/'));
    if (response.statusCode == 204) {
      fetchProductsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Products"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productsList.length,
            itemBuilder: (context, index){
              var item = productsList[index];
              return GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0,),
                  margin: const EdgeInsets.only(bottom: 10.0,),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                          if(preferences.getString("user_id").toString() == item.seller.toString())
                            InkWell(
                              child: const Icon(Icons.delete, size: 18, color: Colors.red,),
                              onTap: (){
                                deleteProduct(item.id ?? -1);
                              },
                            ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (item.categories ?? []).asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final capitalized = category[0].toUpperCase() + category.substring(1);
                          final isLast = index == (item.categories!.length - 1);
                          return Text("$capitalized${isLast ? '.' : ', '}");
                        }).toList(),
                      ),
                      Row(
                        children: [
                          Text(item.purchasePrice ?? ""),
                          Text(item.rentPrice ?? ""),
                          Text(item.rentOption ?? ""),
                        ],
                      ),
                      Text(item.description ?? "",
                        maxLines: selectedMaxLines ? null : 3,
                        overflow: selectedMaxLines ? null : TextOverflow.ellipsis,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            selectedMaxLines = !selectedMaxLines;
                            setState(() {});
                          },
                          child: const Text("see more", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.orange,),),
                        ),
                      ),
                      Text(item.datePosted ?? ""),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyProductEditScreen(productsModel: item ?? ProductsModel(),),),);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyProductEditScreen extends StatefulWidget {
  final ProductsModel productsModel;
  const MyProductEditScreen({super.key, required this.productsModel,});

  @override
  State<MyProductEditScreen> createState() => _MyProductEditScreenState();
}

class _MyProductEditScreenState extends State<MyProductEditScreen> {

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController desEditingController = TextEditingController();
  TextEditingController ppEditingController = TextEditingController();
  TextEditingController rpEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    titleEditingController.text = widget.productsModel.title ?? "";
    desEditingController.text = widget.productsModel.description ?? "";
    ppEditingController.text = widget.productsModel.purchasePrice ?? "";
    rpEditingController.text = widget.productsModel.rentPrice ?? "";
    selectedOption = widget.productsModel.rentOption == "hour" ? optionTypes[0] : optionTypes[1];
  }

  final MultiSelectController<String> _controller = MultiSelectController<String>();
  List<String> selectedCategoryList = [];
  List<CategoriesModel> categoriesList = [];
  bool isLoading = false;
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products/categories/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes,),);

      categoriesList = jsonData
          .map((item) => CategoriesModel.fromJson(item))
          .toList();
      print(jsonData);
      setState(() {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.selectWhere((item) =>
          widget.productsModel.categories?.contains(item.value.toLowerCase()) ?? false);
        });
        // data = jsonData['title'];
      });
    } else {
      setState(() {
        isLoading = false;
        // data = 'Error: ${response.statusCode}';
      });
    }
  }

  String selectedOption = '';
  List<String> optionTypes = ['Per Hour', 'Per Day',];

  Future<void> updateProductData() async {
    var headers = {
      'accept': 'application/json',
    };
    var request = http.MultipartRequest('PATCH', Uri.parse('http://10.0.2.2:8000/api/products/${widget.productsModel.id}/'));
    for (var category in selectedCategoryList) {
      request.files.add(
        http.MultipartFile.fromString('categories', category),
      );
    }
    request.fields.addAll({
      "seller": preferences.getString("user_id") ?? "",
      "title": titleEditingController.text,
      "description": desEditingController.text,
      "purchase_price": ppEditingController.text,
      "rent_price": rpEditingController.text,
      "rent_option": selectedOption.toLowerCase().contains("hour") ? "hour" : "day",
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pop(context);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldTitle(title: "Title",),
              ProductTextFieldWidget(
                controller: titleEditingController,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Categories",),
              isLoading ? const SizedBox.shrink() :
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
                    selectedCategoryList = selectedItems;
                    print(selectedCategoryList);
                  });
                },
              ),
              FieldTitle(title: "Description",),
              ProductTextFieldWidget(
                controller: desEditingController,
                maxLines: 5,
                minLines: 5,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Purchase Price",),
              ProductTextFieldWidget(
                controller: ppEditingController,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Rental Price",),
              ProductTextFieldWidget(
                controller: rpEditingController,
              ),
              const SizedBox(height: 15,),
              DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white,),
                  ),
                ),
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width * 0.925,
                  initialSelection: selectedOption,
                  menuHeight: 150,
                  hintText: "Options",
                  onSelected: (String? value) {
                    setState(() {
                      selectedOption = value ?? "";
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  dropdownMenuEntries: optionTypes.map((String division) {
                    return DropdownMenuEntry(value: division, label: division,);
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
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    child: EditProductButton(
                      title: "Cancel",
                      color: Colors.red,
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: EditProductButton(
                      title: "Save Changes",
                      color: Colors.purple,
                      onTap: (){
                        updateProductData();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FieldTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0,),
      child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 17.0,),),
    );
  }

  Widget EditProductButton({required String title, required Color color, required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        // width: 120,
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
}

class ProductsModel {
  int? id;
  int? seller;
  String? title;
  String? description;
  List<String>? categories;
  String? productImage;
  String? purchasePrice;
  String? rentPrice;
  String? rentOption;
  String? datePosted;

  ProductsModel(
      {this.id,
        this.seller,
        this.title,
        this.description,
        this.categories,
        this.productImage,
        this.purchasePrice,
        this.rentPrice,
        this.rentOption,
        this.datePosted});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seller = json['seller'];
    title = json['title'];
    description = json['description'];
    categories = json['categories'].cast<String>();
    productImage = json['product_image'];
    purchasePrice = json['purchase_price'];
    rentPrice = json['rent_price'];
    rentOption = json['rent_option'];
    datePosted = json['date_posted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller'] = seller;
    data['title'] = title;
    data['description'] = description;
    data['categories'] = categories;
    data['product_image'] = productImage;
    data['purchase_price'] = purchasePrice;
    data['rent_price'] = rentPrice;
    data['rent_option'] = rentOption;
    data['date_posted'] = datePosted;
    return data;
  }
}

class TransactionListModel {
  int? id;
  int? buyer;
  int? seller;
  int? product;
  String? purchaseDate;

  TransactionListModel(
      {this.id, this.buyer, this.seller, this.product, this.purchaseDate});

  TransactionListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyer = json['buyer'];
    seller = json['seller'];
    product = json['product'];
    purchaseDate = json['purchase_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['buyer'] = buyer;
    data['seller'] = seller;
    data['product'] = product;
    data['purchase_date'] = purchaseDate;
    return data;
  }
}

class RentalListModel {
  int? id;
  int? renter;
  int? seller;
  int? product;
  String? rentOption;
  String? rentPeriodStartDate;
  String? rentPeriodEndDate;
  String? totalPrice;
  String? rentDate;

  RentalListModel(
      {this.id,
        this.renter,
        this.seller,
        this.product,
        this.rentOption,
        this.rentPeriodStartDate,
        this.rentPeriodEndDate,
        this.totalPrice,
        this.rentDate});

  RentalListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renter = json['renter'];
    seller = json['seller'];
    product = json['product'];
    rentOption = json['rent_option'];
    rentPeriodStartDate = json['rent_period_start_date'];
    rentPeriodEndDate = json['rent_period_end_date'];
    totalPrice = json['total_price'];
    rentDate = json['rent_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['renter'] = renter;
    data['seller'] = seller;
    data['product'] = product;
    data['rent_option'] = rentOption;
    data['rent_period_start_date'] = rentPeriodStartDate;
    data['rent_period_end_date'] = rentPeriodEndDate;
    data['total_price'] = totalPrice;
    data['rent_date'] = rentDate;
    return data;
  }
}


