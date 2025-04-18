import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/features/product/data/datasources/network/product_datasource.dart';
import 'package:teebay_mobile/features/product/data/repositories/product_repository_impl.dart';
import 'package:teebay_mobile/features/product/domain/repository/product_repository.dart';
import 'package:teebay_mobile/features/product/domain/usecase/add_product_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/categories_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/delete_product_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/product_details_interactor.dart';
import 'package:teebay_mobile/features/product/domain/usecase/update_product_interactor.dart';
import 'package:teebay_mobile/features/transaction/data/datasources/network/transaction_datasource.dart';
import 'package:teebay_mobile/features/transaction/data/repositories/transaction_repositories_impl.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/buy_product_interactor.dart';
import 'package:teebay_mobile/features/transaction/domain/usecase/rent_product_interactor.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/logger.dart';
import '../../domain/usecase/get_products_interactor.dart';
import '../controllers/product_controller.dart';

class ProductBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HttpLogger());

    Get.lazyPut(() => NetworkHttpClient(Get.find<HttpLogger>()));

    Get.lazyPut(() => ProductDatasource(Get.find<NetworkHttpClient>()));
    Get.lazyPut(() => TransactionDatasource(Get.find<NetworkHttpClient>()));

    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(
      Get.find<ProductDatasource>(),
      Get.find<SharedPreferences>(),
    ));
    Get.lazyPut<TransactionRepositories>(() => TransactionRepositoriesImpl(
      Get.find<TransactionDatasource>(),
      Get.find<SharedPreferences>(),
    ));

    Get.lazyPut(() => AddProductInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => GetProductsInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => ProductDetailsInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => CategoriesInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => UpdateProductInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => DeleteProductInteractor(Get.find<ProductRepository>()));
    Get.lazyPut(() => BuyProductInteractor(Get.find<TransactionRepositories>()));
    Get.lazyPut(() => RentProductInteractor(Get.find<TransactionRepositories>()));

    Get.lazyPut(() => ProductController(
      Get.find<AddProductInteractor>(),
      Get.find<GetProductsInteractor>(),
      Get.find<ProductDetailsInteractor>(),
      Get.find<CategoriesInteractor>(),
      Get.find<UpdateProductInteractor>(),
      Get.find<DeleteProductInteractor>(),
      Get.find<BuyProductInteractor>(),
      Get.find<RentProductInteractor>(),
      Get.find<SharedPreferences>(),
    ));

  }

}