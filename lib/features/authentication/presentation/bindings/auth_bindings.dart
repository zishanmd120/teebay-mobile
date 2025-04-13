import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/logger.dart';
import '../../data/datasources/network/auth_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_interactor.dart';
import '../controllers/auth_controller.dart';

class AuthBindings extends Bindings{

  @override
  void dependencies() {
    // Get.lazyPut(() => AuthenticationController(LoginInteractor),);
    // Logger or any dependency for AuthSource
    Get.lazyPut(() => HttpLogger());

    // Register NetworkHttpClient with Logger
    Get.lazyPut(() => NetworkHttpClient(Get.find<HttpLogger>()));

    Get.lazyPut(() => AuthSource(Get.find<NetworkHttpClient>()));

    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthSource>()));

    // UseCase
    Get.lazyPut(() => LoginInteractor(Get.find<AuthRepository>()));

    // Controller
    Get.lazyPut(() => AuthController(Get.find<LoginInteractor>()));

  }

}