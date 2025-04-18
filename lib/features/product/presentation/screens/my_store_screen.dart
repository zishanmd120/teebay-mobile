import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebay_mobile/features/product/presentation/controllers/product_controller.dart';
import 'package:teebay_mobile/main/routes/app_routes.dart';

import '../widgets/product_card_widget.dart';

class MyStoreScreen extends GetView<ProductController> {
  const MyStoreScreen({super.key});

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
          child: Obx(() => controller.isProductLoading.value
              ? const CupertinoActivityIndicator()
              : ListView.builder(
                shrinkWrap: true,
                itemCount: controller.myProductsList.length,
                itemBuilder: (context, index){
                  var item = controller.myProductsList[index];
                  var boolVal = controller.sharedPreference.getString("user_id").toString() == item.seller.toString();
                  print("boolVal: $boolVal");
                  return GestureDetector(
                    child: Stack(
                      children: [
                        ProductCardWidget(
                          productsModel: item,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            child: const Icon(Icons.delete, size: 18, color: Colors.red,),
                            onTap: (){
                              controller.deleteProduct(item.id ?? 0);
                            },
                          ),
                        ),
                      ],
                    ),
                    onTap: (){
                      controller.productEditDataSet(item);
                      Get.toNamed(AppRoutes.myProductEdit);
                    },
                  );
                },
              ),
          ),
        ),
      ),
    );
  }
}