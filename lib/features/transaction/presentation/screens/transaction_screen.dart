import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebay_mobile/features/transaction/presentation/controllers/transaction_controllers.dart';
import 'package:teebay_mobile/main/routes/app_routes.dart';

import '../../../product/data/models/products_response.dart';
import '../../../product/presentation/widgets/product_card_widget.dart';


class MyTransactionScreen extends GetView<TransactionControllers> {
  const MyTransactionScreen({super.key});

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
                Get.toNamed(AppRoutes.myStore);
              },
              icon: const Icon(Icons.storefront_outlined,),
            ),
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
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
      body: TabBarView(controller: controller.tabController, children: [
        Obx(
          () => controller.isTransactionListLoading.value ? const CupertinoActivityIndicator() : ListView.builder(
            shrinkWrap: true,
            itemCount: controller.buyList.length,
            itemBuilder: (context, index){
              var item = controller.buyList[index];
              return ProductLoadDataCard(productId: item.product ?? 0);
            },
          ),
        ),
        Obx(
          () => controller.isTransactionListLoading.value ? const CupertinoActivityIndicator() : ListView.builder(
            shrinkWrap: true,
            itemCount: controller.sellList.length,
            itemBuilder: (context, index){
              var item = controller.sellList[index];
              return ProductLoadDataCard(productId: item.product ?? 0);
            },
          ),
        ),
        Obx(
          () => controller.isRentalListLoading.value ? const CupertinoActivityIndicator() : ListView.builder(
            shrinkWrap: true,
            itemCount: controller.borrowedList.length,
            itemBuilder: (context, index){
              var item = controller.borrowedList[index];
              return ProductLoadDataCard(productId: item.product ?? 0);
            },
          ),
        ),
        Obx(
          ()=> controller.isRentalListLoading.value ? const CupertinoActivityIndicator() :  ListView.builder(
            shrinkWrap: true,
            itemCount: controller.lentList.length,
            itemBuilder: (context, index){
              var item = controller.lentList[index];
              return ProductLoadDataCard(productId: item.product ?? 0);
            },
          ),
        ),
      ]),
    );
  }
}

class ProductLoadDataCard extends GetView<TransactionControllers> {
  final int productId;
  const ProductLoadDataCard({super.key, required this.productId,});

  @override
  Widget build(BuildContext context) {
    controller.fetchSingleProduct(productId);
    return Obx(
      () => controller.isLoading.value
          ? const SizedBox.shrink()
          : ProductCardWidget(productsModel: controller.item ?? ProductsResponse(),),
    );
  }
}




