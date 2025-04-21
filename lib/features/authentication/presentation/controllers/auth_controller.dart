import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/utils/toster.dart';
import '../../../../main/routes/app_routes.dart';
import '../../domain/usecases/login_interactor.dart';
import '../../domain/usecases/signup_interactor.dart';

class AuthController extends GetxController {

  LoginInteractor loginInteractor;
  SignupInteractor signupInteractor;
  AuthController(this.loginInteractor, this.signupInteractor,);

  /// login
  final GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController emailEditingControllerL = TextEditingController();
  TextEditingController passwordEditingControllerL = TextEditingController();
  RxBool obscureLoginPassword = true.obs;

  FocusNode emailFocusNodeL = FocusNode();
  FocusNode passwordFocusNodeL = FocusNode();

  RxBool isLightTheme = true.obs;
  RxBool isLoginLoading = false.obs;

  postLogin() async {
    isLoginLoading.value = true;
    var result = await loginInteractor.execute(
      emailEditingControllerL.text,
      passwordEditingControllerL.text,
    );
    return result.fold((l) {
      print("Login Failed: ${l.message}");
      showErrorSnackBar("Failed", l.message,);
      isLoginLoading.value = false;
    }, (r) {
    print("Login Success");
      isLoginLoading.value = false;
      Get.toNamed(AppRoutes.allProducts);
    });
  }

  /// signup
  final GlobalKey<FormState> signupFormKey = GlobalKey();
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
  postSignup() async {
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
      showErrorSnackBar("Failed", l.message,);
      isSignupLoading.value = false;
    }, (r) {
      isSignupLoading.value = false;
      Get.back();
      showSuccessSnackBar("Success", "Signup Success",);
    });
  }

  /// biometric auth
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
      if(isAuthSuccess.value){
        Get.offAllNamed(AppRoutes.allProducts);
      }
    } catch (e) {
      print("Authentication error: $e");
    }
  }
}