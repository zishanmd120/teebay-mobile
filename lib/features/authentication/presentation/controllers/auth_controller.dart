import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebay_mobile/features/home/presentation/screens/home_screen.dart';

import '../../domain/usecases/login_interactor.dart';
import '../../domain/usecases/signup_interactor.dart';

class AuthController extends GetxController {

  LoginInteractor loginInteractor;
  SignupInteractor signupInteractor;
  AuthController(this.loginInteractor, this.signupInteractor,);

  /// login
  GlobalKey<FormState>  loginFormKey = GlobalKey<FormState>();
  TextEditingController emailEditingControllerL = TextEditingController();
  TextEditingController passwordEditingControllerL = TextEditingController();
  RxBool obscureLoginPassword = true.obs;

  FocusNode emailFocusNodeL = FocusNode();
  FocusNode passwordFocusNodeL = FocusNode();

  RxBool isLightTheme = true.obs;
  RxBool isLoginLoading = false.obs;

  loginTest(BuildContext context) async {
    isLoginLoading.value = true;
    loginInteractor.execute(
      emailEditingControllerL.text,
      passwordEditingControllerL.text,
    ).then((value) {
      if (value.isLeft()) {
        final error = value.fold((l) => l.message, (r) => null);
        print("Login Failed: $error");
        Get.snackbar("Failed", error ?? "Login failed", backgroundColor: Colors.red, colorText: Colors.white);
        isLoginLoading.value = false;
      } else {
        print("Login Success");
        isLoginLoading.value = false;
        // Get.toNamed(AppRoutes.dashboard);
        Get.offAll(()=> const HomeScreen(),);
      }
    });
  }

  /// signup
  GlobalKey<FormState>  signupFormKey = GlobalKey<FormState>();
  TextEditingController fNameEditingControllerS = TextEditingController();
  TextEditingController lNameEditingControllerS = TextEditingController();
  TextEditingController emailEditingControllerS = TextEditingController();
  TextEditingController addressEditingControllerS = TextEditingController();
  TextEditingController passwordEditingControllerS = TextEditingController();
  TextEditingController confirmPasswordEditingControllerS = TextEditingController();
  RxBool obscureLoginPasswordS = true.obs;

  FocusNode fNameFocusNodeS = FocusNode();
  FocusNode lNameFocusNodeS = FocusNode();
  FocusNode emailFocusNodeS = FocusNode();
  FocusNode addressFocusNodeS = FocusNode();
  FocusNode passwordFocusNodeS = FocusNode();
  FocusNode confirmPasswordFocusNodeS = FocusNode();

  RxBool isValidEmail = false.obs;

  RxBool isSignupLoading = false.obs;
  signupTest(BuildContext context) async {
    isSignupLoading.value = true;
    var result = await signupInteractor.execute(
      fNameEditingControllerS.text,
      lNameEditingControllerS.text,
      emailEditingControllerS.text,
      addressEditingControllerS.text,
      passwordEditingControllerS.text,
    );
    return result.fold((l) {
      print("Signup Failed: ${l.message}");

      Get.snackbar("Failed", l.message, backgroundColor: Colors.red, colorText: Colors.white);
      isSignupLoading.value = false;
    }, (r) {
      isSignupLoading.value = false;
      Get.snackbar("Success", "Signup Success", backgroundColor: Colors.green, colorText: Colors.white);

      Get.back();
    });
  }

}