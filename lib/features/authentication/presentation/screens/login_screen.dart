import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/auth_submit_button_widget.dart';
import '../widgets/auth_title_widget.dart';
import '../widgets/authentication_textfield_widget.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              children: [
                const SizedBox(height: 40,),
                const AppLogoWidget(),
                const Text(
                  "Login to the TeeBay App.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Email",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.emailEditingControllerL,
                  focusNode: controller.emailFocusNodeL,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Email is invalid!!!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Password",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.passwordEditingControllerL,
                  focusNode: controller.passwordFocusNodeL,
                  hintText: 'Password',
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  child: Obx(() => controller.isLoginLoading.value
                      ? Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFC911),
                          borderRadius: BorderRadius.circular(10.0,),
                        ),
                        child: const CircularProgressIndicator(color: Colors.white,),
                      )
                      : const AuthSubmitButtonWidget(
                    buttonName: "Login",
                  ),),
                  onTap: (){
                    if(controller.loginFormKey.currentState!.validate()){
                      controller.postLogin();
                    }
                  },
                ),
                const SizedBox(height: 40,),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: "Don't Have An Account?  ", style: TextStyle(color: Colors.black,),),
                      TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(color: Colors.orange,),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Get.offAllNamed(AppRoutes.signup);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
