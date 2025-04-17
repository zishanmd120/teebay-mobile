import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductBindings extends Bindings {


  @override
  void dependencies() {
    Get.put(AddProductController());
  }

}