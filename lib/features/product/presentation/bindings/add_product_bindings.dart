import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/logger.dart';
import '../../data/datasources/network/product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/usecase/add_product_interactor.dart';
import '../controllers/add_product_controller.dart';

class AddProductBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HttpLogger());

    Get.lazyPut(() => NetworkHttpClient(Get.find<HttpLogger>()));

    Get.lazyPut(() => ProductDatasource(Get.find<NetworkHttpClient>()));

    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(
      Get.find<ProductDatasource>(),
      Get.find<SharedPreferences>(),
    ));

    Get.lazyPut(() => AddProductInteractor(Get.find<ProductRepository>()));

    Get.lazyPut(() => AddProductController(
      Get.find<AddProductInteractor>(),
    ));

  }

}