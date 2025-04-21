import 'package:get/get.dart';
import 'package:teebay_mobile/features/authentication/presentation/screens/signup_screen.dart';
import 'package:teebay_mobile/features/splash/presentation/splash_screen.dart';

import '../../features/product/presentation/bindings/product_bindings.dart';
import '../../features/product/presentation/screens/add_product_screen.dart';
import '../../features/authentication/presentation/bindings/auth_bindings.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/product/presentation/screens/all_product_screen.dart';
import '../../features/product/presentation/screens/my_product_edit_screen.dart';
import '../../features/product/presentation/screens/my_store_screen.dart';
import '../../features/product/presentation/screens/product_details_screen.dart';
import '../../features/splash/bindings/splash_bindings.dart';
import '../../features/authentication/presentation/screens/biometric_auth_screen.dart';
import '../../features/transaction/presentation/bindings/transaction_bindings.dart';
import '../../features/transaction/presentation/screens/transaction_screen.dart';
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
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.allProducts,
      page: () => const AllProductScreen(),
      binding: ProductBindings(),
    ),

    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsPage(),
      binding: ProductBindings(),
    ),

    GetPage(
      name: AppRoutes.myStore,
      page: () => const MyStoreScreen(),
      binding: ProductBindings(),
    ),

    GetPage(
      name: AppRoutes.myProductEdit,
      page: () => const MyProductEditScreen(),
      binding: ProductBindings(),
    ),

    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
      binding: ProductBindings(),
    ),

    GetPage(
      name: AppRoutes.myTransaction,
      page: () => const MyTransactionScreen(),
      binding: TransactionBindings(),
    ),

  ];

}