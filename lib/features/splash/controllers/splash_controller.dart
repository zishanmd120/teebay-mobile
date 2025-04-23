import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teebay_mobile/main.dart';
import 'package:teebay_mobile/main/routes/app_routes.dart';

class SplashController extends GetxController {

  SharedPreferences sharedPreferences;
  SplashController(this.sharedPreferences,);


  @override
  void onInit() {
    super.onInit();
    getFCMToken();
    Future.microtask(() => navigateToRoute());
  }

  navigateToRoute() async{
    if(sharedPreferences.getString("user_id") != null){
      if(sharedPreferences.getBool("biometric_enabled") != null || sharedPreferences.getBool("biometric_enabled") == true){
        Get.offAllNamed(AppRoutes.biometric);
      } else {
        Get.offAllNamed(AppRoutes.allProducts);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  ///
  void getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print("FCM Token: $token");
      sharedPreferences.setString("fcm_token", token.toString());
    } else {
      print('User declined or has not accepted permission');
    }
  }

}