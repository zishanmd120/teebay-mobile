import 'package:get/get.dart';

import '../../features/authentication/presentation/bindings/auth_bindings.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../routes/app_routes.dart';

class AppPages {

  static final pages = [

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBindings(),
    ),

  ];

}