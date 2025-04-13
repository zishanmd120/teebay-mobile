import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/usecases/login_interactor.dart';

class AuthController extends GetxController {

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  RxBool isLightTheme = true.obs;

  LoginInteractor loginInteractor;
  AuthController(this.loginInteractor);

  loginTest() async {
    loginInteractor.execute(emailEditingController.text, passwordEditingController.text).then((value) {
      if(value.isLeft()){
        print("Login Failed $value");
      }else{
        print("Login Success $value");
      }
    });
  }

}