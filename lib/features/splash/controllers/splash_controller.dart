import 'package:get/get.dart';
import 'package:teebay_mobile/main.dart';
import 'package:teebay_mobile/main/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => navigateToRoute());
  }

  navigateToRoute(){
    if(preferences.getString("user_id") != null){
      if(preferences.getBool("biometric_enabled") != null || preferences.getBool("biometric_enabled") == true){
        Get.offAllNamed(AppRoutes.biometric);
      } else {
        Get.offAllNamed(AppRoutes.allProducts);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

}