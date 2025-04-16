import 'package:get/get.dart';
import 'package:teebay_mobile/features/splash/controllers/splash_controller.dart';


class SplashBindings extends Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashController());
  }

}