import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBindings extends Bindings {
  @override
  Future dependencies() async {
    await _bindingSharePreference();
  }

  Future _bindingSharePreference() async {
    await Get.putAsync(() async => await SharedPreferences.getInstance(), permanent: true,);
  }
}