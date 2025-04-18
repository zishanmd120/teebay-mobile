import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/features/transaction/data/datasources/network/transaction_datasource.dart';
import 'package:teebay_mobile/features/transaction/data/repositories/transaction_repositories_impl.dart';
import 'package:teebay_mobile/features/transaction/domain/repository/transaction_repositories.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/logger.dart';
import '../../../product/domain/usecase/product_details_interactor.dart';
import '../../domain/usecase/get_rental_interactor.dart';
import '../../domain/usecase/get_transaction_interactor.dart';
import '../controllers/transaction_controllers.dart';

class TransactionBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HttpLogger());

    Get.lazyPut(() => NetworkHttpClient(Get.find<HttpLogger>()));

    Get.lazyPut(() => TransactionDatasource(Get.find<NetworkHttpClient>()));

    Get.lazyPut<TransactionRepositories>(() => TransactionRepositoriesImpl(
      Get.find<TransactionDatasource>(),
      Get.find<SharedPreferences>(),
    ));

    Get.lazyPut(() => GetTransactionInteractor(Get.find<TransactionRepositories>()));
    Get.lazyPut(() => GetRentalInteractor(Get.find<TransactionRepositories>()));

    Get.lazyPut(() => TransactionControllers(
      Get.find<GetRentalInteractor>(),
      Get.find<GetTransactionInteractor>(),
      Get.find<ProductDetailsInteractor>(),
      Get.find<SharedPreferences>(),
    ));

  }

}