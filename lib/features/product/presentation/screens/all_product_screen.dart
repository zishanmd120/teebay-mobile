import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebay_mobile/features/product/presentation/controllers/product_controller.dart';

import '../../../../main/routes/app_routes.dart';
import '../widgets/product_card_widget.dart';

class AllProductScreen extends GetView<ProductController> {
  const AllProductScreen({super.key});

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
              const SizedBox(height: 50,),
              ListTile(
                title: const Text("My Profile",),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                onTap: (){
                  Get.toNamed(AppRoutes.myTransaction);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTransactionScreen(),),);
                },
              ),
              ListTile(
                title: const Text("My Products",),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                onTap: (){
                  Get.toNamed(AppRoutes.myStore);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyStoreScreen(),),);
                },
              ),
              Obx(() => ListTile(
                title: const Text("Biometric Auth",),
                trailing: Switch(
                  value: controller.biometricAuthentication.value,
                  onChanged: (value) async {
                    print(value);
                    if(await controller.isDeviceSupported()){
                      if(value == true){
                        controller.sharedPreference.setBool("biometric_enabled", true);
                      } else {
                        controller.sharedPreference.setBool("biometric_enabled", false);
                      }
                      controller.biometricAuthentication.value = value;
                    } else {
                      Get.snackbar("Warning", "Enable Device Biometric Options.");
                    }
                  },
                ),
              ),),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchProduct();
        },
        child: SafeArea(
          child: Obx(
              () => controller.isProductLoading.value
                  ? const CupertinoActivityIndicator()
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.productsList.length,
                      itemBuilder: (context, index){
                        var item = controller.productsList[index];
                        return GestureDetector(
                          child: ProductCardWidget(productsModel: item,),
                          onTap: (){
                            Get.toNamed(AppRoutes.productDetails);
                            controller.fetchSingleProduct(item.id ?? 0,);
                          },
                        );
                      },
                    ),
                  ),
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
        onTap: () async {
          await Get.toNamed(AppRoutes.addProduct, arguments: controller.categoriesList);
        },
      ),
    );
  }
}