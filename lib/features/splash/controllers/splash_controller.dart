import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
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
        Get.toNamed(AppRoutes.allProducts);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  RxBool isAuthSuccess = false.obs;
  RxBool isBioAuthEnabled = false.obs;
  Future<void> biometricAuthenticate() async {
    try {
      var ressppp = await auth.getAvailableBiometrics();
      var ressppp2 = await auth.isDeviceSupported();
      print(ressppp);
      print(ressppp2);
      isAuthSuccess.value = await auth.authenticate(
        localizedReason: "Biometric Authentication",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      isAuthSuccess.value = true;
      isBioAuthEnabled.value = true;
    } catch (e) {
      print("Authentication error: $e");
    }
  }

}