import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                controller: controller.emailEditingController,
                focusNode: controller.nameFocusNode,
                hintText: 'Email',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Password",
              ),
              AuthenticationTextFieldWidget(
                controller: controller.passwordEditingController,
                focusNode: controller.passwordFocusNode,
                hintText: 'Password',
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                child: const AuthSubmitButtonWidget(
                  buttonName: "Login",
                ),
                onTap: (){
                  controller.loginTest();
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
