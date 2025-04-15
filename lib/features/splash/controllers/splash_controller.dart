import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SplashController extends GetxController{

  final LocalAuthentication auth = LocalAuthentication();
  RxBool isAuthSuccess = false.obs;
  Future<void> biometricAuthenticate() async {
    try {
      isAuthSuccess.value = await auth.authenticate(
        localizedReason: "Biometric Authentication",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      isAuthSuccess.value = true;
    } catch (e) {
      print("Authentication error: $e");
    }
  }

}