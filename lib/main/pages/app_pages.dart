import 'package:get/get.dart';
import 'package:teebay_mobile/features/product/presentation/bindings/add_product_bindings.dart';
import 'package:teebay_mobile/features/product/presentation/screens/add_product_screen.dart';
import 'package:teebay_mobile/features/splash/presentation/splash_screen.dart';

import '../../features/authentication/presentation/bindings/auth_bindings.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/splash/bindings/splash_bindings.dart';
import '../../features/splash/presentation/biometric_auth_screen.dart';
import '../routes/app_routes.dart';

class AppPages {

  static final pages = [

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),

    GetPage(
      name: AppRoutes.biometric,
      page: () => const BiometricAuthScreen(),
      binding: SplashBindings(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
      binding: AddProductBindings(),
    ),

  ];

}